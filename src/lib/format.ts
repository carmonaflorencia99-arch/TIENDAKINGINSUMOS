const ars = new Intl.NumberFormat("es-AR", {
  style: "currency",
  currency: "ARS",
  maximumFractionDigits: 0,
});

/** $ 24.800 */
export function money(n: number): string {
  return ars.format(n);
}

/** "C · 0.07 · 10mm" a partir de las opciones de una variante. */
export function optionsLabel(v: {
  option1: string | null;
  option2: string | null;
  option3: string | null;
}): string {
  return [v.option1, v.option2, v.option3].filter(Boolean).join(" · ");
}

/** Fecha corta en hora de Mendoza: "vie 20/11". */
export function shortDate(iso: string): string {
  return new Date(iso).toLocaleDateString("es-AR", {
    weekday: "short",
    day: "2-digit",
    month: "2-digit",
    timeZone: "America/Argentina/Mendoza",
  });
}

export const PAYMENT_LABEL = {
  mercadopago: "Mercado Pago",
  transfer: "Transferencia",
  cash: "Efectivo en el local",
} as const;

export const DELIVERY_LABEL = {
  pickup: "Retiro en el local",
  moto: "Envío por moto",
} as const;
