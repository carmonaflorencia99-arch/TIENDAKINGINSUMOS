import Link from "next/link";
import { CartProvider } from "@/components/cart";
import { AddedToast, AnnouncementBar, Header, WhatsAppFab } from "@/components/chrome";
import { getSettings } from "@/lib/catalog";

export const revalidate = 60;

export default async function StoreLayout({ children }: { children: React.ReactNode }) {
  const settings = await getSettings();
  return (
        <CartProvider>
          <AnnouncementBar text={settings.announcement_text} />
          <Header />
          <AddedToast />
          <main>{children}</main>
          <footer className="mt-20 bg-ink px-4 pb-24 pt-12 text-[14px] text-paper">
            <div className="mx-auto mb-10 max-w-6xl">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="/brand/logo-gold.png" alt="King · Insumos de Pestañas" width={782} height={1016} className="h-36 w-auto" loading="lazy" />
            </div>
            <div className="mx-auto grid max-w-6xl gap-8 md:grid-cols-3">
              <div>
                <p className="eyebrow mb-3 text-paper/60">Showroom y retiros</p>
                <p>{settings.pickup_address}</p>
                <p className="mt-1 text-paper/60">{settings.store_hours}</p>
              </div>
              <div>
                <p className="eyebrow mb-3 text-paper/60">Contacto</p>
                <p>WhatsApp 261 244-6705</p>
                <a href="https://instagram.com/King_insumos" className="underline underline-offset-4">
                  @King_insumos
                </a>
              </div>
              <div className="flex flex-col gap-1.5">
                <p className="eyebrow mb-2 text-paper/60">Ayuda</p>
                <Link href="/como-comprar">Cómo comprar, pagos y señas</Link>
                <Link href="/como-comprar#envios">Envíos y retiros</Link>
                <Link href="/como-comprar#cambios">Cambios y devoluciones</Link>
              </div>
            </div>
            <p className="mx-auto mt-12 max-w-6xl border-t border-paper/20 pt-6 text-[11px] uppercase tracking-[2px] text-paper/50">
              King Insumos · Distribuidores oficiales de The Lion Beauty, Zaphiria y Abruxlashes en Mendoza
            </p>
          </footer>
          <WhatsAppFab phone={settings.whatsapp} />
        </CartProvider>
  );
}
