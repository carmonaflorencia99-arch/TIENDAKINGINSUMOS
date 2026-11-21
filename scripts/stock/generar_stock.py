"""
Genera el SQL para cargar el stock del Excel del sistema y los datos del reporte.

Uso:  python3 scripts/stock/generar_stock.py productos20.xlsx salida/
Salida: 8-stock-excel.sql y reporte.json (lo usa el script del Excel de control).
"""
import csv
import json
import re
import sys
from pathlib import Path

import openpyxl

sys.path.insert(0, str(Path(__file__).parent))
from mapeo_excel_nov2026 import M, NAGA_MU  # noqa: E402

ROOT = Path(__file__).resolve().parents[2]
xlsx, out = Path(sys.argv[1]), Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)

# ---- Excel del sistema
ws = openpyxl.load_workbook(xlsx, data_only=True).active
X = {}
for i, r in enumerate(ws.iter_rows(min_row=2, values_only=True), start=2):
    X[i] = dict(row=i, codigo=str(r[0] or ""), nombre=(r[1] or "").strip(), unidad=r[2] or "",
                stock=int(r[3] or 0), precio=int(r[6] or 0), categoria=r[7] or "")

# ---- Catálogo de la web
cat = list(csv.DictReader(open(ROOT / "scripts/catalogo/catalogo.csv", encoding="utf-8-sig")))
RESTR_IDX = {345, 346, 354, 355, 356, 357, 358, 359, 372, 413}

faltan = [i for i in range(len(cat)) if i not in M and i not in RESTR_IDX]
assert not faltan, f"Faltan en el mapeo: {faltan}"

used = {}  # fila Excel -> cuántas opciones web la usan (para repartir)
for i, (rows, _) in M.items():
    for r in rows:
        used[r] = used.get(r, 0) + 1

def q(s):
    return "'" + str(s).replace("'", "''") + "'"

lines, report = [], []
for i, x in enumerate(cat):
    if i in RESTR_IDX:
        continue
    rows, nota = M[i]
    if not rows:
        stock, estado = 0, "no_excel"
    else:
        stock = 0
        for r in rows:
            n = used[r]
            if n == 1:
                stock += X[r]["stock"]
            else:  # reparto en partes iguales; el resto va a la primera opción
                share = X[r]["stock"] // n
                first = min(k for k, (rr, _) in M.items() if r in rr)
                stock += share + (X[r]["stock"] - share * n if i == first else 0)
        estado = "dudoso" if ("dudoso" in nota or "reparto" in nota or "Borrado" in nota) else "ok"
    lines.append(f"update variants set stock = {stock} where sku = {q(x['sku'])};")
    report.append(dict(producto=x["producto"], opcion=x["variante"], categoria=x["categoria"], sku=x["sku"],
                       stock=stock, antes=int(x["stock"] or 0), precio_web=int(x["precio_lista"]),
                       excel=[dict(fila=r, nombre=X[r]["nombre"], unidad=X[r]["unidad"], stock=X[r]["stock"], precio=X[r]["precio"]) for r in rows],
                       nota=nota, estado=estado))

# ---- Reestructura por largo
restr_sql, restr_rep = [], []

def mm(nombre):
    m = re.search(r"(\d{1,2})\s*(?:mm)?\s*$", nombre.strip(), re.I)
    return int(m.group(1)) if m else None

def rebuild(slug, kind, option_names, variants, titulo):
    """variants: [(o1, o2, o3, fila_excel|None, precio)]"""
    used_rows = []
    body = [f"  select id into pid from products where slug = {q(slug)};",
            f"  if pid is not null then",
            f"    update products set kind = {q(kind)}, option_names = {q('{' + ','.join(chr(34) + o + chr(34) for o in option_names) + '}')} where id = pid;",
            f"    delete from variants where product_id = pid;"]
    for n, (o1, o2, o3, row, precio) in enumerate(variants):
        st = X[row]["stock"] if row else 0
        sku = (slug.upper() + "-" + "-".join(str(o) for o in (o1, o2, o3) if o)).replace(" ", "").replace(".", "")
        vals = ", ".join(q(v) if v is not None else "null" for v in (o1, o2, o3))
        body.append(f"    insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, {q(sku)}, {vals}, {precio}, {st}, {n});")
        restr_rep.append(dict(producto=titulo, opcion=" · ".join(str(o) for o in (o1, o2, o3) if o), stock=st,
                              excel=X[row]["nombre"] if row else "(no está en el Excel)", fila=row))
        if row:
            used_rows.append(row)
    body.append("  end if;")
    restr_sql.extend(body)
    return used_rows

restr_rows = []
# 1) Nagaraku medida única curva D: grosor × largo
v = []
for g, rows in NAGA_MU.items():
    items = sorted(((mm(X[r]["nombre"]), r) for r in rows), key=lambda t: t[0])
    v += [("D", g, f"{L} mm", r, 4830) for L, r in items]
v += sorted([("D", "0.20", f"{mm(X[r]['nombre'])} mm", r, 4830) for r in range(477, 485)], key=lambda t: int(t[2].split()[0]))
restr_rows += rebuild("pestanas-nagaraku-unica-medida-curva-d", "lash_matrix", ["Curvatura", "Grosor", "Largo"], v,
                      "Pestañas Nagaraku única medida curva D")
# 2) Nagaraku 0.03
v = [("D", "0.03", "Mix", 542, 7500), ("C", "0.03", "Mix", 541, 8100)]
v += sorted([("C", "0.03", f"{mm(X[r]['nombre'])} mm", r, 8100) for r in range(465, 473)], key=lambda t: int(t[2].split()[0]))
v += sorted([("D", "0.03", f"{mm(X[r]['nombre'])} mm", r, 7500) for r in range(473, 477)], key=lambda t: int(t[2].split()[0]))
restr_rows += rebuild("pestanas-mix-nagaraku-0-03", "lash_matrix", ["Curvatura", "Grosor", "Largo"], v, "Pestañas Mix Nagaraku 0.03")
# 3) YY-Shape Nagaraku 0.07 D por largo
v = sorted([("D", "0.07", f"{mm(X[r]['nombre'])} mm", r, 9020) for r in range(628, 636)], key=lambda t: int(t[2].split()[0]))
restr_rows += rebuild("pestanas-yy-shape-nagaraku-0-07-d-medida-unica-8-a-14-mm", "lash_matrix", ["Curvatura", "Grosor", "Largo"], v,
                      "Pestañas YY-Shape Nagaraku 0.07 D")
# 4) 2D UU Nagaraku por largo + mix
v = [(f"{mm(X[r]['nombre'])} mm", None, None, r, 8500) for r in [706, 619, 614, 615, 616, 617, 618]] + [("Mix", None, None, 620, 8500)]
restr_rows += rebuild("pestanas-2d-uu-nagaraku", "variants", ["Largo"], v, "Pestañas 2D UU Nagaraku")

# ---- Filas del Excel que no están en la web
mapped = set(used) | set(restr_rows)
no_web = [X[r] for r in X if r not in mapped and X[r]["categoria"] != "Borrado" and X[r]["nombre"] not in ("", "1")]

sql = f"""-- =====================================================================
-- King Insumos — Stock real desde el Excel del sistema (productos20.xlsx)
-- Ejecutar una vez en Supabase → SQL Editor.
--  1) Actualiza el stock de {len(lines)} opciones (las que no están en el Excel quedan en 0).
--  2) Rearma 4 productos de pestañas con una opción por largo (como en el Excel).
-- Los pedidos viejos no se tocan.
-- =====================================================================
begin;

{chr(10).join(lines)}

do $$
declare pid bigint;
begin
{chr(10).join(restr_sql)}
end $$;

commit;

-- Comprobación: unidades totales en la tienda (tiene que dar {sum(x['stock'] for x in report) + sum(x['stock'] for x in restr_rep)})
select sum(greatest(stock, 0)) as unidades_en_stock, count(*) filter (where stock > 0) as opciones_con_stock from variants;
"""
(out / "8-stock-excel.sql").write_text(sql, encoding="utf-8")
json.dump(dict(web=report, restr=restr_rep, no_web=no_web), open(out / "reporte.json", "w"), ensure_ascii=False, indent=1)

ok = sum(1 for x in report if x["estado"] == "ok")
dud = sum(1 for x in report if x["estado"] == "dudoso")
ne = sum(1 for x in report if x["estado"] == "no_excel")
print(f"opciones: {len(report)} | ok {ok} | revisar {dud} | no están en el Excel {ne} | por largo {len(restr_rep)}")
print(f"Excel sin web: {len(no_web)} (con stock: {sum(1 for x in no_web if x['stock'] > 0)}, unidades {sum(x['stock'] for x in no_web)})")
print("unidades web:", sum(x["stock"] for x in report) + sum(x["stock"] for x in restr_rep))
