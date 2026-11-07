"use client";
import { useState } from "react";

export function CopyButton({ text }: { text: string }) {
  const [done, setDone] = useState(false);
  return (
    <button
      type="button"
      className="border border-ink px-2.5 py-1 text-[11px] font-semibold"
      onClick={async () => {
        try {
          await navigator.clipboard.writeText(text);
          setDone(true);
          setTimeout(() => setDone(false), 1500);
        } catch {
          /* sin permiso de portapapeles */
        }
      }}
    >
      {done ? "Copiado" : "Copiar"}
    </button>
  );
}
