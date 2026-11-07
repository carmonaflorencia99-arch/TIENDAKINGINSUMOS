/**
 * GET /api/cron/maintenance — la llama una vez por día la tarea programada de Netlify
 * (netlify/functions/mantenimiento-diario.mjs).
 *  - Marca como vencidas las señas fuera de plazo y libera su stock.
 *  - Cancela pedidos sin ningún pago con más de 48 h.
 *  - Renueva el token de Instagram cuando tiene más de 7 días.
 */
import { NextResponse } from "next/server";
import { adminClient } from "@/lib/supabase";
import { refreshTokenIfNeeded } from "@/lib/instagram";

export async function GET(req: Request) {
  if (req.headers.get("authorization") !== `Bearer ${process.env.CRON_SECRET}`)
    return NextResponse.json({ error: "no autorizado" }, { status: 401 });

  const db = adminClient();
  const [expired, cancelled, instagram] = await Promise.all([
    db.rpc("expire_deposits"),
    db.rpc("cancel_stale_orders", { p_hours: 48 }),
    refreshTokenIfNeeded().catch(() => "error" as const),
  ]);
  return NextResponse.json({ expiredDeposits: expired.data, cancelledOrders: cancelled.data, instagram });
}
