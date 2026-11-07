import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { adminClient } from "@/lib/supabase";
import { getSettings } from "@/lib/catalog";
import { DELIVERY_LABEL, money, PAYMENT_LABEL, shortDate } from "@/lib/format";
import { orderMessage, whatsappLink } from "@/lib/whatsapp";
import type { OrderStatus } from "@/lib/types";
import { CopyButton } from "./copy-button";

export const metadata: Metadata = { title: "Tu pedido", robots: { index: false } };
export const dynamic = "force-dynamic";

const STATUS: Record<OrderStatus, string> = {
  pending_payment: "Pendiente de pago",
  awaiting_proof: "Esperando comprobante",
  deposit_paid: "Seña recibida",
  paid: "Pagado",
  preparing: "Preparando tu pedido",
  ready_pickup: "Listo para retirar",
  moto_coordinating: "Coordinando envío",
  delivered: "Entregado",
  deposit_expired: "Seña vencida",
  cancelled: "Cancelado",
};

type Props = { params: Promise<{ token: string }>; searchParams: Promise<{ status?: string }> };

export default async function OrderPage({ params, searchParams }: Props) {
  const { token } = await params;
  const { status: mpStatus } = await searchParams;
  if (!/^[0-9a-f-]{36}$/i.test(token)) notFound();

  const db = adminClient();
  const [{ data: order }, settings] = await Promise.all([
    db.from("orders").select("*, items:order_items(*)").eq("public_token", token).maybeSingle(),
    getSettings(),
  ]);
  if (!order) notFound();

  // Mientras King no cargue alias/CBU en settings, los datos se piden por WhatsApp
  const hasBankData = Boolean(settings.bank_alias || settings.cbu);
  const message = orderMessage({
    hasBankData,
    number: order.number,
    customerName: order.customer_name,
    delivery: order.delivery,
    payment: order.payment,
    plan: order.plan,
    total: order.total,
    amountDueNow: order.amount_due_now,
    motoAddress: order.moto_address,
    items: order.items.map((i: { name_snapshot: string; options_snapshot: string | null; qty: number }) => ({
      name: i.name_snapshot,
      options: i.options_snapshot,
      qty: i.qty,
    })),
  });
  const wa = whatsappLink(settings.whatsapp, message);
  const unpaidMp = order.payment === "mercadopago" && order.amount_paid === 0;

  return (
    <div className="mx-auto max-w-xl px-4 pb-24 pt-8">
      <p className="eyebrow">Pedido #{order.number}</p>
      <h1 className="mt-2 text-[26px] leading-tight md:text-[32px] leading-tight">
        {order.amount_paid > 0 ? "¡Gracias! Recibimos tu pago." : "¡Listo! Registramos tu pedido."}
      </h1>
      <p className="mt-3 inline-block bg-ink px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.15em] text-paper">{STATUS[order.status as OrderStatus]}</p>

      {/* Próximo paso según el medio de pago */}
      {order.payment === "transfer" && order.amount_paid === 0 && (
        <section className="mt-6 rounded-none border border-ink bg-white p-5">
          <h2 className="font-sans text-base font-bold">Transferí {money(order.amount_due_now)}</h2>
          {!hasBankData && (
            <p className="mt-2 text-sm leading-relaxed text-mute">
              Escribinos por WhatsApp y te pasamos los datos para transferir. Después nos mandás el comprobante por el mismo chat.
            </p>
          )}
          <dl className="mt-3 space-y-2 text-sm">
            {settings.bank_alias && (
              <div className="flex items-center justify-between gap-3">
                <dt className="text-mute">Alias</dt>
                <dd className="flex items-center gap-2 font-semibold">{settings.bank_alias} <CopyButton text={settings.bank_alias} /></dd>
              </div>
            )}
            {settings.cbu && (
              <div className="flex items-center justify-between gap-3">
                <dt className="text-mute">CBU</dt>
                <dd className="flex items-center gap-2 font-mono text-[13px]">{settings.cbu} <CopyButton text={settings.cbu} /></dd>
              </div>
            )}
            {settings.account_holder && (
              <div className="flex justify-between gap-3"><dt className="text-mute">Titular</dt><dd>{settings.account_holder}</dd></div>
            )}
          </dl>
          <a href={wa} target="_blank" rel="noopener" className="btn mt-5 w-full bg-[#25D366] text-white">
            {hasBankData ? "Enviar comprobante por WhatsApp" : "Pedir los datos por WhatsApp"}
          </a>
          <p className="mt-2 text-center text-xs text-mute">El mensaje ya incluye tu número de pedido y el detalle.</p>
        </section>
      )}

      {order.payment === "cash" && order.amount_paid === 0 && (
        <section className="mt-6 rounded-none bg-white p-5 text-sm leading-relaxed">
          <h2 className="font-sans text-base font-bold">Pagás {money(order.amount_due_now)} en efectivo al retirar</h2>
          <p className="mt-2 text-mute">{settings.pickup_address}. {settings.store_hours}.</p>
          <a href={wa} target="_blank" rel="noopener" className="btn-ghost mt-4 w-full">Avisar por WhatsApp</a>
        </section>
      )}

      {unpaidMp && (
        <section className="mt-6 rounded-none bg-white p-5 text-sm">
          {mpStatus === "pending" || mpStatus === "in_process" ? (
            <p>Mercado Pago está procesando tu pago. Te avisamos apenas se acredite.</p>
          ) : mpStatus === "approved" ? (
            <p>Estamos confirmando tu pago con Mercado Pago. Actualizá la página en unos segundos.</p>
          ) : (
            <p>El pago no se completó. Escribinos por WhatsApp y te ayudamos a terminar la compra.</p>
          )}
          <a href={wa} target="_blank" rel="noopener" className="btn-ghost mt-4 w-full">Escribir por WhatsApp</a>
        </section>
      )}

      {order.status === "deposit_paid" && order.deposit_expires_at && (
        <p className="mt-6 rounded-none bg-surface p-4 text-sm">
          Tenés hasta el <strong>{shortDate(order.deposit_expires_at)}</strong> para retirar o completar el pago. El saldo se
          calcula con el precio vigente ese día.
        </p>
      )}

      {/* Detalle */}
      <section className="mt-8">
        <h2 className="eyebrow mb-3">Detalle</h2>
        <ul className="divide-y divide-line text-[15px]">
          {order.items.map((i: { id: number; name_snapshot: string; options_snapshot: string | null; qty: number; unit_price: number }) => (
            <li key={i.id} className="flex justify-between gap-3 py-2.5">
              <span>
                {i.name_snapshot}
                {i.options_snapshot && <span className="block text-sm text-mute">{i.options_snapshot}</span>}
              </span>
              <span className="whitespace-nowrap">{i.qty} × {money(i.unit_price)}</span>
            </li>
          ))}
        </ul>
        <dl className="mt-3 space-y-1 border-t border-line pt-3 text-sm">
          {order.discount > 0 && (
            <div className="flex justify-between text-ok"><dt>Descuento</dt><dd>−{money(order.discount)}</dd></div>
          )}
          <div className="flex justify-between text-base font-bold"><dt>Total</dt><dd>{money(order.total)}</dd></div>
          {order.plan === "deposit" && (
            <div className="flex justify-between"><dt>Seña</dt><dd>{money(order.amount_due_now)}</dd></div>
          )}
          <div className="flex justify-between text-mute"><dt>Entrega</dt><dd>{DELIVERY_LABEL[order.delivery as "pickup" | "moto"]}</dd></div>
          <div className="flex justify-between text-mute"><dt>Pago</dt><dd>{PAYMENT_LABEL[order.payment as "cash"]}</dd></div>
        </dl>
      </section>

      <p className="mt-8 text-xs text-mute">Guardá este enlace para ver el estado de tu pedido.</p>
    </div>
  );
}
