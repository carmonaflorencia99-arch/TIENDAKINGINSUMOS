import Link from "next/link";
import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { getCategories, getPaymentRules, getProduct } from "@/lib/catalog";
import { pricesFor } from "@/lib/display-prices";
import { ProductImage } from "@/components/product-card";
import { AdhesiveBadges, AdhesiveSpecTable } from "@/components/adhesive-badges";
import { QuickAddMatrix, VariantPicker, type VariantPrices } from "@/components/buy-box";

export const revalidate = 60;
type Props = { params: Promise<{ slug: string }> };

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const { slug } = await params;
  const p = await getProduct(slug);
  if (!p) return { title: "Producto" };
  return {
    title: p.name,
    description: p.description?.slice(0, 155) ?? `${p.name} — King Insumos, Mendoza.`,
    openGraph: { images: p.images[0]?.url ? [p.images[0].url] : [] },
  };
}

export default async function ProductPage({ params }: Props) {
  const { slug } = await params;
  const [product, categories, rules] = await Promise.all([getProduct(slug), getCategories(), getPaymentRules()]);
  if (!product) notFound();

  const prices: VariantPrices = Object.fromEntries(
    product.variants.map((v) => [v.id, pricesFor(v, product.category_id, rules, categories)]),
  );
  const category = product.category;
  const isAdhesive = !!product.adhesive_specs || category?.slug === "adhesivos";

  return (
    <div className="mx-auto max-w-6xl px-4 pb-32 pt-4 md:grid md:grid-cols-2 md:gap-12 md:pb-10 md:pt-8">
      <div>
        {category && (
          <Link href={`/categoria/${category.slug}`} className="eyebrow mb-3 inline-block">
            ← {category.name}
          </Link>
        )}
        <div className="aspect-square overflow-hidden rounded-none border border-line bg-white">
          <ProductImage product={product} />
        </div>
      </div>

      <div className="mt-6 md:mt-10">
        {product.brand && (
          <Link href={`/marca/${product.brand.slug}`} className="eyebrow">
            {product.brand.name}
          </Link>
        )}
        <h1 className="mt-1.5 text-[22px] leading-snug md:text-[28px]">{product.name}</h1>
        {product.adhesive_specs && (
          <div className="mt-3">
            <AdhesiveBadges specs={product.adhesive_specs} />
          </div>
        )}

        <div className="mt-6">
          {product.kind === "lash_matrix" ? (
            <QuickAddMatrix product={product} prices={prices} />
          ) : (
            <VariantPicker product={product} prices={prices} />
          )}
        </div>

        {product.description && (
          <p className="mt-8 whitespace-pre-line text-[15px] leading-relaxed text-ink/85">{product.description}</p>
        )}

        {product.adhesive_specs && (
          <div className="mt-6">
            <AdhesiveSpecTable specs={product.adhesive_specs} />
          </div>
        )}

        <div className="mt-6 rounded-none border border-line p-4 text-sm leading-relaxed text-mute">
          {isAdhesive ? (
            <p><strong className="text-ink">Los adhesivos no tienen cambio ni devolución.</strong> Controlalos al momento de la compra.</p>
          ) : (
            <p>No realizamos cambios ni devoluciones: probá los productos en el local al momento de retirar.</p>
          )}
          <p className="mt-2">Retiro en Av. San Martín 1074, 3° C · Lun a sáb de 10 a 18 hs.</p>
        </div>
      </div>
    </div>
  );
}
