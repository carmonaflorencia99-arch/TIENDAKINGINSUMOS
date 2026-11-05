"""
Genera el catálogo completo de la tienda a partir de datos.py y el PDF de King.

  python3 scripts/catalogo/generar.py <ruta al PDF LISTA INSUMOS>

Salidas:
  public/products/*.jpg           fotos cuadradas uniformes (800 px; fotos propias 1000 px)
  supabase/seed-productos.sql     marcas, subcategorías nuevas, productos, variantes, fotos y fichas
  scripts/catalogo/catalogo.csv   planilla para revisar precios y stock con King

Requiere: pip install pymupdf pillow
"""
import csv
import math
import re
import sys
import unicodedata
from pathlib import Path

import pymupdf
from PIL import Image, ImageFilter, ImageOps

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
sys.path.insert(0, str(HERE))
import datos  # noqa: E402

PDF = pymupdf.open(sys.argv[1])
OUT_IMG = ROOT / "public" / "products"
OUT_SQL = ROOT / "supabase" / "seed-productos.sql"
OUT_CSV = HERE / "catalogo.csv"
PROPIAS = ROOT / "scripts" / "fotos-propias"

BRANDS = {
    "the-lion-beauty": "The Lion Beauty", "nagaraku": "Nagaraku", "zaphiria": "Zaphiria", "iconsign": "Iconsign",
    "abruxlashes": "Abruxlashes", "cherimoya": "Cherimoya", "navina": "Navina", "melania": "Melania", "golle": "Golle",
    "clione": "Clione", "lomansa": "Lomansa", "stars-colors": "Stars Colors", "neicha": "Neicha", "birou": "Birou",
    "charito-ferrari": "Charito Ferrari", "makiaj": "Makiaj", "masscaku": "Masscaku", "refectocil": "Refectocil",
    "rootana": "Rootana", "sahubba": "Sahubba",
}
NEW_SUBCATS = [  # (padre, nombre, slug, orden)
    ("herramientas-y-accesorios", "Espejos", "espejos", 7),
    ("herramientas-y-accesorios", "Accesorios para extensiones", "accesorios-extensiones", 8),
]
STOCK_EJEMPLO = 10


def slugify(s):
    s = unicodedata.normalize("NFKD", s).encode("ascii", "ignore").decode().lower()
    return re.sub(r"[^a-z0-9]+", "-", s).strip("-")[:70]


def q(v):
    return "null" if v is None else "'" + str(v).replace("'", "''") + "'"


def pixmap_image(xref):
    pix = pymupdf.Pixmap(PDF, xref)
    smask = PDF.xref_get_key(xref, "SMask")
    if smask[0] == "xref":
        pix = pymupdf.Pixmap(pix, pymupdf.Pixmap(PDF, int(smask[1].split()[0])))
    if pix.n - pix.alpha >= 4:
        pix = pymupdf.Pixmap(pymupdf.csRGB, pix)
    mode = "RGBA" if pix.alpha else "RGB"
    return Image.frombytes(mode, (pix.width, pix.height), pix.samples)


def pad_square(im, size):
    """Foto del catálogo: se centra en un cuadrado con el color de sus bordes."""
    im = im.convert("RGBA")
    bg = Image.new("RGBA", im.size, (255, 255, 255, 255)); bg.alpha_composite(im); im = bg.convert("RGB")
    w, h = im.size
    px = im.load()
    edge = [px[x, 0] for x in range(w)] + [px[x, h - 1] for x in range(w)] + \
           [px[0, y] for y in range(h)] + [px[w - 1, y] for y in range(h)]
    fill = tuple(sum(c[i] for c in edge) // len(edge) for i in range(3))
    side = max(w, h)
    canvas = Image.new("RGB", (side, side), fill)
    canvas.paste(im, ((side - w) // 2, (side - h) // 2))
    out = canvas.resize((size, size), Image.LANCZOS)
    return out.filter(ImageFilter.UnsharpMask(radius=1.6, percent=70, threshold=2))


def cover_square(path, size):
    """Foto propia: recorte cuadrado centrado."""
    im = ImageOps.exif_transpose(Image.open(path)).convert("RGB")
    return ImageOps.fit(im, (size, size), Image.LANCZOS).filter(
        ImageFilter.UnsharpMask(radius=1.2, percent=50, threshold=2))


def cash_price(lista):
    return math.floor(lista * 0.9 / 10) * 10


# ---------------------------------------------------------------------------
OUT_IMG.mkdir(parents=True, exist_ok=True)
for old in OUT_IMG.glob("*.jpg"):
    old.unlink()

used_slugs = set()
used_skus = set()
sql = [
    "-- Generado por scripts/catalogo/generar.py a partir del catálogo de King (nov 2026).",
    "-- Precios de LISTA. Stock inicial de ejemplo: cargar el real desde el panel.", "",
    "-- Marcas",
]
for slug, name in BRANDS.items():
    sql.append(f"insert into brands (name, slug, featured) values ({q(name)}, {q(slug)}, {str(slug == 'the-lion-beauty').lower()}) "
               f"on conflict (slug) do nothing;")
sql += ["", "-- Subcategorías nuevas"]
for parent, name, slug, order in NEW_SUBCATS:
    sql.append(f"insert into categories (parent_id, name, slug, sort_order) select id, {q(name)}, {q(slug)}, {order} "
               f"from categories where slug = {q(parent)} on conflict (slug) do nothing;")
sql += ["", "delete from products;", "", "do $$", "declare pid bigint;", "begin"]

rows = []
for prod in datos.P:
    slug = slugify(prod["name"])
    base, n = slug, 2
    while slug in used_slugs:
        slug = f"{base}-{n}"; n += 1
    used_slugs.add(slug)

    # Fotos
    urls = []
    for i, ref in enumerate(prod["imgs"]):
        name = f"{slug}{'' if i == 0 else f'-{i + 1}'}.jpg"
        try:
            if isinstance(ref, str) and ref.startswith("propia:"):
                img = cover_square(PROPIAS / ref.split(":", 1)[1], 1000)
            else:
                img = pad_square(pixmap_image(int(ref)), 800)
        except Exception as e:  # noqa: BLE001
            print(f"  ! foto {ref} de {prod['name']}: {e}")
            continue
        img.save(OUT_IMG / name, quality=85, optimize=True)
        urls.append(f"/products/{name}")

    kind = prod["kind"] or ("variants" if prod["options"] else "simple")
    brand = f"(select id from brands where slug = {q(prod['brand'])})" if prod["brand"] else "null"
    opts = "'{" + ",".join('"' + o + '"' for o in prod["options"]) + "}'"
    sql.append(f"  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)")
    sql.append(f"  values ({q(prod['name'])}, {q(slug)}, {brand}, (select id from categories where slug = {q(prod['cat'])}), "
               f"'{kind}', {opts}, 'active', {str(prod['featured']).lower()}, {str(prod['best']).lower()}, {q(prod['desc'])})")
    sql.append("  returning id into pid;")

    stock = 0 if prod["sin_stock"] else STOCK_EJEMPLO
    for order, (key, price) in enumerate(prod["variants"].items()):
        values = list(key) if isinstance(key, tuple) else ([key] if key else [])
        o = values + [None] * (3 - len(values))
        sku = (slug + ("-" + "-".join(values) if values else "")).upper()
        sku = re.sub(r"[^A-Z0-9.-]+", "", sku)[:80]
        base_sku, k = sku, 2
        while sku in used_skus:
            sku = f"{base_sku}-{k}"; k += 1
        used_skus.add(sku)
        sql.append(f"  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) "
                   f"values (pid, {q(sku)}, {q(o[0])}, {q(o[1])}, {q(o[2])}, {int(price)}, {stock}, {order});")
        rows.append({
            "pagina": prod["page"], "categoria": prod["cat"], "marca": BRANDS.get(prod["brand"], ""),
            "producto": prod["name"], "variante": " · ".join(values), "sku": sku,
            "precio_lista": int(price), "precio_efectivo_10": cash_price(int(price)),
            "stock": stock, "sin_stock_en_catalogo": "sí" if prod["sin_stock"] else "",
            "revisar": prod["revisar"] or "", "fotos": len(urls),
        })
    for order, url in enumerate(urls):
        sql.append(f"  insert into product_images (product_id, url, alt, sort_order) values (pid, {q(url)}, {q(prod['name'])}, {order});")
    if prod["specs"]:
        cols = ", ".join(prod["specs"].keys())
        vals = ", ".join(q(v) if isinstance(v, str) else str(v) for v in prod["specs"].values())
        sql.append(f"  insert into adhesive_specs (product_id, {cols}) values (pid, {vals});")
    sql.append("")

sql += ["end $$;", ""]
OUT_SQL.write_text("\n".join(sql), encoding="utf-8")
with OUT_CSV.open("w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=rows[0].keys())
    w.writeheader(); w.writerows(rows)

print(f"{len(datos.P)} productos · {len(rows)} variantes · {len(list(OUT_IMG.glob('*.jpg')))} fotos")
