/**
 * Arma el mensaje de WhatsApp con el pedido en el formato que pide King:
 * "Nombre del producto / Cantidad / Medida / Grosor / Tipo".
 *
 * Por ahora la tienda no cobra online: la clienta manda el pedido por WhatsApp
 * y King le pasa los datos para transferir (o el link de pago / QR para tarjeta)
 * y coordina el envío.
 */
import { money } from "./format";

export interface WhatsappOrder {
  number: number;
  customerName: string;
  total: number;
  discount: number;
  /** "transfer" = transferencia con 10% OFF · "card" = tarjeta con link de pago o QR */
  payment: "transfer" | "card";
  items: { name: string; options: string | null; qty: number }[];
  address?: string | null;
  notes?: string | null;
}

export function orderMessage(o: WhatsappOrder): string {
  const lines = [
    `¡Hola King! Soy ${o.customerName}. Quiero hacer este pedido (*#${o.number}*):`,
    "",
    ...o.items.map((i) => `• ${i.name}${i.options ? ` / ${i.options}` : ""} / Cantidad: ${i.qty}`),
    "",
    o.payment === "card"
      ? `Pago: tarjeta (link de pago o QR)`
      : `Pago: transferencia${o.discount > 0 ? " (10% OFF)" : ""}`,
    `Total: *${money(o.total)}*`,
    `Envío a: ${o.address ?? "—"}`,
  ];
  if (o.notes) lines.push(`Nota: ${o.notes}`);
  lines.push(
    "",
    o.payment === "card"
      ? "¿Me pasás el link de pago o el QR y coordinamos el envío?"
      : "¿Me pasás los datos para transferir y coordinamos el envío?",
  );
  return lines.join("\n");
}

export function whatsappLink(phone: string, text: string): string {
  return `https://wa.me/${phone.replace(/\D/g, "")}?text=${encodeURIComponent(text)}`;
}
