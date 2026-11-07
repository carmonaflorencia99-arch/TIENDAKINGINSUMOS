import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  experimental: {
    // Subida de fotos desde el panel (se achican en el navegador antes de enviar)
    serverActions: { bodySizeLimit: "5mb" },
  },
};

export default nextConfig;
