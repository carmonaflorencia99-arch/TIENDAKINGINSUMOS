import { notFound } from "next/navigation";
import type { Metadata } from "next";
import { adminClient } from "@/lib/supabase";
import { getSettings } from "@/lib/catalog";
import { money } from "@/lib/format";
import { orderMessage, whatsappLink } from "@/lib/whatsapp";
import type { OrderStatus } from "@/lib/types";

export const metadata: Metadata = { title: "Tu pedido", robots: { index: false } };
export const dynamic = "force-dynamic";

const STATUS: Record<OrderStatus, string> = {
  pending_payment: "Pendiente de pago",
  awaiting_proof: "Esperando el pago",
  deposit_paid: "Seña recibida",
  paid: "Pagado",
  preparing: "Preparando tu pedido",
  ready_pickup: "Listo para retirar",
  moto_coordinating: "Coordinando envío",
  delivered: "Entregado",
  deposit_expired: "Seña vencida",
  cancelled: "Cancelado",
};

type Props = { params: Promise<{ token: string }> };

export default async function OrderPage({ params }: Props) {
  const { token } = await params;
  if (!/^[0-9a-f-]{36}$/i.test(token)) notFound();

  const db = adminClient();
  const [{ data: order }, settings] = await Promise.all([
    db.from("orders").select("*, items:order_items(*)").eq("public_token", token).maybeSingle(),
    getSettings(),
  ]);
  if (!order) notFound();

  const message = orderMessage({
    number: order.number,
    customerName: order.customer_name,
    total: order.total,
    discount: order.discount,
    address: order.moto_address,
    notes: order.notes,
    items: order.items.map((i: { name_snapshot: string; options_snapshot: string | null; qty: number }) => ({
      name: i.name_snapshot,
      options: i.options_snapshot,
      qty: i.qty,
    })),
  });
  const wa = whatsappLink(settings.whatsapp, message);

  return (
    <div className="mx-auto max-w-xl px-4 pb-24 pt-8">
      <p className="eyebrow">Pedido #{order.number}</p>
      <h1 className="mt-2 text-[26px] leading-tight md:text-[32px]">
        {order.amount_paid > 0 ? "¡Gracias! Recibimos tu pago." : "¡Listo! Registramos tu pedido."}
      </h1>
      <p className="mt-3 inline-block bg-ink px-3 py-1.5 text-[11px] font-semibold uppercase tracking-[0.15em] text-paper">{STATUS[order.status as OrderStatus]}</p>

      {order.amount_paid === 0 && order.status !== "cancelled" && (
        <section className="mt-6 rounded-none border border-ink bg-white p-5">
          <h2 className="font-sans text-base font-bold">Mandanos el pedido por WhatsApp</h2>
          <p className="mt-2 text-sm leading-relaxed text-mute">
            Te pasamos los datos para transferir {money(order.total)} y coordinamos el envío.
          </p>
          <a href={wa} target="_blank" rel="noopener" className="btn mt-5 w-full bg-[#25D366] text-white">
            Enviar pedido por WhatsApp
          </a>
          <p className="mt-2 text-center text-xs text-mute">El mensaje ya incluye tu número de pedido y el detalle.</p>
        </section>
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
          {order.moto_address && (
            <div className="flex justify-between gap-3 text-mute"><dt>Envío a</dt><dd className="text-right">{order.moto_address}</dd></div>
          )}
          <div className="flex justify-between text-mute"><dt>Pago</dt><dd>Transferencia</dd></div>
        </dl>
      </section>

      <p className="mt-8 text-xs text-mute">Guardá este enlace para ver el estado de tu pedido.</p>
    </div>
  );
}
