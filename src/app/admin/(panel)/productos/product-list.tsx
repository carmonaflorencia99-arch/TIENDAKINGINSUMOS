"use client";
/**
 * Lista de productos del panel con edición en el lugar:
 * - precio y stock de cada opción se guardan solos (sin botón "Guardar");
 * - publicar / ocultar y eliminar sin salir de la lista.
 */
import Link from "next/link";
import { useEffect, useRef, useState, useTransition } from "react";
import { money } from "@/lib/format";
import { deleteProduct, quickSetStatus, quickUpdateVariant } from "./actions";

export interface ListVariant {
  id: number;
  label: string;
  price_list: number;
  stock: number;
  active: boolean;
}
export interface ListProduct {
  id: number;
  name: string;
  status: "active" | "draft" | "archived";
  brand: string | null;
  category: string | null;
  image: string | null;
  variants: ListVariant[];
}

type SaveState = "idle" | "saving" | "saved" | "error";

function SaveBadge({ state, error }: { state: SaveState; error?: string }) {
  if (state === "saving") return <span className="text-[11px] text-mute">Guardando…</span>;
  if (state === "saved") return <span className="text-[11px] text-ok">✓ Guardado</span>;
  if (state === "error") return <span className="text-[11px] text-rose">{error ?? "Error"}</span>;
  return null;
}

/** Una opción (variante): precio y stock con guardado automático. */
function VariantEditor({ v, showLabel }: { v: ListVariant; showLabel: boolean }) {
  const [price, setPrice] = useState(String(v.price_list));
  const [stock, setStock] = useState(v.stock);
  const [state, setState] = useState<SaveState>("idle");
  const [error, setError] = useState<string>();
  const saved = useRef({ price: v.price_list, stock: v.stock });
  const timer = useRef<ReturnType<typeof setTimeout>>(undefined);

  const save = (next: { price?: number; stock?: number }, delay = 700) => {
    clearTimeout(timer.current);
    timer.current = setTimeout(async () => {
      const patch: { price_list?: number; stock?: number } = {};
      if (next.price !== undefined && next.price !== saved.current.price) patch.price_list = next.price;
      if (next.stock !== undefined && next.stock !== saved.current.stock) patch.stock = next.stock;
      if (!Object.keys(patch).length) return;
      setState("saving");
      try {
        const r = await quickUpdateVariant(v.id, patch);
        if (r.ok) {
          if (patch.price_list !== undefined) saved.current.price = patch.price_list;
          if (patch.stock !== undefined) saved.current.stock = patch.stock;
          setState("saved");
          setTimeout(() => setState((s) => (s === "saved" ? "idle" : s)), 2000);
        } else {
          setError(r.error);
          setState("error");
        }
      } catch {
        setError("Sin conexión");
        setState("error");
      }
    }, delay);
  };
  useEffect(() => () => clearTimeout(timer.current), []);

  const changeStock = (n: number) => {
    const val = Math.max(0, n);
    setStock(val);
    save({ stock: val });
  };
  const priceNum = Number(price.replace(/\D/g, ""));

  return (
    <div className={`flex flex-wrap items-center gap-x-3 gap-y-1.5 py-2 ${v.active ? "" : "opacity-50"}`}>
      {showLabel && <span className="w-full text-[13px] font-medium sm:w-48 sm:shrink-0">{v.label}</span>}
      <label className="flex items-center gap-1">
        <span className="text-[11px] uppercase tracking-wider text-mute">$</span>
        <input
          value={price}
          inputMode="numeric"
          onChange={(e) => {
            const raw = e.target.value.replace(/\D/g, "");
            setPrice(raw);
            if (raw) save({ price: Number(raw) }, 1000);
          }}
          onBlur={() => price && save({ price: priceNum }, 0)}
          onKeyDown={(e) => e.key === "Enter" && (e.currentTarget.blur())}
          aria-label={`Precio de lista ${v.label}`}
          className="field w-24 px-2 py-1.5 text-sm tabular-nums"
        />
      </label>
      <div className="flex items-center" role="group" aria-label={`Stock ${v.label}`}>
        <button type="button" onClick={() => changeStock(stock - 1)} className="h-9 w-9 border border-line bg-white text-lg leading-none" aria-label="Restar uno">−</button>
        <input
          value={stock}
          inputMode="numeric"
          onChange={(e) => changeStock(Number(e.target.value.replace(/\D/g, "") || 0))}
          onFocus={(e) => e.target.select()}
          className={`h-9 w-14 border-y border-line text-center text-sm tabular-nums outline-none focus:border-ink ${stock <= 0 ? "text-rose" : ""}`}
          aria-label="Unidades"
        />
        <button type="button" onClick={() => changeStock(stock + 1)} className="h-9 w-9 border border-line bg-white text-lg leading-none" aria-label="Sumar uno">+</button>
      </div>
      {stock <= 0 && state === "idle" && <span className="text-[11px] text-rose">Sin stock</span>}
      <SaveBadge state={state} error={error} />
    </div>
  );
}

const STATUS_LABEL = { active: "Publicado", draft: "Oculto", archived: "Archivado" } as const;

function ProductRow({ p, editHref, onDeleted, highlight }: { p: ListProduct; editHref: string; onDeleted: (id: number) => void; highlight: boolean }) {
  const [open, setOpen] = useState(p.variants.length <= 1 || highlight);
  const [status, setStatus] = useState(p.status);
  const [confirming, setConfirming] = useState(false);
  const [msg, setMsg] = useState<string>();
  const [pending, start] = useTransition();
  const total = p.variants.reduce((s, v) => s + Math.max(v.stock, 0), 0);
  const prices = p.variants.map((v) => v.price_list);

  const toggleStatus = () => {
    const next = status === "active" ? "draft" : "active";
    start(async () => {
      const r = await quickSetStatus(p.id, next);
      if (r.ok) setStatus(next);
      else setMsg(r.error);
    });
  };
  const remove = () =>
    start(async () => {
      const r = await deleteProduct(p.id);
      if (r.ok) onDeleted(p.id);
      else setMsg(r.error);
    });

  return (
    <li id={`p-${p.id}`} className={`border-t border-line px-3 py-3 first:border-t-0 sm:px-4 ${highlight ? "bg-ok/5" : ""}`}>
      <div className="flex gap-3">
        <span className="h-14 w-14 shrink-0 overflow-hidden border border-line bg-surface">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          {p.image && <img src={p.image} alt="" className="h-full w-full object-cover" loading="lazy" />}
        </span>
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-start justify-between gap-x-3 gap-y-1">
            <Link href={editHref} className="font-medium leading-snug underline-offset-4 hover:underline">{p.name}</Link>
            <button
              type="button"
              onClick={toggleStatus}
              disabled={pending}
              className={`badge shrink-0 ${status === "active" ? "border-ok/40 text-ok" : "text-mute"}`}
              title={status === "active" ? "Tocá para ocultarlo de la tienda" : "Tocá para publicarlo"}
            >
              {STATUS_LABEL[status]}
            </button>
          </div>
          <p className="text-xs text-mute">
            {[p.brand ?? "Sin marca", p.category].filter(Boolean).join(" · ")}
            {p.variants.length > 1 && ` · ${p.variants.length} opciones`}
          </p>
        </div>
      </div>

      {p.variants.length > 1 && (
        <button type="button" onClick={() => setOpen((o) => !o)} className="mt-2 flex w-full items-center justify-between border border-line bg-surface/60 px-3 py-2 text-left text-[13px]">
          <span>
            Stock total <strong className={total === 0 ? "text-rose" : ""}>{total}</strong>
            <span className="text-mute"> · {money(Math.min(...prices))}{Math.min(...prices) !== Math.max(...prices) ? ` – ${money(Math.max(...prices))}` : ""}</span>
          </span>
          <span className="text-[11px] uppercase tracking-wider">{open ? "Cerrar ▴" : "Editar opciones ▾"}</span>
        </button>
      )}
      {open && (
        <div className={p.variants.length > 1 ? "mt-1 divide-y divide-line/70 border-x border-b border-line px-3" : "mt-1 sm:pl-[68px]"}>
          {p.variants.map((v) => (
            <VariantEditor key={v.id} v={v} showLabel={p.variants.length > 1} />
          ))}
          {p.variants.length === 0 && <p className="py-2 text-xs text-mute">Sin opciones. Entrá a editar para agregar precio y stock.</p>}
        </div>
      )}

      <div className="mt-2 flex flex-wrap items-center gap-x-4 gap-y-1 text-[12px] sm:pl-[68px]">
        <Link href={editHref} className="underline underline-offset-4">Editar todo (nombre, fotos…)</Link>
        {!confirming ? (
          <button type="button" onClick={() => setConfirming(true)} className="text-rose underline underline-offset-4">Eliminar</button>
        ) : (
          <span className="flex items-center gap-2">
            <span className="text-rose">¿Eliminar este producto?</span>
            <button type="button" onClick={remove} disabled={pending} className="bg-rose px-2 py-1 text-paper">{pending ? "Eliminando…" : "Sí, eliminar"}</button>
            <button type="button" onClick={() => setConfirming(false)} className="underline">No</button>
          </span>
        )}
        {msg && <span className="text-rose">{msg}</span>}
      </div>
    </li>
  );
}

export function ProductList({ products, from, highlightId }: { products: ListProduct[]; from: string; highlightId?: number }) {
  const [items, setItems] = useState(products);
  const [removed, setRemoved] = useState<string>();
  useEffect(() => setItems(products), [products]);
  useEffect(() => {
    if (highlightId) document.getElementById(`p-${highlightId}`)?.scrollIntoView({ block: "center" });
  }, [highlightId]);

  return (
    <>
      {removed && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{removed}</p>}
      {items.length === 0 && <p className="border border-line bg-white p-6 text-center text-sm text-mute">No hay productos con esa búsqueda.</p>}
      <ul className={items.length ? "border border-line bg-white" : "hidden"}>
        {items.map((p) => (
          <ProductRow
            key={p.id}
            p={p}
            highlight={p.id === highlightId}
            editHref={`/admin/productos/${p.id}${from ? `?from=${encodeURIComponent(from)}` : ""}`}
            onDeleted={(id) => {
              setItems((list) => list.filter((x) => x.id !== id));
              setRemoved(`Se eliminó "${p.name}".`);
            }}
          />
        ))}
      </ul>
    </>
  );
}
