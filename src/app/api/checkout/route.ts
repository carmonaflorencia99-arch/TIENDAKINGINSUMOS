/**
 * POST /api/checkout
 * Crea el pedido con precios recalculados en el servidor y devuelve el link de
 * WhatsApp con el pedido armado. Solo envíos. Pago por transferencia (10% OFF)
 * o con tarjeta por link de pago / QR (precio de lista). King pasa los datos
 * y coordina el envío por WhatsApp.
 */
import { NextResponse } from "next/server";
import { z } from "zod";
import { adminClient } from "@/lib/supabase";
import { orderMessage, whatsappLink } from "@/lib/whatsapp";
import { optionsLabel } from "@/lib/format";
import { computeTotals, discountPctFor, linePrice, type PricedLine } from "@/lib/pricing";
import { blackFridayActive, categorySlugsFor, promoPctFor } from "@/lib/promo";
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
    payment: z.enum(["transfer", "card"]).default("transfer"),
    zone: z.string().trim().min(2, "Elegí la zona de envío.").max(80),
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

  const fullAddress = `${body.address} (${body.zone})`;

  const db = adminClient();
  const [rulesRes, catsRes, settingsRes, variantsRes] = await Promise.all([
    db.from("payment_rules").select("*"),
    db.from("categories").select("id, parent_id, slug"),
    db.from("settings").select("whatsapp").eq("id", 1).single(),
    db
      .from("variants")
      .select("*, product:products(id, name, category_id, status, brand:brands(slug))")
      .in("id", [...qtyById.keys()]),
  ]);
  if (rulesRes.error || catsRes.error || settingsRes.error || variantsRes.error)
    return fail("No pudimos procesar el pedido. Probá de nuevo en unos minutos.", 500);

  const rules = rulesRes.data as PaymentRule[];
  const categories = catsRes.data as Pick<Category, "id" | "parent_id" | "slug">[];

  // Transferencia tiene descuento; la tarjeta (link de pago / QR) va a precio de lista
  const rule = body.payment === "transfer" ? rules.find((r) => r.method === "transfer") : undefined;

  // Precios y stock desde la base
  const priced: (PricedLine & { name: string; options: string })[] = [];
  let hasPromo = false;
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
    // Black Friday: % sobre precio de lista, con cualquier medio de pago (no se suma)
    const promoPct = promoPctFor({
      productName: v.product.name,
      brandSlug: v.product.brand?.slug ?? null,
      categorySlugs: categorySlugsFor(v.product.category_id, categories),
      options: [v.option1, v.option2, v.option3],
    });
    if (promoPct > 0) hasPromo = true;
    priced.push({
      variantId,
      qty,
      unitListPrice: v.price_list,
      unitPrice: linePrice(v.price_list, pct, promoPct, v.price_override),
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
      moto_address: fullAddress,
      // la tarjeta se guarda como "mercadopago" (en el panel figura como "Tarjeta (link de pago o QR)")
      payment: body.payment === "card" ? "mercadopago" : "transfer",
      plan: "full",
      subtotal: totals.subtotal,
      discount: totals.discount,
      total: totals.total,
      amount_due_now: totals.total,
      balance_due: totals.total,
      status: body.payment === "card" ? "pending_payment" : "awaiting_proof",
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
    payment: body.payment,
    promo: hasPromo && blackFridayActive(),
    address: fullAddress,
    notes: body.notes || null,
    items: priced.map((p) => ({ name: p.name, options: p.options || null, qty: p.qty })),
  });

  return NextResponse.json({
    whatsapp: whatsappLink(settingsRes.data.whatsapp, message),
    orderUrl: `/pedido/${order.public_token}`,
  });
}
