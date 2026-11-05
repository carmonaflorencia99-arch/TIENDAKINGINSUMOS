import type { AdhesiveSpecs } from "@/lib/types";

const LEVEL = {
  inicial: "Inicial",
  intermedio: "Intermedio",
  avanzado: "Avanzado",
  super_avanzado: "Súper avanzado",
} as const;

function drying(s: AdhesiveSpecs) {
  if (s.drying_min_s == null) return null;
  const fmt = (n: number) => String(n).replace(".", ",");
  return s.drying_max_s && s.drying_max_s !== s.drying_min_s
    ? `${fmt(s.drying_min_s)}–${fmt(s.drying_max_s)} seg`
    : `${fmt(s.drying_min_s)} seg`;
}

/** Badges del adhesivo: secado, nivel, humedad. */
export function AdhesiveBadges({ specs, compact = false }: { specs: AdhesiveSpecs; compact?: boolean }) {
  const d = drying(specs);
  return (
    <div className="flex flex-wrap gap-1.5">
      {d && <span className="badge">⏱ {d}</span>}
      {specs.level && <span className="badge bg-ink text-paper">{LEVEL[specs.level]}</span>}
      {!compact && specs.humidity_min != null && (
        <span className="badge">💧 {specs.humidity_min}–{specs.humidity_max}% humedad</span>
      )}
      {!compact && specs.temp_min != null && (
        <span className="badge">🌡 {specs.temp_min}–{specs.temp_max} °C</span>
      )}
    </div>
  );
}

/** Ficha técnica completa en la página del adhesivo. */
export function AdhesiveSpecTable({ specs }: { specs: AdhesiveSpecs }) {
  const rows: [string, string | null][] = [
    ["Tiempo de secado", drying(specs)],
    ["Nivel", specs.level ? LEVEL[specs.level] : null],
    ["Humedad ideal", specs.humidity_min != null ? `${specs.humidity_min}–${specs.humidity_max}%` : null],
    ["Temperatura ideal", specs.temp_min != null ? `${specs.temp_min}–${specs.temp_max} °C` : null],
    ["Retención", specs.retention_weeks ? `${specs.retention_weeks} semanas` : null],
    ["Viscosidad", specs.viscosity],
    ["Vapores", specs.fumes],
    ["Una vez abierto", specs.open_shelf_life],
  ];
  return (
    <div className="rounded-none border border-line bg-white p-4">
      <p className="eyebrow mb-3">Ficha técnica</p>
      <dl className="divide-y divide-line text-sm">
        {rows
          .filter(([, v]) => v)
          .map(([k, v]) => (
            <div key={k} className="flex justify-between gap-4 py-2">
              <dt className="text-mute">{k}</dt>
              <dd className="text-right font-medium">{v}</dd>
            </div>
          ))}
      </dl>
      <p className="mt-3 text-xs text-mute">
        En Mendoza el clima es seco: si tu gabinete está por debajo de la humedad ideal, usá un nano mister o humidificador.
      </p>
    </div>
  );
}
