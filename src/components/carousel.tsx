"use client";
/**
 * Carrusel liviano con scroll-snap (sin librerías). En celular se desliza con
 * el dedo; en escritorio muestra 4-5 tarjetas y flechas laterales.
 */
import { useRef } from "react";

export function Carousel({ children, label }: { children: React.ReactNode[]; label: string }) {
  const track = useRef<HTMLUListElement>(null);
  const move = (dir: 1 | -1) => {
    const el = track.current;
    if (el) el.scrollBy({ left: dir * el.clientWidth * 0.8, behavior: "smooth" });
  };
  return (
    <div className="relative" role="region" aria-label={label}>
      <ul
        ref={track}
        className="-mx-4 flex snap-x snap-mandatory gap-3 overflow-x-auto scroll-px-4 px-4 pb-2 [scrollbar-width:none] md:mx-0 md:px-0"
      >
        {children.map((c, i) => (
          <li key={i} className="w-[44%] shrink-0 snap-start sm:w-[30%] md:w-[calc(20%-10px)]">
            {c}
          </li>
        ))}
      </ul>
      {[-1, 1].map((d) => (
        <button
          key={d}
          type="button"
          aria-label={d < 0 ? "Anteriores" : "Siguientes"}
          onClick={() => move(d as 1 | -1)}
          className={`absolute top-[32%] hidden h-10 w-10 place-items-center border border-ink bg-white transition-colors hover:bg-ink hover:text-paper md:grid ${
            d < 0 ? "-left-5" : "-right-5"
          }`}
        >
          {d < 0 ? "←" : "→"}
        </button>
      ))}
    </div>
  );
}
