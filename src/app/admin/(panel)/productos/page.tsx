import Link from "next/link";
import { adminDb } from "@/lib/admin";
import { money } from "@/lib/format";

export const metadata = { title: "Productos" };

type Props = { searchParams: Promise<{ q?: string; cat?: string; estado?: string; ok?: string }> };

const STATUS = { active: "Publicado", draft: "Borrador", archived: "Archivado" } as const;

export default async function ProductsPage({ searchParams }: Props) {
  const { q = "", cat = "", estado = "", ok } = await searchParams;
  const db = await adminDb();
  const { data: categories } = await db.from("categories").select("id, name, parent_id, sort_order").order("sort_order");
  const mains = (categories ?? []).filter((c) => !c.parent_id);

  let query = db
    .from("products")
    .select("id, name, slug, status, featured, best_seller, brand:brands(name), category:categories(name), variants(price_list, stock, active), images:product_images(url, sort_order)")
    .order("id")
    .limit(400);
  if (q.trim()) query = query.ilike("name", `%${q.trim().replace(/[%,()]/g, " ")}%`);
  if (cat) {
    const ids = [Number(cat), ...(categories ?? []).filter((c) => c.parent_id === Number(cat)).map((c) => c.id)];
    query = query.in("category_id", ids);
  }
  if (estado) query = query.eq("status", estado);
  const { data: products } = await query;

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-end justify-between gap-3">
        <h1 className="text-[22px]">Productos <span className="text-mute">({products?.length ?? 0})</span></h1>
        <Link href="/admin/productos/nuevo" className="btn px-4 py-2.5">+ Nuevo producto</Link>
      </div>
      {ok && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>}

      <form className="flex flex-wrap gap-2">
        <input name="q" defaultValue={q} placeholder="Buscar por nombre" className="field w-56 py-2 text-sm" />
        <select name="cat" defaultValue={cat} className="field w-auto py-2 text-sm">
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
        <select name="estado" defaultValue={estado} className="field w-auto py-2 text-sm">
          <option value="">Todos los estados</option>
          <option value="active">Publicados</option>
          <option value="draft">Borradores</option>
          <option value="archived">Archivados</option>
        </select>
        <button className="btn-ghost px-4 py-2">Filtrar</button>
      </form>

      <div className="overflow-x-auto border border-line bg-white">
        <table className="w-full min-w-[760px] text-sm">
          <thead className="border-b border-line text-left text-[11px] uppercase tracking-wider text-mute">
            <tr>
              <th className="px-3 py-2.5 font-medium">Producto</th>
              <th className="px-3 py-2.5 font-medium">Categoría</th>
              <th className="px-3 py-2.5 text-right font-medium">Precio de lista</th>
              <th className="px-3 py-2.5 text-right font-medium">Stock</th>
              <th className="px-3 py-2.5 font-medium">Estado</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-line">
            {/* eslint-disable-next-line @typescript-eslint/no-explicit-any */}
            {(products as any[] | null)?.map((p) => {
              const vs = p.variants.filter((v: { active: boolean }) => v.active);
              const prices = vs.map((v: { price_list: number }) => v.price_list);
              const stock = vs.reduce((s: number, v: { stock: number }) => s + Math.max(v.stock, 0), 0);
              const img = [...p.images].sort((a, b) => a.sort_order - b.sort_order)[0]?.url;
              return (
                <tr key={p.id} className="hover:bg-surface">
                  <td className="px-3 py-2">
                    <Link href={`/admin/productos/${p.id}`} className="flex items-center gap-3">
                      <span className="h-11 w-11 shrink-0 overflow-hidden border border-line bg-surface">
                        {/* eslint-disable-next-line @next/next/no-img-element */}
                        {img && <img src={img} alt="" className="h-full w-full object-cover" loading="lazy" />}
                      </span>
                      <span>
                        <span className="font-medium underline-offset-4 hover:underline">{p.name}</span>
                        <span className="block text-xs text-mute">
                          {p.brand?.name ?? "Sin marca"} · {vs.length} {vs.length === 1 ? "variante" : "variantes"}
                          {p.featured ? " · destacado" : ""}
                        </span>
                      </span>
                    </Link>
                  </td>
                  <td className="px-3 py-2 text-xs">{p.category?.name}</td>
                  <td className="px-3 py-2 text-right tabular-nums">
                    {prices.length === 0 ? "—" : Math.min(...prices) === Math.max(...prices) ? money(prices[0]) : `${money(Math.min(...prices))} – ${money(Math.max(...prices))}`}
                  </td>
                  <td className={`px-3 py-2 text-right tabular-nums ${stock === 0 ? "text-rose" : ""}`}>{stock === 0 ? "Sin stock" : stock}</td>
                  <td className="px-3 py-2"><span className="badge">{STATUS[p.status as keyof typeof STATUS]}</span></td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
