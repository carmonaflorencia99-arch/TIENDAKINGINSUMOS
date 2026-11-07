"use server";
import { redirect } from "next/navigation";
import { adminDb, refreshStore } from "@/lib/admin";

function slugify(s: string) {
  return s
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "")
    .slice(0, 70);
}

const int = (v: FormDataEntryValue | null, min = 0) => {
  const n = Math.round(Number(String(v ?? "").replace(/[^\d-]/g, "")));
  return Number.isFinite(n) ? Math.max(n, min) : min;
};
const text = (v: FormDataEntryValue | null) => String(v ?? "").trim();
const back = (id: number, q: string) => redirect(`/admin/productos/${id}?${q}`);

export async function createProduct(f: FormData) {
  const db = await adminDb();
  const name = text(f.get("name"));
  if (name.length < 3) redirect("/admin/productos/nuevo?error=" + encodeURIComponent("Escribí el nombre del producto."));
  const base = slugify(name);
  let slug = base;
  for (let n = 2; ; n++) {
    const { data } = await db.from("products").select("id").eq("slug", slug).maybeSingle();
    if (!data) break;
    slug = `${base}-${n}`;
  }
  const kind = text(f.get("kind")) || "simple";
  const options = kind === "lash_matrix" ? ["Curvatura", "Grosor", "Largo"] : kind === "variants" ? [text(f.get("option")) || "Opción"] : [];
  const { data: p, error } = await db
    .from("products")
    .insert({
      name,
      slug,
      kind,
      option_names: options,
      category_id: int(f.get("category_id")) || null,
      brand_id: int(f.get("brand_id")) || null,
      status: "draft",
    })
    .select("id")
    .single();
  if (error || !p) redirect("/admin/productos/nuevo?error=" + encodeURIComponent("No se pudo crear el producto."));
  await db.from("variants").insert({ product_id: p.id, price_list: int(f.get("price")), stock: int(f.get("stock")) });
  back(p.id, "ok=" + encodeURIComponent("Producto creado como borrador. Completá los datos y publicalo."));
}

/** Guarda datos del producto y todas sus variantes en un solo envío. */
export async function saveProduct(f: FormData) {
  const db = await adminDb();
  const id = int(f.get("id"));
  const optionNames = text(f.get("option_names")).split(",").map((s) => s.trim()).filter(Boolean).slice(0, 3);
  const { error } = await db
    .from("products")
    .update({
      name: text(f.get("name")),
      description: text(f.get("description")) || null,
      category_id: int(f.get("category_id")) || null,
      brand_id: int(f.get("brand_id")) || null,
      status: text(f.get("status")),
      kind: text(f.get("kind")),
      option_names: optionNames,
      featured: f.get("featured") === "on",
      best_seller: f.get("best_seller") === "on",
    })
    .eq("id", id);
  if (error) back(id, "error=" + encodeURIComponent("No se pudo guardar el producto."));

  // Variantes: filas v-<id>-campo (existentes) y n-<i>-campo (nuevas)
  const rows = new Map<string, Record<string, string>>();
  for (const [key, value] of f.entries()) {
    const m = key.match(/^(v|n)-(\d+)-(\w+)$/);
    if (!m) continue;
    const k = `${m[1]}-${m[2]}`;
    rows.set(k, { ...(rows.get(k) ?? {}), [m[3]]: String(value) });
  }
  for (const [k, r] of rows) {
    const isNew = k.startsWith("n-");
    const data = {
      option1: r.option1?.trim() || null,
      option2: r.option2?.trim() || null,
      option3: r.option3?.trim() || null,
      price_list: int(r.price_list ?? null),
      stock: int(r.stock ?? null, -999),
      active: r.active === "on",
    };
    if (isNew) {
      if (!r.price_list) continue; // fila nueva vacía
      await db.from("variants").insert({ product_id: id, ...data, active: true });
    } else if (r.delete === "on") {
      await db.from("variants").delete().eq("id", Number(k.slice(2))).eq("product_id", id);
    } else {
      await db.from("variants").update(data).eq("id", Number(k.slice(2))).eq("product_id", id);
    }
  }
  refreshStore();
  back(id, "ok=" + encodeURIComponent("Cambios guardados. La tienda se actualiza en unos segundos."));
}

/** Sube fotos ya achicadas en el navegador al bucket público "products". */
export async function uploadImages(f: FormData) {
  const db = await adminDb();
  const id = int(f.get("id"));
  const files = f.getAll("files").filter((x): x is File => x instanceof File && x.size > 0);
  const { data: existing } = await db.from("product_images").select("sort_order").eq("product_id", id);
  let order = (existing ?? []).reduce((m, i) => Math.max(m, i.sort_order + 1), 0);
  let failed = 0;
  for (const file of files.slice(0, 8)) {
    const path = `${id}/${Date.now()}-${Math.random().toString(36).slice(2, 7)}.jpg`;
    const { error } = await db.storage.from("products").upload(path, file, { contentType: file.type || "image/jpeg" });
    if (error) { failed++; continue; }
    const { data } = db.storage.from("products").getPublicUrl(path);
    await db.from("product_images").insert({ product_id: id, url: data.publicUrl, sort_order: order++ });
  }
  refreshStore();
  back(id, failed ? "error=" + encodeURIComponent(`No se pudieron subir ${failed} fotos.`) : "ok=" + encodeURIComponent("Fotos subidas."));
}

export async function makeMainImage(f: FormData) {
  const db = await adminDb();
  const id = int(f.get("id"));
  const imageId = int(f.get("image_id"));
  const { data: imgs } = await db.from("product_images").select("id, sort_order").eq("product_id", id).order("sort_order");
  const ordered = [imageId, ...(imgs ?? []).map((i) => i.id).filter((x) => x !== imageId)];
  for (const [i, imgId] of ordered.entries()) await db.from("product_images").update({ sort_order: i }).eq("id", imgId);
  refreshStore();
  back(id, "ok=" + encodeURIComponent("Foto principal actualizada."));
}

export async function deleteImage(f: FormData) {
  const db = await adminDb();
  const id = int(f.get("id"));
  const { data: img } = await db.from("product_images").select("url").eq("id", int(f.get("image_id"))).eq("product_id", id).maybeSingle();
  if (img) {
    await db.from("product_images").delete().eq("id", int(f.get("image_id")));
    const marker = "/storage/v1/object/public/products/";
    if (img.url.includes(marker)) await db.storage.from("products").remove([img.url.split(marker)[1]]);
  }
  refreshStore();
  back(id, "ok=" + encodeURIComponent("Foto eliminada."));
}

export async function saveAdhesiveSpecs(f: FormData) {
  const db = await adminDb();
  const id = int(f.get("id"));
  const num = (k: string) => (text(f.get(k)) === "" ? null : Number(text(f.get(k)).replace(",", ".")));
  const level = text(f.get("level")) || null;
  const row = {
    product_id: id,
    drying_min_s: num("drying_min_s"), drying_max_s: num("drying_max_s"), level,
    humidity_min: num("humidity_min"), humidity_max: num("humidity_max"),
    temp_min: num("temp_min"), temp_max: num("temp_max"),
    retention_weeks: text(f.get("retention_weeks")) || null,
    viscosity: text(f.get("viscosity")) || null, fumes: text(f.get("fumes")) || null,
    open_shelf_life: text(f.get("open_shelf_life")) || null,
  };
  const empty = Object.entries(row).every(([k, v]) => k === "product_id" || v === null);
  if (empty) await db.from("adhesive_specs").delete().eq("product_id", id);
  else await db.from("adhesive_specs").upsert(row);
  refreshStore();
  back(id, "ok=" + encodeURIComponent("Ficha técnica guardada."));
}
