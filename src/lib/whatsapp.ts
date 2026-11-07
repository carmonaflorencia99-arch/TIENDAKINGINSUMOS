/**
 * Arma el mensaje de WhatsApp con el pedido en el formato que pide King:
 * "Nombre del producto / Cantidad / Medida / Grosor / Tipo".
 */
import { money, PAYMENT_LABEL, DELIVERY_LABEL } from "./format";
import type { DeliveryMethod, PaymentMethod, PaymentPlan } from "./types";

export interface WhatsappOrder {
  number: number;
  customerName: string;
  delivery: DeliveryMethod;
  payment: PaymentMethod;
  plan: PaymentPlan;
  total: number;
  amountDueNow: number;
  items: { name: string; options: string | null; qty: number }[];
  motoAddress?: string | null;
  /** false si la tienda todavía no tiene alias/CBU cargados */
  hasBankData?: boolean;
}

export function orderMessage(o: WhatsappOrder): string {
  const lines = [
    `¡Hola King! Soy ${o.customerName}. Te escribo por mi pedido *#${o.number}*:`,
    "",
    ...o.items.map(
      (i) => `• ${i.name}${i.options ? ` / ${i.options}` : ""} / Cantidad: ${i.qty}`,
    ),
    "",
    `Entrega: ${DELIVERY_LABEL[o.delivery]}${o.motoAddress ? ` (${o.motoAddress})` : ""}`,
    `Pago: ${PAYMENT_LABEL[o.payment]}${o.plan === "deposit" ? " · Seña 50%" : ""}`,
    `Total: ${money(o.total)}`,
  ];
  if (o.plan === "deposit") lines.push(`Seña a abonar: ${money(o.amountDueNow)}`);
  if (o.payment === "transfer")
    lines.push(
      "",
      o.hasBankData === false
        ? "¿Me pasás los datos para hacer la transferencia?"
        : "Te adjunto el comprobante de la transferencia.",
    );
  return lines.join("\n");
}

export function whatsappLink(phone: string, text: string): string {
  return `https://wa.me/${phone.replace(/\D/g, "")}?text=${encodeURIComponent(text)}`;
}
