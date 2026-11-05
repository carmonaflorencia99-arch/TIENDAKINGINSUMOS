/**
 * Mercado Pago Checkout Pro (cuenta argentina, ARS).
 * Credenciales en Mercado Pago Developers → Tus integraciones → Credenciales.
 */
import { createHmac, timingSafeEqual } from "node:crypto";
import { MercadoPagoConfig, Payment, Preference } from "mercadopago";

function client() {
  const accessToken = process.env.MP_ACCESS_TOKEN;
  if (!accessToken) throw new Error("Falta MP_ACCESS_TOKEN");
  return new MercadoPagoConfig({ accessToken });
}

export interface PreferenceInput {
  orderId: number;
  orderNumber: number;
  publicToken: string;
  payerEmail?: string | null;
  payerName: string;
  items: { id: string; title: string; quantity: number; unit_price: number }[];
}

export async function createPreference(input: PreferenceInput) {
  const site = process.env.NEXT_PUBLIC_SITE_URL!;
  const back = `${site}/pedido/${input.publicToken}`;
  const pref = await new Preference(client()).create({
    body: {
      items: input.items.map((i) => ({ ...i, currency_id: "ARS" })),
      payer: { name: input.payerName, email: input.payerEmail ?? undefined },
      external_reference: String(input.orderId),
      statement_descriptor: "KING INSUMOS",
      back_urls: { success: back, pending: back, failure: back },
      auto_return: "approved",
      notification_url: `${site}/api/mp/webhook`,
      metadata: { order_number: input.orderNumber },
    },
  });
  return { id: pref.id!, initPoint: pref.init_point! };
}

export async function getPayment(id: string) {
  return new Payment(client()).get({ id });
}

/**
 * Verifica la firma x-signature del webhook.
 * Manifest: "id:{data.id};request-id:{x-request-id};ts:{ts};"
 * Si MP_WEBHOOK_SECRET no está configurado, se omite (igual consultamos
 * el pago a la API de MP, que es la fuente de verdad).
 */
export function verifyWebhookSignature(
  signature: string | null,
  requestId: string | null,
  dataId: string,
): boolean {
  const secret = process.env.MP_WEBHOOK_SECRET;
  if (!secret) return true;
  if (!signature) return false;
  const parts = Object.fromEntries(
    signature.split(",").map((p) => p.trim().split("=") as [string, string]),
  );
  if (!parts.ts || !parts.v1) return false;
  const manifest = `id:${dataId.toLowerCase()};request-id:${requestId ?? ""};ts:${parts.ts};`;
  const expected = createHmac("sha256", secret).update(manifest).digest("hex");
  try {
    return timingSafeEqual(Buffer.from(expected), Buffer.from(parts.v1));
  } catch {
    return false;
  }
}
