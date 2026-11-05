"use client";
/**
 * Compra en la ficha de producto:
 *  - VariantPicker: productos simples o con 1-3 opciones (presentación, color…)
 *  - QuickAddMatrix: pestañas. Curva → grosor → y se suman varios largos de una vez.
 */
import { useMemo, useState } from "react";
import { useCart } from "./cart";
import { money, optionsLabel } from "@/lib/format";
import type { CartLineView, Product, Variant } from "@/lib/types";

export type VariantPrices = Record<number, { list: number; cash: number | null; transfer: number | null }>;

function toLine(p: Product, v: Variant, qty: number): CartLineView {
  return {
    variantId: v.id,
    qty,
    productName: p.name,
    productSlug: p.slug,
    optionsLabel: optionsLabel(v),
    priceList: v.price_list,
    categoryId: p.category_id,
    image: p.images[0]?.url,
    stock: v.stock,
    trackStock: v.track_stock,
  };
}

const maxFor = (v: Variant) => (v.track_stock ? Math.max(v.stock, 0) : 99);
const unique = (xs: (string | null)[]) => [...new Set(xs.filter((x): x is string => !!x))];

/* ---------------------------------------------------------------- */

function Stepper({
  value,
  max,
  onChange,
  label,
}: {
  value: number;
  max: number;
  onChange: (n: number) => void;
  label: string;
}) {
  return (
    <div className="flex items-center border border-line bg-white">
      <button
        type="button"
        aria-label={`Quitar uno ${label}`}
        className="grid h-10 w-10 place-items-center text-lg disabled:opacity-30"
        disabled={value <= 0}
        onClick={() => onChange(value - 1)}
      >
        −
      </button>
      <span className="w-7 text-center text-[15px] font-semibold tabular-nums" aria-live="polite">
        {value}
      </span>
      <button
        type="button"
        aria-label={`Sumar uno ${label}`}
        className="grid h-10 w-10 place-items-center text-lg disabled:opacity-30"
        disabled={value >= max}
        onClick={() => onChange(value + 1)}
      >
        +
      </button>
    </div>
  );
}

function StickyBar({ children }: { children: React.ReactNode }) {
  return (
    <div className="fixed inset-x-0 bottom-0 z-30 border-t border-line bg-paper/95 px-4 pb-[calc(env(safe-area-inset-bottom)+12px)] pt-3 backdrop-blur md:static md:mt-6 md:border-0 md:bg-transparent md:p-0">
      {children}
    </div>
  );
}

function PriceLines({ p }: { p: VariantPrices[number] | undefined }) {
  if (!p) return null;
  return (
    <div className="space-y-1">
      <p className="text-2xl font-bold">{money(p.list)}</p>
      {p.cash != null && (
        <p className="text-sm">
          <span className="font-semibold text-ok">{money(p.cash)}</span>{" "}
          <span className="text-mute">en efectivo en el local (10% OFF)</span>
        </p>
      )}
      {p.transfer != null ? (
        <p className="text-sm">
          <span className="font-semibold text-ok">{money(p.transfer)}</span>{" "}
          <span className="text-mute">por transferencia (10% OFF)</span>
        </p>
      ) : (
        <p className="text-xs text-mute">Transferencia: precio de lista (el 10% OFF en pestañas es solo en efectivo).</p>
      )}
    </div>
  );
}

/* ---------------------------------------------------------------- */

export function VariantPicker({ product, prices }: { product: Product; prices: VariantPrices }) {
  const { add } = useCart();
  const axes = product.option_names;
  const [sel, setSel] = useState<(string | null)[]>(() => {
    const first = product.variants.find((v) => maxFor(v) > 0) ?? product.variants[0];
    return [first?.option1 ?? null, first?.option2 ?? null, first?.option3 ?? null];
  });
  const [qty, setQty] = useState(1);

  const variant = product.variants.find(
    (v) => v.option1 === sel[0] && v.option2 === sel[1] && v.option3 === sel[2],
  );
  const max = variant ? maxFor(variant) : 0;

  const pick = (axis: number, value: string) => {
    const next = [...sel];
    next[axis] = value;
    // si la combinación no existe, toma la primera variante con ese valor
    const exists = product.variants.some((v) => v.option1 === next[0] && v.option2 === next[1] && v.option3 === next[2]);
    if (!exists) {
      const key = (["option1", "option2", "option3"] as const)[axis];
      const v = product.variants.find((x) => x[key] === value);
      if (v) return setSel([v.option1, v.option2, v.option3]);
    }
    setSel(next);
    setQty(1);
  };

  return (
    <div className="space-y-5">
      <PriceLines p={variant ? prices[variant.id] : undefined} />

      {axes.map((name, axis) => {
        const key = (["option1", "option2", "option3"] as const)[axis];
        const values = unique(product.variants.map((v) => v[key]));
        if (values.length === 0) return null;
        return (
          <fieldset key={name}>
            <legend className="eyebrow mb-2">{name}</legend>
            <div className="flex flex-wrap gap-2">
              {values.map((val) => {
                const anyStock = product.variants.some((v) => v[key] === val && maxFor(v) > 0);
                return (
                  <button
                    key={val}
                    type="button"
                    className="chip"
                    aria-pressed={sel[axis] === val}
                    disabled={!anyStock}
                    onClick={() => pick(axis, val)}
                  >
                    {val}
                  </button>
                );
              })}
            </div>
          </fieldset>
        );
      })}

      <StickyBar>
        <div className="flex items-center gap-3">
          <Stepper value={qty} max={max} onChange={setQty} label={product.name} />
          <button
            type="button"
            className="btn flex-1"
            disabled={!variant || max === 0 || qty === 0}
            onClick={() => variant && add([toLine(product, variant, qty)])}
          >
            {max === 0 ? "Sin stock" : `Agregar · ${money((variant?.price_list ?? 0) * qty)}`}
          </button>
        </div>
      </StickyBar>
    </div>
  );
}

/* ---------------------------------------------------------------- */

export function QuickAddMatrix({ product, prices }: { product: Product; prices: VariantPrices }) {
  const { add } = useCart();
  const [names] = useState(() => [
    product.option_names[0] ?? "Curvatura",
    product.option_names[1] ?? "Grosor",
    product.option_names[2] ?? "Largo",
  ]);
  const curves = useMemo(() => unique(product.variants.map((v) => v.option1)), [product.variants]);
  const [curve, setCurve] = useState(curves[0] ?? null);
  const thicknesses = useMemo(
    () => unique(product.variants.filter((v) => v.option1 === curve).map((v) => v.option2)),
    [product.variants, curve],
  );
  const [thick, setThick] = useState<string | null>(thicknesses[0] ?? null);
  const activeThick = thick && thicknesses.includes(thick) ? thick : (thicknesses[0] ?? null);

  // cantidades por variante: se mantienen al cambiar de curva/grosor
  const [qty, setQty] = useState<Record<number, number>>({});

  const lengths = product.variants
    .filter((v) => v.option1 === curve && v.option2 === activeThick)
    .sort((a, b) => parseFloat(a.option3 ?? "0") - parseFloat(b.option3 ?? "0") || a.sort_order - b.sort_order);

  const selected = product.variants.filter((v) => (qty[v.id] ?? 0) > 0);
  const totalBoxes = selected.reduce((s, v) => s + qty[v.id], 0);
  const totalPrice = selected.reduce((s, v) => s + v.price_list * qty[v.id], 0);

  const sample = lengths[0] ?? product.variants[0];

  const commit = () => {
    add(selected.map((v) => toLine(product, v, qty[v.id])));
    setQty({});
  };

  return (
    <div className="space-y-5">
      <PriceLines p={sample ? prices[sample.id] : undefined} />

      <fieldset>
        <legend className="eyebrow mb-2">1 · {names[0]}</legend>
        <div className="flex flex-wrap gap-2">
          {curves.map((c) => (
            <button key={c} type="button" className="chip" aria-pressed={curve === c} onClick={() => setCurve(c)}>
              {c}
            </button>
          ))}
        </div>
      </fieldset>

      <fieldset>
        <legend className="eyebrow mb-2">2 · {names[1]}</legend>
        <div className="flex flex-wrap gap-2">
          {thicknesses.map((t) => (
            <button key={t} type="button" className="chip" aria-pressed={activeThick === t} onClick={() => setThick(t)}>
              {t}
            </button>
          ))}
        </div>
      </fieldset>

      <fieldset>
        <legend className="eyebrow mb-2">
          3 · {names[2]} — sumá todas las que necesites
        </legend>
        <ul className="divide-y divide-line overflow-hidden rounded-none border border-line bg-white">
          {lengths.map((v) => {
            const max = maxFor(v);
            return (
              <li key={v.id} className="flex items-center justify-between px-4 py-2">
                <div>
                  <p className="font-semibold">{v.option3}</p>
                  <p className="text-xs text-mute">
                    {max === 0 ? "Sin stock" : v.track_stock && max <= 3 ? `Quedan ${max}` : money(v.price_list)}
                  </p>
                </div>
                {max === 0 ? (
                  <span className="pr-3 text-xs text-mute">—</span>
                ) : (
                  <Stepper
                    value={qty[v.id] ?? 0}
                    max={max}
                    label={`${curve} ${activeThick} ${v.option3}`}
                    onChange={(n) => setQty((q) => ({ ...q, [v.id]: n }))}
                  />
                )}
              </li>
            );
          })}
        </ul>
      </fieldset>

      {selected.length > 0 && (
        <div className="rounded-none bg-surface p-3 text-sm">
          <p className="eyebrow mb-1.5">Tu selección</p>
          <p className="leading-relaxed">
            {selected.map((v) => `${optionsLabel(v)} ×${qty[v.id]}`).join(" · ")}
          </p>
        </div>
      )}

      <StickyBar>
        <button type="button" className="btn w-full" disabled={totalBoxes === 0} onClick={commit}>
          {totalBoxes === 0
            ? "Elegí los largos"
            : `Agregar ${totalBoxes} ${totalBoxes === 1 ? "caja" : "cajas"} · ${money(totalPrice)}`}
        </button>
      </StickyBar>
    </div>
  );
}
