"use client";
/**
 * Sube fotos achicándolas antes en el navegador (máx. 1600 px, JPEG), así
 * entran en el límite de tamaño del servidor y la tienda carga rápido.
 */
import { useRef, useState } from "react";
import { uploadImages } from "./actions";
import { shrinkImage } from "@/lib/shrink-image";

export function ImageUploader({ productId }: { productId: number }) {
  const input = useRef<HTMLInputElement>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onPick = async () => {
    const files = Array.from(input.current?.files ?? []).slice(0, 8);
    if (files.length === 0) return;
    setBusy(true);
    setError(null);
    try {
      const form = new FormData();
      form.set("id", String(productId));
      for (const f of files) form.append("files", await shrinkImage(f));
      await uploadImages(form);
    } catch (e) {
      // redirect() de la acción también llega acá como excepción; solo mostramos errores reales
      if (!(e instanceof Error && e.message.includes("NEXT_REDIRECT"))) setError("No se pudieron subir las fotos. Probá con menos a la vez.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div>
      <label className={`btn-ghost w-full cursor-pointer px-4 py-2.5 ${busy ? "pointer-events-none opacity-50" : ""}`}>
        {busy ? "Subiendo…" : "+ Subir fotos"}
        <input ref={input} type="file" accept="image/*" multiple className="sr-only" onChange={onPick} disabled={busy} />
      </label>
      <p className="mt-1 text-xs text-mute">Hasta 8 a la vez. Se achican solas antes de subir.</p>
      {error && <p className="mt-1 text-xs text-rose">{error}</p>}
    </div>
  );
}
