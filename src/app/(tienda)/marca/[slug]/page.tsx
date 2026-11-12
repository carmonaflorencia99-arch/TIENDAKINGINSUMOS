import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { getBrands, getCategories, getPaymentRules, getProductsByBrand, OFFICIAL_BRAND_SLUGS } from "@/lib/catalog";
import { ProductGrid } from "@/components/product-grid";

export const revalidate = 60;
type Props = { params: Promise<{ slug: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const b = (await getBrands()).find((x) => x.slug === slug);
  return { title: b ? `${b.name} en Mendoza` : "Marca" };
}

export default async function BrandPage({ params }: Props) {
  const { slug } = await params;
  const [brands, categories, rules] = await Promise.all([getBrands(), getCategories(), getPaymentRules()]);
  const brand = brands.find((b) => b.slug === slug);
  if (!brand) notFound();
  const products = await getProductsByBrand(brand.id);

  return (
    <div className="mx-auto max-w-6xl px-4 pt-6">
      {OFFICIAL_BRAND_SLUGS.includes(brand.slug) && <p className="eyebrow">Distribuidores oficiales en Mendoza</p>}
      <h1 className="mt-2 text-[26px] leading-tight md:text-[32px]">{brand.name}</h1>
      <div className="mt-7">
        <ProductGrid products={products} rules={rules} categories={categories} />
      </div>
    </div>
  );
}
