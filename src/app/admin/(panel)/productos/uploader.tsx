"use client";
/**
 * Sube fotos achicándolas antes en el navegador (máx. 1600 px, JPEG), así
 * entran en el límite de tamaño del servidor y la tienda carga rápido.
 */
import { useRef, useState } from "react";
import { uploadImages } from "./actions";

async function shrink(file: File, max = 1600): Promise<File> {
  const bitmap = await createImageBitmap(file);
  const scale = Math.min(1, max / Math.max(bitmap.width, bitmap.height));
  const canvas = document.createElement("canvas");
  canvas.width = Math.round(bitmap.width * scale);
  canvas.height = Math.round(bitmap.height * scale);
  const ctx = canvas.getContext("2d")!;
  ctx.fillStyle = "#fff";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.drawImage(bitmap, 0, 0, canvas.width, canvas.height);
  const blob: Blob = await new Promise((r) => canvas.toBlob((b) => r(b!), "image/jpeg", 0.85));
  return new File([blob], file.name.replace(/\.\w+$/, "") + ".jpg", { type: "image/jpeg" });
}

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
      for (const f of files) form.append("files", await shrink(f));
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
