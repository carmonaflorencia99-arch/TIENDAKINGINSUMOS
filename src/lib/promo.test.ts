import { describe, expect, it } from "vitest";
import { blackFridayActive, promoPctFor, type PromoSubject } from "./promo";
import { linePrice } from "./pricing";

const VIERNES = Date.parse("2026-11-27T18:00:00-03:00");
const SABADO_NOCHE = Date.parse("2026-11-28T23:59:00-03:00");
const DOMINGO = Date.parse("2026-11-29T00:00:00-03:00");
const JUEVES = Date.parse("2026-11-26T23:59:00-03:00");

const s = (o: Partial<PromoSubject>): PromoSubject => ({ productName: "", brandSlug: null, categorySlugs: [], ...o });
const pestanas = ["medida-unica", "extensiones-de-pestanas"];
const tecno = ["volumen-tecnologico", "extensiones-de-pestanas"];

describe("Black Friday: fechas", () => {
  it("vale viernes 27 y sábado 28 (hora de Mendoza)", () => {
    expect(blackFridayActive(VIERNES)).toBe(true);
    expect(blackFridayActive(SABADO_NOCHE)).toBe(true);
    expect(blackFridayActive(DOMINGO)).toBe(false);
    expect(blackFridayActive(JUEVES)).toBe(false);
  });
  it("fuera de fecha no hay descuento", () => {
    expect(promoPctFor(s({ brandSlug: "the-lion-beauty", productName: "Kit lifting" }), DOMINGO)).toBe(0);
  });
});

describe("Black Friday: productos", () => {
  const pct = (o: Partial<PromoSubject>) => promoPctFor(s(o), VIERNES);
  it("todo The Lion Beauty 10%", () => expect(pct({ brandSlug: "the-lion-beauty", productName: "Kit de lifting Lion Beauty" })).toBe(10));
  it("Lady Diana 15% aunque sea de Lion", () => expect(pct({ brandSlug: "the-lion-beauty", productName: "Adhesivo Lady Diana" })).toBe(15));
  it("Súper Bonder Golle 15%", () => expect(pct({ brandSlug: "golle", productName: "Super Bonder Golle 15 ml" })).toBe(15));
  it("Clione: solo la línea Love", () => {
    expect(pct({ brandSlug: "clione", productName: "Adhesivo Clione Prime", options: ["Love (0,3-1 seg)", "3 g", null] })).toBe(15);
    expect(pct({ brandSlug: "clione", productName: "Adhesivo Clione Prime", options: ["Master (2-3 seg)", "3 g", null] })).toBe(0);
    expect(pct({ brandSlug: "clione", productName: "Bonder Clione 20 ml" })).toBe(0);
  });
  it("3D Lumi única medida 15% (no 60%)", () =>
    expect(pct({ brandSlug: "zaphiria", productName: "Pestañas LUMI 3D 007 única medida curva D", categorySlugs: pestanas })).toBe(15));
  it("Lumi W mix no entra", () =>
    expect(pct({ brandSlug: "zaphiria", productName: "Pestañas Zaphiria Lumi W 3D mix 0.07", categorySlugs: tecno })).toBe(0));
  it("Zaphiria tecnológicas medidas únicas 60%", () =>
    expect(pct({ brandSlug: "zaphiria", productName: "Pestañas Zaphiria W 0.07 D única medida", categorySlugs: tecno })).toBe(60));
  it("otras marcas no entran", () =>
    expect(pct({ brandSlug: "nagaraku", productName: "Pestañas Nagaraku única medida curva D", categorySlugs: pestanas })).toBe(0));
  it("Zaphiria que no es pestaña no entra", () =>
    expect(pct({ brandSlug: "zaphiria", productName: "Primer Lumi Zaphiria 15 ml", categorySlugs: ["primers-selladores"] })).toBe(0));
});

describe("precio con promo", () => {
  it("no se suma al 10% de transferencia", () => {
    expect(linePrice(10000, 10, 15)).toBe(8500);
    expect(linePrice(10000, 0, 15)).toBe(8500);
    expect(linePrice(10000, 10, 10)).toBe(9000);
    expect(linePrice(10000, 10, 0)).toBe(9000);
  });
});
