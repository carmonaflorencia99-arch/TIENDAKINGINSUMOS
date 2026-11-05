import type { Metadata } from "next";
import { getCategories, getPaymentRules, searchProducts } from "@/lib/catalog";
import { ProductGrid } from "@/components/product-grid";

export const metadata: Metadata = { title: "Buscar", robots: { index: false } };
type Props = { searchParams: Promise<{ q?: string }> };

export default async function SearchPage({ searchParams }: Props) {
  const { q = "" } = await searchParams;
  const [products, categories, rules] = await Promise.all([searchProducts(q), getCategories(), getPaymentRules()]);
  return (
    <div className="mx-auto max-w-6xl px-4 pt-6">
      <p className="eyebrow">Resultados para</p>
      <h1 className="mt-1 title">“{q}”</h1>
      <div className="mt-7">
        <ProductGrid
          products={products}
          rules={rules}
          categories={categories}
          empty="No encontramos ese producto. Probá con otra palabra o escribinos por WhatsApp."
        />
      </div>
    </div>
  );
}
