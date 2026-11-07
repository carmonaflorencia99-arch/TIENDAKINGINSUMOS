/**
 * Tarea programada de Netlify: todos los días a las 9:00 UTC (6:00 en Mendoza)
 * llama a /api/cron/maintenance, que:
 *  - marca como vencidas las señas fuera de plazo y libera su stock
 *  - cancela pedidos sin ningún pago con más de 48 h
 *
 * Necesita la variable CRON_SECRET (la misma que usa la ruta).
 * Netlify define URL con la dirección principal del sitio.
 */
export default async () => {
  const site = process.env.NEXT_PUBLIC_SITE_URL || process.env.URL;
  const res = await fetch(`${site}/api/cron/maintenance`, {
    headers: { authorization: `Bearer ${process.env.CRON_SECRET}` },
  });
  const body = await res.text();
  console.log(`[mantenimiento] ${res.status} ${body}`);
  return new Response(body, { status: res.status });
};

export const config = {
  schedule: "0 9 * * *",
};
