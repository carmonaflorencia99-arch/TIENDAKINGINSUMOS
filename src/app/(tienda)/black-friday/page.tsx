import Link from "next/link";
import type { Metadata } from "next";
import { getAllProducts, getCategories, getPaymentRules } from "@/lib/catalog";
import { productPrices } from "@/lib/display-prices";
import { BLACK_FRIDAY, blackFridayActive } from "@/lib/promo";
import { ProductCard } from "@/components/product-card";

export const revalidate = 60;

export const metadata: Metadata = {
  title: "Black Friday",
  description: "Black Friday en King Insumos: hasta 60% OFF en pestañas, adhesivos y The Lion Beauty. Solo viernes 27 y sábado 28 de noviembre.",
};

/** Títulos de cada grupo de ofertas, de mayor a menor descuento. */
const GROUPS: { pct: number; title: string; note: string }[] = [
  { pct: 60, title: "60% OFF", note: "Pestañas tecnológicas Zaphiria medidas únicas, cajas chicas (no incluye Lumi ni cajas grandes). Últimas unidades." },
  { pct: 15, title: "15% OFF", note: "Adhesivo Love de Clione, Adhesivo Lady Diana y Súper Bonder de Gollee." },
  { pct: 10, title: "10% OFF", note: "Todo The Lion Beauty." },
];

export default async function BlackFridayPage() {
  const active = blackFridayActive();
  const [products, categories, rules] = await Promise.all([getAllProducts(), getCategories(), getPaymentRules()]);
  const withPrices = products
    .map((p) => ({ p, prices: productPrices(p, rules, categories) }))
    .filter((x) => x.prices && x.prices.promoPct > 0);

  return (
    <>
      <section className="bg-ink px-4 py-12 text-center text-paper md:py-16">
        <p className="eyebrow text-paper/60">
          <span className="text-gold">✦</span> {BLACK_FRIDAY.datesLabel} <span className="text-gold">✦</span>
        </p>
        <h1 className="mt-4 text-[44px] font-light uppercase leading-none tracking-[6px] md:text-[72px]">Black Friday</h1>
        <p className="mt-4 text-[22px] font-normal uppercase tracking-[4px] md:text-[28px]">
          Hasta <span className="text-gold">{BLACK_FRIDAY.maxPct}% OFF</span>
        </p>
        <p className="mx-auto mt-4 max-w-md text-[14px] text-paper/70">
          Descuentos sobre precio de lista, con cualquier medio de pago. No se suman al 10% de transferencia.
        </p>
      </section>

      <div className="mx-auto max-w-6xl px-4">
        {!active ? (
          <div className="py-16 text-center">
            <p className="title">El Black Friday terminó</p>
            <p className="mt-2 text-mute">Gracias por acompañarnos. Seguí viendo todo el catálogo.</p>
            <Link href="/" className="btn mt-6">Ir a la tienda</Link>
          </div>
        ) : (
          GROUPS.map((g) => {
            const items = withPrices.filter((x) => x.prices!.promoPct === g.pct);
            if (items.length === 0) return null;
            return (
              <section key={g.pct} className="mt-12">
                <h2 className="title text-center">{g.title}</h2>
                <p className="mx-auto mb-7 mt-2 max-w-xl text-center text-[14px] text-mute">{g.note}</p>
                <div className="grid grid-cols-2 gap-x-3 gap-y-7 sm:grid-cols-3 lg:grid-cols-4">
                  {items.map(({ p, prices }) => (
                    <ProductCard key={p.id} product={p} prices={prices} />
                  ))}
                </div>
              </section>
            );
          })
        )}
      </div>
    </>
  );
}
