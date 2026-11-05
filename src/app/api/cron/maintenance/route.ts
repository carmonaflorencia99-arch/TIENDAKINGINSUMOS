/**
 * GET /api/cron/maintenance — lo ejecuta Vercel Cron una vez por día (ver vercel.json).
 *  - Marca como vencidas las señas fuera de plazo y libera su stock.
 *  - Cancela pedidos sin ningún pago con más de 48 h.
 */
import { NextResponse } from "next/server";
import { adminClient } from "@/lib/supabase";

export async function GET(req: Request) {
  if (req.headers.get("authorization") !== `Bearer ${process.env.CRON_SECRET}`)
    return NextResponse.json({ error: "no autorizado" }, { status: 401 });

  const db = adminClient();
  const [expired, cancelled] = await Promise.all([
    db.rpc("expire_deposits"),
    db.rpc("cancel_stale_orders", { p_hours: 48 }),
  ]);
  return NextResponse.json({ expiredDeposits: expired.data, cancelledOrders: cancelled.data });
}
