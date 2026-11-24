"""
Pasa las pestañas a tres ejes: Curvatura · Grosor · Largo (Quick-Add Matrix).

Uso:  python3 scripts/pestanas/generar_ejes.py
Salida: supabase/cambios/9-pestanas-curva-grosor-largo.sql

- Las opciones se actualizan en el lugar (por SKU): se conservan stock, precio e id.
- Los productos que tenían un eje "Tipo" (3D, 4D, 5D…) se separan en un producto
  por tipo, porque el tipo no es curva, grosor ni largo. El producto original queda
  archivado (oculto) para no romper pedidos viejos.
- Solo se tocan productos cuyos datos se conocen; los que faltan se listan en PENDIENTES.
"""
import csv
import re
import unicodedata
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
cat = list(csv.DictReader(open(ROOT / "scripts/catalogo/catalogo.csv", encoding="utf-8-sig")))
AXES = "'{\"Curvatura\",\"Grosor\",\"Largo\"}'"


def slugify(s):
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode().lower()
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-")[:70]


def q(s):
    return "'" + str(s).replace("'", "''") + "'"


def sku(producto, variante):
    rows = [r for r in cat if r["producto"] == producto and r["variante"] == variante]
    assert len(rows) == 1, (producto, variante, len(rows))
    return rows[0]["sku"]


out = []

# ---------------------------------------------------------------- 1) mismos productos, opciones corregidas
EN_LUGAR = {
    # producto: {variante del catálogo: (curva, grosor, largo)}
    "Pestañas Nagaraku Mix 0.07 N": {"D · 0.07 · Mix": ("N", "0.07", "Mix")},           # la curva es N (estaba como D)
    "Pestañas Under curva J mix 5, 6 y 7 mm": {"J · Única · Mix 5-7 mm": ("J", "0.10", "Mix 5-7 mm")},  # Excel: 'Under mix 0,10 J'
    "Pestañas Mix YY-Shape Nagaraku": {"0.05 D": ("D", "0.05", "Mix"), "0.07 C": ("C", "0.07", "Mix"), "0.07 D": ("D", "0.07", "Mix")},
    "Pestañas Y-Shape Brown mix 0.07 D": {"": ("D", "0.07", "Mix")},
}
out.append("-- 1) Opciones corregidas en el mismo producto")
for prod, vs in EN_LUGAR.items():
    out.append(f"update products set kind = 'lash_matrix', option_names = {AXES} where slug = {q(slugify(prod))};")
    for var, (c, g, l) in vs.items():
        out.append(f"update variants set option1 = {q(c)}, option2 = {q(g)}, option3 = {q(l)} where sku = {q(sku(prod, var))};")
    out.append("")

# ---------------------------------------------------------------- 2) un producto por tipo
SEPARAR = [
    # (producto original, nombre nuevo con {t}, {tipo: [(variante catálogo, curva, grosor, largo)]})
    ("Pestañas W-Shape Nagaraku mix 0.07 D", "Pestañas W-Shape {t} Nagaraku mix 0.07 D",
     {t: [(t, "D", "0.07", "Mix")] for t in ["3D", "4D", "5D", "6D"]}),
    ("Pestañas Zaphiria W 0.07 D mix 8 a 14 mm", "Pestañas Zaphiria W {t} 0.07 D mix 8 a 14 mm",
     {t: [(f"D · {t} · Mix 8-14 mm", "D", "0.07", "Mix 8-14 mm")] for t in ["3D", "4D", "5D", "6D"]}),
    ("Pestañas Zaphiria Lumi W mix 0.07", "Pestañas Zaphiria Lumi W {t} mix 0.07",
     {t: [(f"{c} · {t} · Mix 8-14 mm", c, "0.07", "Mix 8-14 mm") for c in (["D"] if t == "3D" else ["D", "N"])]
      for t in ["3D", "4D", "5D", "6D"]}),
]
out.append("-- 2) Productos con eje 'Tipo': uno por tipo, con curva · grosor · largo")
out.append("do $$\ndeclare old_id bigint; new_id bigint;\nbegin")
for orig, nombre, tipos in SEPARAR:
    out.append(f"  select id into old_id from products where slug = {q(slugify(orig))};")
    out.append("  if old_id is not null then")
    for t, vs in tipos.items():
        name = nombre.format(t=t)
        slug = slugify(name)
        out.append(f"    -- {name}")
        out.append(f"    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)")
        out.append(f"      select {q(name)}, {q(slug)}, brand_id, category_id, description, 'lash_matrix', {AXES}, status, featured, best_seller")
        out.append(f"      from products where id = old_id on conflict (slug) do nothing;")
        out.append(f"    select id into new_id from products where slug = {q(slug)};")
        out.append(f"    if not exists (select 1 from product_images where product_id = new_id) then")
        out.append(f"      insert into product_images (product_id, url, alt, sort_order)")
        out.append(f"        select new_id, url, {q(name)}, sort_order from product_images where product_id = old_id;")
        out.append(f"    end if;")
        for n, (var, c, g, l) in enumerate(vs):
            out.append(f"    update variants set product_id = new_id, option1 = {q(c)}, option2 = {q(g)}, option3 = {q(l)}, sort_order = {n}"
                       f" where sku = {q(sku(orig, var))};")
    out.append("    update products set status = 'archived' where id = old_id;  -- queda oculto, sin opciones")
    out.append("  end if;")
out.append("end $$;")

sql = f"""-- =====================================================================
-- King Insumos — Pestañas separadas por Curvatura · Grosor · Largo
-- Ejecutar una vez en Supabase → SQL Editor, DESPUÉS de 8-stock-excel.sql.
-- Se puede volver a ejecutar sin problema.
-- Se conservan el stock y el precio de cada opción (se actualiza por SKU).
-- Generado con scripts/pestanas/generar_ejes.py
-- =====================================================================
begin;

{chr(10).join(out)}

commit;

-- Comprobación: pestañas publicadas que todavía NO están en curva · grosor · largo
select p.name, p.kind, p.option_names
from products p join categories c on c.id = p.category_id
left join categories padre on padre.id = c.parent_id
where p.status = 'active'
  and coalesce(padre.slug, c.slug) = 'extensiones-de-pestanas'
  and c.slug <> 'pestanas-de-practica'
  and (p.kind <> 'lash_matrix' or p.option_names <> '{{"Curvatura","Grosor","Largo"}}')
order by p.name;
"""
dest = ROOT / "supabase/cambios/9-pestanas-curva-grosor-largo.sql"
dest.write_text(sql, encoding="utf-8")
print("ok", dest)
