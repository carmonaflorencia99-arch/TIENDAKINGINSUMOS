"use server";
import { redirect } from "next/navigation";
import { adminDb, refreshStore } from "@/lib/admin";

const done = (q: string) => redirect(`/admin/categorias?${q}`);
const MARKER = "/storage/v1/object/public/products/";

/** Borra del almacenamiento una portada subida por el panel (si lo era). */
async function removeStored(db: Awaited<ReturnType<typeof adminDb>>, url: string | null) {
  if (url?.includes(MARKER + "categorias/")) await db.storage.from("products").remove([url.split(MARKER)[1]]);
}

export async function uploadCover(f: FormData) {
  const db = await adminDb();
  const id = Number(f.get("id"));
  const file = f.get("file");
  if (!(file instanceof File) || file.size === 0) done("error=" + encodeURIComponent("Elegí una foto."));
  const { data: cat } = await db.from("categories").select("name, image_url").eq("id", id).maybeSingle();
  if (!cat) done("error=" + encodeURIComponent("No se encontró la categoría."));

  const path = `categorias/${id}-${Date.now()}.jpg`;
  const { error } = await db.storage.from("products").upload(path, file as File, { contentType: "image/jpeg" });
  if (error) done("error=" + encodeURIComponent("No se pudo subir la foto."));
  const { data } = db.storage.from("products").getPublicUrl(path);
  await db.from("categories").update({ image_url: data.publicUrl }).eq("id", id);
  await removeStored(db, cat!.image_url);
  refreshStore();
  done("ok=" + encodeURIComponent(`Portada de ${cat!.name} actualizada.`));
}

export async function removeCover(f: FormData) {
  const db = await adminDb();
  const id = Number(f.get("id"));
  const { data: cat } = await db.from("categories").select("name, image_url").eq("id", id).maybeSingle();
  if (!cat) done("error=" + encodeURIComponent("No se encontró la categoría."));
  await db.from("categories").update({ image_url: null }).eq("id", id);
  await removeStored(db, cat!.image_url);
  refreshStore();
  done("ok=" + encodeURIComponent(`${cat!.name} vuelve a usar la foto de un producto.`));
}
