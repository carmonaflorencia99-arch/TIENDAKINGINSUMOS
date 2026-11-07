"use client";
import { useRef, useState } from "react";
import { shrinkImage } from "@/lib/shrink-image";
import { uploadCover } from "./actions";

export function CoverUploader({ categoryId, hasOwn }: { categoryId: number; hasOwn: boolean }) {
  const input = useRef<HTMLInputElement>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const onPick = async () => {
    const file = input.current?.files?.[0];
    if (!file) return;
    setBusy(true);
    setError(null);
    try {
      const form = new FormData();
      form.set("id", String(categoryId));
      form.set("file", await shrinkImage(file, 1400));
      await uploadCover(form);
    } catch (e) {
      if (!(e instanceof Error && e.message.includes("NEXT_REDIRECT"))) setError("No se pudo subir. Probá con otra foto.");
    } finally {
      setBusy(false);
    }
  };

  return (
    <div>
      <label className={`btn-ghost cursor-pointer px-3 py-1.5 text-[11px] ${busy ? "pointer-events-none opacity-50" : ""}`}>
        {busy ? "Subiendo…" : hasOwn ? "Cambiar portada" : "Subir portada"}
        <input ref={input} type="file" accept="image/*" className="sr-only" onChange={onPick} disabled={busy} />
      </label>
      {error && <p className="mt-1 text-xs text-rose">{error}</p>}
    </div>
  );
}
