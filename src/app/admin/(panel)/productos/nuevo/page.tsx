import Link from "next/link";
import { adminDb } from "@/lib/admin";
import { createProduct } from "../actions";

export const metadata = { title: "Nuevo producto" };

type Props = { searchParams: Promise<{ error?: string }> };

export default async function NewProduct({ searchParams }: Props) {
  const { error } = await searchParams;
  const db = await adminDb();
  const [{ data: categories }, { data: brands }] = await Promise.all([
    db.from("categories").select("id, name, parent_id, sort_order").order("sort_order"),
    db.from("brands").select("id, name").order("name"),
  ]);
  const mains = (categories ?? []).filter((c) => !c.parent_id);

  return (
    <div className="max-w-xl space-y-5">
      <Link href="/admin/productos" className="eyebrow">← Productos</Link>
      <h1 className="text-[22px]">Nuevo producto</h1>
      {error && <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>}

      <form action={createProduct} className="space-y-4 border border-line bg-white p-5">
        <label className="block">
          <span className="eyebrow mb-1 block">Nombre</span>
          <input name="name" required className="field" placeholder="Ej.: Adhesivo Golle 5 g" />
        </label>
        <div className="grid gap-4 sm:grid-cols-2">
          <label>
            <span className="eyebrow mb-1 block">Categoría</span>
            <select name="category_id" required className="field">
              {mains.map((m) => (
                <optgroup key={m.id} label={m.name}>
                  {(categories ?? []).filter((c) => c.parent_id === m.id).map((c) => (
                    <option key={c.id} value={c.id}>{c.name}</option>
                  ))}
                </optgroup>
              ))}
            </select>
          </label>
          <label>
            <span className="eyebrow mb-1 block">Marca</span>
            <select name="brand_id" className="field">
              <option value="">Sin marca</option>
              {(brands ?? []).map((b) => <option key={b.id} value={b.id}>{b.name}</option>)}
            </select>
          </label>
        </div>
        <label className="block">
          <span className="eyebrow mb-1 block">Tipo</span>
          <select name="kind" className="field">
            <option value="simple">Simple (una sola opción)</option>
            <option value="variants">Con opciones (presentación, color…)</option>
            <option value="lash_matrix">Pestañas (curva · grosor · largo)</option>
          </select>
        </label>
        <label className="block">
          <span className="eyebrow mb-1 block">Nombre de la opción (si tiene opciones)</span>
          <input name="option" className="field" placeholder="Ej.: Presentación, Color, Tipo" />
        </label>
        <div className="grid gap-4 sm:grid-cols-2">
          <label>
            <span className="eyebrow mb-1 block">Precio de lista</span>
            <input name="price" required inputMode="numeric" className="field" placeholder="$" />
          </label>
          <label>
            <span className="eyebrow mb-1 block">Stock</span>
            <input name="stock" inputMode="numeric" defaultValue="0" className="field" />
          </label>
        </div>
        <button className="btn w-full">Crear producto</button>
        <p className="text-xs text-mute">Se crea como borrador: después podés sumar variantes y fotos, y publicarlo.</p>
      </form>
    </div>
  );
}
