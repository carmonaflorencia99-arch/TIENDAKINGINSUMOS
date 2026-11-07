import Link from "next/link";
import { notFound } from "next/navigation";
import { adminDb } from "@/lib/admin";
import { DELIVERY_LABEL, money, PAYMENT_LABEL, shortDate } from "@/lib/format";
import { FLOW_STATES, STATUS_LABEL } from "@/lib/orders-admin";
import { whatsappLink } from "@/lib/whatsapp";
import type { DeliveryMethod, OrderStatus, PaymentMethod } from "@/lib/types";
import {
  cancelAction,
  completeDepositAction,
  markPaidAction,
  notesAction,
  registerDepositAction,
  setStatusAction,
} from "../actions";

type Props = { params: Promise<{ id: string }>; searchParams: Promise<{ ok?: string; error?: string }> };

export async function generateMetadata({ params }: Props) {
  return { title: `Pedido ${(await params).id}` };
}

function Row({ k, v }: { k: string; v: React.ReactNode }) {
  return (
    <div className="flex justify-between gap-4 py-1.5">
      <dt className="text-mute">{k}</dt>
      <dd className="text-right">{v}</dd>
    </div>
  );
}

export default async function OrderDetail({ params, searchParams }: Props) {
  const { id } = await params;
  const { ok, error } = await searchParams;
  const db = await adminDb();
  const { data: o } = await db.from("orders").select("*, items:order_items(*)").eq("id", Number(id)).maybeSingle();
  if (!o) notFound();

  const status = o.status as OrderStatus;
  const unpaid = status === "pending_payment" || status === "awaiting_proof";
  const hasDeposit = status === "deposit_paid" || status === "deposit_expired";
  const canFlow = !unpaid && status !== "cancelled" && status !== "deposit_expired";
  const phone = String(o.customer_phone).replace(/\D/g, "");
  const waPhone = phone.startsWith("54") ? phone : `549${phone.replace(/^0/, "")}`;
  const wa = whatsappLink(waPhone, `¡Hola ${o.customer_name}! Te escribimos de King Insumos por tu pedido #${o.number}.`);

  return (
    <div className="space-y-5">
      <Link href="/admin/pedidos" className="eyebrow">← Pedidos</Link>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-[22px]">Pedido #{o.number}</h1>
        <span className="badge text-[12px]">{STATUS_LABEL[status]}</span>
      </div>

      {ok && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>}
      {error && <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>}

      <div className="grid gap-5 md:grid-cols-[1fr_320px]">
        {/* Detalle */}
        <section className="space-y-5">
          <div className="border border-line bg-white">
            <table className="w-full text-sm">
              <thead className="border-b border-line text-left text-[11px] uppercase tracking-wider text-mute">
                <tr>
                  <th className="px-3 py-2 font-medium">Producto</th>
                  <th className="px-3 py-2 text-right font-medium">Cant.</th>
                  <th className="px-3 py-2 text-right font-medium">Precio</th>
                  <th className="px-3 py-2 text-right font-medium">Subtotal</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-line">
                {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
                {o.items.map((i: any) => (
                  <tr key={i.id}>
                    <td className="px-3 py-2">
                      {i.name_snapshot}
                      {i.options_snapshot && <div className="text-xs text-mute">{i.options_snapshot}</div>}
                    </td>
                    <td className="px-3 py-2 text-right tabular-nums">{i.qty}</td>
                    <td className="px-3 py-2 text-right tabular-nums">{money(i.unit_price)}</td>
                    <td className="px-3 py-2 text-right tabular-nums">{money(i.unit_price * i.qty)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            <dl className="border-t border-line px-3 py-2 text-sm">
              <Row k="Subtotal (lista)" v={money(o.subtotal)} />
              {o.discount > 0 && <Row k="Descuento" v={`−${money(o.discount)}`} />}
              <Row k="Total" v={<strong>{money(o.total)}</strong>} />
              <Row k="Pagado" v={money(o.amount_paid)} />
              {o.balance_due > 0 && !unpaid && <Row k="Saldo" v={<strong>{money(o.balance_due)}</strong>} />}
            </dl>
          </div>

          <form action={notesAction} className="space-y-2 border border-line bg-white p-4">
            <input type="hidden" name="id" value={o.id} />
            <label htmlFor="notes" className="eyebrow block">Notas internas</label>
            <textarea id="notes" name="notes" defaultValue={o.notes ?? ""} className="field min-h-24 text-sm" />
            <button className="btn-ghost px-4 py-2">Guardar notas</button>
          </form>
        </section>

        {/* Clienta y acciones */}
        <aside className="space-y-5">
          <div className="border border-line bg-white p-4 text-sm">
            <p className="eyebrow mb-2">Clienta</p>
            <p className="font-semibold">{o.customer_name}</p>
            <p>{o.customer_phone}</p>
            {o.customer_email && <p className="text-mute">{o.customer_email}</p>}
            <a href={wa} target="_blank" rel="noopener" className="btn mt-3 w-full bg-[#25D366] px-3 py-2.5 text-white">
              Escribir por WhatsApp
            </a>
            <dl className="mt-4 border-t border-line pt-2">
              <Row k="Entrega" v={DELIVERY_LABEL[o.delivery as DeliveryMethod]} />
              {o.moto_address && <Row k="Dirección" v={o.moto_address} />}
              <Row k="Pago" v={`${PAYMENT_LABEL[o.payment as PaymentMethod]}${o.plan === "deposit" ? " · seña" : ""}`} />
              <Row k="Fecha" v={shortDate(o.created_at)} />
              {o.deposit_expires_at && <Row k="Vence la seña" v={shortDate(o.deposit_expires_at)} />}
            </dl>
          </div>

          <div className="space-y-2 border border-line bg-white p-4">
            <p className="eyebrow mb-1">Acciones</p>

            {unpaid && (
              <>
                <form action={markPaidAction}>
                  <input type="hidden" name="id" value={o.id} />
                  <button className="btn w-full px-3 py-3">Marcar pagado ({money(o.total)})</button>
                </form>
                <form action={registerDepositAction}>
                  <input type="hidden" name="id" value={o.id} />
                  <button className="btn-ghost w-full px-3 py-3">
                    Registrar seña{o.plan === "deposit" ? ` (${money(o.amount_due_now)})` : " (50 %)"}
                  </button>
                </form>
                <p className="text-xs text-mute">Al registrar el pago se descuenta el stock.</p>
              </>
            )}

            {hasDeposit && (
              <form action={completeDepositAction}>
                <input type="hidden" name="id" value={o.id} />
                <button className="btn w-full px-3 py-3">Completar pago (precio de hoy)</button>
                <p className="mt-1 text-xs text-mute">
                  Recalcula el total con los precios actuales y cobra la diferencia sobre la seña.
                </p>
              </form>
            )}

            {canFlow && (
              <div className="grid grid-cols-2 gap-2 pt-1">
                {FLOW_STATES.filter((s) => s !== status && (o.delivery === "moto" || s !== "moto_coordinating")).map((s) => (
                  <form key={s} action={setStatusAction}>
                    <input type="hidden" name="id" value={o.id} />
                    <input type="hidden" name="status" value={s} />
                    <button className="chip w-full text-[11px]">{STATUS_LABEL[s]}</button>
                  </form>
                ))}
              </div>
            )}

            {status !== "cancelled" && status !== "delivered" && (
              <details className="pt-2 text-sm">
                <summary className="cursor-pointer text-rose">Cancelar pedido</summary>
                <form action={cancelAction} className="mt-2 space-y-2">
                  <input type="hidden" name="id" value={o.id} />
                  <label className="flex items-start gap-2 text-xs">
                    <input type="checkbox" required className="mt-0.5 accent-ink" />
                    Confirmo que quiero cancelar el pedido #{o.number}. Si tenía stock reservado, vuelve a estar disponible.
                  </label>
                  <button className="btn w-full bg-rose px-3 py-2.5">Cancelar pedido</button>
                </form>
              </details>
            )}
          </div>
        </aside>
      </div>
    </div>
  );
}
