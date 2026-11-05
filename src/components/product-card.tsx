import Link from "next/link";
import { money } from "@/lib/format";
import type { DisplayPrices } from "@/lib/display-prices";
import type { Product } from "@/lib/types";
import { AdhesiveBadges } from "./adhesive-badges";

export function ProductImage({ product, className = "" }: { product: Product; className?: string }) {
  const img = product.images[0];
  if (img)
    // eslint-disable-next-line @next/next/no-img-element
    return <img src={img.url} alt={img.alt ?? product.name} className={`h-full w-full object-cover ${className}`} loading="lazy" />;
  // Sin foto todavía: nombre de la marca
  return (
    <div className={`grid h-full w-full place-items-center bg-surface ${className}`}>
      <span className="text-[13px] font-medium uppercase tracking-[3px] text-ink/30">
        {product.brand?.name ?? "King"}
      </span>
    </div>
  );
}

export function ProductCard({ product, prices }: { product: Product; prices: DisplayPrices | null }) {
  const outOfStock = product.variants.every((v) => v.track_stock && v.stock <= 0);
  const [first, second] = product.images;
  return (
    <Link href={`/producto/${product.slug}`} className="group flex flex-col">
      <div className="relative aspect-square overflow-hidden border border-line bg-white">
        <ProductImage product={product} />
        {/* Hover: muestra la segunda foto */}
        {first && second && (
          // eslint-disable-next-line @next/next/no-img-element
          <img
            src={second.url}
            alt=""
            loading="lazy"
            className="absolute inset-0 h-full w-full object-cover opacity-0 transition-opacity duration-300 ease-in-out group-hover:opacity-100"
          />
        )}
        {outOfStock && (
          <span className="absolute left-0 top-0 bg-ink px-2.5 py-1 text-[10px] font-medium uppercase tracking-[2px] text-paper">
            Sin stock
          </span>
        )}
      </div>
      <div className="mt-3 flex flex-1 flex-col gap-1">
        {product.brand && <p className="eyebrow text-[10px]">{product.brand.name}</p>}
        <h3 className="text-[13px] font-bold uppercase leading-snug tracking-[0.5px]">{product.name}</h3>
        {product.adhesive_specs && <AdhesiveBadges specs={product.adhesive_specs} compact />}
        {prices && (
          <div className="mt-auto pt-1">
            <p className="text-[15px] font-bold">
              {prices.from && <span className="text-[11px] font-normal uppercase tracking-wider text-mute">desde </span>}
              {money(prices.list)}
            </p>
            {prices.cash != null && (
              <p className="text-[12px] font-normal text-ok">
                {money(prices.cash)} {prices.transfer != null ? "efectivo o transf." : "en efectivo"}
              </p>
            )}
          </div>
        )}
      </div>
    </Link>
  );
}
