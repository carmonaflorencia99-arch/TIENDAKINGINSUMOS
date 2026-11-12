import type { Metadata, Viewport } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: { default: "King Insumos · Insumos de pestañas y cejas en Mendoza", template: "%s · King Insumos" },
  description:
    "Adhesivos, extensiones de pestañas, lifting, laminado y herramientas profesionales. Distribuidores oficiales de The Lion Beauty, Zaphiria y Abruxlashes en Mendoza. Retiro en Av. San Martín 1074 o envío por moto.",
  openGraph: { images: ["/brand/logo-gold.png"], siteName: "King Insumos", locale: "es_AR" },
};

export const viewport: Viewport = { themeColor: "#FFFFFF", width: "device-width", initialScale: 1 };

/** Layout raíz mínimo: la tienda y el panel tienen cada uno el suyo. */
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es-AR">
      <body className="min-h-dvh">{children}</body>
    </html>
  );
}
