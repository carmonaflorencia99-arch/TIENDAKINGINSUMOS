"use client";
/**
 * Carrito en el navegador (sin cuenta). Guarda líneas en localStorage.
 * Los precios guardados son solo para mostrar: el checkout los recalcula.
 */
import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";
import type { CartLineView } from "@/lib/types";

const KEY = "king-cart-v1";

interface CartCtx {
  lines: CartLineView[];
  count: number;
  add: (items: CartLineView[]) => void;
  setQty: (variantId: number, qty: number) => void;
  remove: (variantId: number) => void;
  clear: () => void;
  replace: (lines: CartLineView[]) => void;
  lastAdded: number; // timestamp, para mostrar el aviso de "agregado"
}

const Ctx = createContext<CartCtx | null>(null);

function load(): CartLineView[] {
  try {
    const raw = localStorage.getItem(KEY);
    return raw ? (JSON.parse(raw) as CartLineView[]) : [];
  } catch {
    return [];
  }
}

export function CartProvider({ children }: { children: React.ReactNode }) {
  const [lines, setLines] = useState<CartLineView[]>([]);
  const [ready, setReady] = useState(false);
  const [lastAdded, setLastAdded] = useState(0);

  useEffect(() => {
    setLines(load());
    setReady(true);
  }, []);

  useEffect(() => {
    if (!ready) return;
    try {
      localStorage.setItem(KEY, JSON.stringify(lines));
    } catch {
      /* modo privado: el carrito vive solo en memoria */
    }
  }, [lines, ready]);

  const add = useCallback((items: CartLineView[]) => {
    setLines((prev) => {
      const next = [...prev];
      for (const item of items) {
        if (item.qty <= 0) continue;
        const i = next.findIndex((l) => l.variantId === item.variantId);
        if (i >= 0) next[i] = { ...next[i], ...item, qty: next[i].qty + item.qty };
        else next.push(item);
      }
      return next;
    });
    setLastAdded(Date.now());
  }, []);

  const setQty = useCallback((variantId: number, qty: number) => {
    setLines((prev) =>
      qty <= 0 ? prev.filter((l) => l.variantId !== variantId) : prev.map((l) => (l.variantId === variantId ? { ...l, qty } : l)),
    );
  }, []);

  const value = useMemo<CartCtx>(
    () => ({
      lines,
      count: lines.reduce((s, l) => s + l.qty, 0),
      add,
      setQty,
      remove: (id) => setQty(id, 0),
      clear: () => setLines([]),
      replace: setLines,
      lastAdded,
    }),
    [lines, add, setQty, lastAdded],
  );

  return <Ctx.Provider value={value}>{children}</Ctx.Provider>;
}

export function useCart() {
  const c = useContext(Ctx);
  if (!c) throw new Error("useCart fuera de CartProvider");
  return c;
}
