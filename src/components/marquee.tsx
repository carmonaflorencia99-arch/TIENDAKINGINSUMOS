/** Franja negra con mensajes en loop infinito (CSS puro, respeta "reducir movimiento"). */
export function Marquee({ items }: { items: string[] }) {
  const row = (hidden: boolean) => (
    <ul className="flex shrink-0 items-center" aria-hidden={hidden || undefined}>
      {items.map((t, i) => (
        <li key={i} className="flex items-center whitespace-nowrap px-6 text-[12px] font-normal uppercase tracking-[2px]">
          {t}
          <span className="ml-12 text-[8px] text-gold" aria-hidden>✦</span>
        </li>
      ))}
    </ul>
  );
  return (
    <div className="overflow-hidden bg-ink py-3.5 text-paper">
      {/* dos copias idénticas: al moverse -50% el loop no tiene salto */}
      <div className="flex w-max animate-marquee">
        {row(false)}
        {row(true)}
      </div>
    </div>
  );
}
