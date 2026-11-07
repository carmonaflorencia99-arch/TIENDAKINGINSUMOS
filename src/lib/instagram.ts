/**
 * Instagram de King en la tienda (Instagram API con inicio de sesión de Instagram).
 *
 * - Requiere una cuenta profesional (Empresa o Creador) y un token de acceso
 *   de larga duración (60 días). Se carga desde el panel → Configuración.
 * - El token vive en la tabla privada integration_tokens (solo servidor).
 * - La tarea diaria lo renueva cuando tiene más de 7 días.
 * - Si no hay token o Instagram falla, la sección simplemente no se muestra.
 */
import { adminClient } from "./supabase";

const GRAPH = process.env.INSTAGRAM_GRAPH_URL || "https://graph.instagram.com"; // override solo para pruebas

export interface InstagramPost {
  id: string;
  caption: string | null;
  mediaType: "IMAGE" | "VIDEO" | "CAROUSEL_ALBUM";
  image: string;
  permalink: string;
}

async function getToken(): Promise<string | null> {
  try {
    const { data } = await adminClient().from("integration_tokens").select("value").eq("key", "instagram").maybeSingle();
    return data?.value ?? null;
  } catch {
    return null;
  }
}

/** Últimos posts para mostrar en el inicio (se cachean 1 hora). */
export async function getInstagramPosts(limit = 8): Promise<InstagramPost[]> {
  const token = await getToken();
  if (!token) return [];
  try {
    const fields = "id,caption,media_type,media_url,thumbnail_url,permalink";
    const res = await fetch(`${GRAPH}/me/media?fields=${fields}&limit=${limit + 4}&access_token=${encodeURIComponent(token)}`, {
      next: { revalidate: 3600 },
    });
    if (!res.ok) return [];
    const json = (await res.json()) as {
      data?: { id: string; caption?: string; media_type: InstagramPost["mediaType"]; media_url?: string; thumbnail_url?: string; permalink: string }[];
    };
    return (json.data ?? [])
      .map((m) => ({
        id: m.id,
        caption: m.caption ?? null,
        mediaType: m.media_type,
        image: m.media_type === "VIDEO" ? (m.thumbnail_url ?? "") : (m.media_url ?? ""),
        permalink: m.permalink,
      }))
      .filter((p) => p.image)
      .slice(0, limit);
  } catch {
    return [];
  }
}

/** Comprueba un token nuevo y devuelve el usuario de la cuenta. */
export async function verifyToken(token: string): Promise<string> {
  const res = await fetch(`${GRAPH}/me?fields=username,account_type&access_token=${encodeURIComponent(token)}`, { cache: "no-store" });
  const json = await res.json().catch(() => ({}));
  if (!res.ok || !json.username) throw new Error(json?.error?.message || "Instagram no aceptó el token.");
  return json.username as string;
}

/** Renueva el token si tiene más de 7 días (los tokens duran 60). */
export async function refreshTokenIfNeeded(): Promise<"renovado" | "vigente" | "sin token" | "error"> {
  const db = adminClient();
  const { data } = await db.from("integration_tokens").select("value, updated_at").eq("key", "instagram").maybeSingle();
  if (!data) return "sin token";
  const ageDays = (Date.now() - new Date(data.updated_at).getTime()) / 86400000;
  if (ageDays < 7) return "vigente";
  try {
    const res = await fetch(`${GRAPH}/refresh_access_token?grant_type=ig_refresh_token&access_token=${encodeURIComponent(data.value)}`, {
      cache: "no-store",
    });
    const json = await res.json();
    if (!res.ok || !json.access_token) return "error";
    await db.from("integration_tokens").update({ value: json.access_token, updated_at: new Date().toISOString() }).eq("key", "instagram");
    return "renovado";
  } catch {
    return "error";
  }
}
