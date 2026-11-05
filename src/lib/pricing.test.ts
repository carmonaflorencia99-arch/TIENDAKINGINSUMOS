import { describe, expect, it } from "vitest";
import {
  availableMethods,
  computeTotals,
  depositAmount,
  discountPctFor,
  unitPrice,
  validateChoice,
} from "./pricing";
import type { PaymentRule } from "./types";

// 1 = Extensiones de Pestañas, 7 = Volumen tecnológico (hija de 1), 2 = Adhesivos y Líquidos
const categories = [
  { id: 1, parent_id: null },
  { id: 2, parent_id: null },
  { id: 7, parent_id: 1 },
  { id: 11, parent_id: 2 },
];

const rules: PaymentRule[] = [
  { method: "cash", label: "Efectivo", discount_pct: 10, excluded_category_ids: [], allowed_delivery: ["pickup"], allows_deposit: true, active: true },
  { method: "transfer", label: "Transferencia", discount_pct: 10, excluded_category_ids: [1], allowed_delivery: ["pickup", "moto"], allows_deposit: true, active: true },
  { method: "mercadopago", label: "MP", discount_pct: 0, excluded_category_ids: [], allowed_delivery: ["pickup"], allows_deposit: false, active: true },
];
const rule = (m: string) => rules.find((r) => r.method === m)!;

describe("descuentos", () => {
  it("efectivo: 10% en todo, incluso pestañas", () => {
    expect(discountPctFor(rule("cash"), 7, categories)).toBe(10);
    expect(discountPctFor(rule("cash"), 11, categories)).toBe(10);
  });
  it("transferencia: sin descuento en pestañas (también subcategorías)", () => {
    expect(discountPctFor(rule("transfer"), 7, categories)).toBe(0);
    expect(discountPctFor(rule("transfer"), 1, categories)).toBe(0);
    expect(discountPctFor(rule("transfer"), 11, categories)).toBe(10);
  });
  it("precio con descuento coincide con el catálogo (Lion $24.800 → $22.320)", () => {
    expect(unitPrice(24800, 10)).toBe(22320);
    expect(unitPrice(24800, 0)).toBe(24800);
    expect(unitPrice(24800, 10, 22250)).toBe(22250); // override manual
  });
});

describe("totales y seña", () => {
  it("suma subtotal, descuento y total", () => {
    const t = computeTotals([
      { variantId: 1, qty: 2, unitListPrice: 8390, unitPrice: 8390 },
      { variantId: 2, qty: 1, unitListPrice: 29000, unitPrice: 26100 },
    ]);
    expect(t).toEqual({ subtotal: 45780, discount: 2900, total: 42880 });
  });
  it("seña 50% redondeada hacia arriba a $10", () => {
    expect(depositAmount(42880, 50)).toBe(21440);
    expect(depositAmount(42885, 50)).toBe(21450);
  });
});

describe("combinaciones de checkout", () => {
  it("moto solo con transferencia y pago completo", () => {
    expect(validateChoice({ payment: "transfer", delivery: "moto", plan: "full" }, rules)).toBeNull();
    expect(validateChoice({ payment: "cash", delivery: "moto", plan: "full" }, rules)).toMatch(/transferencia/);
    expect(validateChoice({ payment: "mercadopago", delivery: "moto", plan: "full" }, rules)).not.toBeNull();
    expect(validateChoice({ payment: "transfer", delivery: "moto", plan: "deposit" }, rules)).toMatch(/seña/i);
  });
  it("seña solo con retiro y medios que la admiten", () => {
    expect(validateChoice({ payment: "transfer", delivery: "pickup", plan: "deposit" }, rules)).toBeNull();
    expect(validateChoice({ payment: "mercadopago", delivery: "pickup", plan: "deposit" }, rules)).not.toBeNull();
  });
  it("lista de medios disponibles", () => {
    expect(availableMethods("moto", "full", rules).map((r) => r.method)).toEqual(["transfer"]);
    expect(availableMethods("pickup", "full", rules).map((r) => r.method)).toEqual(["cash", "transfer", "mercadopago"]);
    expect(availableMethods("pickup", "deposit", rules).map((r) => r.method)).toEqual(["cash", "transfer"]);
  });
  it("medio desactivado no se puede usar", () => {
    const off = rules.map((r) => (r.method === "mercadopago" ? { ...r, active: false } : r));
    expect(validateChoice({ payment: "mercadopago", delivery: "pickup", plan: "full" }, off)).not.toBeNull();
  });
});
