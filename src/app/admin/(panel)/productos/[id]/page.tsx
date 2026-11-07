import Link from "next/link";
import { notFound } from "next/navigation";
import { adminDb } from "@/lib/admin";
import { money } from "@/lib/format";
import { deleteImage, makeMainImage, saveAdhesiveSpecs, saveProduct } from "../actions";
import { ImageUploader } from "../uploader";

type Props = { params: Promise<{ id: string }>; searchParams: Promise<{ ok?: string; error?: string }> };

export async function generateMetadata({ params }: Props) {
  return { title: `Producto ${(await params).id}` };
}

const NEW_ROWS = 3;

export default async function EditProduct({ params, searchParams }: Props) {
  const { id } = await params;
  const { ok, error } = await searchParams;
  const db = await adminDb();
  const [{ data: p }, { data: categories }, { data: brands }] = await Promise.all([
    db.from("products").select("*, variants(*), images:product_images(*), adhesive_specs(*)").eq("id", Number(id)).maybeSingle(),
    db.from("categories").select("id, name, parent_id, sort_order").order("sort_order"),
    db.from("brands").select("id, name").order("name"),
  ]);
  if (!p) notFound();

  /* eslint-disable @typescript-eslint/no-explicit-any */
  const variants = [...p.variants].sort((a: any, b: any) => a.sort_order - b.sort_order || a.id - b.id);
  const images = [...p.images].sort((a: any, b: any) => a.sort_order - b.sort_order);
  const specs = (Array.isArray(p.adhesive_specs) ? p.adhesive_specs[0] : p.adhesive_specs) ?? {};
  /* eslint-enable @typescript-eslint/no-explicit-any */
  const mains = (categories ?? []).filter((c) => !c.parent_id);
  const opt = [p.option_names?.[0], p.option_names?.[1], p.option_names?.[2]];
  const isAdhesive = (categories ?? []).find((c) => c.id === p.category_id)?.name === "Adhesivos" || Object.keys(specs).length > 0;

  return (
    <div className="space-y-5">
      <Link href="/admin/productos" className="eyebrow">← Productos</Link>
      <div className="flex flex-wrap items-center justify-between gap-3">
        <h1 className="text-[22px]">{p.name}</h1>
        {p.status === "active" && (
          <Link href={`/producto/${p.slug}`} target="_blank" className="text-[12px] uppercase tracking-[1.5px] text-mute">Ver en la tienda ↗</Link>
        )}
      </div>
      {ok && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>}
      {error && <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>}

      <div className="grid gap-5 lg:grid-cols-[1fr_300px]">
        <form action={saveProduct} className="space-y-5">
          <input type="hidden" name="id" value={p.id} />

          <section className="grid gap-4 border border-line bg-white p-4 sm:grid-cols-2">
            <label className="sm:col-span-2">
              <span className="eyebrow mb-1 block">Nombre</span>
              <input name="name" defaultValue={p.name} required className="field" />
            </label>
            <label className="sm:col-span-2">
              <span className="eyebrow mb-1 block">Descripción</span>
              <textarea name="description" defaultValue={p.description ?? ""} className="field min-h-24 text-sm" />
            </label>
            <label>
              <span className="eyebrow mb-1 block">Categoría</span>
              <select name="category_id" defaultValue={p.category_id ?? ""} className="field">
                {mains.map((m) => (
                  <optgroup key={m.id} label={m.name}>
                    {(categories ?? []).filter((c) => c.parent_id === m.id).map((c) => (
                      <option key={c.id} value={c.id}>{c.name}</option>
                    ))}
                    <option value={m.id}>{m.name} (general)</option>
                  </optgroup>
                ))}
              </select>
            </label>
            <label>
              <span className="eyebrow mb-1 block">Marca</span>
              <select name="brand_id" defaultValue={p.brand_id ?? ""} className="field">
                <option value="">Sin marca</option>
                {(brands ?? []).map((b) => <option key={b.id} value={b.id}>{b.name}</option>)}
              </select>
            </label>
            <label>
              <span className="eyebrow mb-1 block">Estado</span>
              <select name="status" defaultValue={p.status} className="field">
                <option value="active">Publicado (se ve en la tienda)</option>
                <option value="draft">Borrador (oculto)</option>
                <option value="archived">Archivado (oculto)</option>
              </select>
            </label>
            <label>
              <span className="eyebrow mb-1 block">Tipo</span>
              <select name="kind" defaultValue={p.kind} className="field">
                <option value="simple">Simple (una sola opción)</option>
                <option value="variants">Con opciones (presentación, color…)</option>
                <option value="lash_matrix">Pestañas (curva · grosor · largo)</option>
              </select>
            </label>
            <label className="sm:col-span-2">
              <span className="eyebrow mb-1 block">Nombres de las opciones (separados por coma, hasta 3)</span>
              <input name="option_names" defaultValue={(p.option_names ?? []).join(", ")} placeholder="Ej.: Presentación  ·  Curvatura, Grosor, Largo" className="field" />
            </label>
            <div className="flex flex-wrap gap-5 text-sm sm:col-span-2">
              <label className="flex items-center gap-2"><input type="checkbox" name="featured" defaultChecked={p.featured} className="accent-ink" /> Destacado</label>
              <label className="flex items-center gap-2"><input type="checkbox" name="best_seller" defaultChecked={p.best_seller} className="accent-ink" /> Más vendido (aparece en el inicio)</label>
            </div>
          </section>

          <section className="border border-line bg-white">
            <div className="flex items-baseline justify-between px-4 pt-4">
              <h2 className="text-[14px]">Variantes, precios y stock</h2>
              <span className="text-xs text-mute">Precio de LISTA. El 10 % lo calcula la tienda.</span>
            </div>
            <div className="overflow-x-auto p-4">
              <table className="w-full min-w-[640px] text-sm">
                <thead className="text-left text-[11px] uppercase tracking-wider text-mute">
                  <tr>
                    {opt.map((o, i) => (o || i === 0 ? <th key={i} className="pb-2 pr-2 font-medium">{o || "Opción"}</th> : null))}
                    <th className="pb-2 pr-2 font-medium">Precio lista</th>
                    <th className="pb-2 pr-2 font-medium">Stock</th>
                    <th className="pb-2 pr-2 font-medium">Activa</th>
                    <th className="pb-2 font-medium">Borrar</th>
                  </tr>
                </thead>
                <tbody>
                  {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
                  {variants.map((v: any) => (
                    <tr key={v.id} className="border-t border-line">
                      {opt.map((o, i) => (o || i === 0 ? (
                        <td key={i} className="py-1.5 pr-2">
                          <input name={`v-${v.id}-option${i + 1}`} defaultValue={v[`option${i + 1}`] ?? ""} className="field px-2 py-1.5 text-sm" />
                        </td>
                      ) : null))}
                      <td className="py-1.5 pr-2">
                        <input name={`v-${v.id}-price_list`} defaultValue={v.price_list} inputMode="numeric" className="field w-28 px-2 py-1.5 text-sm tabular-nums" />
                        <span className="mt-0.5 block text-[11px] text-mute">efect. {money(Math.floor((v.price_list * 0.9) / 10) * 10)}</span>
                      </td>
                      <td className="py-1.5 pr-2">
                        <input name={`v-${v.id}-stock`} defaultValue={v.stock} inputMode="numeric" className={`field w-20 px-2 py-1.5 text-sm tabular-nums ${v.stock <= 0 ? "border-rose" : ""}`} />
                      </td>
                      <td className="py-1.5 pr-2 text-center"><input type="checkbox" name={`v-${v.id}-active`} defaultChecked={v.active} className="accent-ink" /></td>
                      <td className="py-1.5 text-center"><input type="checkbox" name={`v-${v.id}-delete`} className="accent-rose" aria-label="Borrar variante" /></td>
                    </tr>
                  ))}
                  {Array.from({ length: NEW_ROWS }, (_, n) => (
                    <tr key={`n${n}`} className="border-t border-dashed border-line">
                      {opt.map((o, i) => (o || i === 0 ? (
                        <td key={i} className="py-1.5 pr-2">
                          <input name={`n-${n}-option${i + 1}`} placeholder={n === 0 ? "Nueva…" : ""} className="field px-2 py-1.5 text-sm" />
                        </td>
                      ) : null))}
                      <td className="py-1.5 pr-2"><input name={`n-${n}-price_list`} inputMode="numeric" placeholder="$" className="field w-28 px-2 py-1.5 text-sm" /></td>
                      <td className="py-1.5 pr-2"><input name={`n-${n}-stock`} inputMode="numeric" placeholder="0" className="field w-20 px-2 py-1.5 text-sm" /></td>
                      <td colSpan={2} className="py-1.5 text-xs text-mute">nueva</td>
                    </tr>
                  ))}
                </tbody>
              </table>
              <p className="mt-2 text-xs text-mute">Para agregar variantes, completá las filas punteadas (con precio) y guardá.</p>
            </div>
          </section>

          <div className="sticky bottom-0 -mx-4 border-t border-line bg-surface/95 px-4 py-3 backdrop-blur">
            <button className="btn w-full sm:w-auto">Guardar cambios</button>
          </div>
        </form>

        <aside className="space-y-5">
          <section className="space-y-3 border border-line bg-white p-4">
            <h2 className="text-[14px]">Fotos</h2>
            {images.length === 0 && <p className="text-sm text-mute">Todavía no tiene fotos.</p>}
            <ul className="grid grid-cols-2 gap-2">
              {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
              {images.map((img: any, i: number) => (
                <li key={img.id} className="space-y-1">
                  <div className={`aspect-square overflow-hidden border ${i === 0 ? "border-ink" : "border-line"}`}>
                    {/* eslint-disable-next-line @next/next/no-img-element */}
                    <img src={img.url} alt="" className="h-full w-full object-cover" />
                  </div>
                  <div className="flex justify-between text-[11px]">
                    {i === 0 ? (
                      <span className="font-medium uppercase tracking-wider">Principal</span>
                    ) : (
                      <form action={makeMainImage}>
                        <input type="hidden" name="id" value={p.id} />
                        <input type="hidden" name="image_id" value={img.id} />
                        <button className="underline">Hacer principal</button>
                      </form>
                    )}
                    <form action={deleteImage}>
                      <input type="hidden" name="id" value={p.id} />
                      <input type="hidden" name="image_id" value={img.id} />
                      <button className="text-rose underline">Borrar</button>
                    </form>
                  </div>
                </li>
              ))}
            </ul>
            <ImageUploader productId={p.id} />
          </section>

          {isAdhesive && (
            <form action={saveAdhesiveSpecs} className="space-y-3 border border-line bg-white p-4 text-sm">
              <input type="hidden" name="id" value={p.id} />
              <h2 className="text-[14px]">Ficha técnica del adhesivo</h2>
              <div className="grid grid-cols-2 gap-2">
                {([
                  ["drying_min_s", "Secado mín. (seg)"], ["drying_max_s", "Secado máx. (seg)"],
                  ["humidity_min", "Humedad mín. %"], ["humidity_max", "Humedad máx. %"],
                  ["temp_min", "Temp. mín. °C"], ["temp_max", "Temp. máx. °C"],
                ] as const).map(([k, l]) => (
                  <label key={k}>
                    <span className="mb-0.5 block text-[11px] text-mute">{l}</span>
                    {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
                    <input name={k} defaultValue={(specs as any)[k] ?? ""} inputMode="decimal" className="field px-2 py-1.5 text-sm" />
                  </label>
                ))}
              </div>
              <label className="block">
                <span className="mb-0.5 block text-[11px] text-mute">Nivel</span>
                {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
                <select name="level" defaultValue={(specs as any).level ?? ""} className="field px-2 py-1.5 text-sm">
                  <option value="">—</option>
                  <option value="inicial">Inicial</option>
                  <option value="intermedio">Intermedio</option>
                  <option value="avanzado">Avanzado</option>
                  <option value="super_avanzado">Súper avanzado</option>
                </select>
              </label>
              {([["retention_weeks", "Retención (semanas)"], ["viscosity", "Viscosidad"], ["fumes", "Vapores"], ["open_shelf_life", "Una vez abierto"]] as const).map(([k, l]) => (
                <label key={k} className="block">
                  <span className="mb-0.5 block text-[11px] text-mute">{l}</span>
                  {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
                  <input name={k} defaultValue={(specs as any)[k] ?? ""} className="field px-2 py-1.5 text-sm" />
                </label>
              ))}
              <button className="btn-ghost w-full px-4 py-2">Guardar ficha</button>
            </form>
          )}
        </aside>
      </div>
    </div>
  );
}
