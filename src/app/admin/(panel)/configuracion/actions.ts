"use server";
import { redirect } from "next/navigation";
import { adminDb, refreshStore } from "@/lib/admin";

const text = (v: FormDataEntryValue | null) => String(v ?? "").trim() || null;
const done = (q: string) => redirect(`/admin/configuracion?${q}`);

export async function saveSettings(f: FormData) {
  const db = await adminDb();
  const holidays = String(f.get("holidays") ?? "")
    .split(/\s+/)
    .map((d) => d.trim())
    .filter((d) => /^\d{4}-\d{2}-\d{2}$/.test(d));
  const pct = Number(f.get("deposit_pct"));
  const days = Number(f.get("deposit_business_days"));
  if (!(pct > 0 && pct <= 100) || !(days >= 1 && days <= 60))
    done("error=" + encodeURIComponent("Revisá el porcentaje de seña (1 a 100) y el plazo (1 a 60 días)."));

  const { error } = await db
    .from("settings")
    .update({
      bank_alias: text(f.get("bank_alias")),
      cbu: text(f.get("cbu"))?.replace(/\s/g, "") ?? null,
      account_holder: text(f.get("account_holder")),
      announcement_text: text(f.get("announcement_text")),
      whatsapp: (text(f.get("whatsapp")) ?? "5492612446705").replace(/\D/g, ""),
      pickup_address: text(f.get("pickup_address")),
      store_hours: text(f.get("store_hours")),
      deposit_pct: pct,
      deposit_business_days: days,
      deposit_count_saturdays: f.get("deposit_count_saturdays") === "on",
      holidays,
    })
    .eq("id", 1);
  if (error) done("error=" + encodeURIComponent("No se pudo guardar la configuración."));
  refreshStore();
  done("ok=" + encodeURIComponent("Configuración guardada."));
}

export async function saveRules(f: FormData) {
  const db = await adminDb();
  for (const method of ["cash", "transfer", "mercadopago"]) {
    const pct = Math.min(Math.max(Math.round(Number(f.get(`${method}-pct`)) || 0), 0), 50);
    let active = f.get(`${method}-active`) === "on";
    if (method === "mercadopago" && active && !process.env.MP_ACCESS_TOKEN) active = false;
    await db.from("payment_rules").update({ discount_pct: pct, active }).eq("method", method);
  }
  refreshStore();
  done(
    "ok=" +
      encodeURIComponent(
        !process.env.MP_ACCESS_TOKEN && f.get("mercadopago-active") === "on"
          ? "Guardado. Mercado Pago sigue desactivado hasta cargar sus credenciales."
          : "Medios de pago guardados.",
      ),
  );
}
