import Link from "next/link";
import { Flash } from "@/app/admin/(panel)/flash";
import { adminDb } from "@/lib/admin";
import { ProductList, type ListProduct } from "./product-list";

export const metadata = { title: "Productos" };

type Props = { searchParams: Promise<{ q?: string; cat?: string; estado?: string; ok?: string; editado?: string }> };


export default async function ProductsPage({ searchParams }: Props) {
  const { q = "", cat = "", estado = "", ok, editado } = await searchParams;
  const db = await adminDb();
  const { data: categories } = await db.from("categories").select("id, name, parent_id, sort_order").order("sort_order");
  const mains = (categories ?? []).filter((c) => !c.parent_id);

  let query = db
    .from("products")
    .select("id, name, slug, status, featured, best_seller, brand:brands(name), category:categories(name), option_names, variants(id, option1, option2, option3, price_list, stock, active, sort_order), images:product_images(url, sort_order)")
    .order("id")
    .limit(400);
  if (q.trim()) query = query.ilike("name", `%${q.trim().replace(/[%,()]/g, " ")}%`);
  if (cat) {
    const ids = [Number(cat), ...(categories ?? []).filter((c) => c.parent_id === Number(cat)).map((c) => c.id)];
    query = query.in("category_id", ids);
  }
  if (estado) query = query.eq("status", estado);
  const { data: products } = await query;
  const from = new URLSearchParams(Object.entries({ q, cat, estado }).filter(([, v]) => v)).toString();
  /* eslint-disable @typescript-eslint/no-explicit-any */
  const list: ListProduct[] = ((products as any[]) ?? []).map((p) => ({
    id: p.id,
    name: p.name,
    status: p.status,
    brand: p.brand?.name ?? null,
    category: p.category?.name ?? null,
    image: [...p.images].sort((a, b) => a.sort_order - b.sort_order)[0]?.url ?? null,
    variants: [...p.variants]
      .sort((a, b) => a.sort_order - b.sort_order || a.id - b.id)
      .map((v) => ({
        id: v.id,
        label: [v.option1, v.option2, v.option3].filter(Boolean).join(" · ") || "Única",
        price_list: v.price_list,
        stock: v.stock,
        active: v.active,
      })),
  }));
  /* eslint-enable @typescript-eslint/no-explicit-any */

  return (
    <div className="space-y-5">
      <div className="flex flex-wrap items-end justify-between gap-3">
        <h1 className="text-[22px]">Productos <span className="text-mute">({products?.length ?? 0})</span></h1>
        <Link href="/admin/productos/nuevo" className="btn px-4 py-2.5">+ Nuevo producto</Link>
      </div>
      <Flash ok={ok} />

      <form className="flex flex-wrap gap-2">
        <input name="q" defaultValue={q} placeholder="Buscar por nombre" className="field w-full py-2 text-sm sm:w-56" />
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
          <option value="draft">Ocultos</option>
          <option value="archived">Archivados</option>
        </select>
        <button className="btn-ghost px-4 py-2">Filtrar</button>
      </form>

      <p className="text-xs text-mute">
        Cambiá el precio o el stock acá mismo: se guarda solo. Tocá el estado (Publicado / Oculto) para mostrarlo u ocultarlo en la tienda.
      </p>
      <ProductList products={list} from={from} highlightId={editado ? Number(editado) : undefined} />
    </div>
  );
}
