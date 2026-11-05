"use client";
/** Encabezado, barra de anuncios, botón de WhatsApp y aviso de "agregado". */
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { useCart } from "./cart";
import { whatsappLink } from "@/lib/whatsapp";

/**
 * Logo de King. Archivos en /public/brand:
 *  lockup-*  horizontal (encabezado) · logo-*  vertical completo · mark-*  solo emblema
 *  *-black para fondos claros · *-gold para fondos negros
 */
export function Logo({ compact = false }: { compact?: boolean }) {
  return (
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src="/brand/lockup-black.png"
      alt="King · Insumos de Pestañas"
      width={880}
      height={300}
      className={`w-auto transition-[height] duration-300 ease-linear ${compact ? "h-10" : "h-14 md:h-16"}`}
    />
  );
}

export function AnnouncementBar({ text }: { text: string | null }) {
  if (!text) return null;
  return (
    <div className="bg-ink px-4 py-2.5 text-center text-[11px] font-normal uppercase leading-4 tracking-[2px] text-paper">
      {text}
    </div>
  );
}

export function Header() {
  const { count } = useCart();
  const path = usePathname();
  const [q, setQ] = useState("");
  // el encabezado se compacta al hacer scroll
  const [compact, setCompact] = useState(false);
  useEffect(() => {
    const onScroll = () => setCompact(window.scrollY > 40);
    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
    return () => window.removeEventListener("scroll", onScroll);
  }, []);
  if (path.startsWith("/admin")) return null;

  return (
    <header className="sticky top-0 z-30 border-b border-line bg-paper/95 backdrop-blur">
      <div
        className={`mx-auto flex max-w-6xl items-center justify-between gap-3 px-4 transition-[padding] duration-300 ease-linear ${
          compact ? "py-1.5" : "py-3"
        }`}
      >
        <Link href="/como-comprar" className="w-16 text-[10px] font-medium uppercase leading-tight tracking-[1.5px]">
          Cómo comprar
        </Link>
        <Link href="/" aria-label="King Insumos — inicio">
          <Logo compact={compact} />
        </Link>
        <Link href="/carrito" className="relative flex w-16 justify-end" aria-label={`Carrito, ${count} productos`}>
          <svg viewBox="0 0 24 24" className="h-6 w-6" fill="none" stroke="currentColor" strokeWidth={1.6}>
            <path d="M5 8h14l-1.2 11.2a2 2 0 0 1-2 1.8H8.2a2 2 0 0 1-2-1.8L5 8Z" />
            <path d="M9 8V6a3 3 0 0 1 6 0v2" />
          </svg>
          {count > 0 && (
            <span className="absolute -right-2 -top-1.5 grid h-5 min-w-5 place-items-center rounded-full bg-ink px-1 text-[10px] font-medium text-paper">
              {count}
            </span>
          )}
        </Link>
      </div>
      {/* Buscador siempre visible */}
      <form action="/buscar" className="mx-auto max-w-6xl px-4 pb-3">
        <label className="relative block">
          <span className="sr-only">Buscar productos</span>
          <svg viewBox="0 0 24 24" className="pointer-events-none absolute left-4 top-1/2 h-4 w-4 -translate-y-1/2 text-mute" fill="none" stroke="currentColor" strokeWidth={2}>
            <circle cx="11" cy="11" r="7" /><path d="m20 20-3.5-3.5" />
          </svg>
          <input
            name="q"
            value={q}
            onChange={(e) => setQ(e.target.value)}
            placeholder="Buscá adhesivo, pinzas, YY 0.07…"
            className="w-full rounded-[3px] border border-divider bg-white py-2.5 pl-10 pr-4 text-[15px] font-normal outline-none placeholder:font-light focus:border-ink"
            enterKeyHint="search"
          />
        </label>
      </form>
    </header>
  );
}

/**
 * Botón flotante de WhatsApp. En la ficha de producto sube para no tapar
 * la barra fija de "Agregar al carrito".
 */
export function WhatsAppFab({ phone }: { phone: string }) {
  const path = usePathname();
  // checkout y pedido ya tienen sus propios botones de WhatsApp
  if (["/admin", "/checkout", "/pedido"].some((p) => path.startsWith(p))) return null;
  // sube donde hay barra fija inferior (agregar al carrito / continuar compra)
  const raised = path.startsWith("/producto") || path.startsWith("/carrito");
  return (
    <a
      href={whatsappLink(phone, "¡Hola King! Tengo una consulta:")}
      target="_blank"
      rel="noopener"
      aria-label="Escribinos por WhatsApp"
      className={`fixed right-4 z-40 grid h-12 w-12 place-items-center rounded-full bg-[#25D366] text-white shadow-lg shadow-black/15 transition-[bottom] ${
        raised ? "bottom-28 md:bottom-6" : "bottom-5"
      }`}
    >
      <svg viewBox="0 0 24 24" className="h-6 w-6" fill="currentColor" aria-hidden>
        <path d="M12 2a10 10 0 0 0-8.6 15.1L2 22l5-1.3A10 10 0 1 0 12 2Zm0 18.2a8.2 8.2 0 0 1-4.2-1.2l-.3-.2-3 .8.8-2.9-.2-.3A8.2 8.2 0 1 1 12 20.2Zm4.5-6.1c-.2-.1-1.5-.7-1.7-.8s-.4-.1-.6.1-.6.8-.8 1-.3.2-.5.1a6.7 6.7 0 0 1-3.3-2.9c-.2-.4.2-.4.7-1.3.1-.2 0-.3 0-.4l-.8-1.8c-.2-.5-.4-.4-.6-.4h-.5a1 1 0 0 0-.7.3 3 3 0 0 0-.9 2.2 5.2 5.2 0 0 0 1.1 2.7 11.8 11.8 0 0 0 4.5 4c1.7.7 2.3.8 3.2.6a2.7 2.7 0 0 0 1.8-1.2 2.2 2.2 0 0 0 .1-1.3c0-.1-.2-.2-.5-.3Z" />
      </svg>
    </a>
  );
}

/** Aviso breve al agregar al carrito. */
export function AddedToast() {
  const { lastAdded } = useCart();
  const [show, setShow] = useState(false);
  useEffect(() => {
    if (!lastAdded) return;
    setShow(true);
    const t = setTimeout(() => setShow(false), 2600);
    return () => clearTimeout(t);
  }, [lastAdded]);
  return (
    <div
      role="status"
      className={`fixed inset-x-4 top-4 z-50 mx-auto flex max-w-sm items-center justify-between rounded-none bg-ink px-5 py-3.5 text-sm text-paper shadow-xl transition ${
        show ? "translate-y-0 opacity-100" : "pointer-events-none -translate-y-4 opacity-0"
      }`}
    >
      <span>Agregado al carrito</span>
      <Link href="/carrito" className="font-semibold underline underline-offset-4">
        Ver carrito
      </Link>
    </div>
  );
}
