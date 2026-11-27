/**
 * Black Friday — viernes 27 y sábado 28 de noviembre de 2026 (hora de Mendoza).
 *
 * Mientras dura, los productos en oferta se venden al precio de lista menos el %
 * de la promo, con cualquier medio de pago (no se suma al 10% de transferencia).
 * Fuera de esas fechas todo vuelve solo a la normalidad: no hay que tocar nada.
 *
 * Funciones puras: se usan igual en el navegador (para mostrar) y en el
 * servidor (para cobrar).
 */

export const BLACK_FRIDAY = {
  name: "Black Friday",
  starts: Date.parse("2026-11-27T00:00:00-03:00"),
  ends: Date.parse("2026-11-29T00:00:00-03:00"), // hasta el sábado 28 a las 23:59
  maxPct: 60,
  datesLabel: "Solo viernes 27 y sábado 28 de noviembre",
};

export function blackFridayActive(now: number = Date.now()): boolean {
  return now >= BLACK_FRIDAY.starts && now < BLACK_FRIDAY.ends;
}

/** Lo que hace falta saber de un producto/variante para decidir si está en oferta. */
export interface PromoSubject {
  productName: string;
  brandSlug: string | null;
  /** slugs de la categoría del producto y de sus categorías padre */
  categorySlugs: string[];
  /** opciones de la variante (option1..3); vacío si se evalúa el producto entero */
  options?: (string | null)[];
}

const norm = (s: string | null | undefined) =>
  (s ?? "").normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();

const isUnica = (s: PromoSubject) =>
  /\bunicas?\b/.test(norm(s.productName)) || s.categorySlugs.includes("medida-unica");
const isLashes = (s: PromoSubject) =>
  s.categorySlugs.includes("extensiones-de-pestanas") || norm(s.productName).startsWith("pestanas");

interface PromoRule {
  pct: number;
  label: string;
  match: (s: PromoSubject) => boolean;
  /** true si la oferta depende de la variante (ej. solo la línea Love) */
  byVariant?: boolean;
}

/** Ofertas de Ivana. Gana la PRIMERA regla que coincide (por eso el orden importa). */
export const PROMO_RULES: PromoRule[] = [
  {
    pct: 15,
    label: "Pestañas 3D Lumi medidas únicas",
    match: (s) => isLashes(s) && /\blumi\b/.test(norm(s.productName)) && /\b3d\b/.test(norm(s.productName)) && isUnica(s),
  },
  {
    pct: 60,
    label: "Pestañas tecnológicas Zaphiria medidas únicas, cajas chicas (no Lumi ni cajas grandes)",
    // las Lumi NO entran en el 60% (solo las 3D Lumi únicas tienen 15%, regla de arriba)
    // solo las cajas chicas: quedan afuera las Lumi y las cajas grandes (Spike, Spire, Fan, Wings)
    match: (s) =>
      s.brandSlug === "zaphiria" &&
      isLashes(s) &&
      isUnica(s) &&
      !/\blumi\b/.test(norm(s.productName)) &&
      !/\b(spike|spikes|spire|fan|wings?|espigas?)\b/.test(norm(s.productName)),
  },
  {
    pct: 15,
    label: "Adhesivo Lady Diana (The Lion)",
    byVariant: true,
    // puede cargarse como producto propio o como una "línea" del Adhesivo Lion Beauty
    match: (s) => [s.productName, ...(s.options ?? [])].some((t) => /lady\s*diana/.test(norm(t))),
  },
  {
    pct: 15,
    label: "Súper Bonder de Gollee",
    match: (s) => /super\s*bonder/.test(norm(s.productName)) && (s.brandSlug === "golle" || /goll?ee?/.test(norm(s.productName))),
  },
  {
    pct: 15,
    label: "Adhesivo Love de Clione",
    byVariant: true,
    match: (s) =>
      (s.brandSlug === "clione" || /clione/.test(norm(s.productName))) &&
      (/\blove\b/.test(norm(s.productName)) || (s.options ?? []).some((o) => /\blove\b/.test(norm(o)))),
  },
  {
    pct: 10,
    label: "Todo The Lion Beauty",
    match: (s) => s.brandSlug === "the-lion-beauty",
  },
];

/** % de Black Friday para una variante (0 si no está en oferta o no es la fecha). */
export function promoPctFor(subject: PromoSubject, now: number = Date.now()): number {
  if (!blackFridayActive(now)) return 0;
  return PROMO_RULES.find((r) => r.match(subject))?.pct ?? 0;
}

/** Slugs de una categoría y sus padres, a partir de la lista completa de categorías. */
export function categorySlugsFor(
  categoryId: number | null,
  categories: { id: number; parent_id: number | null; slug: string }[],
): string[] {
  const byId = new Map(categories.map((c) => [c.id, c]));
  const out: string[] = [];
  let cur = categoryId != null ? byId.get(categoryId) : undefined;
  while (cur && !out.includes(cur.slug)) {
    out.push(cur.slug);
    cur = cur.parent_id != null ? byId.get(cur.parent_id) : undefined;
  }
  return out;
}
