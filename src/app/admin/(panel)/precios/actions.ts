"use server";
import { redirect } from "next/navigation";
import { adminDb, refreshStore } from "@/lib/admin";

export async function bulkPrices(f: FormData) {
  const db = await adminDb();
  const pct = Number(String(f.get("pct") ?? "").replace(",", "."));
  if (!Number.isFinite(pct) || pct === 0 || pct <= -90 || pct > 500)
    redirect("/admin/precios?error=" + encodeURIComponent("Escribí un porcentaje válido (por ejemplo 8 o -5)."));

  const brand = Number(f.get("brand_id")) || null;
  const category = Number(f.get("category_id")) || null;
  const { data, error } = await db.rpc("bulk_update_prices", {
    p_pct: pct,
    p_brand_id: brand,
    p_category_id: category,
    p_round_to: 10,
  });
  if (error) redirect("/admin/precios?error=" + encodeURIComponent("No se pudieron actualizar los precios."));
  refreshStore();
  redirect(
    "/admin/precios?ok=" +
      encodeURIComponent(`Listo: ${data} ${data === 1 ? "precio actualizado" : "precios actualizados"} (${pct > 0 ? "+" : ""}${pct} %).`),
  );
}
