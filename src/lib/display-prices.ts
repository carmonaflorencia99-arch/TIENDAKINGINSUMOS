/** Precios para mostrar en cards y fichas: lista, efectivo y transferencia. */
import { discountPctFor, unitPrice } from "./pricing";
import type { Category, PaymentRule, Product, Variant } from "./types";

export interface DisplayPrices {
  list: number;
  cash: number | null;     // null si efectivo no tiene descuento
  transfer: number | null; // null si transferencia no tiene descuento para este producto
  from: boolean;           // hay variantes con distinto precio → "desde"
}

export function pricesFor(
  variant: Pick<Variant, "price_list" | "price_override">,
  categoryId: number | null,
  rules: PaymentRule[],
  categories: Pick<Category, "id" | "parent_id">[],
): Omit<DisplayPrices, "from"> {
  const calc = (method: "cash" | "transfer") => {
    const rule = rules.find((r) => r.method === method && r.active);
    const pct = discountPctFor(rule, categoryId, categories);
    return pct > 0 ? unitPrice(variant.price_list, pct, variant.price_override) : null;
  };
  return { list: variant.price_list, cash: calc("cash"), transfer: calc("transfer") };
}

export function productPrices(
  p: Product,
  rules: PaymentRule[],
  categories: Pick<Category, "id" | "parent_id">[],
): DisplayPrices | null {
  if (p.variants.length === 0) return null;
  const cheapest = p.variants.reduce((a, b) => (b.price_list < a.price_list ? b : a));
  const from = p.variants.some((v) => v.price_list !== cheapest.price_list);
  return { ...pricesFor(cheapest, p.category_id, rules, categories), from };
}
