/**
 * POST /api/cart/refresh — actualiza precios y stock de las líneas del carrito
 * (por si cambiaron desde que la clienta las agregó).
 */
import { NextResponse } from "next/server";
import { getCategories, getVariantsWithProduct } from "@/lib/catalog";
import { categorySlugsFor, promoPctFor } from "@/lib/promo";
import { optionsLabel } from "@/lib/format";
import type { CartLineView } from "@/lib/types";

export async function POST(req: Request) {
  const { lines } = (await req.json().catch(() => ({ lines: [] }))) as { lines: CartLineView[] };
  if (!Array.isArray(lines) || lines.length === 0) return NextResponse.json({ lines: [] });

  const [rows, categories] = await Promise.all([
    getVariantsWithProduct(lines.map((l) => Number(l.variantId)).filter(Boolean)),
    getCategories(),
  ]);
  const fresh: CartLineView[] = [];
  for (const l of lines) {
    const v = rows.find((r) => r.id === l.variantId);
    if (!v || !v.active || !v.product || v.product.status !== "active") continue; // ya no existe
    fresh.push({
      variantId: v.id,
      qty: l.qty,
      productName: v.product.name,
      productSlug: v.product.slug,
      optionsLabel: optionsLabel(v),
      priceList: v.price_list,
      categoryId: v.product.category_id,
      image: v.product.images?.sort((a: { sort_order: number }, b: { sort_order: number }) => a.sort_order - b.sort_order)[0]?.url,
      stock: v.stock,
      trackStock: v.track_stock,
      promoPct: promoPctFor({
        productName: v.product.name,
        brandSlug: v.product.brand?.slug ?? null,
        categorySlugs: categorySlugsFor(v.product.category_id, categories),
        options: [v.option1, v.option2, v.option3],
      }),
    });
  }
  return NextResponse.json({ lines: fresh });
}
