"use client";
/**
 * Buscador para sumar productos a un pedido desde el panel.
 * Genera los campos add_variant_<n> / add_qty_<n> dentro del formulario de "Modificar pedido".
 */
import { useMemo, useState } from "react";
import { money } from "@/lib/format";

export type AddOption = { id: number; name: string; options: string; price: number; stock: number | null };

const norm = (s: string) => s.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase();

export function AddProducts({ options }: { options: AddOption[] }) {
  const [q, setQ] = useState("");
  const [picked, setPicked] = useState<{ opt: AddOption; qty: number }[]>([]);

  const results = useMemo(() => {
    const words = norm(q).split(/\s+/).filter(Boolean);
    if (!words.length) return [];
    return options
      .filter((o) => {
        const hay = norm(`${o.name} ${o.options}`);
        return words.every((w) => hay.includes(w));
      })
      .slice(0, 12);
  }, [q, options]);

  function add(opt: AddOption) {
    setPicked((p) => (p.some((x) => x.opt.id === opt.id) ? p.map((x) => (x.opt.id === opt.id ? { ...x, qty: x.qty + 1 } : x)) : [...p, { opt, qty: 1 }]));
    setQ("");
  }

  return (
    <div className="space-y-2">
      <p className="eyebrow">Sumar productos</p>
      <input
        type="search"
        value={q}
        onChange={(e) => setQ(e.target.value)}
        onKeyDown={(e) => e.key === "Enter" && e.preventDefault()}
        placeholder="Buscar producto (ej.: parches, cc 0.07 12)"
        className="field text-sm"
      />
      {results.length > 0 && (
        <ul className="max-h-64 divide-y divide-line overflow-auto border border-line">
          {results.map((o) => {
            const out = o.stock !== null && o.stock <= 0;
            return (
              <li key={o.id}>
                <button
                  type="button"
                  disabled={out}
                  onClick={() => add(o)}
                  className="flex w-full items-center justify-between gap-3 px-3 py-2 text-left hover:bg-black/5 disabled:opacity-40"
                >
                  <span className="min-w-0">
                    {o.name}
                    {o.options && <span className="block text-xs text-mute">{o.options}</span>}
                  </span>
                  <span className="shrink-0 text-right text-xs tabular-nums">
                    {money(o.price)}
                    <span className="block text-mute">{o.stock === null ? "" : out ? "sin stock" : `stock ${o.stock}`}</span>
                  </span>
                </button>
              </li>
            );
          })}
        </ul>
      )}
      {q && results.length === 0 && <p className="text-xs text-mute">No hay productos con ese nombre.</p>}

      {picked.length > 0 && (
        <ul className="divide-y divide-line border border-line bg-black/[0.02]">
          {picked.map((p, n) => (
            <li key={p.opt.id} className="flex items-center gap-3 px-3 py-2">
              <input type="hidden" name={`add_variant_${n}`} value={p.opt.id} />
              <div className="min-w-0 flex-1">
                <span className="text-ok">+ </span>
                {p.opt.name}
                {p.opt.options && <div className="text-xs text-mute">{p.opt.options}</div>}
              </div>
              <label className="flex items-center gap-1 text-xs text-mute">
                Cant.
                <input
                  type="number"
                  name={`add_qty_${n}`}
                  value={p.qty}
                  min={1}
                  max={999}
                  inputMode="numeric"
                  onChange={(e) => {
                    const qty = Number(e.target.value);
                    setPicked((all) => all.map((x) => (x.opt.id === p.opt.id ? { ...x, qty } : x)));
                  }}
                  className="field w-16 px-2 py-1.5 text-right text-sm text-ink"
                />
              </label>
              <button
                type="button"
                onClick={() => setPicked((all) => all.filter((x) => x.opt.id !== p.opt.id))}
                className="text-xs text-rose"
              >
                Sacar
              </button>
            </li>
          ))}
        </ul>
      )}
      <p className="text-xs text-mute">
        Los productos nuevos se cobran al precio de hoy (con el descuento por transferencia si el pedido es por transferencia).
      </p>
    </div>
  );
}
