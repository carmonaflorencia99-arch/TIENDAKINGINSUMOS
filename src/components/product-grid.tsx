import { ProductCard } from "./product-card";
import { productPrices } from "@/lib/display-prices";
import type { Category, PaymentRule, Product } from "@/lib/types";

export function ProductGrid({
  products,
  rules,
  categories,
  empty = "Todavía no hay productos acá.",
}: {
  products: Product[];
  rules: PaymentRule[];
  categories: Category[];
  empty?: string;
}) {
  if (products.length === 0) return <p className="py-10 text-center text-mute">{empty}</p>;
  return (
    <div className="grid grid-cols-2 gap-x-3 gap-y-7 sm:grid-cols-3 lg:grid-cols-4">
      {products.map((p) => (
        <ProductCard key={p.id} product={p} prices={productPrices(p, rules, categories)} />
      ))}
    </div>
  );
}
