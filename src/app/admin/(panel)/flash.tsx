"use client";
/** Aviso de "guardado" del panel: se va solo a los 5 segundos y se limpia de la dirección. */
import { useEffect, useState } from "react";

export function Flash({ ok, error }: { ok?: string; error?: string }) {
  const [show, setShow] = useState(true);
  useEffect(() => {
    setShow(true);
    const url = new URL(window.location.href);
    if (url.searchParams.has("ok") || url.searchParams.has("error")) {
      url.searchParams.delete("ok");
      url.searchParams.delete("error");
      window.history.replaceState(window.history.state, "", url.pathname + (url.search || "") + url.hash);
    }
    if (ok && !error) {
      const t = setTimeout(() => setShow(false), 5000);
      return () => clearTimeout(t);
    }
  }, [ok, error]);
  if (!show || (!ok && !error)) return null;
  return error ? (
    <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>
  ) : (
    <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>
  );
}
