/**
 * Acceso al panel. Hay una sola cuenta de administración: un usuario de
 * Supabase Auth que además figura en la tabla `staff`.
 */
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { adminClient } from "./supabase";
import { sessionClient } from "./supabase-session";

/** Devuelve el usuario logueado si es administrador; si no, redirige al login. */
export async function requireAdmin() {
  const supabase = await sessionClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) redirect("/admin/login");

  const { data: staff } = await adminClient().from("staff").select("user_id").eq("user_id", user.id).maybeSingle();
  if (!staff) redirect("/admin/login?error=sin-acceso");
  return user;
}

/** Para server actions: verifica el acceso y devuelve el cliente con permisos de servidor. */
export async function adminDb() {
  await requireAdmin();
  return adminClient();
}

/** Después de cambiar productos, precios o configuración, refresca la tienda. */
export function refreshStore() {
  revalidatePath("/", "layout");
}
