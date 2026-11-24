/**
 * POST /api/checkout
 * Crea el pedido con precios recalculados en el servidor y devuelve el link de
 * WhatsApp con el pedido armado. Por ahora la única opción es envío + pago por
 * transferencia (King pasa los datos y coordina el envío por WhatsApp).
 */
import { NextResponse } from "next/server";
import { z } from "zod";
import { adminClient } from "@/lib/supabase";
import { orderMessage, whatsappLink } from "@/lib/whatsapp";
import { optionsLabel } from "@/lib/format";
import { computeTotals, discountPctFor, unitPrice, type PricedLine } from "@/lib/pricing";
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
    address: z.string().trim().min(5, "Ingresá la dirección de entrega.").max(300),
    notes: z.string().trim().max(500).optional(),
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
    db.from("settings").select("whatsapp").eq("id", 1).single(),
    db
      .from("variants")
      .select("*, product:products(id, name, category_id, status)")
      .in("id", [...qtyById.keys()]),
  ]);
  if (rulesRes.error || catsRes.error || settingsRes.error || variantsRes.error)
    return fail("No pudimos procesar el pedido. Probá de nuevo en unos minutos.", 500);

  const rules = rulesRes.data as PaymentRule[];
  const categories = catsRes.data as Pick<Category, "id" | "parent_id">[];

  // Única opción por ahora: transferencia (con su descuento) + envío
  const rule = rules.find((r) => r.method === "transfer");

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

  const { data: order, error: orderErr } = await db
    .from("orders")
    .insert({
      customer_name: body.customer.name,
      customer_phone: body.customer.phone,
      customer_email: body.customer.email || null,
      delivery: "moto",
      moto_address: body.address,
      payment: "transfer",
      plan: "full",
      subtotal: totals.subtotal,
      discount: totals.discount,
      total: totals.total,
      amount_due_now: totals.total,
      balance_due: totals.total,
      status: "awaiting_proof",
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

  const message = orderMessage({
    number: order.number,
    customerName: body.customer.name,
    total: totals.total,
    discount: totals.discount,
    address: body.address,
    notes: body.notes || null,
    items: priced.map((p) => ({ name: p.name, options: p.options || null, qty: p.qty })),
  });

  return NextResponse.json({
    whatsapp: whatsappLink(settingsRes.data.whatsapp, message),
    orderUrl: `/pedido/${order.public_token}`,
  });
}
