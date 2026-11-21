import json, sys
from openpyxl import Workbook
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
d = json.load(open(sys.argv[1])); out = sys.argv[2]
F = "Arial"; H = Font(name=F, bold=True, color="FFFFFF"); B = Font(name=F); BB = Font(name=F, bold=True)
fill_h = PatternFill("solid", fgColor="000000"); yel = PatternFill("solid", fgColor="FFF4CC"); red = PatternFill("solid", fgColor="FBEBEB")
wb = Workbook()

def sheet(title, headers, rows, widths, note=None, hl=None):
    ws = wb.create_sheet(title)
    r0 = 1
    if note:
        ws.cell(1, 1, note).font = Font(name=F, italic=True, color="555555"); ws.merge_cells(start_row=1, start_column=1, end_row=1, end_column=len(headers)); r0 = 3
    for c, h in enumerate(headers, 1):
        x = ws.cell(r0, c, h); x.font = H; x.fill = fill_h; x.alignment = Alignment(vertical="center", wrap_text=True)
    for i, row in enumerate(rows, r0 + 1):
        for c, v in enumerate(row, 1):
            x = ws.cell(i, c, v); x.font = B; x.alignment = Alignment(vertical="top", wrap_text=True)
            if isinstance(v, int) and headers[c-1].lower().startswith("precio"): x.number_format = '"$"#,##0'
        if hl and hl(row):
            for c in range(1, len(headers) + 1): ws.cell(i, c).fill = hl(row)
    for c, w in enumerate(widths, 1): ws.column_dimensions[get_column_letter(c)].width = w
    ws.freeze_panes = ws.cell(r0 + 1, 1); ws.auto_filter.ref = f"A{r0}:{get_column_letter(len(headers))}{r0 + max(len(rows),1)}"
    return ws, r0

exc = lambda x: " + ".join(f"{e['nombre']} {e['unidad'] if 'CANTIDAD' not in str(e['unidad']) else ''}".strip() + f" (fila {e['fila']})" for e in x["excel"])
exst = lambda x: sum(e["stock"] for e in x["excel"])
expr = lambda x: (x["excel"][0]["precio"] if x["excel"] else None)

rev = [x for x in d["web"] if x["estado"] == "dudoso"]
ok = [x for x in d["web"] if x["estado"] == "ok"]
ne = [x for x in d["web"] if x["estado"] == "no_excel"]
nw = sorted(d["no_web"], key=lambda x: (-x["stock"], x["categoria"], x["nombre"]))

sheet("Para revisar", ["Producto en la web", "Opción", "Se emparejó con (Excel)", "Stock en el Excel", "Stock cargado en la web", "Por qué revisar", "¿Está bien? (sí / no + cuál es)"],
      [[x["producto"], x["opcion"] or "—", exc(x), exst(x), x["stock"], x["nota"], ""] for x in rev], [34, 22, 46, 12, 12, 40, 26],
      "Estos los emparejé por nombre o precio, o el Excel junta varias opciones en un renglón (se repartió en partes iguales). Confirmá en la última columna.")
sheet("Cargados", ["Producto en la web", "Opción", "Producto en el Excel", "Stock cargado", "Precio web (lista)", "Precio Excel (venta)", "Diferencia de precio"],
      [[x["producto"], x["opcion"] or "—", exc(x), x["stock"], x["precio_web"], expr(x), (expr(x) - x["precio_web"]) if expr(x) else None] for x in ok],
      [34, 22, 46, 10, 13, 13, 13], "Coinciden y se cargó el stock del Excel. A la derecha, la diferencia de precio entre la web y el sistema (solo informativo, no se cambió ningún precio).",
      hl=lambda r: yel if (r[6] not in (None, 0) and abs(r[6]) >= 500) else None)
sheet("Por largo", ["Producto en la web", "Opción nueva", "Stock cargado", "Renglón del Excel"],
      [[x["producto"], x["opcion"], x["stock"], x["excel"] + (f" (fila {x['fila']})" if x["fila"] else "")] for x in d["restr"]], [36, 22, 12, 46],
      "En el Excel estas pestañas tienen stock por largo (mm). En la web ahora tienen una opción por largo, así la clienta elige la medida.")
sheet("En la web, no en el Excel", ["Producto en la web", "Opción", "Categoría", "Stock que queda", "Nota"],
      [[x["producto"], x["opcion"] or "—", x["categoria"], 0, x["nota"]] for x in ne], [40, 22, 22, 12, 40],
      "No los encontré en el Excel: quedan en 0 (no se pueden comprar en la web). Si los tenés, cargá el stock desde el panel o decime y lo agrego.", hl=lambda r: red)
sheet("En el Excel, no en la web", ["Producto en el Excel", "Unidad", "Categoría (sistema)", "Stock", "Precio venta", "Fila"],
      [[x["nombre"], x["unidad"], x["categoria"], x["stock"], x["precio"], x["row"]] for x in nw], [50, 14, 24, 9, 13, 7],
      "Productos del sistema que no están publicados en la web. Arriba los que tienen stock: son candidatos para agregar a la tienda.",
      hl=lambda r: yel if r[3] > 0 else None)

ws = wb["Sheet"]; ws.title = "Resumen"
rows = [("Cargados (coinciden)", "Cargados", "D", 4), ("Para revisar", "Para revisar", "E", 4), ("Pestañas por largo", "Por largo", "C", 4),
        ("En la web, no en el Excel (quedan en 0)", "En la web, no en el Excel", "D", 4), ("En el Excel, no en la web", "En el Excel, no en la web", "D", 4)]
ws["A1"] = "Stock de la web desde el Excel del sistema (productos20.xlsx)"; ws["A1"].font = Font(name=F, bold=True, size=14)
ws["A2"] = "Generado el 21/11/2026. Los números se calculan con fórmulas sobre las otras pestañas."; ws["A2"].font = Font(name=F, italic=True, color="555555")
for c, h in enumerate(["Grupo", "Renglones", "Unidades"], 1):
    x = ws.cell(4, c, h); x.font = H; x.fill = fill_h
for i, (lab, sh, col, r0) in enumerate(rows, 5):
    ws.cell(i, 1, lab).font = B
    ws.cell(i, 2, f"=COUNTA('{sh}'!A{r0}:A2000)").font = B
    ws.cell(i, 3, f"=SUM('{sh}'!{col}{r0}:{col}2000)").font = B
i += 1
ws.cell(i, 1, "Unidades que quedan a la venta en la web").font = BB
ws.cell(i, 3, "=C5+C6+C7").font = BB
ws.column_dimensions["A"].width = 44; ws.column_dimensions["B"].width = 12; ws.column_dimensions["C"].width = 12
wb.save(out)
