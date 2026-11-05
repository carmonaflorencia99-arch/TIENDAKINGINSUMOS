import type { Metadata } from "next";
import { getSettings } from "@/lib/catalog";
import { whatsappLink } from "@/lib/whatsapp";

export const metadata: Metadata = {
  title: "Cómo comprar, pagos, señas y envíos",
  description: "Medios de pago, descuentos, señas, envíos por moto y retiro en el showroom de King Insumos en Mendoza.",
};
export const revalidate = 300;

export default async function HowToBuy() {
  const s = await getSettings();
  const sections = [
    {
      id: "pedidos",
      title: "Cómo hacer tu pedido",
      body: (
        <>
          <p>Armá el carrito acá en la web y confirmá tu compra en pocos pasos, sin crear cuenta.</p>
          <p>
            Si preferís, también podés pedir por WhatsApp al{" "}
            <a className="underline" href={whatsappLink(s.whatsapp, "¡Hola King! Quiero hacer un pedido:")}>261 244-6705</a>. Detallá
            cada producto tal como figura en el catálogo: <strong>nombre / cantidad / medida / grosor / tipo o volumen</strong> (en
            pestañas). Cuanto más claro, más rápido y preciso el armado.
          </p>
        </>
      ),
    },
    {
      id: "pagos",
      title: "Medios de pago",
      body: (
        <ul className="list-disc space-y-1.5 pl-5">
          <li><strong>Efectivo en el local:</strong> 10% de descuento en todos los productos.</li>
          <li><strong>Transferencia:</strong> 10% de descuento en todo, excepto pestañas.</li>
        </ul>
      ),
    },
    {
      id: "senas",
      title: "Señas",
      body: (
        <ul className="list-disc space-y-1.5 pl-5">
          <li>Los productos se señan con el <strong>{s.deposit_pct}% del total</strong>.</li>
          <li>Tenés <strong>{s.deposit_business_days} días hábiles</strong> (según la ley) para retirar o completar el pago.</li>
          <li>Pasado ese plazo, la seña no es reembolsable.</li>
          <li>
            <strong>Los precios no se congelan.</strong> Si el producto aumenta después de señarlo, se ajusta al precio vigente al
            momento de completar el pago.
          </li>
        </ul>
      ),
    },
    {
      id: "envios",
      title: "Envíos y retiros",
      body: (
        <>
          <p>
            <strong>Retiro en el showroom:</strong> {s.pickup_address}. Podés retirar tu pedido una vez que esté señado o abonado en
            su totalidad. {s.store_hours}.
          </p>
          <p><strong>Envíos:</strong> únicamente por moto (Cabify, Uber u otro servicio similar).</p>
          <ul className="list-disc space-y-1.5 pl-5">
            <li>El pedido debe estar abonado previamente, solo por transferencia.</li>
            <li>Una vez enviado el comprobante, coordinamos el retiro. Vos solicitás el envío, hacés el seguimiento y recibís el pedido.</li>
            <li>No trabajamos con efectivo en envíos, porque no es posible gestionar devoluciones de dinero en esos casos.</li>
          </ul>
        </>
      ),
    },
    {
      id: "cambios",
      title: "Cambios y devoluciones",
      body: (
        <>
          <p>No realizamos cambios ni devoluciones. Todos los productos deben ser probados en el local al momento de la compra.</p>
          <p>Los adhesivos no tienen cambio ni devolución: deben ser controlados al momento de la compra.</p>
        </>
      ),
    },
  ];

  return (
    <div className="mx-auto max-w-2xl px-4 pt-8">
      <h1 className="text-[26px] leading-tight md:text-[32px]">Cómo comprar</h1>
      <nav className="-mx-4 mt-5 flex gap-2 overflow-x-auto px-4 pb-1">
        {sections.map((x) => (
          <a key={x.id} href={`#${x.id}`} className="chip whitespace-nowrap">{x.title}</a>
        ))}
      </nav>
      <div className="mt-8 space-y-10">
        {sections.map((x) => (
          <section key={x.id} id={x.id} className="scroll-mt-40">
            <h2 className="title text-[18px] md:text-[20px]">{x.title}</h2>
            <div className="mt-3 space-y-3 text-[15px] leading-relaxed text-ink/85">{x.body}</div>
          </section>
        ))}
      </div>
    </div>
  );
}
