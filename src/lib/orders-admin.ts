/**
 * Operaciones del panel sobre pedidos. Reciben el cliente con permisos de
 * servidor (ya verificado con adminDb()).
 */
import type { SupabaseClient } from "@supabase/supabase-js";
import { computeTotals, depositAmount, discountPctFor, unitPrice } from "./pricing";
import type { OrderStatus, PaymentRule } from "./types";

export const STATUS_LABEL: Record<OrderStatus, string> = {
  pending_payment: "Pendiente de pago",
  awaiting_proof: "Esperando comprobante",
  deposit_paid: "Seña recibida",
  paid: "Pagado",
  preparing: "Preparando",
  ready_pickup: "Listo para retirar",
  moto_coordinating: "Coordinando moto",
  delivered: "Entregado",
  deposit_expired: "Seña vencida",
  cancelled: "Cancelado",
};

/** Estados a los que se puede pasar manualmente desde un pedido pagado. */
export const FLOW_STATES: OrderStatus[] = ["preparing", "ready_pickup", "moto_coordinating", "delivered"];

const UNPAID: OrderStatus[] = ["pending_payment", "awaiting_proof"];

async function getOrder(db: SupabaseClient, id: number) {
  const { data, error } = await db.from("orders").select("*").eq("id", id).single();
  if (error || !data) throw new Error("No se encontró el pedido.");
  return data;
}

/** Pago total confirmado (transferencia recibida o efectivo cobrado). */
export async function markPaid(db: SupabaseClient, id: number) {
  const o = await getOrder(db, id);
  if (!UNPAID.includes(o.status)) throw new Error("El pedido ya tiene un pago registrado.");
  await db.from("orders").update({ amount_paid: o.total, balance_due: 0, status: "paid", proof_received: true }).eq("id", id);
  await db.rpc("reserve_order_stock", { p_order_id: id });
}

/** Seña recibida: reserva el stock y fija el vencimiento en días hábiles. */
export async function registerDeposit(db: SupabaseClient, id: number) {
  const o = await getOrder(db, id);
  if (!UNPAID.includes(o.status)) throw new Error("El pedido ya tiene un pago registrado.");
  const { data: s } = await db.from("settings").select("deposit_pct, deposit_business_days").eq("id", 1).single();
  const amount = o.plan === "deposit" ? o.amount_due_now : Math.ceil((o.total * (s?.deposit_pct ?? 50)) / 100 / 10) * 10;
  const now = new Date().toISOString();
  const { data: expires } = await db.rpc("add_business_days", { p_start: now, p_days: s?.deposit_business_days ?? 10 });
  await db
    .from("orders")
    .update({
      plan: "deposit",
      amount_due_now: amount,
      amount_paid: amount,
      balance_due: o.total - amount,
      deposit_paid_at: now,
      deposit_expires_at: expires,
      status: "deposit_paid",
      proof_received: true,
    })
    .eq("id", id);
  await db.rpc("reserve_order_stock", { p_order_id: id });
}

/**
 * Completa una seña: los precios NO se congelan, así que recalcula el pedido
 * con los precios vigentes de hoy y cobra la diferencia.
 * Devuelve el saldo que se cobró.
 */
export async function completeDeposit(db: SupabaseClient, id: number): Promise<number> {
  const o = await getOrder(db, id);
  if (o.status !== "deposit_paid" && o.status !== "deposit_expired")
    throw new Error("Este pedido no tiene una seña pendiente.");

  const [{ data: items }, { data: rules }, { data: cats }] = await Promise.all([
    db.from("order_items").select("id, variant_id, qty, unit_list_price, variant:variants(price_list, price_override, product:products(category_id))").eq("order_id", id),
    db.from("payment_rules").select("*"),
    db.from("categories").select("id, parent_id"),
  ]);
  const rule = (rules as PaymentRule[] | null)?.find((r) => r.method === o.payment);

  /* eslint-disable @typescript-eslint/no-explicit-any */
  const priced = (items ?? []).map((i: any) => {
    const list = i.variant?.price_list ?? i.unit_list_price; // si la variante se borró, queda el precio anterior
    const pct = discountPctFor(rule, i.variant?.product?.category_id ?? null, cats ?? []);
    return { id: i.id, variantId: i.variant_id, qty: i.qty, unitListPrice: list, unitPrice: unitPrice(list, pct, i.variant?.price_override ?? null) };
  });
  /* eslint-enable @typescript-eslint/no-explicit-any */
  const totals = computeTotals(priced);

  for (const p of priced) {
    await db.from("order_items").update({ unit_list_price: p.unitListPrice, unit_price: p.unitPrice }).eq("id", p.id);
  }
  const balance = Math.max(totals.total - o.amount_paid, 0);
  await db
    .from("orders")
    .update({ ...totals, amount_paid: o.amount_paid + balance, balance_due: 0, status: "paid" })
    .eq("id", id);
  if (o.status === "deposit_expired") await db.rpc("reserve_order_stock", { p_order_id: id });
  return balance;
}

export async function setStatus(db: SupabaseClient, id: number, status: OrderStatus) {
  if (!FLOW_STATES.includes(status)) throw new Error("Estado no válido.");
  const o = await getOrder(db, id);
  if (UNPAID.includes(o.status) || o.status === "cancelled") throw new Error("Primero registrá el pago del pedido.");
  await db.from("orders").update({ status }).eq("id", id);
}

/** Cancela y devuelve el stock si estaba reservado. */
export async function cancelOrder(db: SupabaseClient, id: number) {
  const o = await getOrder(db, id);
  if (o.status === "delivered") throw new Error("Un pedido entregado no se puede cancelar.");
  await db.from("orders").update({ status: "cancelled" }).eq("id", id);
  await db.rpc("release_order_stock", { p_order_id: id });
}

export async function saveNotes(db: SupabaseClient, id: number, notes: string) {
  await db.from("orders").update({ notes: notes.slice(0, 2000) || null }).eq("id", id);
}

/**
 * Modifica los productos de un pedido (cambiar cantidades o quitar
 * productos), por ejemplo cuando la clienta pide por WhatsApp sacar algo.
 * `changes` es { id de order_item: nueva cantidad } — 0 = quitar.
 * Mantiene los precios con los que se hizo el pedido, recalcula los totales
 * y, si el stock ya estaba reservado, lo ajusta. Devuelve el mensaje para Ivana.
 */
export async function editItems(db: SupabaseClient, id: number, changes: Map<number, number>): Promise<string> {
  const o = await getOrder(db, id);
  if (o.status === "delivered" || o.status === "cancelled")
    throw new Error("Un pedido entregado o cancelado no se puede modificar.");

  const { data: items } = await db.from("order_items").select("id, name_snapshot, options_snapshot, qty, unit_list_price, unit_price").eq("order_id", id);
  const current = items ?? [];

  const log: string[] = [];
  const next = current.map((i) => {
    const raw = changes.get(i.id);
    const qty = raw == null || !Number.isFinite(raw) ? i.qty : Math.max(0, Math.min(999, Math.floor(raw)));
    const name = i.options_snapshot ? `${i.name_snapshot} (${i.options_snapshot})` : i.name_snapshot;
    if (qty === 0) log.push(`se quitó ${name}`);
    else if (qty !== i.qty) log.push(`${name}: ${i.qty} → ${qty}`);
    return { ...i, newQty: qty };
  });
  if (!log.length) throw new Error("No hubo cambios para guardar.");
  const kept = next.filter((i) => i.newQty > 0);
  if (!kept.length) throw new Error("No se pueden quitar todos los productos. Si la clienta no quiere nada, cancelá el pedido.");

  // Si el stock ya estaba descontado: se devuelve, se cambia el pedido y se vuelve a descontar.
  const reserved = o.stock_reserved;
  if (reserved) await db.rpc("release_order_stock", { p_order_id: id });

  for (const i of next) {
    if (i.newQty === 0) await db.from("order_items").delete().eq("id", i.id);
    else if (i.newQty !== i.qty) await db.from("order_items").update({ qty: i.newQty }).eq("id", i.id);
  }

  const totals = computeTotals(
    kept.map((i) => ({ variantId: 0, qty: i.newQty, unitListPrice: i.unit_list_price, unitPrice: i.unit_price })),
  );

  const unpaid = UNPAID.includes(o.status);
  let money: Record<string, number>;
  if (unpaid) {
    let due = totals.total;
    if (o.plan === "deposit") {
      const { data: s } = await db.from("settings").select("deposit_pct").eq("id", 1).single();
      due = depositAmount(totals.total, s?.deposit_pct ?? 50);
    }
    money = { amount_due_now: due, balance_due: totals.total };
  } else {
    money = { balance_due: Math.max(totals.total - o.amount_paid, 0) };
  }

  const stamp = new Date().toLocaleDateString("es-AR", { day: "2-digit", month: "2-digit", timeZone: "America/Argentina/Mendoza" });
  const notes = `${o.notes ?? ""}\n✏️ ${stamp} pedido modificado: ${log.join("; ")}.`.trim().slice(-2000);

  await db.from("orders").update({ ...totals, ...money, notes }).eq("id", id);
  if (reserved) await db.rpc("reserve_order_stock", { p_order_id: id });

  const fmt = (n: number) => `$${n.toLocaleString("es-AR")}`;
  let msg = `Pedido modificado. Nuevo total: ${fmt(totals.total)}.`;
  if (!unpaid) {
    const diff = o.amount_paid - totals.total;
    if (diff > 0) msg += ` La clienta ya pagó ${fmt(o.amount_paid)}: hay que devolverle ${fmt(diff)}.`;
    else if (diff < 0 && o.status !== "deposit_paid" && o.status !== "deposit_expired")
      msg += ` Falta cobrarle ${fmt(-diff)}.`;
  }
  return msg;
}
