import type { Config } from "tailwindcss";

/**
 * Dirección visual: casi monocromo (negro/blanco), un único acento nude en bordes,
 * esquinas rectas, Jost en mayúsculas con tracking. El dorado queda solo para la
 * corona del logo de King.
 */
export default {
  content: ["./src/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: "#000000",
        paper: "#FFFFFF",
        line: "#ECDFD3",       // nude: bordes de tarjetas
        divider: "#CCCCCC",
        surface: "#F2F2F2",
        mute: "#3B3A36",       // texto secundario cálido
        rose: "#D54D4D",       // alertas / contador del carrito
        gold: "#F6CE3F",       // dorado del logo (solo en fondos negros)
        ok: "#2F6B4F",         // precio con descuento
      },
      fontFamily: {
        sans: ['"Jost Variable"', "futura-pt", "Helvetica", "sans-serif"],
      },
      keyframes: {
        marquee: { to: { transform: "translateX(-50%)" } },
        "fade-up": { from: { opacity: "0", transform: "translateY(20px)" }, to: { opacity: "1", transform: "none" } },
      },
      animation: {
        marquee: "marquee 28s linear infinite",
        "fade-up": "fade-up .6s ease-out both",
      },
    },
  },
  plugins: [],
} satisfies Config;
