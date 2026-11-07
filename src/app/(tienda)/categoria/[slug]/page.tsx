import Link from "next/link";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { getBrands, getCategories, getPaymentRules, getProductsInCategory } from "@/lib/catalog";
import { ProductGrid } from "@/components/product-grid";

export const revalidate = 60;

type Props = { params: Promise<{ slug: string }>; searchParams: Promise<{ marca?: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const cat = (await getCategories()).find((c) => c.slug === slug);
  return { title: cat?.name ?? "Categoría" };
}

export default async function CategoryPage({ params, searchParams }: Props) {
  const { slug } = await params;
  const { marca } = await searchParams;
  const [categories, rules, brands] = await Promise.all([getCategories(), getPaymentRules(), getBrands()]);
  const cat = categories.find((c) => c.slug === slug);
  if (!cat) notFound();

  const parent = cat.parent_id ? categories.find((c) => c.id === cat.parent_id) : null;
  const children = categories.filter((c) => c.parent_id === cat.id);
  const siblings = parent ? categories.filter((c) => c.parent_id === parent.id) : children;

  let products = await getProductsInCategory([cat.id, ...children.map((c) => c.id)]);
  const brandsHere = brands.filter((b) => products.some((p) => p.brand_id === b.id));
  const brandFilter = brands.find((b) => b.slug === marca);
  if (brandFilter) products = products.filter((p) => p.brand_id === brandFilter.id);

  return (
    <div className="mx-auto max-w-6xl px-4 pt-6">
      {parent && (
        <Link href={`/categoria/${parent.slug}`} className="eyebrow">
          ← {parent.name}
        </Link>
      )}
      <h1 className="mt-2 text-[26px] leading-tight md:text-[32px]">{cat.name}</h1>

      {siblings.length > 0 && (
        <nav className="-mx-4 mt-5 flex gap-2 overflow-x-auto px-4 pb-1" aria-label="Subcategorías">
          {parent && (
            <Link href={`/categoria/${parent.slug}`} className="chip whitespace-nowrap">Todo</Link>
          )}
          {siblings.map((c) => (
            <Link key={c.id} href={`/categoria/${c.slug}`} aria-pressed={c.id === cat.id} className="chip whitespace-nowrap">
              {c.name}
            </Link>
          ))}
        </nav>
      )}

      {brandsHere.length > 1 && (
        <nav className="-mx-4 mt-3 flex gap-2 overflow-x-auto px-4 pb-1" aria-label="Filtrar por marca">
          <Link href={`/categoria/${cat.slug}`} aria-pressed={!brandFilter} className="chip whitespace-nowrap text-xs">
            Todas las marcas
          </Link>
          {brandsHere.map((b) => (
            <Link
              key={b.id}
              href={`/categoria/${cat.slug}?marca=${b.slug}`}
              aria-pressed={brandFilter?.id === b.id}
              className="chip whitespace-nowrap text-xs"
            >
              {b.name}
            </Link>
          ))}
        </nav>
      )}

      <div className="mt-7">
        <ProductGrid products={products} rules={rules} categories={categories} />
      </div>
    </div>
  );
}
