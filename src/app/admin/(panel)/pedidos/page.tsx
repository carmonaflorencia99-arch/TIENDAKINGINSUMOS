import Link from "next/link";
import { adminDb } from "@/lib/admin";
import { DELIVERY_LABEL, money, PAYMENT_LABEL, shortDate } from "@/lib/format";
import { STATUS_LABEL } from "@/lib/orders-admin";
import type { DeliveryMethod, OrderStatus, PaymentMethod } from "@/lib/types";

export const metadata = { title: "Pedidos" };

const FILTERS: { key: string; label: string; statuses: OrderStatus[] }[] = [
  { key: "abiertos", label: "Abiertos", statuses: ["pending_payment", "awaiting_proof", "deposit_paid", "paid", "preparing", "ready_pickup", "moto_coordinating"] },
  { key: "awaiting_proof", label: "Esperan comprobante", statuses: ["awaiting_proof"] },
  { key: "pending_payment", label: "Pendientes de pago", statuses: ["pending_payment"] },
  { key: "deposit_paid", label: "Con seña", statuses: ["deposit_paid"] },
  { key: "paid", label: "Para preparar", statuses: ["paid", "preparing"] },
  { key: "ready_pickup", label: "Listos para retirar", statuses: ["ready_pickup"] },
  { key: "moto_coordinating", label: "Moto", statuses: ["moto_coordinating"] },
  { key: "cerrados", label: "Entregados y cancelados", statuses: ["delivered", "cancelled", "deposit_expired"] },
];

type Props = { searchParams: Promise<{ estado?: string; q?: string }> };

export default async function OrdersPage({ searchParams }: Props) {
  const { estado = "abiertos", q = "" } = await searchParams;
  const filter = FILTERS.find((f) => f.key === estado) ?? FILTERS[0];
  const db = await adminDb();

  let query = db
    .from("orders")
    .select("id, number, customer_name, customer_phone, delivery, payment, plan, total, balance_due, status, deposit_expires_at, created_at")
    .in("status", filter.statuses)
    .order("created_at", { ascending: false })
    .limit(200);
  const term = q.trim();
  if (term) {
    const n = Number(term.replace("#", ""));
    query = Number.isInteger(n) && n > 0 ? query.eq("number", n) : query.ilike("customer_name", `%${term.replace(/[%,()]/g, " ")}%`);
  }
  const { data: orders, error } = await query;

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-end justify-between gap-3">
        <h1 className="text-[22px]">Pedidos</h1>
        <form className="flex w-full gap-2 sm:w-auto">
          <input type="hidden" name="estado" value={filter.key} />
          <input name="q" defaultValue={q} placeholder="Nº de pedido o nombre" className="field min-w-0 flex-1 py-2 text-sm sm:w-56 sm:flex-none" />
          <button className="btn-ghost px-4 py-2">Buscar</button>
        </form>
      </div>

      <nav className="-mx-4 flex gap-2 overflow-x-auto px-4 pb-1">
        {FILTERS.map((f) => (
          <Link key={f.key} href={`/admin/pedidos?estado=${f.key}`} aria-pressed={f.key === filter.key} className="chip whitespace-nowrap text-[11px]">
            {f.label}
          </Link>
        ))}
      </nav>

      {error && <p className="text-sm text-rose">No se pudieron cargar los pedidos.</p>}
      {(orders ?? []).length === 0 ? (
        <p className="border border-line bg-white p-6 text-center text-sm text-mute">No hay pedidos en esta lista.</p>
      ) : (
        <div className="overflow-x-auto border border-line bg-white">
          <table className="w-full text-sm sm:min-w-[720px]">
            <thead className="border-b border-line text-left text-[11px] uppercase tracking-wider text-mute">
              <tr>
                <th className="px-3 py-2.5 font-medium">Pedido</th>
                <th className="px-3 py-2.5 font-medium">Clienta</th>
                <th className="hidden px-3 py-2.5 font-medium sm:table-cell">Entrega · pago</th>
                <th className="hidden px-3 py-2.5 font-medium sm:table-cell">Estado</th>
                <th className="px-3 py-2.5 text-right font-medium">Total</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-line">
              {orders!.map((o) => (
                <tr key={o.id} className="hover:bg-surface">
                  <td className="px-3 py-2.5">
                    <Link href={`/admin/pedidos/${o.id}`} className="font-semibold underline-offset-4 hover:underline">#{o.number}</Link>
                    <div className="whitespace-nowrap text-xs text-mute">{shortDate(o.created_at)}</div>
                  </td>
                  <td className="px-3 py-2.5">
                    {o.customer_name}
                    <div className="text-xs text-mute">{o.customer_phone}</div>
                    <div className="mt-1 text-xs text-mute sm:hidden">
                      {DELIVERY_LABEL[o.delivery as DeliveryMethod]} · {PAYMENT_LABEL[o.payment as PaymentMethod]}{o.plan === "deposit" ? " · seña" : ""}
                    </div>
                    <span className="badge mt-1.5 sm:hidden">{STATUS_LABEL[o.status as OrderStatus]}</span>
                  </td>
                  <td className="hidden px-3 py-2.5 text-xs sm:table-cell">
                    {DELIVERY_LABEL[o.delivery as DeliveryMethod]}
                    <div className="text-mute">{PAYMENT_LABEL[o.payment as PaymentMethod]}{o.plan === "deposit" ? " · seña" : ""}</div>
                  </td>
                  <td className="hidden px-3 py-2.5 sm:table-cell">
                    <span className="badge">{STATUS_LABEL[o.status as OrderStatus]}</span>
                    {o.status === "deposit_paid" && o.deposit_expires_at && (
                      <div className="mt-1 text-xs text-mute">vence {shortDate(o.deposit_expires_at)}</div>
                    )}
                  </td>
                  <td className="whitespace-nowrap px-3 py-2.5 text-right tabular-nums">
                    {money(o.total)}
                    {o.balance_due > 0 && o.status === "deposit_paid" && <div className="text-xs text-mute">saldo {money(o.balance_due)}</div>}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
