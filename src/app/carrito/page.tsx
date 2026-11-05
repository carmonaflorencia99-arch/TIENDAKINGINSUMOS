"use client";
import Link from "next/link";
import { useEffect, useRef } from "react";
import { useCart } from "@/components/cart";
import { money } from "@/lib/format";

export default function CartPage() {
  const { lines, setQty, remove, replace } = useCart();
  const refreshed = useRef(false);

  // Actualiza precios y stock al abrir el carrito
  useEffect(() => {
    if (refreshed.current || lines.length === 0) return;
    refreshed.current = true;
    fetch("/api/cart/refresh", { method: "POST", body: JSON.stringify({ lines }) })
      .then((r) => r.json())
      .then((d) => Array.isArray(d.lines) && replace(d.lines))
      .catch(() => {});
  }, [lines, replace]);

  const subtotal = lines.reduce((s, l) => s + l.priceList * l.qty, 0);

  if (lines.length === 0)
    return (
      <div className="mx-auto max-w-md px-4 py-20 text-center">
        <h1 className="title">Tu carrito está vacío</h1>
        <p className="mt-2 text-mute">Sumá productos y retiralos en el showroom o pedí tu moto.</p>
        <Link href="/" className="btn mt-6">Ver productos</Link>
      </div>
    );

  return (
    <div className="mx-auto max-w-2xl px-4 pb-32 pt-6">
      <h1 className="text-[26px] leading-tight md:text-[32px]">Carrito</h1>
      <ul className="mt-6 divide-y divide-line">
        {lines.map((l) => {
          const max = l.trackStock ? l.stock : 99;
          const over = l.qty > max;
          return (
            <li key={l.variantId} className="flex gap-3 py-4">
              <div className="h-20 w-20 shrink-0 overflow-hidden rounded-none border border-line bg-surface">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                {l.image && <img src={l.image} alt="" className="h-full w-full object-cover" />}
              </div>
              <div className="flex flex-1 flex-col">
                <Link href={`/producto/${l.productSlug}`} className="text-[15px] font-semibold leading-snug">
                  {l.productName}
                </Link>
                {l.optionsLabel && <p className="text-sm text-mute">{l.optionsLabel}</p>}
                {over && (
                  <p className="text-xs font-semibold text-rose">
                    {max > 0 ? `Quedan ${max}. Ajustá la cantidad.` : "Sin stock: quitalo para continuar."}
                  </p>
                )}
                <div className="mt-auto flex items-center justify-between pt-2">
                  <div className="flex items-center border border-line bg-white">
                    <button className="h-9 w-9" aria-label="Quitar uno" onClick={() => setQty(l.variantId, l.qty - 1)}>−</button>
                    <span className="w-6 text-center text-sm font-semibold tabular-nums">{l.qty}</span>
                    <button className="h-9 w-9 disabled:opacity-30" aria-label="Sumar uno" disabled={l.qty >= max} onClick={() => setQty(l.variantId, l.qty + 1)}>+</button>
                  </div>
                  <div className="text-right">
                    <p className="font-semibold">{money(l.priceList * l.qty)}</p>
                    <button className="text-xs text-mute underline" onClick={() => remove(l.variantId)}>Quitar</button>
                  </div>
                </div>
              </div>
            </li>
          );
        })}
      </ul>

      <div className="mt-4 rounded-none bg-white p-4 text-sm">
        <div className="flex justify-between text-base">
          <span>Subtotal (precio de lista)</span>
          <span className="font-bold">{money(subtotal)}</span>
        </div>
        <p className="mt-2 text-mute">
          En el siguiente paso elegís retiro o moto y el medio de pago. Efectivo 10% OFF en todo · Transferencia 10% OFF
          excepto pestañas.
        </p>
      </div>

      <div className="fixed inset-x-0 bottom-0 z-30 border-t border-line bg-paper/95 px-4 pb-[calc(env(safe-area-inset-bottom)+12px)] pt-3 backdrop-blur md:static md:mt-6 md:border-0 md:p-0">
        <Link
          href="/checkout"
          aria-disabled={lines.some((l) => l.trackStock && l.qty > l.stock)}
          className="btn w-full aria-disabled:pointer-events-none aria-disabled:opacity-40"
        >
          Continuar compra
        </Link>
      </div>
    </div>
  );
}
