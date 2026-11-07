import Link from "next/link";
import { getBrands, getCategories, getCategoryCovers, getHighlighted, getPaymentRules, getSettings } from "@/lib/catalog";
import { getInstagramPosts } from "@/lib/instagram";
import { InstagramGrid } from "@/components/instagram-grid";
import { productPrices } from "@/lib/display-prices";
import { ProductCard } from "@/components/product-card";
import { Carousel } from "@/components/carousel";
import { Marquee } from "@/components/marquee";

export const revalidate = 60;

export default async function Home() {
  const [categories, brands, products, rules, settings] = await Promise.all([
    getCategories(),
    getBrands(),
    getHighlighted(),
    getPaymentRules(),
    getSettings(),
  ]);
  const main = categories.filter((c) => c.parent_id == null);
  const [covers, instagram] = await Promise.all([getCategoryCovers(categories), getInstagramPosts(8)]);
  const lion = brands.find((b) => b.featured);

  return (
    <>
      {/* Hero: foto propia de King sobre negro (public/brand/hero.jpg) */}
      <section className="bg-ink text-paper">
        <div className="mx-auto grid max-w-6xl md:grid-cols-2 md:items-center md:px-4">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img
            src="/brand/hero.jpg"
            alt="Cajas de pestañas Zaphiria Lumi 4D, 5D y 6D"
            width={1086}
            height={1448}
            className="aspect-[4/3] w-full object-cover object-[50%_45%] md:order-2 md:aspect-[4/5] md:max-h-[640px]"
          />
          <div className="px-4 pb-12 pt-6 md:px-0 md:py-16 md:pr-10">
            {/* El h1 describe el negocio (SEO); visualmente manda el titular */}
            <h1 className="animate-fade-up text-[11px] font-medium tracking-[2px] text-paper/60">
              Insumos profesionales de pestañas y cejas en Mendoza
            </h1>
            <p className="mt-4 max-w-lg animate-fade-up text-[32px] font-light uppercase leading-[1.1] tracking-[3px] [animation-delay:.1s] md:text-[48px]">
              Todo para tu gabinete, listo para retirar hoy
            </p>
            <div className="mt-8 flex animate-fade-up flex-wrap gap-3 [animation-delay:.2s]">
              <Link href="/categoria/extensiones-de-pestanas" className="btn bg-paper text-ink">Ver pestañas</Link>
              <Link href="/categoria/adhesivos" className="btn-ghost border-paper text-paper hover:bg-paper hover:text-ink">
                Adhesivos
              </Link>
            </div>
          </div>
        </div>
      </section>

      <Marquee
        items={[
          lion ? `Distribuidores oficiales ${lion.name}` : "Insumos profesionales",
          "Efectivo 10% OFF en todo",
          "Retiro en el showroom · Mendoza Centro",
          "Envíos por moto",
          "Señá tu pedido con el 50%",
        ]}
      />

      <div className="mx-auto max-w-6xl px-4">
        <section className="mt-14">
          <h2 className="title mb-7 text-center">Lo más pedido</h2>
          <Carousel label="Lo más pedido">
            {products.map((p) => (
              <ProductCard key={p.id} product={p} prices={productPrices(p, rules, categories)} />
            ))}
          </Carousel>
        </section>

        <section className="mt-16">
          <h2 className="title mb-7 text-center">Comprá por categoría</h2>
          <ul className="grid grid-cols-2 gap-3 md:grid-cols-3">
            {main.map((c) => (
              <li key={c.id}>
                <Link
                  href={`/categoria/${c.slug}`}
                  className="group relative flex aspect-[4/3] items-end overflow-hidden border border-line bg-surface md:aspect-[16/9]"
                >
                  {covers[c.id] && (
                    // eslint-disable-next-line @next/next/no-img-element
                    <img
                      src={covers[c.id]}
                      alt=""
                      loading="lazy"
                      className="absolute inset-0 h-full w-full object-cover transition-transform duration-500 group-hover:scale-[1.04]"
                    />
                  )}
                  <span className="absolute inset-0 bg-gradient-to-t from-ink/75 via-ink/10 to-transparent" aria-hidden />
                  <span className="relative p-4 text-[13px] font-medium uppercase leading-snug tracking-[1.5px] text-paper">
                    {c.name}
                  </span>
                </Link>
              </li>
            ))}
          </ul>
        </section>

        {lion && (
          <Link href={`/marca/${lion.slug}`} className="mt-16 block bg-ink px-6 py-10 text-center text-paper">
            <span className="eyebrow block text-paper/60">Distribuidores oficiales en Mendoza</span>
            <span className="mt-2 block text-[24px] font-light uppercase tracking-[4px]">{lion.name}</span>
            <span className="mt-5 inline-block border-b border-paper pb-0.5 text-[12px] uppercase tracking-[2px]">Ver productos</span>
          </Link>
        )}

        {instagram.length > 0 && (
          <section className="mt-16">
            <h2 className="title mb-2 text-center">Seguinos en Instagram</h2>
            <p className="mb-7 text-center">
              <a href="https://instagram.com/King_insumos" target="_blank" rel="noopener" className="border-b border-ink pb-0.5 text-[12px] uppercase tracking-[2px]">
                @King_insumos
              </a>
            </p>
            <InstagramGrid posts={instagram} />
          </section>
        )}

        <section className="mt-16 grid border border-line md:grid-cols-3">
          {[
            ["Retiro en el showroom", settings.pickup_address ?? ""],
            ["Envío por moto", "Uber, Cabify o similar. El pedido se abona por transferencia antes del envío."],
            ["Señá con el 50%", "Tenés 10 días hábiles para completar el pago y retirar."],
          ].map(([t, d], i) => (
            <div key={t} className={`p-6 ${i > 0 ? "border-t border-line md:border-l md:border-t-0" : ""}`}>
              <h3 className="text-[13px] font-bold uppercase tracking-[1px]">{t}</h3>
              <p className="mt-2 text-[14px] leading-relaxed text-mute">{d}</p>
            </div>
          ))}
        </section>

        <div className="mt-6 text-center">
          <Link href="/como-comprar" className="border-b border-ink pb-0.5 text-[12px] uppercase tracking-[2px]">
            Medios de pago, señas y condiciones
          </Link>
        </div>
      </div>
    </>
  );
}
