import { adminDb } from "@/lib/admin";
import { bulkPrices } from "./actions";

export const metadata = { title: "Precios" };

type Props = { searchParams: Promise<{ ok?: string; error?: string }> };

export default async function PricesPage({ searchParams }: Props) {
  const { ok, error } = await searchParams;
  const db = await adminDb();
  const [{ data: categories }, { data: brands }] = await Promise.all([
    db.from("categories").select("id, name, parent_id, sort_order").order("sort_order"),
    db.from("brands").select("id, name").order("name"),
  ]);
  const mains = (categories ?? []).filter((c) => !c.parent_id);

  return (
    <div className="max-w-xl space-y-5">
      <h1 className="text-[22px]">Actualizar precios</h1>
      <p className="text-sm text-mute">
        Sube (o baja) el precio de lista de muchos productos a la vez. Los precios se redondean a $10. Los pedidos ya hechos no cambian.
      </p>
      {ok && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>}
      {error && <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>}

      <form action={bulkPrices} className="space-y-4 border border-line bg-white p-5">
        <label className="block">
          <span className="eyebrow mb-1 block">Porcentaje</span>
          <div className="flex items-center gap-2">
            <input name="pct" required inputMode="decimal" placeholder="Ej.: 8" className="field w-32 text-lg" />
            <span className="text-lg">%</span>
          </div>
          <span className="mt-1 block text-xs text-mute">Para bajar precios, usá un número negativo (ej.: -5).</span>
        </label>

        <fieldset className="space-y-2">
          <legend className="eyebrow mb-1">¿A qué productos?</legend>
          <label className="block">
            <span className="mb-0.5 block text-xs text-mute">Marca</span>
            <select name="brand_id" className="field">
              <option value="">Todas las marcas</option>
              {(brands ?? []).map((b) => <option key={b.id} value={b.id}>{b.name}</option>)}
            </select>
          </label>
          <label className="block">
            <span className="mb-0.5 block text-xs text-mute">Categoría</span>
            <select name="category_id" className="field">
              <option value="">Todas las categorías</option>
              {mains.map((m) => (
                <optgroup key={m.id} label={m.name}>
                  <option value={m.id}>{m.name} (todo)</option>
                  {(categories ?? []).filter((c) => c.parent_id === m.id).map((c) => (
                    <option key={c.id} value={c.id}>{c.name}</option>
                  ))}
                </optgroup>
              ))}
            </select>
          </label>
          <p className="text-xs text-mute">Si elegís marca y categoría, se aplica a los productos que cumplan las dos.</p>
        </fieldset>

        <label className="flex items-start gap-2 text-sm">
          <input type="checkbox" required className="mt-1 accent-ink" />
          Confirmo que quiero cambiar los precios. Para volver atrás hay que aplicar el porcentaje inverso.
        </label>
        <button className="btn w-full">Aplicar</button>
      </form>
    </div>
  );
}
