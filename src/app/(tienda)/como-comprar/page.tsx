import type { Metadata } from "next";
import { getSettings } from "@/lib/catalog";
import { whatsappLink } from "@/lib/whatsapp";

export const metadata: Metadata = {
  title: "Cómo comprar, pagos y envíos",
  description: "Cómo hacer tu pedido por WhatsApp, pago por transferencia con 10% OFF y envíos de King Insumos en Mendoza.",
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
          <p>
            Armá el carrito acá en la web, completá tus datos y la dirección de envío, y tocá{" "}
            <strong>Enviar pedido por WhatsApp</strong>. Se abre el chat con el pedido ya escrito: solo tenés que mandarlo. No
            hace falta crear cuenta.
          </p>
          <p>
            También podés escribirnos directo al{" "}
            <a className="underline" href={whatsappLink(s.whatsapp, "¡Hola King! Quiero hacer un pedido:")}>261 244-6705</a>. Detallá
            cada producto tal como figura en el catálogo: <strong>nombre / cantidad / medida / grosor / tipo o volumen</strong> (en
            pestañas).
          </p>
        </>
      ),
    },
    {
      id: "pagos",
      title: "Pago",
      body: (
        <ul className="list-disc space-y-1.5 pl-5">
          <li><strong>Transferencia:</strong> 10% de descuento en todos los productos, pestañas incluidas.</li>
          <li><strong>Tarjeta de crédito o débito:</strong> con link de pago o QR, a precio de lista.</li>
          <li>Cuando recibimos tu pedido te pasamos por WhatsApp los datos para transferir o el link / QR.</li>
          <li>El pedido se abona completo antes del envío.</li>
        </ul>
      ),
    },
    {
      id: "envios",
      title: "Envíos",
      body: (
        <>
          <p>Trabajamos <strong>solo con envíos</strong>: no hay retiro ni compras presenciales.</p>
          <ul className="list-disc space-y-1.5 pl-5">
            <li>Una vez acreditada la transferencia, coordinamos el envío por WhatsApp.</li>
            <li>En Gran Mendoza el envío es por moto (Uber, Cabify o similar): vos lo solicitás, lo seguís y recibís el pedido.</li>
            <li>El costo del envío corre por cuenta de la clienta.</li>
          </ul>
        </>
      ),
    },
    {
      id: "cambios",
      title: "Cambios y devoluciones",
      body: (
        <>
          <p>No realizamos cambios ni devoluciones. Controlá tu pedido al recibirlo.</p>
          <p>Los adhesivos no tienen cambio ni devolución.</p>
        </>
      ),
    },
  ];

  return (
    <div className="mx-auto max-w-2xl px-4 pt-8">
      <h1 className="text-[26px] leading-tight md:text-[32px]">Cómo comprar</h1>
      <nav className="mt-5 flex flex-wrap gap-2">
        {sections.map((x) => (
          <a key={x.id} href={`#${x.id}`} className="chip text-[12px]">{x.title}</a>
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
