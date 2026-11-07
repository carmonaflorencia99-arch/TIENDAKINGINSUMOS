/**
 * Lecturas del catálogo (server components).
 * Todas usan el cliente público: RLS ya filtra productos en borrador.
 */
import { publicClient } from "./supabase";
import type { Brand, Category, PaymentRule, Product, Settings } from "./types";

const PRODUCT_SELECT = `
  id, name, slug, description, kind, option_names, category_id, brand_id, featured, best_seller,
  brand:brands(id, name, slug, featured),
  category:categories(id, parent_id, name, slug, sort_order),
  variants(*),
  images:product_images(url, alt, sort_order),
  adhesive_specs(*)
`;

/* eslint-disable @typescript-eslint/no-explicit-any */
function normalize(p: any): Product {
  return {
    ...p,
    // PostgREST puede devolver la relación 1-1 como objeto o como array
    adhesive_specs: Array.isArray(p.adhesive_specs) ? (p.adhesive_specs[0] ?? null) : p.adhesive_specs,
    variants: (p.variants ?? [])
      .filter((v: any) => v.active)
      .sort((a: any, b: any) => a.sort_order - b.sort_order || a.id - b.id),
    images: (p.images ?? []).sort((a: any, b: any) => a.sort_order - b.sort_order),
  };
}
/* eslint-enable @typescript-eslint/no-explicit-any */

export async function getCategories(): Promise<Category[]> {
  const { data, error } = await publicClient().from("categories").select("*").order("sort_order");
  if (error) throw error;
  return data;
}

export async function getBrands(): Promise<Brand[]> {
  const { data, error } = await publicClient().from("brands").select("*").order("sort_order");
  if (error) throw error;
  return data;
}

export async function getPaymentRules(): Promise<PaymentRule[]> {
  const { data, error } = await publicClient().from("payment_rules").select("*");
  if (error) throw error;
  const order = ["cash", "transfer", "mercadopago"];
  return data.sort((a, b) => order.indexOf(a.method) - order.indexOf(b.method));
}

export async function getSettings(): Promise<Settings> {
  const { data, error } = await publicClient().from("settings").select("*").eq("id", 1).single();
  if (error) throw error;
  return data;
}

export async function getProduct(slug: string): Promise<Product | null> {
  const { data, error } = await publicClient()
    .from("products")
    .select(PRODUCT_SELECT)
    .eq("slug", slug)
    .maybeSingle();
  if (error) throw error;
  return data ? normalize(data) : null;
}

/**
 * Orden de las grillas: destacados y más vendidos primero, después por
 * subcategoría (su orden) y por último en el orden del catálogo (id).
 */
function shelfOrder(a: Product, b: Product): number {
  const score = (p: Product) => (p.featured ? 2 : 0) + (p.best_seller ? 1 : 0);
  return (
    score(b) - score(a) ||
    (a.category?.sort_order ?? 99) - (b.category?.sort_order ?? 99) ||
    a.id - b.id
  );
}

/** Productos de una categoría y sus subcategorías. */
export async function getProductsInCategory(categoryIds: number[]): Promise<Product[]> {
  const { data, error } = await publicClient()
    .from("products")
    .select(PRODUCT_SELECT)
    .in("category_id", categoryIds);
  if (error) throw error;
  return data.map(normalize).sort(shelfOrder);
}

export async function getProductsByBrand(brandId: number): Promise<Product[]> {
  const { data, error } = await publicClient()
    .from("products")
    .select(PRODUCT_SELECT)
    .eq("brand_id", brandId);
  if (error) throw error;
  return data.map(normalize).sort(shelfOrder);
}

export async function getHighlighted(): Promise<Product[]> {
  const { data, error } = await publicClient()
    .from("products")
    .select(PRODUCT_SELECT)
    .or("featured.eq.true,best_seller.eq.true")
    .limit(12);
  if (error) throw error;
  return data.map(normalize);
}

export async function searchProducts(q: string): Promise<Product[]> {
  const term = q.trim().replace(/[%,()]/g, " ");
  if (!term) return [];
  const { data, error } = await publicClient()
    .from("products")
    .select(PRODUCT_SELECT)
    .ilike("name", `%${term}%`)
    .limit(40);
  if (error) throw error;
  return data.map(normalize);
}

/** Variantes con su producto, para el carrito y el checkout. */
export async function getVariantsWithProduct(ids: number[]) {
  if (ids.length === 0) return [];
  const { data, error } = await publicClient()
    .from("variants")
    .select("*, product:products(id, name, slug, category_id, status, images:product_images(url, sort_order))")
    .in("id", ids);
  if (error) throw error;
  return data;
}

/**
 * Portada de cada categoría: la que se subió desde el panel o, si no hay,
 * la foto del producto más destacado de esa categoría (o de sus subcategorías).
 */
export async function getCategoryCovers(categories: Category[]): Promise<Record<number, string>> {
  const { data, error } = await publicClient()
    .from("products")
    .select("id, category_id, featured, best_seller, images:product_images(url, sort_order)");
  if (error) throw error;
  const parentOf = new Map(categories.map((c) => [c.id, c.parent_id]));
  const auto: Record<number, string> = {};
  /* eslint-disable @typescript-eslint/no-explicit-any */
  const ranked = (data as any[])
    .filter((p) => p.images?.length)
    .sort((a, b) => Number(b.featured) * 2 + Number(b.best_seller) - (Number(a.featured) * 2 + Number(a.best_seller)) || a.id - b.id);
  for (const p of ranked) {
    const url = [...p.images].sort((x: any, y: any) => x.sort_order - y.sort_order)[0].url;
    for (const id of [p.category_id, parentOf.get(p.category_id)]) if (id && !auto[id]) auto[id] = url;
  }
  /* eslint-enable @typescript-eslint/no-explicit-any */
  const out: Record<number, string> = {};
  for (const c of categories) {
    const url = c.image_url || auto[c.id];
    if (url) out[c.id] = url;
  }
  return out;
}
