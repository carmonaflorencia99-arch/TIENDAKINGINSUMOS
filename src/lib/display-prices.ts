/** Precios para mostrar en cards y fichas: lista, efectivo, transferencia y promo. */
import { discountPctFor, unitPrice } from "./pricing";
import { categorySlugsFor, promoPctFor } from "./promo";
import type { Category, PaymentRule, Product, Variant } from "./types";

type Cats = Pick<Category, "id" | "parent_id" | "slug">[];

export interface DisplayPrices {
  list: number;
  cash: number | null;     // null si efectivo no tiene descuento
  transfer: number | null; // null si transferencia no tiene descuento para este producto
  promoPct: number;        // % de Black Friday (0 si no hay)
  promo: number | null;    // precio Black Friday, con cualquier medio de pago
  from: boolean;           // hay variantes con distinto precio → "desde"
}

export function pricesFor(
  variant: Pick<Variant, "price_list" | "price_override" | "option1" | "option2" | "option3">,
  product: Pick<Product, "name" | "category_id"> & { brand?: { slug: string } | null },
  rules: PaymentRule[],
  categories: Cats,
): Omit<DisplayPrices, "from"> {
  const promoPct = promoPctFor({
    productName: product.name,
    brandSlug: product.brand?.slug ?? null,
    categorySlugs: categorySlugsFor(product.category_id, categories),
    options: [variant.option1, variant.option2, variant.option3],
  });
  const calc = (method: "cash" | "transfer") => {
    const rule = rules.find((r) => r.method === method && r.active);
    const pct = discountPctFor(rule, product.category_id, categories);
    if (promoPct > 0 && promoPct >= pct) return null; // con promo, el precio es el mismo para todos los medios
    return pct > 0 ? unitPrice(variant.price_list, pct, variant.price_override) : null;
  };
  return {
    list: variant.price_list,
    cash: calc("cash"),
    transfer: calc("transfer"),
    promoPct,
    promo: promoPct > 0 ? unitPrice(variant.price_list, promoPct) : null,
  };
}

export function productPrices(p: Product, rules: PaymentRule[], categories: Cats): DisplayPrices | null {
  if (p.variants.length === 0) return null;
  const all = p.variants.map((v) => ({ v, prices: pricesFor(v, p, rules, categories) }));
  const effective = (x: (typeof all)[number]) => x.prices.promo ?? x.prices.list;
  const cheapest = all.reduce((a, b) => (effective(b) < effective(a) ? b : a));
  const from = all.some((x) => effective(x) !== effective(cheapest));
  // el cartel de la card muestra la promo aunque solo aplique a algunas variantes (ej. Clione Love)
  const promoPct = Math.max(...all.map((x) => x.prices.promoPct));
  return { ...cheapest.prices, promoPct, from };
}
