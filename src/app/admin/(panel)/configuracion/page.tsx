import { adminDb } from "@/lib/admin";
import { adminClient } from "@/lib/supabase";
import { disconnectInstagram, saveInstagram, saveRules, saveSettings } from "./actions";

export const metadata = { title: "Configuración" };

type Props = { searchParams: Promise<{ ok?: string; error?: string }> };

export default async function SettingsPage({ searchParams }: Props) {
  const { ok, error } = await searchParams;
  const db = await adminDb();
  const [{ data: s }, { data: rules }, { data: cats }] = await Promise.all([
    db.from("settings").select("*").eq("id", 1).single(),
    db.from("payment_rules").select("*"),
    db.from("categories").select("id, name"),
  ]);
  const { data: ig } = await adminClient()
    .from("integration_tokens")
    .select("account, updated_at")
    .eq("key", "instagram")
    .maybeSingle()
    .then((r) => r, () => ({ data: null }));
  const order = ["cash", "transfer", "mercadopago"];
  const sorted = (rules ?? []).sort((a, b) => order.indexOf(a.method) - order.indexOf(b.method));
  const catName = (id: number) => cats?.find((c) => c.id === id)?.name ?? `#${id}`;

  const field = (name: string, label: string, value: unknown, hint?: string, props: Record<string, unknown> = {}) => (
    <label className="block">
      <span className="eyebrow mb-1 block">{label}</span>
      <input name={name} defaultValue={value == null ? "" : String(value)} className="field" {...props} />
      {hint && <span className="mt-1 block text-xs text-mute">{hint}</span>}
    </label>
  );

  return (
    <div className="max-w-2xl space-y-6">
      <h1 className="text-[22px]">Configuración</h1>
      {ok && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>}
      {error && <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>}

      <form action={saveSettings} className="space-y-5 border border-line bg-white p-5">
        <h2 className="text-[14px]">Datos para transferencias</h2>
        <p className="-mt-3 text-xs text-mute">Mientras estén vacíos, la clienta pide los datos por WhatsApp.</p>
        <div className="grid gap-4 sm:grid-cols-2">
          {field("bank_alias", "Alias", s?.bank_alias)}
          {field("cbu", "CBU / CVU", s?.cbu, undefined, { inputMode: "numeric" })}
          {field("account_holder", "Titular", s?.account_holder)}
        </div>

        <h2 className="pt-2 text-[14px]">Tienda</h2>
        {field("announcement_text", "Barra de anuncios", s?.announcement_text, "El texto de la franja negra de arriba.")}
        {field("whatsapp", "WhatsApp", s?.whatsapp, "Con código de país, sin espacios: 5492612446705")}
        {field("pickup_address", "Dirección de retiro", s?.pickup_address)}
        {field("store_hours", "Horarios", s?.store_hours)}

        <h2 className="pt-2 text-[14px]">Señas</h2>
        <div className="grid gap-4 sm:grid-cols-2">
          {field("deposit_pct", "Seña (%)", s?.deposit_pct, undefined, { inputMode: "numeric" })}
          {field("deposit_business_days", "Plazo (días hábiles)", s?.deposit_business_days, undefined, { inputMode: "numeric" })}
        </div>
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" name="deposit_count_saturdays" defaultChecked={s?.deposit_count_saturdays} className="accent-ink" />
          Contar los sábados como días hábiles
        </label>
        <label className="block">
          <span className="eyebrow mb-1 block">Feriados (no cuentan para el plazo)</span>
          <textarea
            name="holidays"
            defaultValue={(s?.holidays ?? []).join("\n")}
            placeholder={"2026-12-08\n2026-12-25"}
            className="field min-h-24 font-mono text-sm"
          />
          <span className="mt-1 block text-xs text-mute">Una fecha por línea, en formato año-mes-día.</span>
        </label>
        <button className="btn">Guardar configuración</button>
      </form>

      <form action={saveRules} className="space-y-4 border border-line bg-white p-5">
        <h2 className="text-[14px]">Medios de pago y descuentos</h2>
        {sorted.map((r) => (
          <div key={r.method} className="grid items-end gap-3 border-t border-line pt-3 sm:grid-cols-[1fr_120px_auto]">
            <div>
              <p className="font-medium">{r.label}</p>
              {r.excluded_category_ids?.length > 0 && (
                <p className="text-xs text-mute">Sin descuento en: {r.excluded_category_ids.map(catName).join(", ")}</p>
              )}
              {r.method === "mercadopago" && <p className="text-xs text-mute">Para activarlo hace falta cargar las credenciales de Mercado Pago en Netlify.</p>}
            </div>
            <label>
              <span className="mb-0.5 block text-[11px] text-mute">Descuento %</span>
              <input name={`${r.method}-pct`} defaultValue={r.discount_pct} inputMode="numeric" className="field px-2 py-1.5" />
            </label>
            <label className="flex items-center gap-2 pb-2 text-sm">
              <input type="checkbox" name={`${r.method}-active`} defaultChecked={r.active} className="accent-ink" /> Activo
            </label>
          </div>
        ))}
        <button className="btn">Guardar medios de pago</button>
      </form>

      <section className="space-y-3 border border-line bg-white p-5">
        <h2 className="text-[14px]">Instagram</h2>
        {ig ? (
          <>
            <p className="text-sm">
              Conectado a <strong>@{ig.account}</strong>. Los últimos posts se ven en el inicio de la tienda (se actualizan cada hora).
            </p>
            <p className="text-xs text-mute">
              Última renovación del acceso: {new Date(ig.updated_at).toLocaleDateString("es-AR")}. Se renueva solo cada semana.
            </p>
            <form action={disconnectInstagram}>
              <button className="btn-ghost px-4 py-2 text-[12px]">Desconectar</button>
            </form>
          </>
        ) : (
          <form action={saveInstagram} className="space-y-3">
            <p className="text-sm text-mute">
              Pegá el token de acceso de la cuenta de Instagram (se genera en Meta for Developers). Mientras no esté conectado, la sección no aparece en la tienda.
            </p>
            <input name="token" type="password" autoComplete="off" placeholder="IGAA…" className="field font-mono text-sm" />
            <button className="btn">Conectar Instagram</button>
          </form>
        )}
      </section>
    </div>
  );
}
