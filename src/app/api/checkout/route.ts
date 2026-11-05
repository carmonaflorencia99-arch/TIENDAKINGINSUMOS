/**
 * POST /api/checkout
 * Crea el pedido con precios recalculados en el servidor y, si el pago es
 * por Mercado Pago, la preferencia de Checkout Pro.
 */
import { NextResponse } from "next/server";
import { z } from "zod";
import { adminClient } from "@/lib/supabase";
import { createPreference } from "@/lib/mercadopago";
import { optionsLabel } from "@/lib/format";
import {
  computeTotals,
  depositAmount,
  discountPctFor,
  unitPrice,
  validateChoice,
  type PricedLine,
} from "@/lib/pricing";
import type { PaymentRule, Category } from "@/lib/types";

const Body = z
  .object({
    lines: z
      .array(z.object({ variantId: z.number().int().positive(), qty: z.number().int().min(1).max(200) }))
      .min(1, "El carrito está vacío."),
    customer: z.object({
      name: z.string().trim().min(2, "Ingresá tu nombre."),
      phone: z.string().trim().min(8, "Ingresá un WhatsApp válido."),
      email: z.string().trim().email("El email no es válido.").optional().or(z.literal("")),
    }),
    delivery: z.enum(["pickup", "moto"]),
    payment: z.enum(["mercadopago", "transfer", "cash"]),
    plan: z.enum(["full", "deposit"]),
    motoAddress: z.string().trim().optional(),
    notes: z.string().trim().max(500).optional(),
  })
  .refine((b) => b.delivery !== "moto" || (b.motoAddress && b.motoAddress.length > 4), {
    message: "Ingresá la dirección para el envío por moto.",
    path: ["motoAddress"],
  });

function fail(message: string, status = 400) {
  return NextResponse.json({ error: message }, { status });
}

export async function POST(req: Request) {
  const parsed = Body.safeParse(await req.json().catch(() => null));
  if (!parsed.success) return fail(parsed.error.issues[0]?.message ?? "Datos inválidos.");
  const body = parsed.data;

  // Unifica líneas repetidas de la misma variante
  const qtyById = new Map<number, number>();
  for (const l of body.lines) qtyById.set(l.variantId, (qtyById.get(l.variantId) ?? 0) + l.qty);

  const db = adminClient();
  const [rulesRes, catsRes, settingsRes, variantsRes] = await Promise.all([
    db.from("payment_rules").select("*"),
    db.from("categories").select("id, parent_id"),
    db.from("settings").select("deposit_pct").eq("id", 1).single(),
    db
      .from("variants")
      .select("*, product:products(id, name, category_id, status)")
      .in("id", [...qtyById.keys()]),
  ]);
  if (rulesRes.error || catsRes.error || settingsRes.error || variantsRes.error)
    return fail("No pudimos procesar el pedido. Probá de nuevo en unos minutos.", 500);

  const rules = rulesRes.data as PaymentRule[];
  const categories = catsRes.data as Pick<Category, "id" | "parent_id">[];

  const choiceError = validateChoice(body, rules);
  if (choiceError) return fail(choiceError);
  const rule = rules.find((r) => r.method === body.payment)!;

  // Precios y stock desde la base
  const priced: (PricedLine & { name: string; options: string })[] = [];
  for (const [variantId, qty] of qtyById) {
    const v = variantsRes.data.find((x) => x.id === variantId);
    if (!v || !v.active || v.product?.status !== "active")
      return fail("Uno de los productos ya no está disponible. Revisá tu carrito.");
    const options = optionsLabel(v);
    if (v.track_stock && v.stock < qty)
      return fail(
        v.stock > 0
          ? `De "${v.product.name}${options ? ` ${options}` : ""}" quedan ${v.stock} unidades.`
          : `"${v.product.name}${options ? ` ${options}` : ""}" está sin stock.`,
      );
    const pct = discountPctFor(rule, v.product.category_id, categories);
    priced.push({
      variantId,
      qty,
      unitListPrice: v.price_list,
      unitPrice: unitPrice(v.price_list, pct, v.price_override),
      name: v.product.name,
      options,
    });
  }

  const totals = computeTotals(priced);
  const amountDueNow =
    body.plan === "deposit" ? depositAmount(totals.total, settingsRes.data.deposit_pct) : totals.total;

  const { data: order, error: orderErr } = await db
    .from("orders")
    .insert({
      customer_name: body.customer.name,
      customer_phone: body.customer.phone,
      customer_email: body.customer.email || null,
      delivery: body.delivery,
      moto_address: body.delivery === "moto" ? body.motoAddress : null,
      payment: body.payment,
      plan: body.plan,
      subtotal: totals.subtotal,
      discount: totals.discount,
      total: totals.total,
      amount_due_now: amountDueNow,
      balance_due: totals.total,
      status: body.payment === "transfer" ? "awaiting_proof" : "pending_payment",
      notes: body.notes || null,
    })
    .select("id, number, public_token")
    .single();
  if (orderErr || !order) return fail("No pudimos crear el pedido. Probá de nuevo.", 500);

  const { error: itemsErr } = await db.from("order_items").insert(
    priced.map((p) => ({
      order_id: order.id,
      type: "product",
      variant_id: p.variantId,
      name_snapshot: p.name,
      options_snapshot: p.options || null,
      unit_list_price: p.unitListPrice,
      unit_price: p.unitPrice,
      qty: p.qty,
    })),
  );
  if (itemsErr) {
    await db.from("orders").delete().eq("id", order.id);
    return fail("No pudimos crear el pedido. Probá de nuevo.", 500);
  }

  const orderUrl = `/pedido/${order.public_token}`;

  if (body.payment === "mercadopago") {
    try {
      const pref = await createPreference({
        orderId: order.id,
        orderNumber: order.number,
        publicToken: order.public_token,
        payerName: body.customer.name,
        payerEmail: body.customer.email,
        items: priced.map((p) => ({
          id: String(p.variantId),
          title: `${p.name}${p.options ? ` ${p.options}` : ""}`.slice(0, 250),
          quantity: p.qty,
          unit_price: p.unitPrice,
        })),
      });
      await db.from("orders").update({ mp_preference_id: pref.id }).eq("id", order.id);
      return NextResponse.json({ redirect: pref.initPoint, orderUrl });
    } catch (e) {
      console.error("[checkout] Mercado Pago", e);
      return NextResponse.json({
        redirect: orderUrl,
        warning: "No pudimos abrir Mercado Pago. Tu pedido quedó registrado: escribinos por WhatsApp.",
      });
    }
  }

  return NextResponse.json({ redirect: orderUrl });
}
