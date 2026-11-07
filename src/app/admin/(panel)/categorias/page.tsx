import { requireAdmin } from "@/lib/admin";
import { getCategories, getCategoryCovers } from "@/lib/catalog";
import type { Category } from "@/lib/types";
import { CoverUploader } from "./cover-uploader";
import { removeCover } from "./actions";

export const metadata = { title: "Categorías" };
export const dynamic = "force-dynamic";

type Props = { searchParams: Promise<{ ok?: string; error?: string }> };

function Row({ c, cover, main }: { c: Category; cover?: string; main?: boolean }) {
  return (
    <li className={`flex items-center gap-3 border-t border-line py-3 ${main ? "" : "pl-4 sm:pl-8"}`}>
      <div className={`${main ? "h-20 w-28" : "h-14 w-20"} shrink-0 overflow-hidden bg-surface`}>
        {/* eslint-disable-next-line @next/next/no-img-element */}
        {cover && <img src={cover} alt="" className="h-full w-full object-cover" />}
      </div>
      <div className="min-w-0 flex-1">
        <p className={main ? "font-medium" : "text-sm"}>{c.name}</p>
        <p className="text-xs text-mute">{c.image_url ? "Portada propia" : cover ? "Automática (foto de un producto)" : "Sin foto"}</p>
      </div>
      <div className="flex flex-col items-end gap-1 sm:flex-row sm:items-center sm:gap-2">
        <CoverUploader categoryId={c.id} hasOwn={!!c.image_url} />
        {c.image_url && (
          <form action={removeCover}>
            <input type="hidden" name="id" value={c.id} />
            <button className="text-[11px] text-mute underline">Quitar</button>
          </form>
        )}
      </div>
    </li>
  );
}

export default async function CategoriesPage({ searchParams }: Props) {
  await requireAdmin();
  const { ok, error } = await searchParams;
  const categories = await getCategories();
  const covers = await getCategoryCovers(categories);
  const mains = categories.filter((c) => !c.parent_id);

  return (
    <div className="max-w-3xl space-y-4">
      <div>
        <h1 className="text-[22px]">Categorías</h1>
        <p className="mt-1 text-sm text-mute">
          La portada se ve en el inicio y arriba de cada categoría. Si no subís una, se usa la foto de un producto destacado.
          Conviene una foto horizontal.
        </p>
      </div>
      {ok && <p role="status" className="border border-ok/30 bg-ok/10 p-3 text-sm text-ok">{ok}</p>}
      {error && <p role="alert" className="border border-rose/30 bg-rose/10 p-3 text-sm text-rose">{error}</p>}
      <div className="border border-line bg-white px-4">
        <ul>
          {mains.map((m) => (
            <li key={m.id}>
              <ul>
                <Row c={m} cover={covers[m.id]} main />
                {categories
                  .filter((s) => s.parent_id === m.id)
                  .map((s) => (
                    <Row key={s.id} c={s} cover={covers[s.id]} />
                  ))}
              </ul>
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}
