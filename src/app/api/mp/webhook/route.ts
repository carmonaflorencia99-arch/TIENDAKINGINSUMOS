/**
 * POST /api/mp/webhook
 * Mercado Pago avisa cuando cambia un pago. Consultamos el pago a la API de
 * MP (fuente de verdad) y recién ahí marcamos el pedido como pagado y
 * descontamos stock. Es idempotente: si llega dos veces, no pasa nada.
 */
import { NextResponse } from "next/server";
import { adminClient } from "@/lib/supabase";
import { getPayment, verifyWebhookSignature } from "@/lib/mercadopago";

export async function POST(req: Request) {
  const url = new URL(req.url);
  const body = await req.json().catch(() => ({}));

  const type = body?.type ?? url.searchParams.get("type") ?? url.searchParams.get("topic");
  const dataId: string | undefined =
    body?.data?.id?.toString() ?? url.searchParams.get("data.id") ?? url.searchParams.get("id") ?? undefined;

  // Solo nos interesan pagos; al resto respondemos 200 para que MP no reintente
  if (type !== "payment" || !dataId) return NextResponse.json({ ok: true });

  if (!verifyWebhookSignature(req.headers.get("x-signature"), req.headers.get("x-request-id"), dataId))
    return NextResponse.json({ error: "firma inválida" }, { status: 401 });

  let payment;
  try {
    payment = await getPayment(dataId);
  } catch (e) {
    console.error("[mp webhook] no se pudo consultar el pago", dataId, e);
    return NextResponse.json({ error: "reintentar" }, { status: 500 }); // MP reintenta
  }

  const orderId = Number(payment.external_reference);
  if (!orderId) return NextResponse.json({ ok: true });

  const db = adminClient();
  const { data: order } = await db.from("orders").select("*").eq("id", orderId).single();
  if (!order) return NextResponse.json({ ok: true });

  // Ya procesado
  if (order.mp_payment_id === String(payment.id) && order.amount_paid > 0)
    return NextResponse.json({ ok: true });

  if (payment.status !== "approved") {
    await db.from("orders").update({ mp_payment_id: String(payment.id) }).eq("id", orderId);
    return NextResponse.json({ ok: true });
  }

  const paid = Math.round(payment.transaction_amount ?? 0);
  if (paid < order.amount_due_now) {
    console.error("[mp webhook] monto menor al esperado", { orderId, paid, due: order.amount_due_now });
    await db
      .from("orders")
      .update({ mp_payment_id: String(payment.id), notes: `${order.notes ?? ""}\n⚠️ Pago MP por ${paid}, se esperaba ${order.amount_due_now}`.trim() })
      .eq("id", orderId);
    return NextResponse.json({ ok: true });
  }

  const isDeposit = order.plan === "deposit" && paid < order.total;
  const update: Record<string, unknown> = {
    mp_payment_id: String(payment.id),
    amount_paid: paid,
    balance_due: Math.max(order.total - paid, 0),
    status: isDeposit ? "deposit_paid" : "paid",
  };
  if (isDeposit) {
    const { data: settings } = await db.from("settings").select("deposit_business_days").eq("id", 1).single();
    const { data: expires } = await db.rpc("add_business_days", {
      p_start: new Date().toISOString(),
      p_days: settings?.deposit_business_days ?? 10,
    });
    update.deposit_paid_at = new Date().toISOString();
    update.deposit_expires_at = expires;
  }

  await db.from("orders").update(update).eq("id", orderId);
  await db.rpc("reserve_order_stock", { p_order_id: orderId });

  return NextResponse.json({ ok: true });
}
