import Link from "next/link";
import { adminDb } from "@/lib/admin";
import { money, shortDate } from "@/lib/format";
import { STATUS_LABEL } from "@/lib/orders-admin";
import type { OrderStatus } from "@/lib/types";

export const metadata = { title: "Inicio" };

function Tile({ href, n, label, tone }: { href: string; n: number; label: string; tone?: "alert" }) {
  return (
    <Link href={href} className="flex flex-col gap-1 border border-line bg-white p-4">
      <span className={`text-[32px] font-light tabular-nums ${tone === "alert" && n > 0 ? "text-rose" : ""}`}>{n}</span>
      <span className="text-[12px] font-medium uppercase tracking-[1.5px] text-mute">{label}</span>
    </Link>
  );
}

export default async function Dashboard() {
  const db = await adminDb();
  const inThreeDays = new Date(Date.now() + 3 * 86400000).toISOString();
  const today = new Date(); today.setHours(0, 0, 0, 0);

  const head = () => db.from("orders").select("id", { count: "exact", head: true });
  const [proof, pending, deposits, ready, moto] = (
    await Promise.all([
      head().eq("status", "awaiting_proof"),
      head().eq("status", "pending_payment"),
      head().eq("status", "deposit_paid").lte("deposit_expires_at", inThreeDays),
      head().in("status", ["paid", "preparing"]),
      head().eq("status", "moto_coordinating"),
    ])
  ).map((r) => r.count ?? 0);

  const [{ data: todayOrders }, { data: lowStock }] = await Promise.all([
    db.from("orders").select("id, number, customer_name, total, status, created_at").gte("created_at", today.toISOString()).order("created_at", { ascending: false }),
    db.from("variants").select("id, stock, option1, option2, option3, product:products(id, name, status)").eq("track_stock", true).eq("active", true).lte("stock", 2).order("stock").limit(15),
  ]);
  const sales = (todayOrders ?? []).filter((o) => !["cancelled", "pending_payment", "awaiting_proof"].includes(o.status)).reduce((s, o) => s + o.total, 0);

  return (
    <div className="space-y-8">
      <h1 className="text-[22px]">Hoy</h1>

      <section className="grid grid-cols-2 gap-3 md:grid-cols-5">
        <Tile href="/admin/pedidos?estado=awaiting_proof" n={proof} label="Esperan comprobante" tone="alert" />
        <Tile href="/admin/pedidos?estado=pending_payment" n={pending} label="Pendientes de pago" />
        <Tile href="/admin/pedidos?estado=deposit_paid" n={deposits} label="Señas que vencen en 3 días" tone="alert" />
        <Tile href="/admin/pedidos?estado=paid" n={ready} label="Para preparar" />
        <Tile href="/admin/pedidos?estado=moto_coordinating" n={moto} label="Motos por coordinar" />
      </section>

      <section className="grid gap-6 md:grid-cols-2">
        <div className="border border-line bg-white p-4">
          <div className="mb-3 flex items-baseline justify-between">
            <h2 className="text-[14px]">Pedidos de hoy</h2>
            <span className="text-sm text-mute">Cobrado: <strong className="text-ink">{money(sales)}</strong></span>
          </div>
          {(todayOrders ?? []).length === 0 ? (
            <p className="text-sm text-mute">Todavía no entraron pedidos hoy.</p>
          ) : (
            <ul className="divide-y divide-line text-sm">
              {todayOrders!.map((o) => (
                <li key={o.id}>
                  <Link href={`/admin/pedidos/${o.id}`} className="flex items-center justify-between gap-3 py-2">
                    <span><strong>#{o.number}</strong> {o.customer_name}</span>
                    <span className="flex items-center gap-3">
                      <span className="text-[11px] uppercase tracking-wider text-mute">{STATUS_LABEL[o.status as OrderStatus]}</span>
                      <span className="tabular-nums">{money(o.total)}</span>
                    </span>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>

        <div className="border border-line bg-white p-4">
          <h2 className="mb-3 text-[14px]">Stock bajo (2 o menos)</h2>
          {(lowStock ?? []).length === 0 ? (
            <p className="text-sm text-mute">No hay productos con stock bajo.</p>
          ) : (
            <ul className="divide-y divide-line text-sm">
              {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
              {(lowStock as any[]).map((v) => (
                <li key={v.id}>
                  <Link href={`/admin/productos/${v.product?.id}`} className="flex justify-between gap-3 py-2">
                    <span>
                      {v.product?.name}
                      <span className="text-mute"> {[v.option1, v.option2, v.option3].filter(Boolean).join(" · ")}</span>
                    </span>
                    <span className={`tabular-nums ${v.stock <= 0 ? "text-rose" : ""}`}>{v.stock <= 0 ? "Sin stock" : v.stock}</span>
                  </Link>
                </li>
              ))}
            </ul>
          )}
        </div>
      </section>

      <p className="text-xs text-mute">Actualizado {shortDate(new Date().toISOString())}</p>
    </div>
  );
}
