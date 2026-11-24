"use client";
/**
 * Checkout por WhatsApp: la clienta deja sus datos y la dirección, se registra
 * el pedido y se abre WhatsApp con el pedido armado. King le pasa los datos
 * para transferir y coordina el envío. Solo envíos y solo transferencia.
 */
import Link from "next/link";
import { useMemo, useState } from "react";
import { useCart } from "@/components/cart";
import { money } from "@/lib/format";
import { computeTotals, discountPctFor, unitPrice } from "@/lib/pricing";
import type { Category, PaymentRule } from "@/lib/types";

interface Props {
  transferRule: PaymentRule | undefined;
  categories: Pick<Category, "id" | "parent_id">[];
}

export function CheckoutForm({ transferRule, categories }: Props) {
  const { lines, clear } = useCart();
  const [form, setForm] = useState({ name: "", phone: "", email: "", address: "", notes: "" });
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [sent, setSent] = useState<{ whatsapp: string; orderUrl: string } | null>(null);

  const summary = useMemo(() => {
    const priced = lines.map((l) => {
      const pct = discountPctFor(transferRule, l.categoryId, categories);
      return { variantId: l.variantId, qty: l.qty, unitListPrice: l.priceList, unitPrice: unitPrice(l.priceList, pct) };
    });
    return computeTotals(priced);
  }, [lines, transferRule, categories]);

  // Si el navegador no abrió WhatsApp solo, queda el botón para abrirlo a mano
  if (sent)
    return (
      <div className="mx-auto max-w-md px-4 py-16 text-center">
        <h1 className="title">¡Listo! Ya armamos tu pedido</h1>
        <p className="mt-3 text-mute">Mandalo por WhatsApp y te pasamos los datos para transferir y coordinar el envío.</p>
        <a href={sent.whatsapp} className="btn mt-6 w-full bg-[#25D366] text-white">Enviar pedido por WhatsApp</a>
        <Link href={sent.orderUrl} className="mt-4 inline-block border-b border-ink pb-0.5 text-[12px] uppercase tracking-[2px]">
          Ver mi pedido
        </Link>
      </div>
    );

  if (lines.length === 0)
    return (
      <div className="mx-auto max-w-md px-4 py-20 text-center">
        <h1 className="title">No hay productos en el carrito</h1>
        <Link href="/" className="btn mt-6">Ver productos</Link>
      </div>
    );

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    setSending(true);
    setError(null);
    try {
      const res = await fetch("/api/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          lines: lines.map((l) => ({ variantId: l.variantId, qty: l.qty })),
          customer: { name: form.name, phone: form.phone, email: form.email },
          address: form.address,
          notes: form.notes,
        }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error ?? "No pudimos armar el pedido.");
      clear();
      setSent(data);
      window.location.href = data.whatsapp;
    } catch (err) {
      setError(err instanceof Error ? err.message : "No pudimos armar el pedido.");
      setSending(false);
    }
  };

  const set = (k: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) =>
    setForm((f) => ({ ...f, [k]: e.target.value }));

  return (
    <form onSubmit={submit} className="mx-auto max-w-2xl space-y-9 px-4 pb-36 pt-6">
      <div>
        <h1 className="text-[26px] leading-tight md:text-[32px]">Finalizar pedido</h1>
        <p className="mt-2 text-[15px] leading-relaxed text-mute">
          Completá tus datos y te abrimos WhatsApp con el pedido listo para mandar. Ahí te pasamos los datos para
          transferir y coordinamos el envío.
        </p>
      </div>

      <section className="space-y-3">
        <h2 className="eyebrow">1 · Tus datos</h2>
        <input className="field" placeholder="Nombre y apellido" autoComplete="name" value={form.name} onChange={set("name")} required />
        <input className="field" placeholder="WhatsApp (ej. 261 555-1234)" type="tel" autoComplete="tel" inputMode="tel" value={form.phone} onChange={set("phone")} required />
        <input className="field" placeholder="Email (opcional)" type="email" autoComplete="email" value={form.email} onChange={set("email")} />
      </section>

      <section className="space-y-3">
        <h2 className="eyebrow">2 · Envío</h2>
        <input
          className="field"
          placeholder="Dirección de entrega (calle, número, depto, localidad)"
          autoComplete="street-address"
          value={form.address}
          onChange={set("address")}
          required
        />
        <p className="text-sm leading-relaxed text-mute">
          Trabajamos solo con envíos. El pedido se abona completo por transferencia antes de enviarlo y el costo del
          envío corre por tu cuenta.
        </p>
        <textarea className="field min-h-20" placeholder="¿Algo que tengamos que saber? (opcional)" value={form.notes} onChange={set("notes")} />
      </section>

      <section className="rounded-none bg-white p-5 text-[15px]">
        <h2 className="eyebrow mb-3">Resumen · {lines.reduce((s, l) => s + l.qty, 0)} productos</h2>
        <div className="space-y-1.5">
          <div className="flex justify-between"><span className="text-mute">Subtotal</span><span>{money(summary.subtotal)}</span></div>
          {summary.discount > 0 && (
            <div className="flex justify-between text-ok"><span>Transferencia 10% OFF</span><span>−{money(summary.discount)}</span></div>
          )}
          <div className="flex justify-between border-t border-line pt-2 text-lg font-bold"><span>Total por transferencia</span><span>{money(summary.total)}</span></div>
        </div>
        <p className="mt-3 text-xs text-mute">
          Pago solo por transferencia: 10% OFF en todo. No realizamos cambios ni devoluciones.
        </p>
      </section>

      {error && <p role="alert" className="rounded-none bg-rose/10 p-3 text-sm font-semibold text-rose">{error}</p>}

      <div className="fixed inset-x-0 bottom-0 z-30 border-t border-line bg-paper/95 px-4 pb-[calc(env(safe-area-inset-bottom)+12px)] pt-3 backdrop-blur md:static md:border-0 md:p-0">
        <button type="submit" className="btn w-full" disabled={sending}>
          {sending ? "Armando tu pedido…" : `Enviar pedido por WhatsApp · ${money(summary.total)}`}
        </button>
      </div>
    </form>
  );
}
