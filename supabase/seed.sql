-- =====================================================================
-- King Insumos — datos iniciales
-- Categorías, marcas, reglas de pago y algunos productos REALES del
-- catálogo (precios de lista del PDF) para probar la tienda.
-- El catálogo completo se carga después con la planilla de importación.
-- =====================================================================

-- ---------- Categorías principales ----------
insert into categories (name, slug, sort_order) values
  ('Extensiones de Pestañas',     'extensiones-de-pestanas', 1),
  ('Adhesivos y Líquidos',        'adhesivos-y-liquidos',    2),
  ('Lifting y Laminado',          'lifting-y-laminado',      3),
  ('Herramientas y Accesorios',   'herramientas-y-accesorios', 4),
  ('Descartables y Gabinete',     'descartables-y-gabinete', 5),
  ('Cuidado Facial y Corporal',   'cuidado-facial-y-corporal', 6);

-- ---------- Subcategorías ----------
insert into categories (parent_id, name, slug, sort_order)
select p.id, s.name, s.slug, s.ord
from (values
  ('extensiones-de-pestanas', 'Volumen tecnológico (W, YY, espigas)', 'volumen-tecnologico', 1),
  ('extensiones-de-pestanas', 'Pestañas mix',                         'pestanas-mix', 2),
  ('extensiones-de-pestanas', 'Medida única',                         'medida-unica', 3),
  ('extensiones-de-pestanas', 'Pestañas de práctica',                 'pestanas-de-practica', 4),
  ('adhesivos-y-liquidos',    'Adhesivos',                            'adhesivos', 1),
  ('adhesivos-y-liquidos',    'Removedores',                          'removedores', 2),
  ('adhesivos-y-liquidos',    'Primers, selladores y bonders',        'primers-selladores', 3),
  ('adhesivos-y-liquidos',    'Shampoo y limpieza',                   'shampoo-y-limpieza', 4),
  ('adhesivos-y-liquidos',    'Complementos para adhesivos',          'complementos-adhesivos', 5),
  ('lifting-y-laminado',      'Kits de lifting y laminado',           'kits-lifting', 1),
  ('lifting-y-laminado',      'Nutrición, botox y monodosis',         'nutricion-botox', 2),
  ('lifting-y-laminado',      'Bigudíes',                             'bigudies', 3),
  ('lifting-y-laminado',      'Adhesivo para bigudíes',               'adhesivo-bigudies', 4),
  ('lifting-y-laminado',      'Tintes, henna y reveladores',          'tintes-henna', 5),
  ('herramientas-y-accesorios','Pinzas',                              'pinzas', 1),
  ('herramientas-y-accesorios','Brochas, cepillos y microhisopos',    'brochas-cepillos', 2),
  ('herramientas-y-accesorios','Ventiladores y nano mister',          'ventiladores', 3),
  ('herramientas-y-accesorios','Medidores de humedad',                'medidores-humedad', 4),
  ('herramientas-y-accesorios','Herramientas lifting y cejas',        'herramientas-lifting', 5),
  ('herramientas-y-accesorios','Mobiliario y carritos',               'mobiliario', 6),
  ('descartables-y-gabinete', 'Cintas, portacintas y parches',        'cintas-parches', 1),
  ('descartables-y-gabinete', 'Guantes y descartables',               'guantes-descartables', 2)
) as s(parent, name, slug, ord)
join categories p on p.slug = s.parent;

-- ---------- Marcas ----------
insert into brands (name, slug, featured, sort_order) values
  ('The Lion Beauty', 'the-lion-beauty', true, 1),
  ('Nagaraku',        'nagaraku',        false, 2),
  ('Zaphiria',        'zaphiria',        false, 3),
  ('Iconsign',        'iconsign',        false, 4),
  ('Abruxlashes',     'abruxlashes',     false, 5),
  ('Cherimoya',       'cherimoya',       false, 6),
  ('Navina',          'navina',          false, 7),
  ('Melania',         'melania',         false, 8),
  ('Golle',           'golle',           false, 9),
  ('Clione',          'clione',          false, 10),
  ('Lomansa',         'lomansa',         false, 11),
  ('Stars Colors',    'stars-colors',    false, 12);

-- ---------- Reglas de pago (políticas actuales de King) ----------
insert into payment_rules (method, label, discount_pct, excluded_category_ids, allowed_delivery, allows_deposit, active)
values
  ('cash', 'Efectivo en el local', 10, '{}', '{pickup}', true, true),
  ('transfer', 'Transferencia bancaria', 10,
     array[(select id from categories where slug = 'extensiones-de-pestanas')],
     '{pickup,moto}', true, true),
  -- precio online a definir: por ahora sin descuento y desactivado hasta tener credenciales
  ('mercadopago', 'Mercado Pago (tarjetas, cuotas, dinero en cuenta)', 0, '{}', '{pickup}', false, false);

-- Productos: ejecutar después supabase/seed-productos.sql (catálogo completo).
