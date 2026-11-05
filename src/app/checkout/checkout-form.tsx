"use client";
import Link from "next/link";
import { useMemo, useState } from "react";
import { useCart } from "@/components/cart";
import { money } from "@/lib/format";
import { availableMethods, computeTotals, depositAmount, discountPctFor, unitPrice } from "@/lib/pricing";
import type { Category, DeliveryMethod, PaymentMethod, PaymentPlan, PaymentRule } from "@/lib/types";

interface Props {
  rules: PaymentRule[];
  categories: Pick<Category, "id" | "parent_id">[];
  depositPct: number;
  depositDays: number;
  pickupAddress: string;
  storeHours: string;
}

function Option({
  checked,
  onSelect,
  title,
  children,
  name,
}: {
  checked: boolean;
  onSelect: () => void;
  title: string;
  children?: React.ReactNode;
  name: string;
}) {
  return (
    <label
      className={`flex cursor-pointer gap-3 rounded-none border bg-white p-4 transition ${
        checked ? "border-ink ring-1 ring-ink" : "border-line"
      }`}
    >
      <input type="radio" name={name} checked={checked} onChange={onSelect} className="mt-1 accent-ink" />
      <span>
        <span className="block text-[15px] font-semibold">{title}</span>
        {children && <span className="mt-0.5 block text-sm leading-relaxed text-mute">{children}</span>}
      </span>
    </label>
  );
}

export function CheckoutForm({ rules, categories, depositPct, depositDays, pickupAddress, storeHours }: Props) {
  const { lines, clear } = useCart();
  const [delivery, setDelivery] = useState<DeliveryMethod>("pickup");
  const [plan, setPlan] = useState<PaymentPlan>("full");
  const [payment, setPayment] = useState<PaymentMethod | null>(null);
  const [form, setForm] = useState({ name: "", phone: "", email: "", motoAddress: "", notes: "" });
  const [sending, setSending] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const effectivePlan: PaymentPlan = delivery === "moto" ? "full" : plan;
  const methods = availableMethods(delivery, effectivePlan, rules);
  const method = methods.find((m) => m.method === payment) ?? methods[0];
  const depositAllowed = delivery === "pickup" && rules.some((r) => r.allows_deposit);

  const summary = useMemo(() => {
    const priced = lines.map((l) => {
      const pct = discountPctFor(method, l.categoryId, categories);
      return { variantId: l.variantId, qty: l.qty, unitListPrice: l.priceList, unitPrice: unitPrice(l.priceList, pct) };
    });
    const totals = computeTotals(priced);
    const dueNow = effectivePlan === "deposit" ? depositAmount(totals.total, depositPct) : totals.total;
    return { ...totals, dueNow };
  }, [lines, method, categories, effectivePlan, depositPct]);

  if (lines.length === 0)
    return (
      <div className="mx-auto max-w-md px-4 py-20 text-center">
        <h1 className="title">No hay productos en el carrito</h1>
        <Link href="/" className="btn mt-6">Ver productos</Link>
      </div>
    );

  const submit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!method) return;
    setSending(true);
    setError(null);
    try {
      const res = await fetch("/api/checkout", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          lines: lines.map((l) => ({ variantId: l.variantId, qty: l.qty })),
          customer: { name: form.name, phone: form.phone, email: form.email },
          delivery,
          plan: effectivePlan,
          payment: method.method,
          motoAddress: form.motoAddress,
          notes: form.notes,
        }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.error ?? "No pudimos crear el pedido.");
      clear();
      window.location.href = data.redirect;
    } catch (err) {
      setError(err instanceof Error ? err.message : "No pudimos crear el pedido.");
      setSending(false);
    }
  };

  const set = (k: keyof typeof form) => (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) =>
    setForm((f) => ({ ...f, [k]: e.target.value }));

  return (
    <form onSubmit={submit} className="mx-auto max-w-2xl space-y-9 px-4 pb-36 pt-6">
      <h1 className="text-[26px] leading-tight md:text-[32px]">Finalizar compra</h1>

      {/* 1. Entrega */}
      <section className="space-y-3">
        <h2 className="eyebrow">1 · ¿Cómo lo recibís?</h2>
        <Option name="delivery" checked={delivery === "pickup"} onSelect={() => setDelivery("pickup")} title="Retiro en el showroom — gratis">
          {pickupAddress}. {storeHours}.
        </Option>
        <Option name="delivery" checked={delivery === "moto"} onSelect={() => setDelivery("moto")} title="Envío por moto (Uber, Cabify o similar)">
          Se abona completo por transferencia. Cuando nos mandás el comprobante coordinamos y vos pedís el viaje, lo seguís y
          recibís el pedido. El costo del viaje corre por tu cuenta.
        </Option>
        {delivery === "moto" && (
          <input className="field" placeholder="Dirección de entrega (calle, número, departamento)" value={form.motoAddress} onChange={set("motoAddress")} required />
        )}
      </section>

      {/* 2. Seña o total */}
      {depositAllowed && (
        <section className="space-y-3">
          <h2 className="eyebrow">2 · ¿Pagás todo o señás?</h2>
          <Option name="plan" checked={plan === "full"} onSelect={() => setPlan("full")} title="Pago total" />
          <Option name="plan" checked={plan === "deposit"} onSelect={() => setPlan("deposit")} title={`Seña del ${depositPct}%`}>
            Tenés {depositDays} días hábiles para retirar o completar el pago. Pasado ese plazo la seña no se reembolsa.{" "}
            <strong className="text-ink">Los precios no se congelan:</strong> si el producto aumenta, el saldo se ajusta al precio
            del día en que completás el pago.
          </Option>
        </section>
      )}

      {/* 3. Medio de pago */}
      <section className="space-y-3">
        <h2 className="eyebrow">{depositAllowed ? "3" : "2"} · Medio de pago</h2>
        {methods.map((m) => (
          <Option key={m.method} name="payment" checked={method?.method === m.method} onSelect={() => setPayment(m.method)} title={m.label}>
            {m.method === "cash" && "10% OFF en todos los productos. Pagás al retirar."}
            {m.method === "transfer" && "10% OFF excepto pestañas. Al confirmar te mostramos el alias y nos mandás el comprobante por WhatsApp."}
            {m.method === "mercadopago" && "Tarjetas de crédito y débito, cuotas o dinero en cuenta."}
          </Option>
        ))}
        {methods.length === 0 && <p className="text-sm text-rose">No hay medios de pago disponibles para esta opción.</p>}
      </section>

      {/* 4. Datos */}
      <section className="space-y-3">
        <h2 className="eyebrow">{depositAllowed ? "4" : "3"} · Tus datos</h2>
        <input className="field" placeholder="Nombre y apellido" autoComplete="name" value={form.name} onChange={set("name")} required />
        <input className="field" placeholder="WhatsApp (ej. 261 555-1234)" type="tel" autoComplete="tel" inputMode="tel" value={form.phone} onChange={set("phone")} required />
        <input className="field" placeholder="Email (opcional)" type="email" autoComplete="email" value={form.email} onChange={set("email")} />
        <textarea className="field min-h-20" placeholder="¿Algo que tengamos que saber? (opcional)" value={form.notes} onChange={set("notes")} />
      </section>

      {/* Resumen */}
      <section className="rounded-none bg-white p-5 text-[15px]">
        <h2 className="eyebrow mb-3">Resumen · {lines.reduce((s, l) => s + l.qty, 0)} productos</h2>
        <div className="space-y-1.5">
          <div className="flex justify-between"><span className="text-mute">Subtotal</span><span>{money(summary.subtotal)}</span></div>
          {summary.discount > 0 && (
            <div className="flex justify-between text-ok"><span>Descuento {method?.label.toLowerCase()}</span><span>−{money(summary.discount)}</span></div>
          )}
          <div className="flex justify-between border-t border-line pt-2 text-lg font-bold"><span>Total</span><span>{money(summary.total)}</span></div>
          {effectivePlan === "deposit" && (
            <div className="flex justify-between rounded-none bg-surface px-3 py-2 font-semibold">
              <span>Seña a pagar ahora</span><span>{money(summary.dueNow)}</span>
            </div>
          )}
        </div>
        <p className="mt-3 text-xs text-mute">No realizamos cambios ni devoluciones. Los adhesivos se controlan al momento de la compra.</p>
      </section>

      {error && <p role="alert" className="rounded-none bg-rose/10 p-3 text-sm font-semibold text-rose">{error}</p>}

      <div className="fixed inset-x-0 bottom-0 z-30 border-t border-line bg-paper/95 px-4 pb-[calc(env(safe-area-inset-bottom)+12px)] pt-3 backdrop-blur md:static md:border-0 md:p-0">
        <button type="submit" className="btn w-full" disabled={sending || !method}>
          {sending
            ? "Creando pedido…"
            : method?.method === "mercadopago"
              ? `Pagar ${money(summary.dueNow)} con Mercado Pago`
              : `Confirmar pedido · ${money(summary.dueNow)}`}
        </button>
      </div>
    </form>
  );
}
