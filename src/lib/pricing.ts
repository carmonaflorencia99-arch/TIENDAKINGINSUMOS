/**
 * Reglas de precios y checkout de King Insumos.
 *
 * Funciones puras: se usan igual en el navegador (para mostrar) y en el
 * servidor (para cobrar). El servidor SIEMPRE recalcula con datos de la base;
 * nunca confía en precios enviados por el navegador.
 *
 * Políticas actuales:
 *  - Efectivo en el local: 10% OFF en todo. Solo con retiro.
 *  - Transferencia: 10% OFF excepto Extensiones de Pestañas. Retiro o moto.
 *  - Moto: pedido abonado completo y solo por transferencia.
 *  - Seña: 50% del total, solo con retiro en el local.
 */
import type {
  Category,
  DeliveryMethod,
  PaymentMethod,
  PaymentPlan,
  PaymentRule,
} from "./types";

/** Devuelve la categoría y todas sus categorías padre. */
export function categoryLineage(
  categoryId: number | null,
  categories: Pick<Category, "id" | "parent_id">[],
): number[] {
  const byId = new Map(categories.map((c) => [c.id, c]));
  const lineage: number[] = [];
  let current = categoryId != null ? byId.get(categoryId) : undefined;
  // corta ciclos por si alguien carga mal una categoría
  while (current && !lineage.includes(current.id)) {
    lineage.push(current.id);
    current = current.parent_id != null ? byId.get(current.parent_id) : undefined;
  }
  return lineage;
}

/** % de descuento que corresponde a un producto según el medio de pago. */
export function discountPctFor(
  rule: Pick<PaymentRule, "discount_pct" | "excluded_category_ids"> | undefined,
  categoryId: number | null,
  categories: Pick<Category, "id" | "parent_id">[],
): number {
  if (!rule || rule.discount_pct <= 0) return 0;
  const lineage = categoryLineage(categoryId, categories);
  const excluded = lineage.some((id) => rule.excluded_category_ids.includes(id));
  return excluded ? 0 : rule.discount_pct;
}

/** Precio unitario final. Redondea a $10 hacia abajo, como en el catálogo. */
export function unitPrice(
  priceList: number,
  pct: number,
  priceOverride: number | null = null,
): number {
  if (pct <= 0) return priceList;
  if (priceOverride != null) return priceOverride;
  return Math.floor((priceList * (100 - pct)) / 100 / 10) * 10;
}

export interface PricedLine {
  variantId: number;
  qty: number;
  unitListPrice: number;
  unitPrice: number;
}

export interface Totals {
  subtotal: number; // a precio de lista
  discount: number;
  total: number;
}

export function computeTotals(lines: PricedLine[]): Totals {
  const subtotal = lines.reduce((s, l) => s + l.unitListPrice * l.qty, 0);
  const total = lines.reduce((s, l) => s + l.unitPrice * l.qty, 0);
  return { subtotal, discount: subtotal - total, total };
}

/** Monto de la seña (redondeado hacia arriba a $10). */
export function depositAmount(total: number, depositPct: number): number {
  return Math.ceil((total * depositPct) / 100 / 10) * 10;
}

export interface CheckoutChoice {
  payment: PaymentMethod;
  delivery: DeliveryMethod;
  plan: PaymentPlan;
}

/**
 * Valida la combinación elegida. Devuelve un mensaje de error en castellano
 * para mostrar a la clienta, o null si está todo bien.
 */
export function validateChoice(
  choice: CheckoutChoice,
  rules: PaymentRule[],
): string | null {
  const rule = rules.find((r) => r.method === choice.payment);
  if (!rule || !rule.active) return "Ese medio de pago no está disponible.";

  if (!rule.allowed_delivery.includes(choice.delivery)) {
    if (choice.delivery === "moto")
      return "Los envíos por moto se abonan completos y solo por transferencia.";
    return "Ese medio de pago no está disponible para la entrega elegida.";
  }

  if (choice.plan === "deposit") {
    if (choice.delivery !== "pickup")
      return "La seña es solo para retirar en el local. Los envíos por moto se abonan completos.";
    if (!rule.allows_deposit) return "Ese medio de pago no admite seña.";
  }
  return null;
}

/** Medios de pago que se pueden elegir para una entrega y plan dados. */
export function availableMethods(
  delivery: DeliveryMethod,
  plan: PaymentPlan,
  rules: PaymentRule[],
): PaymentRule[] {
  return rules.filter(
    (r) => validateChoice({ payment: r.method, delivery, plan }, rules) === null,
  );
}
