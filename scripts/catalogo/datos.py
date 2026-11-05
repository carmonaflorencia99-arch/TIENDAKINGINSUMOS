"""
Catálogo completo de King Insumos, transcripto del PDF "LISTA INSUMOS" (nov 2026).

Cada producto: p(página, subcategoría, marca, nombre, opciones, variantes, fotos, ...)
  - variantes: {valor: precio} para una opción, {(v1, v2): precio} para dos,
    {"": precio} para producto simple.
  - precios: de LISTA (sin descuento). El precio en efectivo/transferencia
    lo calcula la tienda con el 10%.
  - fotos: xref de la imagen dentro del PDF (las exporta generar.py).
  - sin_stock=True cuando el catálogo lo marca "sin stock".
  - revisar="..." cuando el precio o el dato no se lee con claridad.
"""
P = []


def p(page, cat, brand, name, options, variants, imgs=(), desc=None, specs=None,
      sin_stock=False, revisar=None, featured=False, best=False, kind=None):
    P.append(dict(page=page, cat=cat, brand=brand, name=name, options=list(options),
                  variants=variants, imgs=list(imgs), desc=desc, specs=specs,
                  sin_stock=sin_stock, revisar=revisar, featured=featured, best=best, kind=kind))


def grid(a, b, prices_b):
    """Dos opciones donde el precio depende solo de la segunda (ej. línea × presentación)."""
    return {(x, y): prices_b[y] for x in a for y in b}


NO_DEV = "Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra."

# --------------------------------------------------------------- PÁG 1-2 · ADHESIVOS
p(1, "adhesivos", "neicha", "Adhesivo Black Glue Neicha", ["Nivel", "Presentación"],
  grid(["Inicial (2-3 seg)", "Intermedio (1-2 seg)", "Avanzado (0,5 seg)"], ["2 g", "3 g", "5 g"],
       {"2 g": 21500, "3 g": 26300, "5 g": 32800}),
  [54, 55, 56], desc="Tres velocidades según tu nivel: inicial seca en 2-3 segundos, intermedio en 1-2 y avanzado en 0,5. Color negro, fórmula líquida, temperatura ideal 18-24 °C y humedad 40-70 %. " + NO_DEV,
  specs=dict(drying_min_s=0.5, drying_max_s=3, level="intermedio", humidity_min=40, humidity_max=70, temp_min=18, temp_max=24))
p(1, "adhesivos", "the-lion-beauty", "Adhesivo Lion Beauty", ["Línea", "Presentación"],
  grid(["Magno", "Sublime", "Extreme", "Odín"], ["3 g", "5 g"], {"3 g": 26833, "5 g": 33666}),
  [58, 60, 63], featured=True,
  desc="Magno: secado intermedio de 2-3 segundos, para profesionales iniciales e intermedias, retención 5-6 semanas. Sublime: seca en 1 segundo, para clásicas y volumen, retención 7-8 semanas. Extreme: seca en 0,5 segundos, para volumen y mega volumen, retención 7-8 semanas. Odín: el más rápido de la gama, 0,3 a 0,5 segundos, para profesionales súper avanzadas, retención 8-9 semanas. " + NO_DEV,
  specs=dict(drying_min_s=0.3, drying_max_s=3, level="avanzado", retention_weeks="5-9"))
p(1, "adhesivos", "zaphiria", "Adhesivo Lumi Zaphiria 5 g", ["Tipo"],
  {"Lumiglow (0,5 seg)": 18300, "Lumibloom (0,5-1 seg)": 18300, "Purple Glue (0,5 seg)": 18300, "Flex Glue (0,3 seg)": 20500},
  desc=NO_DEV, specs=dict(drying_min_s=0.3, drying_max_s=1, level="avanzado"))
p(1, "adhesivos", "golle", "Adhesivo Golle 5 g", ["Tipo"],
  {"Genius Fix (0,5-1 seg)": 29000, "Thin and Fast (1-2 seg)": 29000}, [71, 72], best=True,
  desc=NO_DEV, specs=dict(drying_min_s=0.5, drying_max_s=2, level="avanzado"))
p(2, "adhesivos", None, "Adhesivo Elite HS-16 5 g", [], {"": 32400}, [96, 97],
  desc="Uso exclusivamente profesional para extensiones clásicas, efecto máscara y volumen ruso. Origen Corea del Sur. Secado 0,5 a 1 segundo, durabilidad 7 a 8 semanas, viscosidad líquida, temperatura de uso 19 a 24 °C, vapores bajos a medios. Incluye paquete Magic Preserve de regalo. " + NO_DEV,
  specs=dict(drying_min_s=0.5, drying_max_s=1, level="avanzado", temp_min=19, temp_max=24, retention_weeks="6-8",
             viscosity="Líquida", fumes="Bajos a medios", open_shelf_life="1 a 3 meses una vez abierto"))
p(2, "adhesivos", "abruxlashes", "Adhesivo Abruxlashes 5 g", ["Tipo"],
  {"Rápida (0,3 seg)": 37700, "Furia (0,5 seg)": 37700, "Eclipse (0,8 seg)": 37000}, [107, 108, 109], featured=True,
  desc=NO_DEV, specs=dict(drying_min_s=0.3, drying_max_s=0.8, level="avanzado"))
p(2, "adhesivos", "clione", "Adhesivo Clione Prime", ["Línea", "Presentación"],
  grid(["Love (0,3-1 seg)", "Luna (1-2 seg)", "Sol (1-2 seg)"], ["3 g", "5 g"], {"3 g": 25200, "5 g": 28888}),
  [100, 102, 103], best=True, desc="Love seca en 0,3 a 1 segundo; Luna y Sol en 1 a 2 segundos. Retención de 8 a 9 semanas. " + NO_DEV,
  specs=dict(drying_min_s=0.3, drying_max_s=2, level="intermedio", humidity_min=40, humidity_max=90, temp_min=17, temp_max=29, retention_weeks="8-9"))
p(2, "adhesivos", "cherimoya", "Adhesivo Eyelash Glue Cherimoya 5 g", ["Tipo"],
  {"1 seg (intermedio)": 31300, "0,5 seg (avanzado)": 31300}, [111, 112],
  desc="1 seg: para clásicas. 0,5 seg: para volumen, volumen ruso y mega volumen. Temperatura 18-24 °C, humedad 45-60 %. " + NO_DEV,
  specs=dict(drying_min_s=0.5, drying_max_s=1, level="intermedio", humidity_min=45, humidity_max=60, temp_min=18, temp_max=24))

# --------------------------------------------------------------- PÁG 3 · MEDIDORES DE HUMEDAD
p(3, "medidores-humedad", None, "Medidor de humedad y temperatura con reloj", [], {"": 16390}, [140])
p(3, "medidores-humedad", None, "Medidor de humedad digital compacto", [], {"": 4523})
p(3, "medidores-humedad", None, "Mini medidor de humedad", [], {"": 6000}, [3276])
p(3, "medidores-humedad", None, "Medidor de humedad con reloj y alarma", [], {"": 8200}, [3279])
p(3, "medidores-humedad", None, "Medidor de humedad rosa", [], {"": 8700}, [126], best=True)

# --------------------------------------------------------------- PÁG 3-4 · REMOVEDORES
p(3, "removedores", "iconsign", "Removedor lápiz Iconsign blanco", [], {"": 4645}, [139])
p(3, "removedores", "navina", "Removedor en crema Navina x 5 g (nueva fórmula)", [], {"": 5500})
p(3, "removedores", "nagaraku", "Removedor en crema Nagaraku x 5 g", [], {"": 5745}, [123])
p(3, "removedores", "navina", "Removedor en crema Navina Clásico x 5 g", [], {"": 5012}, [129])
p(3, "removedores", "cherimoya", "Removedor en crema Cherimoya x 5 g", [], {"": 6723}, [130, 131])
p(3, "removedores", None, "Removedor lápiz en gel Debby Rose", [], {"": 3912}, [136])
p(3, "removedores", None, "Removedor lápiz en gel 10 g", [], {"": 3912})
p(3, "removedores", "iconsign", "Removedor lápiz en gel Iconsign 5 g", [], {"": 4525}, [3297])
p(3, "removedores", "navina", "Removedor lápiz en gel Navina 10 g", [], {"": 6234}, [3286])
p(3, "removedores", "the-lion-beauty", "Removedor en crema Lion Beauty 15 g", [], {"": 23900}, [124], featured=True,
  desc="Fragancia a frutilla, ideal para ojos sensibles y de fácil aplicación.")
p(3, "removedores", None, "Removedor en crema 15 g", ["Tipo"], {"Clásico": 19678, "Light": 19678}, [133])
p(3, "removedores", "nagaraku", "Removedor lápiz Nagaraku", [], {"": 3056}, [122])
p(4, "removedores", "zaphiria", "Removedor en gel Zaphiria Lumi 15 g", [], {"": 14912}, [162])
p(4, "removedores", None, "Removedor en gel City Girl 15 g", [], {"": 8250}, [161])
p(4, "removedores", "zaphiria", "Removedor en gel Zaphiria 15 g", [], {"": 19678}, [163])
p(4, "removedores", "the-lion-beauty", "Removedor en gel Lion Beauty 20 ml", [], {"": 20890},
  desc="Libre de acetona, de aroma refrescante. Remueve rápidamente las extensiones de pestañas.")
p(4, "removedores", "zaphiria", "Removedor en gel Express Zaphiria 10 g", [], {"": 11000}, [165])
p(4, "removedores", "iconsign", "Removedor en gel Iconsign 1 g", [], {"": 5600}, [166])
p(4, "removedores", "stars-colors", "Removedor en crema Stars Colors 5 g", [], {"": 5378}, [167])
p(4, "removedores", "stars-colors", "Removedor en lápiz Stars Colors 5 ml", [], {"": 3900}, [168])
p(4, "removedores", "stars-colors", "Removedor en gel Stars Colors 15 ml", [], {"": 8678}, [169])

# --------------------------------------------------------------- PÁG 5-6 · COMPLEMENTOS PARA ADHESIVOS
C = "complementos-adhesivos"
p(5, C, None, "Repuesto wipes limpia pegamento x 200", [], {"": 2570}, [194])
p(5, C, None, "Wipes limpia pegamento x 200", ["Color"], {"Blanco": 3178, "Rosa": 3178}, [3396])
p(5, C, None, "Mezclador de adhesivo", [], {"": 22000}, [184])
p(5, C, None, "Limpia pegamento paquete x 300", [], {"": 5625}, [186])
p(5, C, None, "Anillo con ranuras para adhesivo", ["Presentación"], {"x 100": 3910, "x 10": 820}, [3408, 3411])
p(5, C, None, "Base flor rosa x 10 (solo base)", [], {"": 540}, [3393])
p(5, C, None, "Líquido limpia pinzas", [], {"": 2445}, [3399])
p(5, C, None, "Anillo portapegamento", ["Presentación"], {"x 100 rosa": 2445, "x 100 blanco": 2445, "x 10": 320}, [3405], best=True)
p(5, C, None, "Base flor para adhesivo x 10", [], {"": 810})
p(5, C, None, "Tapón para pegamento x unidad", [], {"": 540}, [3414])
p(6, C, None, "Piedra jade", ["Color"], {"Verde": 675, "Negra": 675}, [3462])
p(6, C, None, "Porta pegamento PVC x 10", ["Forma"], {"Redondo": 1230, "Cuadrado": 1230}, [3459])
p(6, C, None, "Destapador de adhesivo", [], {"": 2670}, [220])
p(6, C, None, "Portapegamento rosa con medidor de humedad", [], {"": 11980}, [214])
p(6, C, None, "Cristal portapegamento rosa", [], {"": 3800}, [3466])
p(6, C, None, "Portapegamento negro", [], {"": 5000}, [3469])
p(6, C, None, "Tanque portapegamento de plástico Press", [], {"": 9170}, [216])
p(6, C, None, "Tanque portapegamento de plástico rosa", [], {"": 8440}, [3472])
p(6, C, None, "Portapegamento rosa hermético", [], {"": 7500}, [219])

# --------------------------------------------------------------- PÁG 7 · LIMPIEZA
L = "shampoo-y-limpieza"
p(7, L, "the-lion-beauty", "Shampoo para pestañas Lion Beauty", ["Presentación"], {"40 ml": 7200, "150 ml": 16600}, [240], best=True)
p(7, L, "navina", "Shampoo Navina 80 ml", [], {"": 3555}, [3513])
p(7, L, "zaphiria", "Shampoo Ice Cream Zaphiria", [], {"": 10300}, [249], sin_stock=True)
p(7, L, "iconsign", "Shampoo Iconsign", [], {"": 9400}, [245])
p(7, L, None, "Shampoo Lash", ["Presentación"], {"60 ml": 4000, "100 ml": 4330}, [235], sin_stock=True,
  revisar="Precio de lista de 100 ml estimado desde la oferta ($3.900)")
p(7, L, None, "Agua micelar Thelma y Louise", ["Presentación"], {"160 ml": 4900, "70 ml": 3000}, [244])
p(7, L, None, "Espumero 150 ml", [], {"": 2310})
p(7, L, None, "Espumero rojo 100 ml", [], {"": 4280})
p(7, L, None, "Espumero rosa", ["Presentación"], {"30 ml": 1800, "120 ml": 3300}, [243])
p(7, L, None, "Espumero 100 ml", ["Presentación"], {"100 ml": 1900, "50 ml": 1400}, [241])
p(7, L, None, "Espumero 30 ml", [], {"": 1470}, [242])
p(7, L, None, "Espumero dorado o rosa con frasco transparente 50 ml", ["Color"], {"Dorado": 3300, "Rosa": 3300})
p(7, L, None, "Agua micelar Mely común", [], {"": 6200}, [246])
p(7, L, None, "Agua micelar bifásica Thelma y Louise", [], {"": 7335}, [247])
p(7, L, "zaphiria", "Shampoo concentrado Zaphiria Lumi para 60 ml", [], {"": 2100}, [248])

# --------------------------------------------------------------- PÁG 8 · PRIMERS, SELLADORES Y BONDERS
S = "primers-selladores"
p(8, S, "nagaraku", "Sellador Nagaraku", [], {"": 10510}, [276])
p(8, S, "navina", "Sellador para extensiones transparente Navina", [], {"": 8435}, [272])
p(8, S, "iconsign", "Sellador Iconsign", [], {"": 10390}, [282])
p(8, S, None, "Lash Primer 10 ml", [], {"": 11735}, [274])
p(8, S, "navina", "Primer para pestañas Navina", [], {"": 4770}, [271])
p(8, S, None, "Primer Dlux", [], {"": 16010}, [281])
p(8, S, "zaphiria", "Primer Zaphiria 20 ml", [], {"": 16700}, [273], sin_stock=True)
p(8, S, "iconsign", "Lash Bonder Iconsign", [], {"": 13700}, [275], sin_stock=True)
p(8, S, "stars-colors", "Lash Primer Stars Colors", [], {"": 11620}, [283])
p(8, S, "zaphiria", "Primer Melon Zaphiria 15 ml", [], {"": 9780}, [278])
p(8, S, "zaphiria", "Natural Primer Zaphiria", [], {"": 22245}, [279], sin_stock=True)
p(8, S, "zaphiria", "Primer Lumi Zaphiria 15 ml", [], {"": 10000}, ["propia:zaphiria-lumi-primer-bonder.jpeg", 280],
  revisar="El catálogo dice $1000 (oferta $9000); se tomó $10.000")


def lista(oferta):
    """El catálogo solo muestra el precio de oferta: lista = oferta / 0,9 redondeado a $10."""
    import math
    return int(math.ceil(oferta / 0.9 / 10) * 10)


SOLO_OFERTA = "El catálogo solo muestra el precio de oferta; la lista se calculó (+10 %)"

# --------------------------------------------------------------- PÁG 9 · BONDERS Y BOOSTERS
p(9, S, "golle", "Super Booster Golle", [], {"": 12710})
p(9, S, None, "Ultrabalance 15 ml", [], {"": 9535}, [313], desc="Mantiene el balance de humedad para mejorar la retención.")
p(9, S, "golle", "Super Bonder Golle 15 ml", [], {"": 24080}, [312])
p(9, S, "zaphiria", "Bonder Zaphiria 20 ml", [], {"": 28845}, [318], desc="Maximiza la retención.")
p(9, S, "zaphiria", "Bonder Zaphiria Lumi 15 ml", [], {"": 20700}, ["propia:zaphiria-lumi-primer-bonder.jpeg", 316],
  desc="Maximiza la retención de las extensiones.")
p(9, S, None, "Booster Dlux", [], {"": 22245}, [319])
p(9, S, "iconsign", "Cleanser Iconsign", [], {"": 5320}, [315])
p(9, S, "clione", "Bonder Clione 20 ml", [], {"": 25900}, [320])
p(9, S, "abruxlashes", "Magic Bonder Abruxlashes", [], {"": 18900}, [311])
p(9, S, "abruxlashes", "Super Booster Abruxlashes", [], {"": 16700}, [321])

# --------------------------------------------------------------- PÁG 10 · BROCHAS, CEPILLOS Y MICROHISOPOS
B = "brochas-cepillos"
p(10, B, None, "Hisopo aplicador cristal x 50", [], {"": 2060}, [3733])
p(10, B, None, "Pack cepillos para pestañas x 50", [], {"": 2090}, [3728], best=True)
p(10, B, None, "Pack cepillos de silicona para laminado", [], {"": 3300}, [351])
p(10, B, None, "Hisopo regular 2,5 pack x 100", [], {"": lista(1870)}, [3722], revisar=SOLO_OFERTA)
p(10, B, None, "Microhisopos en bolsa x 100", [], {"": lista(1210)}, [3725], revisar=SOLO_OFERTA, best=True,
  desc="Color según stock.")
p(10, B, None, "Brocha limpia pestañas", ["Tipo"], {"Lisa": lista(990), "Glitter": lista(990)}, [3739], revisar=SOLO_OFERTA)
p(10, B, None, "Microhisopos en bolsa x 100 cristal glitter", [], {"": 2080}, [349])
p(10, B, None, "Hisopo aplicador x 50", [], {"": lista(1800)}, [3736], revisar=SOLO_OFERTA)
p(10, B, None, "Botella pico curvo grande", [], {"": lista(1670)}, [348], revisar=SOLO_OFERTA)

# --------------------------------------------------------------- PÁG 11 · VENTILADORES Y NANO MISTER
V = "ventiladores"
p(11, V, None, "Nano mister USB", ["Color"], {"Rosa": 6600, "Blanco": 6600}, [371], best=True)
p(11, V, None, "Nano mister huevito animal USB", [], {"": 5380}, [372])
p(11, V, None, "Ventilador USB animal", [], {"": 7770}, [376])
p(11, V, None, "Ventilador USB gatito", [], {"": 6130}, [3794])
p(11, V, None, "Ventilador con luz", [], {"": 8330}, [374])
p(11, V, None, "Ventilador USB con cargador tipo C", [], {"": 6110}, [369])
p(11, V, None, "Mini cooling ventilador y humidificador grande", [], {"": 23200}, [375])

# --------------------------------------------------------------- PÁG 12 · CINTAS, PORTACINTAS Y PARCHES
T = "cintas-parches"
p(12, T, None, "Cinta micropore color", [], {"": 860}, [406], best=True)
p(12, T, None, "Cinta micropore ECO", [], {"": 770}, [3840])
p(12, T, None, "Cinta micropore hipoalergénica 3M", [], {"": 1100}, [3856])
p(12, T, None, "Cinta gel blanca 2,5 cm x 5 m", [], {"": 2290}, [3849], sin_stock=True)
p(12, T, None, "Cinta plástica Transpore", ["Color"], {"Rosa": 860, "Verde": 860, "Transparente": 860}, [3843])
p(12, T, None, "Cinta micropore para tapping 4 mm", [], {"": 780}, [412])
p(12, T, None, "Cinta gel carrusel", [], {"": 2640}, [414])
p(12, T, None, "Portacinta acrílico ECO", [], {"": 1950}, [405])
p(12, T, None, "Portacinta corazón", [], {"": 2455}, [3846])
p(12, T, None, "Parches de lifting reutilizables de silicona con dibujitos", [], {"": 5000}, [413])
p(12, T, None, "Parches de lifting reutilizables de silicona", [], {"": lista(2200)}, [407, 392], revisar=SOLO_OFERTA)
p(12, T, None, "Parches de silicona City Girl x 2 pares", [], {"": 2300})
p(12, T, None, "Parches común de tela x 10", [], {"": 1890}, [3853])
p(12, T, None, "Parches de hidrogel x 10 pares", [], {"": 2500}, [3837], best=True)
p(12, T, None, "Cinta contenedora de cejas para laminado", [], {"": 2570}, [408])
p(12, T, None, "Cinta de silicona para lifting", [], {"": 3000}, [411])
p(12, T, None, "Cintas contenedoras de pestañas para lifting de papel x 1000", [], {"": 8440}, [409, 410])

# --------------------------------------------------------------- PÁG 13-14 · HERRAMIENTAS LIFTING, CEJAS Y GABINETE
H = "herramientas-lifting"
p(13, H, None, "Herramienta para lifting de acero inoxidable", ["Tipo"], {"Simple": 2970, "Con peine": 4510}, [441, 458])
p(13, H, None, "Perfilador blister x 3", [], {"": 1210}, [3952])
p(13, H, None, "Palito naranjo x 100", [], {"": 2690}, [449])
p(13, H, None, "Hisopo de madera x 100 (10 cm)", [], {"": 1050}, [3949])
p(13, H, None, "Cepillos para laminado rectos x 10", [], {"": 3180}, [450])
p(13, H, None, "Herramienta para lifting x 1", [], {"": 300}, [3943])
p(13, H, None, "Marcador para mapping doble punta", [], {"": 3300}, [3959])
p(13, H, None, "Lápiz fibra para cejas blanco con regla", [], {"": 1600}, [452])
p(13, H, None, "Lapicera gel para cejas", ["Color"], {"Blanca": 2200, "Rosa": 2200, "Verde": 2200}, [454])
p(13, H, "birou", "Lápiz para cejas con peine Birou", [], {"": 9045}, [3966])
p(13, H, None, "Lápiz dermográfico x unidad", ["Color"], {"Marrón": 1710, "Negro": 1710, "Blanco": 1710}, [3963])
p(13, H, None, "Calibre plástico", ["Tamaño"], {"15 cm": 2445, "8 cm": 1225}, [480])
p(13, H, None, "Film", [], {"": 1780}, [3956])
p(13, H, None, "Hilo marcador 10 m", ["Color"], {"Blanco": 3790, "Negro": 3790, "Rosa": 3790}, [442])
p(13, H, None, "Peine para lifting x 3", [], {"": 1470}, [446])
p(13, H, None, "Regla para pestañas", [], {"": 920}, [491])
p(13, H, None, "Mapping pre-inked hilo 30 m", [], {"": 6970}, [459])
p(13, H, None, "Cepillo doble madera con peine plástico", [], {"": 3300}, [4036])
p(13, H, None, "Pincel de precisión para cejas", ["Tamaño"], {"Grande": 1870, "Chico": 1100}, [487])
p(13, H, None, "Regla para pestañas portátil", [], {"": 575}, [494])
p(14, H, None, "Piel sintética para cejas", [], {"": 3180}, [474])
p(14, H, None, "Mezclador de tinta", [], {"": 4160}, [505])
p(14, "cuidado-facial-y-corporal", "zaphiria", "Mini derretidor de cera Zaphiria", [], {"": 16380}, [518])
p(14, "cuidado-facial-y-corporal", None, "Cera para depilar rostro Mely", ["Presentación"], {"100 g": 5400, "400 g": 8900}, [517], sin_stock=True)
p(14, "guantes-descartables", None, "Guantes 100% nitrilo caja x 100", ["Color"], {"Azul": 9780, "Rosa": 9780, "Negro": 9780},
  [502, 504, 501], best=True)
p(14, H, None, "Bandeja de acero inoxidable", [], {"": 4035}, [507])
p(14, H, None, "Bandeja esmaltada", [], {"": 3425}, [506])
p(14, "cuidado-facial-y-corporal", None, "Soporte de pigmentos para microblading y dermapen", [], {"": 3700}, [508])

# --------------------------------------------------------------- PÁG 15 · ESPEJOS Y ACCESORIOS DE EXTENSIONES
E = "espejos"
A = "accesorios-extensiones"
p(15, E, None, "Espejo de acero inoxidable", [], {"": 2200}, [536])
p(15, E, None, "Espejito corazón sin glitter", [], {"": 4400}, [537])
p(15, E, None, "Espejito corazón con glitter", [], {"": 6970}, [534])
p(15, E, None, "Espejito rectangular", ["Modelo"], {"Negro": 4520, "Plateado": 4520, "Rosa": 5010, "Dorado": 5010, "Con glitter": 6600}, [530])
p(15, E, None, "Espejo redondo 16 x 2 cm", [], {"": 1345}, [4129])
p(15, E, None, "Espejo de mano cuadrado 23,5 cm", [], {"": 5260}, [538])
p(15, E, None, "Espejo redondo conejo 23,11 cm", [], {"": 4645}, [539])
p(15, A, "cherimoya", "Muñequera porta pestañas", [], {"": 2080}, [4126, 532])
p(15, A, None, "Base de vidrio con base para adhesivo", [], {"": 3545}, [531])
p(15, A, None, "Base acrílica con imán", [], {"": 4400}, [533])
p(15, A, None, "Lente macro 0.45X para fotos con celular", [], {"": 20045}, [535])

# --------------------------------------------------------------- PÁG 16 · PRÁCTICA Y DESCARTABLES
p(16, "pestanas-de-practica", None, "Cabeza de práctica para pestañas", [], {"": 20290}, [4194])
p(16, C, None, "Anillo portapegamento con caja", [], {"": 1800})
p(16, "pestanas-de-practica", None, "Esponjas de práctica x 10", [], {"": 1300}, [571])
p(16, "pestanas-de-practica", None, "Esponjitas x 10", [], {"": 2000}, [562])
p(16, A, None, "Almohadilla porta pestañas rosa", [], {"": 1900})
p(16, "pestanas-de-practica", None, "Aislador de pestañas", [], {"": 2000}, [564])
p(16, "guantes-descartables", None, "Barbijo descartable x 10", ["Color"], {"Rosa": 1200, "Negro": 1200}, [4207])
p(16, "guantes-descartables", None, "Barbijo plástico transparente", [], {"": 700}, [567])
p(16, "guantes-descartables", None, "Compresas", ["Presentación"], {"x 100": 7200, "x 50": 4200}, [568])
p(16, "guantes-descartables", None, "Cofias descartables x 10", [], {"": 1300}, [569])

# --------------------------------------------------------------- PÁG 17 · BIGUDÍES
G = "bigudies"
p(17, G, "zaphiria", "Bigudíes Zaphiria Fish curva U anatómicos", [], {"": 8800}, [592])
p(17, G, "zaphiria", "Bigudíes Zaphiria con ranuras efecto húmedo curva U", [], {"": 8800}, [593])
p(17, G, "zaphiria", "Bigudíes Zaphiria Flat planos para técnica coreana", [], {"": 6500}, [595])
p(17, G, "zaphiria", "Bigudíes Zaphiria inferiores", [], {"": 6500}, [596])
p(17, G, None, "Bigudíes Frozen estuche rosado curva L", [], {"": 10000}, [606, 605])
p(17, G, "zaphiria", "Bigudíes Zaphiria Shell curva C anatómicos", [], {"": 8800}, [594], best=True)
p(17, G, "zaphiria", "Bigudíes Zaphiria Moño curva M anatómicos", [], {"": 8800}, [591])
p(17, G, None, "Bigudíes inferiores con ranuras (chiquitos)", [], {"": 6600}, [598])
p(17, G, None, "Bigudíes en bolsa anatómicos naranja o amarillo flúor", ["Color"], {"Naranja": 10000, "Amarillo flúor": 10000}, [599])
p(17, G, None, "Googles para técnica coreana", [], {"": 14400}, [600])
p(17, G, "iconsign", "Pads de silicona Iconsign", [], {"": 8300}, [601])
p(17, G, None, "Bigudí para técnica inversa forma de corazón", [], {"": 9200}, [602])
p(17, G, None, "Bigudí para técnica inversa forma de huella", [], {"": 9200}, [603])
p(17, G, None, "Bigudí para técnica inversa forma de mariposa", [], {"": 9200}, [604])
p(17, G, None, "Bigudíes Kitty curva U", [], {"": 9000}, [607])
p(17, G, None, "Bigudíes planos para técnica coreana delfín", [], {"": 12200}, [608])
p(17, G, None, "Bigudíes Frozen blanco glitter", [], {"": 19450}, [609])

# --------------------------------------------------------------- PÁG 18 · TINTES, HENNA Y REVELADORES
TI = "tintes-henna"
p(18, TI, "the-lion-beauty", "Kit tinte y revelador Lion", [], {"": 24800}, [640], featured=True)
p(18, TI, "the-lion-beauty", "Tinte gel Lion", [], {"": 20900}, [641])
p(18, TI, "the-lion-beauty", "Revelador Lion", [], {"": 5280})
p(18, TI, "iconsign", "Tinte Iconsign Plant Extract", ["Color"], {"Negro": 7560, "Marrón": 7560, "Café": 7560}, [639])
p(18, TI, "iconsign", "Henna Iconsign", [], {"": 9000}, [652])
p(18, TI, "refectocil", "Tintes Refectocil", ["Color"], {"Varios colores (consultar)": 25670}, [651])
p(18, TI, "refectocil", "Refectocil Blonde Brow 15 ml", [], {"": 24640}, [649],
  desc="Aclara las cejas hasta tres niveles de tonalidad, con un estilo naturalmente rubio (pre-tinte).")
p(18, TI, "charito-ferrari", "Tinte Charito Ferrari", ["Color"], {"Negro": 15340, "Marrón": 15340}, [647, 646])
p(18, TI, "golle", "Kit Lash and Brow Tinte Gollee", [], {"": 12780}, [638])
p(18, TI, "charito-ferrari", "Crema protectora para no manchar con tinte Charito Ferrari", [], {"": 6230}, [648])
p(18, TI, "charito-ferrari", "Revelador de tinte Charito Ferrari", [], {"": 6780}, [653])
p(18, TI, "iconsign", "Tinte Iconsign en caja", ["Presentación"], {"Caja chica": 5000, "Caja grande": 7230}, [645])
p(18, TI, "makiaj", "Henna Makiaj en polvo", ["Color"],
  {c: 7700 for c in ["Negro", "Marrón", "Castaño claro", "Castaño medio", "Castaño oscuro", "Rubio", "Colorado"]}, [644])
p(18, TI, "rootana", "Henna para cejas Rootana", ["Color"], {"Brown": 4570, "Coffee": 4570, "Black": 4570}, [4342])
p(18, TI, "sahubba", "Henna para cejas Sahubba", ["Color"], {"Brown": 5513, "Coffee": 5513, "Black": 5513}, [4346])
p(18, TI, "refectocil", "Refectocil Styling Gel 15 ml", [], {"": 54420}, [650],
  desc="Fija los pelos rebeldes, protege el color tras el tinte y aporta brillo e hidratación gracias al D-Pantenol y la vitamina E.")

# --------------------------------------------------------------- PÁG 19-20 · KITS DE LIFTING, MONODOSIS Y NUTRICIÓN
K = "kits-lifting"
N = "nutricion-botox"
p(19, K, "the-lion-beauty", "Kit de lifting Lion Beauty 10 pares", [], {"": 46700}, [691], featured=True)
p(19, N, "iconsign", "Lash lifting Iconsign paso 1 y 2 monodosis 1 g", [], {"": 2700}, [675], desc="Precio por par.")
p(19, N, "iconsign", "Lash Lift Iconsign 1 y 2 x 10 ml", [], {"": 9900}, [676])
p(19, K, "golle", "Kit de lifting Gollee", ["Tipo"], {"Kit de lifting": 30120, "Kit con tinte y laminado": 31400}, [677])
p(19, K, "iconsign", "Kit de lifting Iconsign Original", [], {"": 20780}, [672])
p(19, N, "iconsign", "Camellia Lift Kit paso 1 y 2 10 g", [], {"": 11560}, [687])
p(19, K, "iconsign", "Kit para lifting Iconsign con monodosis", [], {"": 24230}, [673])
p(19, K, "iconsign", "Kit de lifting Iconsign Original (caja rosa)", [], {"": 23120}, [690])
p(19, K, "iconsign", "Kit laminado de cejas Brow Lift Iconsign", [], {"": 24308}, [674])
p(19, K, "iconsign", "Kit laminado de cejas", [], {"": 18000}, [688])
p(19, N, None, "Easy Kit Fall In The Volume lifting y laminado de cejas sobre 1 y 2", [], {"": 3120}, [689])
p(19, N, "the-lion-beauty", "Lash lifting Lion Beauty paso 1 y 2 1 ml", ["Presentación"], {"1 par": 3100, "10 pares": 26400}, [678, 679])
p(19, N, "the-lion-beauty", "Hidralash Lion Beauty paso 3 monodosis", [], {"": 1280}, [4404],
  desc="Hidrata y repara la pestaña después del lifting.")
p(19, N, "the-lion-beauty", "Botox Lion Beauty paso 4 monodosis", [], {"": 1280}, [681],
  desc="Tratamiento profundo que rellena, fortalece y engrosa la pestaña para un acabado más sano y denso.")
p(19, N, "the-lion-beauty", "Botox Lion Beauty paso 4 15 g", [], {"": 13420}, [682],
  desc="Tratamiento profundo que rellena, fortalece y engrosa la pestaña para un acabado más sano y denso.")
p(19, N, "the-lion-beauty", "Hidralash Lion Beauty paso 3 15 g", [], {"": 13420}, [683],
  desc="Hidrata y repara la pestaña después del lifting, devolviendo brillo y suavidad.")
p(19, N, "zaphiria", "Keratin Vitamin Zaphiria sérum final para lifting 15 g", [], {"": 21300}, [4409], sin_stock=True)
p(19, N, None, "Nutrición Lady's Eye monodosis", [], {"": 1100}, [685])
p(19, N, None, "Paso 1 y 2 lifting Lady's Eye", [], {"": 2120}, [692], desc="Precio por par.")
p(19, N, "lomansa", "Pasos de lifting Lomansa", ["Presentación"], {"Paso 1 y 2 (par)": 5700, "Paso 3": 2200}, [701])
p(20, K, "iconsign", "Kit de lifting Iconsign Premium", [], {"": 27000}, [706], featured=True)
p(20, K, "iconsign", "Kit 2 en 1 Iconsign laminado y lifting", [], {"": 20300}, [705])
p(20, K, "golle", "Kit laminado y lifting acción rápida Golle", [], {"": 28800}, [707])

# --------------------------------------------------------------- PÁG 21 · MELANIA, CHARITO FERRARI E ICONSIGN
p(21, N, "melania", "Paso 1 y 2 Melania 10 ml", [], {"": 56100}, [4447])
p(21, N, "melania", "Pro Lash Keratin Melania 15 g", [], {"": 19250}, ["propia:melania-keratin-botox.jpeg", 712])
p(21, N, "melania", "Pro Lash Botox Melania 15 g", [], {"": 20680}, [713, "propia:melania-keratin-botox.jpeg"])
p(21, N, "melania", "Pro Hidraluxe Melania", [], {"": 20730}, [714])
p(21, N, "melania", "Paso 1 y 2 Melania monodosis", [], {"": 4180}, [715], sin_stock=True)
p(21, N, "melania", "Keratina Melania monodosis", [], {"": 1980}, [4452])
p(21, N, "melania", "Botox Melania monodosis", [], {"": 1980}, [4456])
p(21, N, "melania", "Lash One crecimiento de cejas y pestañas Melania", [], {"": 20350}, [723])
p(21, N, "melania", "Pro Elixir Melania", [], {"": 20730}, [718])
p(21, N, "melania", "Easy Gel Melania", [], {"": 18150}, [719])
p(21, N, "charito-ferrari", "Paso 1 lifting Charito Ferrari 10 ml", [], {"": 18300}, [720])
p(21, N, "charito-ferrari", "Paso 2 lifting Charito Ferrari 10 ml", [], {"": 18300}, [721])
p(21, N, "charito-ferrari", "Botox Charito Ferrari", [], {"": 22700}, [725])
p(21, N, "iconsign", "Gel nutritivo Iconsign 5 g", [], {"": 7560}, [722])
p(21, N, "iconsign", "Oil nutritivo Iconsign 5 g", [], {"": 11350}, [724])

# --------------------------------------------------------------- PÁG 22 · ADHESIVO Y BÁLSAMO PARA BIGUDÍES
AB = "adhesivo-bigudies"
p(22, AB, "lomansa", "Bálsamo para lifting Lomansa 10 g", [], {"": 9800}, [753])
p(22, AB, "lomansa", "Pegamento para lifting Lomansa 5 ml", [], {"": 11550}, [754])
p(22, AB, "iconsign", "Adhesivo para bigudíes Iconsign", [], {"": 4300}, [752])
p(22, AB, None, "Adhesivo para bigudíes CG", [], {"": 4100}, [743], sin_stock=True)
p(22, AB, "melania", "Adhesivo para bigudíes Pro Glue Melania", [], {"": 19580}, [741])
p(22, AB, None, "Fixing Gel adhesivo para bigudíes de silicona 8 ml", [], {"": 16120}, [739])
p(22, AB, "the-lion-beauty", "Royal Stick adhesivo para bigudíes 5 ml", [], {"": 16500}, [740])
p(22, AB, "zaphiria", "Adhesivo para bigudíes Lumi Zaphiria", [], {"": 13120}, [742])
p(22, AB, "zaphiria", "Bálsamo Lumi Zaphiria 15 ml", [], {"": 12000}, [744])
p(22, AB, "cherimoya", "Bálsamo para lifting Cherimoya 5 g", [], {"": 8900}, [745])
p(22, AB, "iconsign", "Bálsamo para lifting Iconsign 8 g", [], {"": 12570}, [746])
p(22, AB, "iconsign", "Bálsamo para lifting Iconsign 8 g peach o avocado", ["Aroma"], {"Peach": 11666, "Avocado": 11666}, [747])
p(22, AB, "clione", "Polvo espesante Clione", [], {"": 32250}, [755])
p(22, AB, None, "Polvo espesador de paso 1 y 2 de lifting 5 g", [], {"": 10250}, [748])
p(22, AB, "the-lion-beauty", "Bálsamo para lifting Awa Stick Lion Beauty 15 g", [], {"": lista(19900)}, [749, "propia:glue-balm.png"],
  revisar="Solo figura $19.900; puede ser el precio final")
p(22, AB, "iconsign", "Bálsamo para lifting Iconsign super sticky 8 g", [], {"": 10400}, [750])
p(22, AB, "stars-colors", "Pegamento para lifting Stars Colors 5 ml", [], {"": 4500}, [756])
p(22, AB, "zaphiria", "Zaphiria Lashes Spike gel para espigas", [], {"": 8000}, [757, 758])


def matrix(curvas, grosores, largo, price):
    return {(c, g, largo): price for c in curvas for g in grosores}


MX = ["Curvatura", "Grosor", "Largo"]
PM = "pestanas-mix"
MU = "medida-unica"
VT = "volumen-tecnologico"

# --------------------------------------------------------------- PÁG 23-24 · PESTAÑAS NAGARAKU
p(23, PM, "nagaraku", "Pestañas Mix Nagaraku 0.03", MX, {("D", "0.03", "Mix"): 7500, ("C", "0.03", "Medida única"): 8100}, kind="lash_matrix")
p(23, PM, "nagaraku", "Pestañas Mix Nagaraku Premium curva D", MX,
  matrix(["D"], ["0.05", "0.07", "0.10", "0.12", "0.15", "0.20"], "Mix", 5600), kind="lash_matrix")
p(23, PM, "nagaraku", "Pestañas Nagaraku Mix 0.07 N", MX, matrix(["D"], ["0.07"], "Mix", 10300), [4494], kind="lash_matrix")
p(23, MU, "nagaraku", "Pestañas Nagaraku única medida curva D", MX,
  matrix(["D"], ["0.05", "0.07", "0.10", "0.12", "0.15", "0.20"], "Medida única", 4830), kind="lash_matrix", best=True)
p(23, PM, "nagaraku", "Pestañas Mix Nagaraku Marrón", MX, matrix(["C", "D"], ["0.07", "0.10", "0.15"], "Mix", 6860), [4506], kind="lash_matrix")
p(23, PM, "nagaraku", "Pestañas Under curva J mix 5, 6 y 7 mm", MX, matrix(["J"], ["Única"], "Mix 5-7 mm", 6200), kind="lash_matrix")
p(23, PM, "nagaraku", "Pestañas Mix Nagaraku curva L", MX, matrix(["L"], ["0.07", "0.10"], "Mix", 10900), [4509], kind="lash_matrix")
p(23, PM, "nagaraku", "Pestañas Mix 0.07 LD", MX, matrix(["LD"], ["0.07"], "Mix", 11100), [4530], kind="lash_matrix")
p(23, VT, "nagaraku", "Pestañas V-Shape Bottom 0.07 C", [], {"": 5000}, [4536])
p(23, VT, "nagaraku", "Pestañas Under Bottom Ellipse 0.20 J", [], {"": 7100}, [4542])
p(24, VT, "nagaraku", "Pestañas YY-Shape Nagaraku 0.07 D medida única 8 a 14 mm", [], {"": 9020}, [4559])
p(24, VT, "nagaraku", "Pestañas Mix YY-Shape Nagaraku", ["Curva y grosor"], {"0.05 D": 9020, "0.07 C": 9020, "0.07 D": 9020}, [4562])
p(24, VT, "nagaraku", "Pestañas W-Shape Nagaraku mix 0.07 D", ["Tipo"], {"3D": 10500, "4D": 14700, "5D": 16450, "6D": 21347}, [4585], best=True)
p(24, VT, "nagaraku", "Pestañas Triple Tips Y-Shape (YYY) Nagaraku", [], {"": 8000}, [809])
p(24, VT, "nagaraku", "Pestañas Nagaraku curvas L / LU", ["Tipo"], {"2D": 9900, "3D": 9900}, [4618, 4616, 4617])

# --------------------------------------------------------------- PÁG 25-26 · NAGARAKU Y ZAPHIRIA
PP = "pestanas-de-practica"
p(25, VT, "nagaraku", "Pestañas Single Tips 2D Y Nagaraku", [], {"": 6650}, [816])
p(25, VT, "nagaraku", "Pestañas Big Box Nagaraku 54 filas", ["Tipo"],
  {"3D W": 26680, "Clásicas 0.07 D mix": 17150, "YY": 20580, "4D W": 30230, "5D W": 33230}, [819, 817, 818, 820, 826])
p(25, VT, "nagaraku", "Pestañas Nagaraku Spire, Wings y Fairy", ["Tipo"], {"Spire": 6980, "Wings": 6980, "Fairy": 6980}, [815])
p(25, VT, "zaphiria", "Pestañas Zaphiria Wings", [], {"": 7035}, [4633, 4634])
p(25, VT, "zaphiria", "Pestañas Zaphiria Spire", [], {"": 7035}, [822])
p(25, VT, "zaphiria", "Pestañas Zaphiria Spire Fan", [], {"": 7035}, [823])
p(25, PM, "nagaraku", "Pestañas Mix Nagaraku curva N", MX, matrix(["N"], ["0.07", "0.10", "0.15"], "Mix", 9400), [4640], kind="lash_matrix")
p(26, PP, None, "Pestaña de práctica 8 y 10 mm", [], {"": 2600}, [4687])
p(26, VT, "nagaraku", "Pestañas Y-Shape Brown mix 0.07 D", [], {"": 10800}, [4690])
p(26, MU, "nagaraku", "Pestañas Nagaraku curva J medida única (consultar medida)", [], {"": 7000})
p(26, PP, None, "Pestaña de práctica x 10 pares", [], {"": 5400}, [4684])
lumi = {}
for tipo, precio in {"3D": 7000, "4D": 7850, "5D": 9100, "6D": 9900}.items():
    lumi[("D", tipo, "Mix 8-14 mm")] = precio
for tipo, precio in {"4D": 10100, "5D": 12100, "6D": 12600}.items():
    lumi[("N", tipo, "Mix 8-14 mm")] = precio
p(26, VT, "zaphiria", "Pestañas Zaphiria Lumi W mix 0.07", ["Curvatura", "Tipo", "Largo"], lumi,
  ["propia:zaphiria-lumi-negro.png", "propia:zaphiria-lumi.jpeg", 845], kind="lash_matrix", featured=True, best=True,
  desc="Fibras W prehechas para volumen tecnológico, grosor 0.07, en cajas mix de 8 a 14 mm. Elegí curva y tipo, y sumá todas las cajas que necesites.")

# --------------------------------------------------------------- PÁG 27 · ZAPHIRIA Y NAGARAKU U
p(27, VT, "zaphiria", "Pestañas Zaphiria W 0.07 D mix 8 a 14 mm", ["Curvatura", "Tipo", "Largo"],
  {("D", "3D", "Mix 8-14 mm"): 8390, ("D", "4D", "Mix 8-14 mm"): 10185, ("D", "5D", "Mix 8-14 mm"): 10500, ("D", "6D", "Mix 8-14 mm"): 13650},
  [850, 851, 852], kind="lash_matrix", best=True,
  desc="Fibras W prehechas, grosor 0.07, curva D, en cajas mix de 8 a 14 mm. Elegí el tipo y sumá todas las cajas que necesites.")
p(27, VT, "nagaraku", "Pestañas 2D UU Nagaraku", [], {"": 8500}, [853])
p(27, VT, "nagaraku", "Pestañas 2D UU Nagaraku 54 filas", [], {"": 27400}, [858])
p(27, VT, "zaphiria", "Pestañas 4D U Zaphiria", [], {"": 13000}, [4699, 4698], sin_stock=True)
p(27, VT, "nagaraku", "Pestañas U Nagaraku", ["Tipo"], {"3D U": 15620, "4D U": 17400, "5D U": 19459}, [855, 857, 856])

# --------------------------------------------------------------- PÁG 28 · ABRUXLASHES (sin stock)
p(28, VT, "abruxlashes", "Pestañas YY Mix D Abruxlashes", [], {"": 21100}, [866, 865], sin_stock=True)
p(28, VT, "abruxlashes", "Pestañas Rimel Tech YY UU Mix M Abruxlashes", [], {"": 21100}, [870, 868], sin_stock=True)
p(28, VT, "abruxlashes", "Pestañas Eye Liner Effect 4U B+C+L Abruxlashes", [], {"": 25000}, [872, 874], sin_stock=True)
p(28, VT, "abruxlashes", "Pestañas Foxy Effect 4U C+M Abruxlashes", [], {"": 25000}, [876, 878], sin_stock=True)
p(28, VT, "abruxlashes", "Pestañas Brown Chocolate Bar curva CC Abruxlashes", [], {"": 25000}, [882, 880], sin_stock=True)

# --------------------------------------------------------------- PÁG 29 · MASSCAKU
p(29, VT, "masscaku", "Pestañas Masscaku W prehechas", ["Tipo"],
  {"YY Double Tips": 8500, "3D-W": 9000, "4D-W": lista(9000), "4D-W M": lista(12600), "5D-W": 10500, "6D-WW": 13900, "2D UU (YY UU)": 10500},
  [892, 890, 894, 896, 898, 900], revisar="4D y 4D M: el catálogo solo muestra la oferta; la lista se calculó (+10 %)")

# --------------------------------------------------------------- PÁG 30 · MOBILIARIO
M = "mobiliario"
p(30, M, None, "Carrito ayudante de 4 pisos metálico", [], {"": 49245}, [909], sin_stock=True)
p(30, M, None, "Carrito ayudante de 3 pisos plástico", [], {"": 23100}, [907])
p(30, M, None, "Carrito ayudante de 3 pisos metálico", [], {"": 43700}, [906])
p(30, M, None, "Organizador acrílico chico", [], {"": 9700}, [4757], sin_stock=True)
p(30, M, None, "Organizador acrílico con cajones", [], {"": 20874}, [922], sin_stock=True)
p(30, M, None, "Organizador acrílico grande con cajones", [], {"": 30650}, [904])
p(30, M, None, "Organizador blanco con cajones", [], {"": 28000}, [905])
p(30, M, None, "Organizador acrílico con cajones negros", [], {"": 23200}, [908])
p(30, M, None, "Apoya cabezas", ["Color"], {"Consultar colores": 19900}, [915])
p(30, M, None, "Cubrecamilla importada", ["Modelo"],
  {"Lycra rosa": 20800, "Lycra negra": 20800, "Negra 180 x 60": 17900, "Negra 190 x 80": 22900}, [912, 913])
p(30, M, None, "Colchoneta para camilla", ["Color"], {"Consultar colores": 45000}, [914])
p(30, M, None, "Cubrecamillas descartables", ["Presentación"], {"Unidad": 1000, "x 10": 9500}, [917])
p(30, M, None, "Manta de polar 180 x 180", ["Color"], {"Rosa": 27000, "Negro": 27000}, [916])

# --------------------------------------------------------------- PÁG 31-33 · PINZAS
PZ = "pinzas"
p(31, PZ, None, "Porta pinzas", ["Color"], {"Rosa": 7170, "Blanco": 7170}, [4801])
p(31, PZ, None, "Porta pinzas de lata", [], {"": 3300}, [5957])
p(31, PZ, None, "Porta pinzas de cuerina", [], {"": 2400}, [4808])
p(31, PZ, None, "Tijeras", [], {"": 2310}, [4831, 4830])
p(31, PZ, "cherimoya", "Pinza de cejas Cherimoya", ["Punta"], {"Oblicua": 2058, "Recta": 2058, "Diagonal": 2058}, [948])
p(31, PZ, None, "Pulsera anticaída para pinzas", [], {"": 7400}, [949])
p(32, PZ, "abruxlashes", "Pinza Abruxlashes", ["Modelo"],
  {"N-01": 14500, "N-02": 13400, "N-03": 14500, "N-04": 12300, "N-05": 12300, "N-06": 13400},
  [955, 959, 956, 960, 957, 958], featured=True, best=True)
p(32, E, "abruxlashes", "Espejo Master Abruxlashes", [], {"": 13400}, [967])
p(33, PZ, None, "Pinza Lash Money Tweezer", ["Modelo"],
  {"10K": 15500, "20K": 13400, "30K": 15600, "40K": 13400, "50K": 12300, "60K": 12300},
  [975, 976, 974, 984, 977, 978])
