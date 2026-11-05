-- Generado por scripts/catalogo/generar.py a partir del catálogo de King (nov 2026).
-- Precios de LISTA. Stock inicial de ejemplo: cargar el real desde el panel.

-- Marcas
insert into brands (name, slug, featured) values ('The Lion Beauty', 'the-lion-beauty', true) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Nagaraku', 'nagaraku', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Zaphiria', 'zaphiria', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Iconsign', 'iconsign', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Abruxlashes', 'abruxlashes', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Cherimoya', 'cherimoya', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Navina', 'navina', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Melania', 'melania', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Golle', 'golle', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Clione', 'clione', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Lomansa', 'lomansa', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Stars Colors', 'stars-colors', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Neicha', 'neicha', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Birou', 'birou', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Charito Ferrari', 'charito-ferrari', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Makiaj', 'makiaj', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Masscaku', 'masscaku', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Refectocil', 'refectocil', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Rootana', 'rootana', false) on conflict (slug) do nothing;
insert into brands (name, slug, featured) values ('Sahubba', 'sahubba', false) on conflict (slug) do nothing;

-- Subcategorías nuevas
insert into categories (parent_id, name, slug, sort_order) select id, 'Espejos', 'espejos', 7 from categories where slug = 'herramientas-y-accesorios' on conflict (slug) do nothing;
insert into categories (parent_id, name, slug, sort_order) select id, 'Accesorios para extensiones', 'accesorios-extensiones', 8 from categories where slug = 'herramientas-y-accesorios' on conflict (slug) do nothing;

delete from products;

do $$
declare pid bigint;
begin
  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Black Glue Neicha', 'adhesivo-black-glue-neicha', (select id from brands where slug = 'neicha'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Nivel","Presentación"}', 'active', false, false, 'Tres velocidades según tu nivel: inicial seca en 2-3 segundos, intermedio en 1-2 y avanzado en 0,5. Color negro, fórmula líquida, temperatura ideal 18-24 °C y humedad 40-70 %. Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-INICIAL2-3SEG-2G', 'Inicial (2-3 seg)', '2 g', null, 21500, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-INICIAL2-3SEG-3G', 'Inicial (2-3 seg)', '3 g', null, 26300, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-INICIAL2-3SEG-5G', 'Inicial (2-3 seg)', '5 g', null, 32800, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-INTERMEDIO1-2SEG-2G', 'Intermedio (1-2 seg)', '2 g', null, 21500, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-INTERMEDIO1-2SEG-3G', 'Intermedio (1-2 seg)', '3 g', null, 26300, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-INTERMEDIO1-2SEG-5G', 'Intermedio (1-2 seg)', '5 g', null, 32800, 10, 5);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-AVANZADO05SEG-2G', 'Avanzado (0,5 seg)', '2 g', null, 21500, 10, 6);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-AVANZADO05SEG-3G', 'Avanzado (0,5 seg)', '3 g', null, 26300, 10, 7);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-BLACK-GLUE-NEICHA-AVANZADO05SEG-5G', 'Avanzado (0,5 seg)', '5 g', null, 32800, 10, 8);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-black-glue-neicha.jpg', 'Adhesivo Black Glue Neicha', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-black-glue-neicha-2.jpg', 'Adhesivo Black Glue Neicha', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-black-glue-neicha-3.jpg', 'Adhesivo Black Glue Neicha', 2);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level, humidity_min, humidity_max, temp_min, temp_max) values (pid, 0.5, 3, 'intermedio', 40, 70, 18, 24);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Lion Beauty', 'adhesivo-lion-beauty', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Línea","Presentación"}', 'active', true, false, 'Magno: secado intermedio de 2-3 segundos, para profesionales iniciales e intermedias, retención 5-6 semanas. Sublime: seca en 1 segundo, para clásicas y volumen, retención 7-8 semanas. Extreme: seca en 0,5 segundos, para volumen y mega volumen, retención 7-8 semanas. Odín: el más rápido de la gama, 0,3 a 0,5 segundos, para profesionales súper avanzadas, retención 8-9 semanas. Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-MAGNO-3G', 'Magno', '3 g', null, 26833, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-MAGNO-5G', 'Magno', '5 g', null, 33666, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-SUBLIME-3G', 'Sublime', '3 g', null, 26833, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-SUBLIME-5G', 'Sublime', '5 g', null, 33666, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-EXTREME-3G', 'Extreme', '3 g', null, 26833, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-EXTREME-5G', 'Extreme', '5 g', null, 33666, 10, 5);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-ODN-3G', 'Odín', '3 g', null, 26833, 10, 6);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LION-BEAUTY-ODN-5G', 'Odín', '5 g', null, 33666, 10, 7);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-lion-beauty.jpg', 'Adhesivo Lion Beauty', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-lion-beauty-2.jpg', 'Adhesivo Lion Beauty', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-lion-beauty-3.jpg', 'Adhesivo Lion Beauty', 2);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level, retention_weeks) values (pid, 0.3, 3, 'avanzado', '5-9');

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Lumi Zaphiria 5 g', 'adhesivo-lumi-zaphiria-5-g', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Tipo"}', 'active', false, false, 'Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LUMI-ZAPHIRIA-5-G-LUMIGLOW05SEG', 'Lumiglow (0,5 seg)', null, null, 18300, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LUMI-ZAPHIRIA-5-G-LUMIBLOOM05-1SEG', 'Lumibloom (0,5-1 seg)', null, null, 18300, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LUMI-ZAPHIRIA-5-G-PURPLEGLUE05SEG', 'Purple Glue (0,5 seg)', null, null, 18300, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-LUMI-ZAPHIRIA-5-G-FLEXGLUE03SEG', 'Flex Glue (0,3 seg)', null, null, 20500, 10, 3);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level) values (pid, 0.3, 1, 'avanzado');

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Golle 5 g', 'adhesivo-golle-5-g', (select id from brands where slug = 'golle'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Tipo"}', 'active', false, true, 'Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-GOLLE-5-G-GENIUSFIX05-1SEG', 'Genius Fix (0,5-1 seg)', null, null, 29000, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-GOLLE-5-G-THINANDFAST1-2SEG', 'Thin and Fast (1-2 seg)', null, null, 29000, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-golle-5-g.jpg', 'Adhesivo Golle 5 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-golle-5-g-2.jpg', 'Adhesivo Golle 5 g', 1);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level) values (pid, 0.5, 2, 'avanzado');

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Elite HS-16 5 g', 'adhesivo-elite-hs-16-5-g', null, (select id from categories where slug = 'adhesivos'), 'simple', '{}', 'active', false, false, 'Uso exclusivamente profesional para extensiones clásicas, efecto máscara y volumen ruso. Origen Corea del Sur. Secado 0,5 a 1 segundo, durabilidad 7 a 8 semanas, viscosidad líquida, temperatura de uso 19 a 24 °C, vapores bajos a medios. Incluye paquete Magic Preserve de regalo. Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-ELITE-HS-16-5-G', null, null, null, 32400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-elite-hs-16-5-g.jpg', 'Adhesivo Elite HS-16 5 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-elite-hs-16-5-g-2.jpg', 'Adhesivo Elite HS-16 5 g', 1);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level, temp_min, temp_max, retention_weeks, viscosity, fumes, open_shelf_life) values (pid, 0.5, 1, 'avanzado', 19, 24, '6-8', 'Líquida', 'Bajos a medios', '1 a 3 meses una vez abierto');

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Abruxlashes 5 g', 'adhesivo-abruxlashes-5-g', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Tipo"}', 'active', true, false, 'Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-ABRUXLASHES-5-G-RPIDA03SEG', 'Rápida (0,3 seg)', null, null, 37700, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-ABRUXLASHES-5-G-FURIA05SEG', 'Furia (0,5 seg)', null, null, 37700, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-ABRUXLASHES-5-G-ECLIPSE08SEG', 'Eclipse (0,8 seg)', null, null, 37000, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-abruxlashes-5-g.jpg', 'Adhesivo Abruxlashes 5 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-abruxlashes-5-g-2.jpg', 'Adhesivo Abruxlashes 5 g', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-abruxlashes-5-g-3.jpg', 'Adhesivo Abruxlashes 5 g', 2);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level) values (pid, 0.3, 0.8, 'avanzado');

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Clione Prime', 'adhesivo-clione-prime', (select id from brands where slug = 'clione'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Línea","Presentación"}', 'active', false, true, 'Love seca en 0,3 a 1 segundo; Luna y Sol en 1 a 2 segundos. Retención de 8 a 9 semanas. Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-CLIONE-PRIME-LOVE03-1SEG-3G', 'Love (0,3-1 seg)', '3 g', null, 25200, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-CLIONE-PRIME-LOVE03-1SEG-5G', 'Love (0,3-1 seg)', '5 g', null, 28888, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-CLIONE-PRIME-LUNA1-2SEG-3G', 'Luna (1-2 seg)', '3 g', null, 25200, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-CLIONE-PRIME-LUNA1-2SEG-5G', 'Luna (1-2 seg)', '5 g', null, 28888, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-CLIONE-PRIME-SOL1-2SEG-3G', 'Sol (1-2 seg)', '3 g', null, 25200, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-CLIONE-PRIME-SOL1-2SEG-5G', 'Sol (1-2 seg)', '5 g', null, 28888, 10, 5);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-clione-prime.jpg', 'Adhesivo Clione Prime', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-clione-prime-2.jpg', 'Adhesivo Clione Prime', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-clione-prime-3.jpg', 'Adhesivo Clione Prime', 2);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level, humidity_min, humidity_max, temp_min, temp_max, retention_weeks) values (pid, 0.3, 2, 'intermedio', 40, 90, 17, 29, '8-9');

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo Eyelash Glue Cherimoya 5 g', 'adhesivo-eyelash-glue-cherimoya-5-g', (select id from brands where slug = 'cherimoya'), (select id from categories where slug = 'adhesivos'), 'variants', '{"Tipo"}', 'active', false, false, '1 seg: para clásicas. 0,5 seg: para volumen, volumen ruso y mega volumen. Temperatura 18-24 °C, humedad 45-60 %. Los adhesivos no tienen cambio ni devolución: controlalos al momento de la compra.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-EYELASH-GLUE-CHERIMOYA-5-G-1SEGINTERMEDIO', '1 seg (intermedio)', null, null, 31300, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-EYELASH-GLUE-CHERIMOYA-5-G-05SEGAVANZADO', '0,5 seg (avanzado)', null, null, 31300, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-eyelash-glue-cherimoya-5-g.jpg', 'Adhesivo Eyelash Glue Cherimoya 5 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-eyelash-glue-cherimoya-5-g-2.jpg', 'Adhesivo Eyelash Glue Cherimoya 5 g', 1);
  insert into adhesive_specs (product_id, drying_min_s, drying_max_s, level, humidity_min, humidity_max, temp_min, temp_max) values (pid, 0.5, 1, 'intermedio', 45, 60, 18, 24);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Medidor de humedad y temperatura con reloj', 'medidor-de-humedad-y-temperatura-con-reloj', null, (select id from categories where slug = 'medidores-humedad'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MEDIDOR-DE-HUMEDAD-Y-TEMPERATURA-CON-RELOJ', null, null, null, 16390, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/medidor-de-humedad-y-temperatura-con-reloj.jpg', 'Medidor de humedad y temperatura con reloj', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Medidor de humedad digital compacto', 'medidor-de-humedad-digital-compacto', null, (select id from categories where slug = 'medidores-humedad'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MEDIDOR-DE-HUMEDAD-DIGITAL-COMPACTO', null, null, null, 4523, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Mini medidor de humedad', 'mini-medidor-de-humedad', null, (select id from categories where slug = 'medidores-humedad'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MINI-MEDIDOR-DE-HUMEDAD', null, null, null, 6000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/mini-medidor-de-humedad.jpg', 'Mini medidor de humedad', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Medidor de humedad con reloj y alarma', 'medidor-de-humedad-con-reloj-y-alarma', null, (select id from categories where slug = 'medidores-humedad'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MEDIDOR-DE-HUMEDAD-CON-RELOJ-Y-ALARMA', null, null, null, 8200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/medidor-de-humedad-con-reloj-y-alarma.jpg', 'Medidor de humedad con reloj y alarma', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Medidor de humedad rosa', 'medidor-de-humedad-rosa', null, (select id from categories where slug = 'medidores-humedad'), 'simple', '{}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MEDIDOR-DE-HUMEDAD-ROSA', null, null, null, 8700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/medidor-de-humedad-rosa.jpg', 'Medidor de humedad rosa', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor lápiz Iconsign blanco', 'removedor-lapiz-iconsign-blanco', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-LAPIZ-ICONSIGN-BLANCO', null, null, null, 4645, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-lapiz-iconsign-blanco.jpg', 'Removedor lápiz Iconsign blanco', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema Navina x 5 g (nueva fórmula)', 'removedor-en-crema-navina-x-5-g-nueva-formula', (select id from brands where slug = 'navina'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-NAVINA-X-5-G-NUEVA-FORMULA', null, null, null, 5500, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema Nagaraku x 5 g', 'removedor-en-crema-nagaraku-x-5-g', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-NAGARAKU-X-5-G', null, null, null, 5745, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-nagaraku-x-5-g.jpg', 'Removedor en crema Nagaraku x 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema Navina Clásico x 5 g', 'removedor-en-crema-navina-clasico-x-5-g', (select id from brands where slug = 'navina'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-NAVINA-CLASICO-X-5-G', null, null, null, 5012, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-navina-clasico-x-5-g.jpg', 'Removedor en crema Navina Clásico x 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema Cherimoya x 5 g', 'removedor-en-crema-cherimoya-x-5-g', (select id from brands where slug = 'cherimoya'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-CHERIMOYA-X-5-G', null, null, null, 6723, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-cherimoya-x-5-g.jpg', 'Removedor en crema Cherimoya x 5 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-cherimoya-x-5-g-2.jpg', 'Removedor en crema Cherimoya x 5 g', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor lápiz en gel Debby Rose', 'removedor-lapiz-en-gel-debby-rose', null, (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-LAPIZ-EN-GEL-DEBBY-ROSE', null, null, null, 3912, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-lapiz-en-gel-debby-rose.jpg', 'Removedor lápiz en gel Debby Rose', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor lápiz en gel 10 g', 'removedor-lapiz-en-gel-10-g', null, (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-LAPIZ-EN-GEL-10-G', null, null, null, 3912, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor lápiz en gel Iconsign 5 g', 'removedor-lapiz-en-gel-iconsign-5-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-LAPIZ-EN-GEL-ICONSIGN-5-G', null, null, null, 4525, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-lapiz-en-gel-iconsign-5-g.jpg', 'Removedor lápiz en gel Iconsign 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor lápiz en gel Navina 10 g', 'removedor-lapiz-en-gel-navina-10-g', (select id from brands where slug = 'navina'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-LAPIZ-EN-GEL-NAVINA-10-G', null, null, null, 6234, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-lapiz-en-gel-navina-10-g.jpg', 'Removedor lápiz en gel Navina 10 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema Lion Beauty 15 g', 'removedor-en-crema-lion-beauty-15-g', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', true, false, 'Fragancia a frutilla, ideal para ojos sensibles y de fácil aplicación.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-LION-BEAUTY-15-G', null, null, null, 23900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-lion-beauty-15-g.jpg', 'Removedor en crema Lion Beauty 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema 15 g', 'removedor-en-crema-15-g', null, (select id from categories where slug = 'removedores'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-15-G-CLSICO', 'Clásico', null, null, 19678, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-15-G-LIGHT', 'Light', null, null, 19678, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-15-g.jpg', 'Removedor en crema 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor lápiz Nagaraku', 'removedor-lapiz-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-LAPIZ-NAGARAKU', null, null, null, 3056, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-lapiz-nagaraku.jpg', 'Removedor lápiz Nagaraku', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel Zaphiria Lumi 15 g', 'removedor-en-gel-zaphiria-lumi-15-g', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-ZAPHIRIA-LUMI-15-G', null, null, null, 14912, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-gel-zaphiria-lumi-15-g.jpg', 'Removedor en gel Zaphiria Lumi 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel City Girl 15 g', 'removedor-en-gel-city-girl-15-g', null, (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-CITY-GIRL-15-G', null, null, null, 8250, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-gel-city-girl-15-g.jpg', 'Removedor en gel City Girl 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel Zaphiria 15 g', 'removedor-en-gel-zaphiria-15-g', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-ZAPHIRIA-15-G', null, null, null, 19678, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-gel-zaphiria-15-g.jpg', 'Removedor en gel Zaphiria 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel Lion Beauty 20 ml', 'removedor-en-gel-lion-beauty-20-ml', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, 'Libre de acetona, de aroma refrescante. Remueve rápidamente las extensiones de pestañas.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-LION-BEAUTY-20-ML', null, null, null, 20890, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel Express Zaphiria 10 g', 'removedor-en-gel-express-zaphiria-10-g', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-EXPRESS-ZAPHIRIA-10-G', null, null, null, 11000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-gel-express-zaphiria-10-g.jpg', 'Removedor en gel Express Zaphiria 10 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel Iconsign 1 g', 'removedor-en-gel-iconsign-1-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-ICONSIGN-1-G', null, null, null, 5600, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-gel-iconsign-1-g.jpg', 'Removedor en gel Iconsign 1 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en crema Stars Colors 5 g', 'removedor-en-crema-stars-colors-5-g', (select id from brands where slug = 'stars-colors'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-CREMA-STARS-COLORS-5-G', null, null, null, 5378, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-crema-stars-colors-5-g.jpg', 'Removedor en crema Stars Colors 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en lápiz Stars Colors 5 ml', 'removedor-en-lapiz-stars-colors-5-ml', (select id from brands where slug = 'stars-colors'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-LAPIZ-STARS-COLORS-5-ML', null, null, null, 3900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-lapiz-stars-colors-5-ml.jpg', 'Removedor en lápiz Stars Colors 5 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Removedor en gel Stars Colors 15 ml', 'removedor-en-gel-stars-colors-15-ml', (select id from brands where slug = 'stars-colors'), (select id from categories where slug = 'removedores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REMOVEDOR-EN-GEL-STARS-COLORS-15-ML', null, null, null, 8678, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/removedor-en-gel-stars-colors-15-ml.jpg', 'Removedor en gel Stars Colors 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Repuesto wipes limpia pegamento x 200', 'repuesto-wipes-limpia-pegamento-x-200', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REPUESTO-WIPES-LIMPIA-PEGAMENTO-X-200', null, null, null, 2570, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/repuesto-wipes-limpia-pegamento-x-200.jpg', 'Repuesto wipes limpia pegamento x 200', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Wipes limpia pegamento x 200', 'wipes-limpia-pegamento-x-200', null, (select id from categories where slug = 'complementos-adhesivos'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'WIPES-LIMPIA-PEGAMENTO-X-200-BLANCO', 'Blanco', null, null, 3178, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'WIPES-LIMPIA-PEGAMENTO-X-200-ROSA', 'Rosa', null, null, 3178, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/wipes-limpia-pegamento-x-200.jpg', 'Wipes limpia pegamento x 200', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Mezclador de adhesivo', 'mezclador-de-adhesivo', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MEZCLADOR-DE-ADHESIVO', null, null, null, 22000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/mezclador-de-adhesivo.jpg', 'Mezclador de adhesivo', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Limpia pegamento paquete x 300', 'limpia-pegamento-paquete-x-300', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LIMPIA-PEGAMENTO-PAQUETE-X-300', null, null, null, 5625, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/limpia-pegamento-paquete-x-300.jpg', 'Limpia pegamento paquete x 300', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Anillo con ranuras para adhesivo', 'anillo-con-ranuras-para-adhesivo', null, (select id from categories where slug = 'complementos-adhesivos'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ANILLO-CON-RANURAS-PARA-ADHESIVO-X100', 'x 100', null, null, 3910, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ANILLO-CON-RANURAS-PARA-ADHESIVO-X10', 'x 10', null, null, 820, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/anillo-con-ranuras-para-adhesivo.jpg', 'Anillo con ranuras para adhesivo', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/anillo-con-ranuras-para-adhesivo-2.jpg', 'Anillo con ranuras para adhesivo', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Base flor rosa x 10 (solo base)', 'base-flor-rosa-x-10-solo-base', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BASE-FLOR-ROSA-X-10-SOLO-BASE', null, null, null, 540, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/base-flor-rosa-x-10-solo-base.jpg', 'Base flor rosa x 10 (solo base)', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Líquido limpia pinzas', 'liquido-limpia-pinzas', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LIQUIDO-LIMPIA-PINZAS', null, null, null, 2445, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/liquido-limpia-pinzas.jpg', 'Líquido limpia pinzas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Anillo portapegamento', 'anillo-portapegamento', null, (select id from categories where slug = 'complementos-adhesivos'), 'variants', '{"Presentación"}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ANILLO-PORTAPEGAMENTO-X100ROSA', 'x 100 rosa', null, null, 2445, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ANILLO-PORTAPEGAMENTO-X100BLANCO', 'x 100 blanco', null, null, 2445, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ANILLO-PORTAPEGAMENTO-X10', 'x 10', null, null, 320, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/anillo-portapegamento.jpg', 'Anillo portapegamento', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Base flor para adhesivo x 10', 'base-flor-para-adhesivo-x-10', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BASE-FLOR-PARA-ADHESIVO-X-10', null, null, null, 810, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tapón para pegamento x unidad', 'tapon-para-pegamento-x-unidad', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TAPON-PARA-PEGAMENTO-X-UNIDAD', null, null, null, 540, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tapon-para-pegamento-x-unidad.jpg', 'Tapón para pegamento x unidad', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Piedra jade', 'piedra-jade', null, (select id from categories where slug = 'complementos-adhesivos'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PIEDRA-JADE-VERDE', 'Verde', null, null, 675, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PIEDRA-JADE-NEGRA', 'Negra', null, null, 675, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/piedra-jade.jpg', 'Piedra jade', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Porta pegamento PVC x 10', 'porta-pegamento-pvc-x-10', null, (select id from categories where slug = 'complementos-adhesivos'), 'variants', '{"Forma"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTA-PEGAMENTO-PVC-X-10-REDONDO', 'Redondo', null, null, 1230, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTA-PEGAMENTO-PVC-X-10-CUADRADO', 'Cuadrado', null, null, 1230, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/porta-pegamento-pvc-x-10.jpg', 'Porta pegamento PVC x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Destapador de adhesivo', 'destapador-de-adhesivo', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'DESTAPADOR-DE-ADHESIVO', null, null, null, 2670, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/destapador-de-adhesivo.jpg', 'Destapador de adhesivo', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Portapegamento rosa con medidor de humedad', 'portapegamento-rosa-con-medidor-de-humedad', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTAPEGAMENTO-ROSA-CON-MEDIDOR-DE-HUMEDAD', null, null, null, 11980, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/portapegamento-rosa-con-medidor-de-humedad.jpg', 'Portapegamento rosa con medidor de humedad', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cristal portapegamento rosa', 'cristal-portapegamento-rosa', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CRISTAL-PORTAPEGAMENTO-ROSA', null, null, null, 3800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cristal-portapegamento-rosa.jpg', 'Cristal portapegamento rosa', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Portapegamento negro', 'portapegamento-negro', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTAPEGAMENTO-NEGRO', null, null, null, 5000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/portapegamento-negro.jpg', 'Portapegamento negro', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tanque portapegamento de plástico Press', 'tanque-portapegamento-de-plastico-press', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TANQUE-PORTAPEGAMENTO-DE-PLASTICO-PRESS', null, null, null, 9170, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tanque-portapegamento-de-plastico-press.jpg', 'Tanque portapegamento de plástico Press', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tanque portapegamento de plástico rosa', 'tanque-portapegamento-de-plastico-rosa', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TANQUE-PORTAPEGAMENTO-DE-PLASTICO-ROSA', null, null, null, 8440, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tanque-portapegamento-de-plastico-rosa.jpg', 'Tanque portapegamento de plástico rosa', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Portapegamento rosa hermético', 'portapegamento-rosa-hermetico', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTAPEGAMENTO-ROSA-HERMETICO', null, null, null, 7500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/portapegamento-rosa-hermetico.jpg', 'Portapegamento rosa hermético', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Shampoo para pestañas Lion Beauty', 'shampoo-para-pestanas-lion-beauty', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'shampoo-y-limpieza'), 'variants', '{"Presentación"}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-PARA-PESTANAS-LION-BEAUTY-40ML', '40 ml', null, null, 7200, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-PARA-PESTANAS-LION-BEAUTY-150ML', '150 ml', null, null, 16600, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/shampoo-para-pestanas-lion-beauty.jpg', 'Shampoo para pestañas Lion Beauty', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Shampoo Navina 80 ml', 'shampoo-navina-80-ml', (select id from brands where slug = 'navina'), (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-NAVINA-80-ML', null, null, null, 3555, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/shampoo-navina-80-ml.jpg', 'Shampoo Navina 80 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Shampoo Ice Cream Zaphiria', 'shampoo-ice-cream-zaphiria', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-ICE-CREAM-ZAPHIRIA', null, null, null, 10300, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/shampoo-ice-cream-zaphiria.jpg', 'Shampoo Ice Cream Zaphiria', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Shampoo Iconsign', 'shampoo-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-ICONSIGN', null, null, null, 9400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/shampoo-iconsign.jpg', 'Shampoo Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Shampoo Lash', 'shampoo-lash', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-LASH-60ML', '60 ml', null, null, 4000, 0, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-LASH-100ML', '100 ml', null, null, 4330, 0, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/shampoo-lash.jpg', 'Shampoo Lash', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Agua micelar Thelma y Louise', 'agua-micelar-thelma-y-louise', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'AGUA-MICELAR-THELMA-Y-LOUISE-160ML', '160 ml', null, null, 4900, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'AGUA-MICELAR-THELMA-Y-LOUISE-70ML', '70 ml', null, null, 3000, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/agua-micelar-thelma-y-louise.jpg', 'Agua micelar Thelma y Louise', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espumero 150 ml', 'espumero-150-ml', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-150-ML', null, null, null, 2310, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espumero rojo 100 ml', 'espumero-rojo-100-ml', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-ROJO-100-ML', null, null, null, 4280, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espumero rosa', 'espumero-rosa', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-ROSA-30ML', '30 ml', null, null, 1800, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-ROSA-120ML', '120 ml', null, null, 3300, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espumero-rosa.jpg', 'Espumero rosa', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espumero 100 ml', 'espumero-100-ml', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-100-ML-100ML', '100 ml', null, null, 1900, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-100-ML-50ML', '50 ml', null, null, 1400, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espumero-100-ml.jpg', 'Espumero 100 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espumero 30 ml', 'espumero-30-ml', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-30-ML', null, null, null, 1470, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espumero-30-ml.jpg', 'Espumero 30 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espumero dorado o rosa con frasco transparente 50 ml', 'espumero-dorado-o-rosa-con-frasco-transparente-50-ml', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-DORADO-O-ROSA-CON-FRASCO-TRANSPARENTE-50-ML-DORADO', 'Dorado', null, null, 3300, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPUMERO-DORADO-O-ROSA-CON-FRASCO-TRANSPARENTE-50-ML-ROSA', 'Rosa', null, null, 3300, 10, 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Agua micelar Mely común', 'agua-micelar-mely-comun', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'AGUA-MICELAR-MELY-COMUN', null, null, null, 6200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/agua-micelar-mely-comun.jpg', 'Agua micelar Mely común', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Agua micelar bifásica Thelma y Louise', 'agua-micelar-bifasica-thelma-y-louise', null, (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'AGUA-MICELAR-BIFASICA-THELMA-Y-LOUISE', null, null, null, 7335, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/agua-micelar-bifasica-thelma-y-louise.jpg', 'Agua micelar bifásica Thelma y Louise', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Shampoo concentrado Zaphiria Lumi para 60 ml', 'shampoo-concentrado-zaphiria-lumi-para-60-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'shampoo-y-limpieza'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SHAMPOO-CONCENTRADO-ZAPHIRIA-LUMI-PARA-60-ML', null, null, null, 2100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/shampoo-concentrado-zaphiria-lumi-para-60-ml.jpg', 'Shampoo concentrado Zaphiria Lumi para 60 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Sellador Nagaraku', 'sellador-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SELLADOR-NAGARAKU', null, null, null, 10510, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/sellador-nagaraku.jpg', 'Sellador Nagaraku', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Sellador para extensiones transparente Navina', 'sellador-para-extensiones-transparente-navina', (select id from brands where slug = 'navina'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SELLADOR-PARA-EXTENSIONES-TRANSPARENTE-NAVINA', null, null, null, 8435, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/sellador-para-extensiones-transparente-navina.jpg', 'Sellador para extensiones transparente Navina', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Sellador Iconsign', 'sellador-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SELLADOR-ICONSIGN', null, null, null, 10390, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/sellador-iconsign.jpg', 'Sellador Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash Primer 10 ml', 'lash-primer-10-ml', null, (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-PRIMER-10-ML', null, null, null, 11735, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-primer-10-ml.jpg', 'Lash Primer 10 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Primer para pestañas Navina', 'primer-para-pestanas-navina', (select id from brands where slug = 'navina'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRIMER-PARA-PESTANAS-NAVINA', null, null, null, 4770, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/primer-para-pestanas-navina.jpg', 'Primer para pestañas Navina', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Primer Dlux', 'primer-dlux', null, (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRIMER-DLUX', null, null, null, 16010, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/primer-dlux.jpg', 'Primer Dlux', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Primer Zaphiria 20 ml', 'primer-zaphiria-20-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRIMER-ZAPHIRIA-20-ML', null, null, null, 16700, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/primer-zaphiria-20-ml.jpg', 'Primer Zaphiria 20 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash Bonder Iconsign', 'lash-bonder-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-BONDER-ICONSIGN', null, null, null, 13700, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-bonder-iconsign.jpg', 'Lash Bonder Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash Primer Stars Colors', 'lash-primer-stars-colors', (select id from brands where slug = 'stars-colors'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-PRIMER-STARS-COLORS', null, null, null, 11620, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-primer-stars-colors.jpg', 'Lash Primer Stars Colors', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Primer Melon Zaphiria 15 ml', 'primer-melon-zaphiria-15-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRIMER-MELON-ZAPHIRIA-15-ML', null, null, null, 9780, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/primer-melon-zaphiria-15-ml.jpg', 'Primer Melon Zaphiria 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Natural Primer Zaphiria', 'natural-primer-zaphiria', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'NATURAL-PRIMER-ZAPHIRIA', null, null, null, 22245, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/natural-primer-zaphiria.jpg', 'Natural Primer Zaphiria', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Primer Lumi Zaphiria 15 ml', 'primer-lumi-zaphiria-15-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRIMER-LUMI-ZAPHIRIA-15-ML', null, null, null, 10000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/primer-lumi-zaphiria-15-ml.jpg', 'Primer Lumi Zaphiria 15 ml', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/primer-lumi-zaphiria-15-ml-2.jpg', 'Primer Lumi Zaphiria 15 ml', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Super Booster Golle', 'super-booster-golle', (select id from brands where slug = 'golle'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SUPER-BOOSTER-GOLLE', null, null, null, 12710, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Ultrabalance 15 ml', 'ultrabalance-15-ml', null, (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, 'Mantiene el balance de humedad para mejorar la retención.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ULTRABALANCE-15-ML', null, null, null, 9535, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/ultrabalance-15-ml.jpg', 'Ultrabalance 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Super Bonder Golle 15 ml', 'super-bonder-golle-15-ml', (select id from brands where slug = 'golle'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SUPER-BONDER-GOLLE-15-ML', null, null, null, 24080, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/super-bonder-golle-15-ml.jpg', 'Super Bonder Golle 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bonder Zaphiria 20 ml', 'bonder-zaphiria-20-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, 'Maximiza la retención.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BONDER-ZAPHIRIA-20-ML', null, null, null, 28845, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bonder-zaphiria-20-ml.jpg', 'Bonder Zaphiria 20 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bonder Zaphiria Lumi 15 ml', 'bonder-zaphiria-lumi-15-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, 'Maximiza la retención de las extensiones.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BONDER-ZAPHIRIA-LUMI-15-ML', null, null, null, 20700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bonder-zaphiria-lumi-15-ml.jpg', 'Bonder Zaphiria Lumi 15 ml', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bonder-zaphiria-lumi-15-ml-2.jpg', 'Bonder Zaphiria Lumi 15 ml', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Booster Dlux', 'booster-dlux', null, (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BOOSTER-DLUX', null, null, null, 22245, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/booster-dlux.jpg', 'Booster Dlux', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cleanser Iconsign', 'cleanser-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CLEANSER-ICONSIGN', null, null, null, 5320, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cleanser-iconsign.jpg', 'Cleanser Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bonder Clione 20 ml', 'bonder-clione-20-ml', (select id from brands where slug = 'clione'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BONDER-CLIONE-20-ML', null, null, null, 25900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bonder-clione-20-ml.jpg', 'Bonder Clione 20 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Magic Bonder Abruxlashes', 'magic-bonder-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MAGIC-BONDER-ABRUXLASHES', null, null, null, 18900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/magic-bonder-abruxlashes.jpg', 'Magic Bonder Abruxlashes', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Super Booster Abruxlashes', 'super-booster-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'primers-selladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SUPER-BOOSTER-ABRUXLASHES', null, null, null, 16700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/super-booster-abruxlashes.jpg', 'Super Booster Abruxlashes', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hisopo aplicador cristal x 50', 'hisopo-aplicador-cristal-x-50', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HISOPO-APLICADOR-CRISTAL-X-50', null, null, null, 2060, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hisopo-aplicador-cristal-x-50.jpg', 'Hisopo aplicador cristal x 50', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pack cepillos para pestañas x 50', 'pack-cepillos-para-pestanas-x-50', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PACK-CEPILLOS-PARA-PESTANAS-X-50', null, null, null, 2090, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pack-cepillos-para-pestanas-x-50.jpg', 'Pack cepillos para pestañas x 50', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pack cepillos de silicona para laminado', 'pack-cepillos-de-silicona-para-laminado', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PACK-CEPILLOS-DE-SILICONA-PARA-LAMINADO', null, null, null, 3300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pack-cepillos-de-silicona-para-laminado.jpg', 'Pack cepillos de silicona para laminado', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hisopo regular 2,5 pack x 100', 'hisopo-regular-2-5-pack-x-100', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HISOPO-REGULAR-2-5-PACK-X-100', null, null, null, 2080, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hisopo-regular-2-5-pack-x-100.jpg', 'Hisopo regular 2,5 pack x 100', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Microhisopos en bolsa x 100', 'microhisopos-en-bolsa-x-100', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, true, 'Color según stock.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MICROHISOPOS-EN-BOLSA-X-100', null, null, null, 1350, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/microhisopos-en-bolsa-x-100.jpg', 'Microhisopos en bolsa x 100', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Brocha limpia pestañas', 'brocha-limpia-pestanas', null, (select id from categories where slug = 'brochas-cepillos'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BROCHA-LIMPIA-PESTANAS-LISA', 'Lisa', null, null, 1100, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BROCHA-LIMPIA-PESTANAS-GLITTER', 'Glitter', null, null, 1100, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/brocha-limpia-pestanas.jpg', 'Brocha limpia pestañas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Microhisopos en bolsa x 100 cristal glitter', 'microhisopos-en-bolsa-x-100-cristal-glitter', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MICROHISOPOS-EN-BOLSA-X-100-CRISTAL-GLITTER', null, null, null, 2080, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/microhisopos-en-bolsa-x-100-cristal-glitter.jpg', 'Microhisopos en bolsa x 100 cristal glitter', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hisopo aplicador x 50', 'hisopo-aplicador-x-50', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HISOPO-APLICADOR-X-50', null, null, null, 2000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hisopo-aplicador-x-50.jpg', 'Hisopo aplicador x 50', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Botella pico curvo grande', 'botella-pico-curvo-grande', null, (select id from categories where slug = 'brochas-cepillos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BOTELLA-PICO-CURVO-GRANDE', null, null, null, 1860, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/botella-pico-curvo-grande.jpg', 'Botella pico curvo grande', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Nano mister USB', 'nano-mister-usb', null, (select id from categories where slug = 'ventiladores'), 'variants', '{"Color"}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'NANO-MISTER-USB-ROSA', 'Rosa', null, null, 6600, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'NANO-MISTER-USB-BLANCO', 'Blanco', null, null, 6600, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/nano-mister-usb.jpg', 'Nano mister USB', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Nano mister huevito animal USB', 'nano-mister-huevito-animal-usb', null, (select id from categories where slug = 'ventiladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'NANO-MISTER-HUEVITO-ANIMAL-USB', null, null, null, 5380, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/nano-mister-huevito-animal-usb.jpg', 'Nano mister huevito animal USB', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Ventilador USB animal', 'ventilador-usb-animal', null, (select id from categories where slug = 'ventiladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'VENTILADOR-USB-ANIMAL', null, null, null, 7770, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/ventilador-usb-animal.jpg', 'Ventilador USB animal', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Ventilador USB gatito', 'ventilador-usb-gatito', null, (select id from categories where slug = 'ventiladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'VENTILADOR-USB-GATITO', null, null, null, 6130, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/ventilador-usb-gatito.jpg', 'Ventilador USB gatito', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Ventilador con luz', 'ventilador-con-luz', null, (select id from categories where slug = 'ventiladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'VENTILADOR-CON-LUZ', null, null, null, 8330, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/ventilador-con-luz.jpg', 'Ventilador con luz', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Ventilador USB con cargador tipo C', 'ventilador-usb-con-cargador-tipo-c', null, (select id from categories where slug = 'ventiladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'VENTILADOR-USB-CON-CARGADOR-TIPO-C', null, null, null, 6110, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/ventilador-usb-con-cargador-tipo-c.jpg', 'Ventilador USB con cargador tipo C', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Mini cooling ventilador y humidificador grande', 'mini-cooling-ventilador-y-humidificador-grande', null, (select id from categories where slug = 'ventiladores'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MINI-COOLING-VENTILADOR-Y-HUMIDIFICADOR-GRANDE', null, null, null, 23200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/mini-cooling-ventilador-y-humidificador-grande.jpg', 'Mini cooling ventilador y humidificador grande', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta micropore color', 'cinta-micropore-color', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-MICROPORE-COLOR', null, null, null, 860, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-micropore-color.jpg', 'Cinta micropore color', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta micropore ECO', 'cinta-micropore-eco', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-MICROPORE-ECO', null, null, null, 770, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-micropore-eco.jpg', 'Cinta micropore ECO', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta micropore hipoalergénica 3M', 'cinta-micropore-hipoalergenica-3m', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-MICROPORE-HIPOALERGENICA-3M', null, null, null, 1100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-micropore-hipoalergenica-3m.jpg', 'Cinta micropore hipoalergénica 3M', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta gel blanca 2,5 cm x 5 m', 'cinta-gel-blanca-2-5-cm-x-5-m', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-GEL-BLANCA-2-5-CM-X-5-M', null, null, null, 2290, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-gel-blanca-2-5-cm-x-5-m.jpg', 'Cinta gel blanca 2,5 cm x 5 m', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta plástica Transpore', 'cinta-plastica-transpore', null, (select id from categories where slug = 'cintas-parches'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-PLASTICA-TRANSPORE-ROSA', 'Rosa', null, null, 860, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-PLASTICA-TRANSPORE-VERDE', 'Verde', null, null, 860, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-PLASTICA-TRANSPORE-TRANSPARENTE', 'Transparente', null, null, 860, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-plastica-transpore.jpg', 'Cinta plástica Transpore', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta micropore para tapping 4 mm', 'cinta-micropore-para-tapping-4-mm', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-MICROPORE-PARA-TAPPING-4-MM', null, null, null, 780, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-micropore-para-tapping-4-mm.jpg', 'Cinta micropore para tapping 4 mm', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta gel carrusel', 'cinta-gel-carrusel', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-GEL-CARRUSEL', null, null, null, 2640, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-gel-carrusel.jpg', 'Cinta gel carrusel', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Portacinta acrílico ECO', 'portacinta-acrilico-eco', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTACINTA-ACRILICO-ECO', null, null, null, 1950, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/portacinta-acrilico-eco.jpg', 'Portacinta acrílico ECO', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Portacinta corazón', 'portacinta-corazon', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTACINTA-CORAZON', null, null, null, 2455, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/portacinta-corazon.jpg', 'Portacinta corazón', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Parches de lifting reutilizables de silicona con dibujitos', 'parches-de-lifting-reutilizables-de-silicona-con-dibujitos', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PARCHES-DE-LIFTING-REUTILIZABLES-DE-SILICONA-CON-DIBUJITOS', null, null, null, 5000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/parches-de-lifting-reutilizables-de-silicona-con-dibujitos.jpg', 'Parches de lifting reutilizables de silicona con dibujitos', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Parches de lifting reutilizables de silicona', 'parches-de-lifting-reutilizables-de-silicona', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PARCHES-DE-LIFTING-REUTILIZABLES-DE-SILICONA', null, null, null, 2450, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/parches-de-lifting-reutilizables-de-silicona.jpg', 'Parches de lifting reutilizables de silicona', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/parches-de-lifting-reutilizables-de-silicona-2.jpg', 'Parches de lifting reutilizables de silicona', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Parches de silicona City Girl x 2 pares', 'parches-de-silicona-city-girl-x-2-pares', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PARCHES-DE-SILICONA-CITY-GIRL-X-2-PARES', null, null, null, 2300, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Parches común de tela x 10', 'parches-comun-de-tela-x-10', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PARCHES-COMUN-DE-TELA-X-10', null, null, null, 1890, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/parches-comun-de-tela-x-10.jpg', 'Parches común de tela x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Parches de hidrogel x 10 pares', 'parches-de-hidrogel-x-10-pares', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PARCHES-DE-HIDROGEL-X-10-PARES', null, null, null, 2500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/parches-de-hidrogel-x-10-pares.jpg', 'Parches de hidrogel x 10 pares', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta contenedora de cejas para laminado', 'cinta-contenedora-de-cejas-para-laminado', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-CONTENEDORA-DE-CEJAS-PARA-LAMINADO', null, null, null, 2570, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-contenedora-de-cejas-para-laminado.jpg', 'Cinta contenedora de cejas para laminado', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cinta de silicona para lifting', 'cinta-de-silicona-para-lifting', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTA-DE-SILICONA-PARA-LIFTING', null, null, null, 3000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cinta-de-silicona-para-lifting.jpg', 'Cinta de silicona para lifting', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cintas contenedoras de pestañas para lifting de papel x 1000', 'cintas-contenedoras-de-pestanas-para-lifting-de-papel-x-1000', null, (select id from categories where slug = 'cintas-parches'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CINTAS-CONTENEDORAS-DE-PESTANAS-PARA-LIFTING-DE-PAPEL-X-1000', null, null, null, 8440, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cintas-contenedoras-de-pestanas-para-lifting-de-papel-x-1000.jpg', 'Cintas contenedoras de pestañas para lifting de papel x 1000', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cintas-contenedoras-de-pestanas-para-lifting-de-papel-x-1000-2.jpg', 'Cintas contenedoras de pestañas para lifting de papel x 1000', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Herramienta para lifting de acero inoxidable', 'herramienta-para-lifting-de-acero-inoxidable', null, (select id from categories where slug = 'herramientas-lifting'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HERRAMIENTA-PARA-LIFTING-DE-ACERO-INOXIDABLE-SIMPLE', 'Simple', null, null, 2970, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HERRAMIENTA-PARA-LIFTING-DE-ACERO-INOXIDABLE-CONPEINE', 'Con peine', null, null, 4510, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/herramienta-para-lifting-de-acero-inoxidable.jpg', 'Herramienta para lifting de acero inoxidable', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/herramienta-para-lifting-de-acero-inoxidable-2.jpg', 'Herramienta para lifting de acero inoxidable', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Perfilador blister x 3', 'perfilador-blister-x-3', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PERFILADOR-BLISTER-X-3', null, null, null, 1210, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/perfilador-blister-x-3.jpg', 'Perfilador blister x 3', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Palito naranjo x 100', 'palito-naranjo-x-100', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PALITO-NARANJO-X-100', null, null, null, 2690, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/palito-naranjo-x-100.jpg', 'Palito naranjo x 100', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hisopo de madera x 100 (10 cm)', 'hisopo-de-madera-x-100-10-cm', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HISOPO-DE-MADERA-X-100-10-CM', null, null, null, 1050, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hisopo-de-madera-x-100-10-cm.jpg', 'Hisopo de madera x 100 (10 cm)', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cepillos para laminado rectos x 10', 'cepillos-para-laminado-rectos-x-10', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CEPILLOS-PARA-LAMINADO-RECTOS-X-10', null, null, null, 3180, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cepillos-para-laminado-rectos-x-10.jpg', 'Cepillos para laminado rectos x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Herramienta para lifting x 1', 'herramienta-para-lifting-x-1', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HERRAMIENTA-PARA-LIFTING-X-1', null, null, null, 300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/herramienta-para-lifting-x-1.jpg', 'Herramienta para lifting x 1', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Marcador para mapping doble punta', 'marcador-para-mapping-doble-punta', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MARCADOR-PARA-MAPPING-DOBLE-PUNTA', null, null, null, 3300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/marcador-para-mapping-doble-punta.jpg', 'Marcador para mapping doble punta', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lápiz fibra para cejas blanco con regla', 'lapiz-fibra-para-cejas-blanco-con-regla', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPIZ-FIBRA-PARA-CEJAS-BLANCO-CON-REGLA', null, null, null, 1600, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lapiz-fibra-para-cejas-blanco-con-regla.jpg', 'Lápiz fibra para cejas blanco con regla', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lapicera gel para cejas', 'lapicera-gel-para-cejas', null, (select id from categories where slug = 'herramientas-lifting'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPICERA-GEL-PARA-CEJAS-BLANCA', 'Blanca', null, null, 2200, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPICERA-GEL-PARA-CEJAS-ROSA', 'Rosa', null, null, 2200, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPICERA-GEL-PARA-CEJAS-VERDE', 'Verde', null, null, 2200, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lapicera-gel-para-cejas.jpg', 'Lapicera gel para cejas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lápiz para cejas con peine Birou', 'lapiz-para-cejas-con-peine-birou', (select id from brands where slug = 'birou'), (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPIZ-PARA-CEJAS-CON-PEINE-BIROU', null, null, null, 9045, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lapiz-para-cejas-con-peine-birou.jpg', 'Lápiz para cejas con peine Birou', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lápiz dermográfico x unidad', 'lapiz-dermografico-x-unidad', null, (select id from categories where slug = 'herramientas-lifting'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPIZ-DERMOGRAFICO-X-UNIDAD-MARRN', 'Marrón', null, null, 1710, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPIZ-DERMOGRAFICO-X-UNIDAD-NEGRO', 'Negro', null, null, 1710, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LAPIZ-DERMOGRAFICO-X-UNIDAD-BLANCO', 'Blanco', null, null, 1710, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lapiz-dermografico-x-unidad.jpg', 'Lápiz dermográfico x unidad', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Calibre plástico', 'calibre-plastico', null, (select id from categories where slug = 'herramientas-lifting'), 'variants', '{"Tamaño"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CALIBRE-PLASTICO-15CM', '15 cm', null, null, 2445, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CALIBRE-PLASTICO-8CM', '8 cm', null, null, 1225, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/calibre-plastico.jpg', 'Calibre plástico', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Film', 'film', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'FILM', null, null, null, 1780, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/film.jpg', 'Film', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hilo marcador 10 m', 'hilo-marcador-10-m', null, (select id from categories where slug = 'herramientas-lifting'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HILO-MARCADOR-10-M-BLANCO', 'Blanco', null, null, 3790, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HILO-MARCADOR-10-M-NEGRO', 'Negro', null, null, 3790, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HILO-MARCADOR-10-M-ROSA', 'Rosa', null, null, 3790, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hilo-marcador-10-m.jpg', 'Hilo marcador 10 m', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Peine para lifting x 3', 'peine-para-lifting-x-3', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PEINE-PARA-LIFTING-X-3', null, null, null, 1470, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/peine-para-lifting-x-3.jpg', 'Peine para lifting x 3', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Regla para pestañas', 'regla-para-pestanas', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REGLA-PARA-PESTANAS', null, null, null, 920, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/regla-para-pestanas.jpg', 'Regla para pestañas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Mapping pre-inked hilo 30 m', 'mapping-pre-inked-hilo-30-m', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MAPPING-PRE-INKED-HILO-30-M', null, null, null, 6970, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/mapping-pre-inked-hilo-30-m.jpg', 'Mapping pre-inked hilo 30 m', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cepillo doble madera con peine plástico', 'cepillo-doble-madera-con-peine-plastico', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CEPILLO-DOBLE-MADERA-CON-PEINE-PLASTICO', null, null, null, 3300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cepillo-doble-madera-con-peine-plastico.jpg', 'Cepillo doble madera con peine plástico', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pincel de precisión para cejas', 'pincel-de-precision-para-cejas', null, (select id from categories where slug = 'herramientas-lifting'), 'variants', '{"Tamaño"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINCEL-DE-PRECISION-PARA-CEJAS-GRANDE', 'Grande', null, null, 1870, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINCEL-DE-PRECISION-PARA-CEJAS-CHICO', 'Chico', null, null, 1100, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pincel-de-precision-para-cejas.jpg', 'Pincel de precisión para cejas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Regla para pestañas portátil', 'regla-para-pestanas-portatil', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REGLA-PARA-PESTANAS-PORTATIL', null, null, null, 575, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/regla-para-pestanas-portatil.jpg', 'Regla para pestañas portátil', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Piel sintética para cejas', 'piel-sintetica-para-cejas', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PIEL-SINTETICA-PARA-CEJAS', null, null, null, 3180, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Mezclador de tinta', 'mezclador-de-tinta', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MEZCLADOR-DE-TINTA', null, null, null, 4160, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/mezclador-de-tinta.jpg', 'Mezclador de tinta', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Mini derretidor de cera Zaphiria', 'mini-derretidor-de-cera-zaphiria', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'cuidado-facial-y-corporal'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MINI-DERRETIDOR-DE-CERA-ZAPHIRIA', null, null, null, 16380, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/mini-derretidor-de-cera-zaphiria.jpg', 'Mini derretidor de cera Zaphiria', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cera para depilar rostro Mely', 'cera-para-depilar-rostro-mely', null, (select id from categories where slug = 'cuidado-facial-y-corporal'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CERA-PARA-DEPILAR-ROSTRO-MELY-100G', '100 g', null, null, 5400, 0, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CERA-PARA-DEPILAR-ROSTRO-MELY-400G', '400 g', null, null, 8900, 0, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cera-para-depilar-rostro-mely.jpg', 'Cera para depilar rostro Mely', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Guantes 100% nitrilo caja x 100', 'guantes-100-nitrilo-caja-x-100', null, (select id from categories where slug = 'guantes-descartables'), 'variants', '{"Color"}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'GUANTES-100-NITRILO-CAJA-X-100-AZUL', 'Azul', null, null, 9780, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'GUANTES-100-NITRILO-CAJA-X-100-ROSA', 'Rosa', null, null, 9780, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'GUANTES-100-NITRILO-CAJA-X-100-NEGRO', 'Negro', null, null, 9780, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/guantes-100-nitrilo-caja-x-100.jpg', 'Guantes 100% nitrilo caja x 100', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/guantes-100-nitrilo-caja-x-100-2.jpg', 'Guantes 100% nitrilo caja x 100', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/guantes-100-nitrilo-caja-x-100-3.jpg', 'Guantes 100% nitrilo caja x 100', 2);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bandeja de acero inoxidable', 'bandeja-de-acero-inoxidable', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BANDEJA-DE-ACERO-INOXIDABLE', null, null, null, 4035, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bandeja-de-acero-inoxidable.jpg', 'Bandeja de acero inoxidable', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bandeja esmaltada', 'bandeja-esmaltada', null, (select id from categories where slug = 'herramientas-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BANDEJA-ESMALTADA', null, null, null, 3425, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bandeja-esmaltada.jpg', 'Bandeja esmaltada', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Soporte de pigmentos para microblading y dermapen', 'soporte-de-pigmentos-para-microblading-y-dermapen', null, (select id from categories where slug = 'cuidado-facial-y-corporal'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'SOPORTE-DE-PIGMENTOS-PARA-MICROBLADING-Y-DERMAPEN', null, null, null, 3700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/soporte-de-pigmentos-para-microblading-y-dermapen.jpg', 'Soporte de pigmentos para microblading y dermapen', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejo de acero inoxidable', 'espejo-de-acero-inoxidable', null, (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJO-DE-ACERO-INOXIDABLE', null, null, null, 2200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejo-de-acero-inoxidable.jpg', 'Espejo de acero inoxidable', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejito corazón sin glitter', 'espejito-corazon-sin-glitter', null, (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-CORAZON-SIN-GLITTER', null, null, null, 4400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejito-corazon-sin-glitter.jpg', 'Espejito corazón sin glitter', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejito corazón con glitter', 'espejito-corazon-con-glitter', null, (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-CORAZON-CON-GLITTER', null, null, null, 6970, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejito-corazon-con-glitter.jpg', 'Espejito corazón con glitter', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejito rectangular', 'espejito-rectangular', null, (select id from categories where slug = 'espejos'), 'variants', '{"Modelo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-RECTANGULAR-NEGRO', 'Negro', null, null, 4520, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-RECTANGULAR-PLATEADO', 'Plateado', null, null, 4520, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-RECTANGULAR-ROSA', 'Rosa', null, null, 5010, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-RECTANGULAR-DORADO', 'Dorado', null, null, 5010, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJITO-RECTANGULAR-CONGLITTER', 'Con glitter', null, null, 6600, 10, 4);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejito-rectangular.jpg', 'Espejito rectangular', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejo redondo 16 x 2 cm', 'espejo-redondo-16-x-2-cm', null, (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJO-REDONDO-16-X-2-CM', null, null, null, 1345, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejo-redondo-16-x-2-cm.jpg', 'Espejo redondo 16 x 2 cm', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejo de mano cuadrado 23,5 cm', 'espejo-de-mano-cuadrado-23-5-cm', null, (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJO-DE-MANO-CUADRADO-23-5-CM', null, null, null, 5260, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejo-de-mano-cuadrado-23-5-cm.jpg', 'Espejo de mano cuadrado 23,5 cm', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejo redondo conejo 23,11 cm', 'espejo-redondo-conejo-23-11-cm', null, (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJO-REDONDO-CONEJO-23-11-CM', null, null, null, 4645, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejo-redondo-conejo-23-11-cm.jpg', 'Espejo redondo conejo 23,11 cm', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Muñequera porta pestañas', 'munequera-porta-pestanas', (select id from brands where slug = 'cherimoya'), (select id from categories where slug = 'accesorios-extensiones'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MUNEQUERA-PORTA-PESTANAS', null, null, null, 2080, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/munequera-porta-pestanas.jpg', 'Muñequera porta pestañas', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/munequera-porta-pestanas-2.jpg', 'Muñequera porta pestañas', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Base de vidrio con base para adhesivo', 'base-de-vidrio-con-base-para-adhesivo', null, (select id from categories where slug = 'accesorios-extensiones'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BASE-DE-VIDRIO-CON-BASE-PARA-ADHESIVO', null, null, null, 3545, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/base-de-vidrio-con-base-para-adhesivo.jpg', 'Base de vidrio con base para adhesivo', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Base acrílica con imán', 'base-acrilica-con-iman', null, (select id from categories where slug = 'accesorios-extensiones'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BASE-ACRILICA-CON-IMAN', null, null, null, 4400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/base-acrilica-con-iman.jpg', 'Base acrílica con imán', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lente macro 0.45X para fotos con celular', 'lente-macro-0-45x-para-fotos-con-celular', null, (select id from categories where slug = 'accesorios-extensiones'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LENTE-MACRO-0-45X-PARA-FOTOS-CON-CELULAR', null, null, null, 20045, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lente-macro-0-45x-para-fotos-con-celular.jpg', 'Lente macro 0.45X para fotos con celular', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cabeza de práctica para pestañas', 'cabeza-de-practica-para-pestanas', null, (select id from categories where slug = 'pestanas-de-practica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CABEZA-DE-PRACTICA-PARA-PESTANAS', null, null, null, 20290, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cabeza-de-practica-para-pestanas.jpg', 'Cabeza de práctica para pestañas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Anillo portapegamento con caja', 'anillo-portapegamento-con-caja', null, (select id from categories where slug = 'complementos-adhesivos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ANILLO-PORTAPEGAMENTO-CON-CAJA', null, null, null, 1800, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Esponjas de práctica x 10', 'esponjas-de-practica-x-10', null, (select id from categories where slug = 'pestanas-de-practica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPONJAS-DE-PRACTICA-X-10', null, null, null, 1300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/esponjas-de-practica-x-10.jpg', 'Esponjas de práctica x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Esponjitas x 10', 'esponjitas-x-10', null, (select id from categories where slug = 'pestanas-de-practica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPONJITAS-X-10', null, null, null, 2000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/esponjitas-x-10.jpg', 'Esponjitas x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Almohadilla porta pestañas rosa', 'almohadilla-porta-pestanas-rosa', null, (select id from categories where slug = 'accesorios-extensiones'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ALMOHADILLA-PORTA-PESTANAS-ROSA', null, null, null, 1900, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Aislador de pestañas', 'aislador-de-pestanas', null, (select id from categories where slug = 'pestanas-de-practica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'AISLADOR-DE-PESTANAS', null, null, null, 2000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/aislador-de-pestanas.jpg', 'Aislador de pestañas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Barbijo descartable x 10', 'barbijo-descartable-x-10', null, (select id from categories where slug = 'guantes-descartables'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BARBIJO-DESCARTABLE-X-10-ROSA', 'Rosa', null, null, 1200, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BARBIJO-DESCARTABLE-X-10-NEGRO', 'Negro', null, null, 1200, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/barbijo-descartable-x-10.jpg', 'Barbijo descartable x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Barbijo plástico transparente', 'barbijo-plastico-transparente', null, (select id from categories where slug = 'guantes-descartables'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BARBIJO-PLASTICO-TRANSPARENTE', null, null, null, 700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/barbijo-plastico-transparente.jpg', 'Barbijo plástico transparente', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Compresas', 'compresas', null, (select id from categories where slug = 'guantes-descartables'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'COMPRESAS-X100', 'x 100', null, null, 7200, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'COMPRESAS-X50', 'x 50', null, null, 4200, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/compresas.jpg', 'Compresas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cofias descartables x 10', 'cofias-descartables-x-10', null, (select id from categories where slug = 'guantes-descartables'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'COFIAS-DESCARTABLES-X-10', null, null, null, 1300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cofias-descartables-x-10.jpg', 'Cofias descartables x 10', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Zaphiria Fish curva U anatómicos', 'bigudies-zaphiria-fish-curva-u-anatomicos', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-ZAPHIRIA-FISH-CURVA-U-ANATOMICOS', null, null, null, 8800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-zaphiria-fish-curva-u-anatomicos.jpg', 'Bigudíes Zaphiria Fish curva U anatómicos', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Zaphiria con ranuras efecto húmedo curva U', 'bigudies-zaphiria-con-ranuras-efecto-humedo-curva-u', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-ZAPHIRIA-CON-RANURAS-EFECTO-HUMEDO-CURVA-U', null, null, null, 8800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-zaphiria-con-ranuras-efecto-humedo-curva-u.jpg', 'Bigudíes Zaphiria con ranuras efecto húmedo curva U', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Zaphiria Flat planos para técnica coreana', 'bigudies-zaphiria-flat-planos-para-tecnica-coreana', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-ZAPHIRIA-FLAT-PLANOS-PARA-TECNICA-COREANA', null, null, null, 6500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-zaphiria-flat-planos-para-tecnica-coreana.jpg', 'Bigudíes Zaphiria Flat planos para técnica coreana', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Zaphiria inferiores', 'bigudies-zaphiria-inferiores', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-ZAPHIRIA-INFERIORES', null, null, null, 6500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-zaphiria-inferiores.jpg', 'Bigudíes Zaphiria inferiores', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Frozen estuche rosado curva L', 'bigudies-frozen-estuche-rosado-curva-l', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-FROZEN-ESTUCHE-ROSADO-CURVA-L', null, null, null, 10000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-frozen-estuche-rosado-curva-l.jpg', 'Bigudíes Frozen estuche rosado curva L', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-frozen-estuche-rosado-curva-l-2.jpg', 'Bigudíes Frozen estuche rosado curva L', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Zaphiria Shell curva C anatómicos', 'bigudies-zaphiria-shell-curva-c-anatomicos', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-ZAPHIRIA-SHELL-CURVA-C-ANATOMICOS', null, null, null, 8800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-zaphiria-shell-curva-c-anatomicos.jpg', 'Bigudíes Zaphiria Shell curva C anatómicos', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Zaphiria Moño curva M anatómicos', 'bigudies-zaphiria-mono-curva-m-anatomicos', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-ZAPHIRIA-MONO-CURVA-M-ANATOMICOS', null, null, null, 8800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-zaphiria-mono-curva-m-anatomicos.jpg', 'Bigudíes Zaphiria Moño curva M anatómicos', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes inferiores con ranuras (chiquitos)', 'bigudies-inferiores-con-ranuras-chiquitos', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-INFERIORES-CON-RANURAS-CHIQUITOS', null, null, null, 6600, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-inferiores-con-ranuras-chiquitos.jpg', 'Bigudíes inferiores con ranuras (chiquitos)', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes en bolsa anatómicos naranja o amarillo flúor', 'bigudies-en-bolsa-anatomicos-naranja-o-amarillo-fluor', null, (select id from categories where slug = 'bigudies'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-EN-BOLSA-ANATOMICOS-NARANJA-O-AMARILLO-FLUOR-NARANJA', 'Naranja', null, null, 10000, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-EN-BOLSA-ANATOMICOS-NARANJA-O-AMARILLO-FLUOR-AMARILLOFLOR', 'Amarillo flúor', null, null, 10000, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-en-bolsa-anatomicos-naranja-o-amarillo-fluor.jpg', 'Bigudíes en bolsa anatómicos naranja o amarillo flúor', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Googles para técnica coreana', 'googles-para-tecnica-coreana', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'GOOGLES-PARA-TECNICA-COREANA', null, null, null, 14400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/googles-para-tecnica-coreana.jpg', 'Googles para técnica coreana', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pads de silicona Iconsign', 'pads-de-silicona-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PADS-DE-SILICONA-ICONSIGN', null, null, null, 8300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pads-de-silicona-iconsign.jpg', 'Pads de silicona Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudí para técnica inversa forma de corazón', 'bigudi-para-tecnica-inversa-forma-de-corazon', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDI-PARA-TECNICA-INVERSA-FORMA-DE-CORAZON', null, null, null, 9200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudi-para-tecnica-inversa-forma-de-corazon.jpg', 'Bigudí para técnica inversa forma de corazón', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudí para técnica inversa forma de huella', 'bigudi-para-tecnica-inversa-forma-de-huella', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDI-PARA-TECNICA-INVERSA-FORMA-DE-HUELLA', null, null, null, 9200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudi-para-tecnica-inversa-forma-de-huella.jpg', 'Bigudí para técnica inversa forma de huella', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudí para técnica inversa forma de mariposa', 'bigudi-para-tecnica-inversa-forma-de-mariposa', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDI-PARA-TECNICA-INVERSA-FORMA-DE-MARIPOSA', null, null, null, 9200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudi-para-tecnica-inversa-forma-de-mariposa.jpg', 'Bigudí para técnica inversa forma de mariposa', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Kitty curva U', 'bigudies-kitty-curva-u', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-KITTY-CURVA-U', null, null, null, 9000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-kitty-curva-u.jpg', 'Bigudíes Kitty curva U', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes planos para técnica coreana delfín', 'bigudies-planos-para-tecnica-coreana-delfin', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-PLANOS-PARA-TECNICA-COREANA-DELFIN', null, null, null, 12200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-planos-para-tecnica-coreana-delfin.jpg', 'Bigudíes planos para técnica coreana delfín', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bigudíes Frozen blanco glitter', 'bigudies-frozen-blanco-glitter', null, (select id from categories where slug = 'bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BIGUDIES-FROZEN-BLANCO-GLITTER', null, null, null, 19450, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/bigudies-frozen-blanco-glitter.jpg', 'Bigudíes Frozen blanco glitter', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit tinte y revelador Lion', 'kit-tinte-y-revelador-lion', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', true, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-TINTE-Y-REVELADOR-LION', null, null, null, 24800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-tinte-y-revelador-lion.jpg', 'Kit tinte y revelador Lion', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tinte gel Lion', 'tinte-gel-lion', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-GEL-LION', null, null, null, 20900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tinte-gel-lion.jpg', 'Tinte gel Lion', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Revelador Lion', 'revelador-lion', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REVELADOR-LION', null, null, null, 5280, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tinte Iconsign Plant Extract', 'tinte-iconsign-plant-extract', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-ICONSIGN-PLANT-EXTRACT-NEGRO', 'Negro', null, null, 7560, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-ICONSIGN-PLANT-EXTRACT-MARRN', 'Marrón', null, null, 7560, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-ICONSIGN-PLANT-EXTRACT-CAF', 'Café', null, null, 7560, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tinte-iconsign-plant-extract.jpg', 'Tinte Iconsign Plant Extract', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Henna Iconsign', 'henna-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-ICONSIGN', null, null, null, 9000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/henna-iconsign.jpg', 'Henna Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tintes Refectocil', 'tintes-refectocil', (select id from brands where slug = 'refectocil'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTES-REFECTOCIL-VARIOSCOLORESCONSULTAR', 'Varios colores (consultar)', null, null, 25670, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tintes-refectocil.jpg', 'Tintes Refectocil', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Refectocil Blonde Brow 15 ml', 'refectocil-blonde-brow-15-ml', (select id from brands where slug = 'refectocil'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, 'Aclara las cejas hasta tres niveles de tonalidad, con un estilo naturalmente rubio (pre-tinte).')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REFECTOCIL-BLONDE-BROW-15-ML', null, null, null, 24640, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/refectocil-blonde-brow-15-ml.jpg', 'Refectocil Blonde Brow 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tinte Charito Ferrari', 'tinte-charito-ferrari', (select id from brands where slug = 'charito-ferrari'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-CHARITO-FERRARI-NEGRO', 'Negro', null, null, 15340, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-CHARITO-FERRARI-MARRN', 'Marrón', null, null, 15340, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tinte-charito-ferrari.jpg', 'Tinte Charito Ferrari', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tinte-charito-ferrari-2.jpg', 'Tinte Charito Ferrari', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit Lash and Brow Tinte Gollee', 'kit-lash-and-brow-tinte-gollee', (select id from brands where slug = 'golle'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-LASH-AND-BROW-TINTE-GOLLEE', null, null, null, 12780, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-lash-and-brow-tinte-gollee.jpg', 'Kit Lash and Brow Tinte Gollee', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Crema protectora para no manchar con tinte Charito Ferrari', 'crema-protectora-para-no-manchar-con-tinte-charito-ferrari', (select id from brands where slug = 'charito-ferrari'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CREMA-PROTECTORA-PARA-NO-MANCHAR-CON-TINTE-CHARITO-FERRARI', null, null, null, 6230, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/crema-protectora-para-no-manchar-con-tinte-charito-ferrari.jpg', 'Crema protectora para no manchar con tinte Charito Ferrari', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Revelador de tinte Charito Ferrari', 'revelador-de-tinte-charito-ferrari', (select id from brands where slug = 'charito-ferrari'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REVELADOR-DE-TINTE-CHARITO-FERRARI', null, null, null, 6780, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/revelador-de-tinte-charito-ferrari.jpg', 'Revelador de tinte Charito Ferrari', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tinte Iconsign en caja', 'tinte-iconsign-en-caja', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-ICONSIGN-EN-CAJA-CAJACHICA', 'Caja chica', null, null, 5000, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TINTE-ICONSIGN-EN-CAJA-CAJAGRANDE', 'Caja grande', null, null, 7230, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tinte-iconsign-en-caja.jpg', 'Tinte Iconsign en caja', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Henna Makiaj en polvo', 'henna-makiaj-en-polvo', (select id from brands where slug = 'makiaj'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-NEGRO', 'Negro', null, null, 7700, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-MARRN', 'Marrón', null, null, 7700, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-CASTAOCLARO', 'Castaño claro', null, null, 7700, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-CASTAOMEDIO', 'Castaño medio', null, null, 7700, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-CASTAOOSCURO', 'Castaño oscuro', null, null, 7700, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-RUBIO', 'Rubio', null, null, 7700, 10, 5);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-MAKIAJ-EN-POLVO-COLORADO', 'Colorado', null, null, 7700, 10, 6);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/henna-makiaj-en-polvo.jpg', 'Henna Makiaj en polvo', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Henna para cejas Rootana', 'henna-para-cejas-rootana', (select id from brands where slug = 'rootana'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-PARA-CEJAS-ROOTANA-BROWN', 'Brown', null, null, 4570, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-PARA-CEJAS-ROOTANA-COFFEE', 'Coffee', null, null, 4570, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-PARA-CEJAS-ROOTANA-BLACK', 'Black', null, null, 4570, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/henna-para-cejas-rootana.jpg', 'Henna para cejas Rootana', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Henna para cejas Sahubba', 'henna-para-cejas-sahubba', (select id from brands where slug = 'sahubba'), (select id from categories where slug = 'tintes-henna'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-PARA-CEJAS-SAHUBBA-BROWN', 'Brown', null, null, 5513, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-PARA-CEJAS-SAHUBBA-COFFEE', 'Coffee', null, null, 5513, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HENNA-PARA-CEJAS-SAHUBBA-BLACK', 'Black', null, null, 5513, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/henna-para-cejas-sahubba.jpg', 'Henna para cejas Sahubba', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Refectocil Styling Gel 15 ml', 'refectocil-styling-gel-15-ml', (select id from brands where slug = 'refectocil'), (select id from categories where slug = 'tintes-henna'), 'simple', '{}', 'active', false, false, 'Fija los pelos rebeldes, protege el color tras el tinte y aporta brillo e hidratación gracias al D-Pantenol y la vitamina E.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'REFECTOCIL-STYLING-GEL-15-ML', null, null, null, 54420, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/refectocil-styling-gel-15-ml.jpg', 'Refectocil Styling Gel 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit de lifting Lion Beauty 10 pares', 'kit-de-lifting-lion-beauty-10-pares', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', true, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-DE-LIFTING-LION-BEAUTY-10-PARES', null, null, null, 46700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-de-lifting-lion-beauty-10-pares.jpg', 'Kit de lifting Lion Beauty 10 pares', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash lifting Iconsign paso 1 y 2 monodosis 1 g', 'lash-lifting-iconsign-paso-1-y-2-monodosis-1-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, 'Precio por par.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-LIFTING-ICONSIGN-PASO-1-Y-2-MONODOSIS-1-G', null, null, null, 2700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-lifting-iconsign-paso-1-y-2-monodosis-1-g.jpg', 'Lash lifting Iconsign paso 1 y 2 monodosis 1 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash Lift Iconsign 1 y 2 x 10 ml', 'lash-lift-iconsign-1-y-2-x-10-ml', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-LIFT-ICONSIGN-1-Y-2-X-10-ML', null, null, null, 9900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-lift-iconsign-1-y-2-x-10-ml.jpg', 'Lash Lift Iconsign 1 y 2 x 10 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit de lifting Gollee', 'kit-de-lifting-gollee', (select id from brands where slug = 'golle'), (select id from categories where slug = 'kits-lifting'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-DE-LIFTING-GOLLEE-KITDELIFTING', 'Kit de lifting', null, null, 30120, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-DE-LIFTING-GOLLEE-KITCONTINTEYLAMINADO', 'Kit con tinte y laminado', null, null, 31400, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-de-lifting-gollee.jpg', 'Kit de lifting Gollee', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit de lifting Iconsign Original', 'kit-de-lifting-iconsign-original', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-DE-LIFTING-ICONSIGN-ORIGINAL', null, null, null, 20780, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-de-lifting-iconsign-original.jpg', 'Kit de lifting Iconsign Original', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Camellia Lift Kit paso 1 y 2 10 g', 'camellia-lift-kit-paso-1-y-2-10-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CAMELLIA-LIFT-KIT-PASO-1-Y-2-10-G', null, null, null, 11560, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/camellia-lift-kit-paso-1-y-2-10-g.jpg', 'Camellia Lift Kit paso 1 y 2 10 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit para lifting Iconsign con monodosis', 'kit-para-lifting-iconsign-con-monodosis', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-PARA-LIFTING-ICONSIGN-CON-MONODOSIS', null, null, null, 24230, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-para-lifting-iconsign-con-monodosis.jpg', 'Kit para lifting Iconsign con monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit de lifting Iconsign Original (caja rosa)', 'kit-de-lifting-iconsign-original-caja-rosa', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-DE-LIFTING-ICONSIGN-ORIGINAL-CAJA-ROSA', null, null, null, 23120, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-de-lifting-iconsign-original-caja-rosa.jpg', 'Kit de lifting Iconsign Original (caja rosa)', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit laminado de cejas Brow Lift Iconsign', 'kit-laminado-de-cejas-brow-lift-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-LAMINADO-DE-CEJAS-BROW-LIFT-ICONSIGN', null, null, null, 24308, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-laminado-de-cejas-brow-lift-iconsign.jpg', 'Kit laminado de cejas Brow Lift Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit laminado de cejas', 'kit-laminado-de-cejas', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-LAMINADO-DE-CEJAS', null, null, null, 18000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-laminado-de-cejas.jpg', 'Kit laminado de cejas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Easy Kit Fall In The Volume lifting y laminado de cejas sobre 1 y 2', 'easy-kit-fall-in-the-volume-lifting-y-laminado-de-cejas-sobre-1-y-2', null, (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'EASY-KIT-FALL-IN-THE-VOLUME-LIFTING-Y-LAMINADO-DE-CEJAS-SOBRE-1-Y-2', null, null, null, 3120, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/easy-kit-fall-in-the-volume-lifting-y-laminado-de-cejas-sobre-1-y-2.jpg', 'Easy Kit Fall In The Volume lifting y laminado de cejas sobre 1 y 2', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash lifting Lion Beauty paso 1 y 2 1 ml', 'lash-lifting-lion-beauty-paso-1-y-2-1-ml', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'nutricion-botox'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-LIFTING-LION-BEAUTY-PASO-1-Y-2-1-ML-1PAR', '1 par', null, null, 3100, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-LIFTING-LION-BEAUTY-PASO-1-Y-2-1-ML-10PARES', '10 pares', null, null, 26400, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-lifting-lion-beauty-paso-1-y-2-1-ml.jpg', 'Lash lifting Lion Beauty paso 1 y 2 1 ml', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-lifting-lion-beauty-paso-1-y-2-1-ml-2.jpg', 'Lash lifting Lion Beauty paso 1 y 2 1 ml', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hidralash Lion Beauty paso 3 monodosis', 'hidralash-lion-beauty-paso-3-monodosis', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, 'Hidrata y repara la pestaña después del lifting.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HIDRALASH-LION-BEAUTY-PASO-3-MONODOSIS', null, null, null, 1280, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hidralash-lion-beauty-paso-3-monodosis.jpg', 'Hidralash Lion Beauty paso 3 monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Botox Lion Beauty paso 4 monodosis', 'botox-lion-beauty-paso-4-monodosis', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, 'Tratamiento profundo que rellena, fortalece y engrosa la pestaña para un acabado más sano y denso.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BOTOX-LION-BEAUTY-PASO-4-MONODOSIS', null, null, null, 1280, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/botox-lion-beauty-paso-4-monodosis.jpg', 'Botox Lion Beauty paso 4 monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Botox Lion Beauty paso 4 15 g', 'botox-lion-beauty-paso-4-15-g', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, 'Tratamiento profundo que rellena, fortalece y engrosa la pestaña para un acabado más sano y denso.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BOTOX-LION-BEAUTY-PASO-4-15-G', null, null, null, 13420, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/botox-lion-beauty-paso-4-15-g.jpg', 'Botox Lion Beauty paso 4 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Hidralash Lion Beauty paso 3 15 g', 'hidralash-lion-beauty-paso-3-15-g', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, 'Hidrata y repara la pestaña después del lifting, devolviendo brillo y suavidad.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'HIDRALASH-LION-BEAUTY-PASO-3-15-G', null, null, null, 13420, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/hidralash-lion-beauty-paso-3-15-g.jpg', 'Hidralash Lion Beauty paso 3 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Keratin Vitamin Zaphiria sérum final para lifting 15 g', 'keratin-vitamin-zaphiria-serum-final-para-lifting-15-g', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KERATIN-VITAMIN-ZAPHIRIA-SERUM-FINAL-PARA-LIFTING-15-G', null, null, null, 21300, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/keratin-vitamin-zaphiria-serum-final-para-lifting-15-g.jpg', 'Keratin Vitamin Zaphiria sérum final para lifting 15 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Nutrición Lady''s Eye monodosis', 'nutricion-lady-s-eye-monodosis', null, (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'NUTRICION-LADY-S-EYE-MONODOSIS', null, null, null, 1100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/nutricion-lady-s-eye-monodosis.jpg', 'Nutrición Lady''s Eye monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Paso 1 y 2 lifting Lady''s Eye', 'paso-1-y-2-lifting-lady-s-eye', null, (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, 'Precio por par.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASO-1-Y-2-LIFTING-LADY-S-EYE', null, null, null, 2120, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/paso-1-y-2-lifting-lady-s-eye.jpg', 'Paso 1 y 2 lifting Lady''s Eye', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pasos de lifting Lomansa', 'pasos-de-lifting-lomansa', (select id from brands where slug = 'lomansa'), (select id from categories where slug = 'nutricion-botox'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASOS-DE-LIFTING-LOMANSA-PASO1Y2PAR', 'Paso 1 y 2 (par)', null, null, 5700, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASOS-DE-LIFTING-LOMANSA-PASO3', 'Paso 3', null, null, 2200, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pasos-de-lifting-lomansa.jpg', 'Pasos de lifting Lomansa', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit de lifting Iconsign Premium', 'kit-de-lifting-iconsign-premium', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', true, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-DE-LIFTING-ICONSIGN-PREMIUM', null, null, null, 27000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-de-lifting-iconsign-premium.jpg', 'Kit de lifting Iconsign Premium', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit 2 en 1 Iconsign laminado y lifting', 'kit-2-en-1-iconsign-laminado-y-lifting', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-2-EN-1-ICONSIGN-LAMINADO-Y-LIFTING', null, null, null, 20300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-2-en-1-iconsign-laminado-y-lifting.jpg', 'Kit 2 en 1 Iconsign laminado y lifting', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Kit laminado y lifting acción rápida Golle', 'kit-laminado-y-lifting-accion-rapida-golle', (select id from brands where slug = 'golle'), (select id from categories where slug = 'kits-lifting'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KIT-LAMINADO-Y-LIFTING-ACCION-RAPIDA-GOLLE', null, null, null, 28800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/kit-laminado-y-lifting-accion-rapida-golle.jpg', 'Kit laminado y lifting acción rápida Golle', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Paso 1 y 2 Melania 10 ml', 'paso-1-y-2-melania-10-ml', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASO-1-Y-2-MELANIA-10-ML', null, null, null, 56100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/paso-1-y-2-melania-10-ml.jpg', 'Paso 1 y 2 Melania 10 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pro Lash Keratin Melania 15 g', 'pro-lash-keratin-melania-15-g', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRO-LASH-KERATIN-MELANIA-15-G', null, null, null, 19250, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pro-lash-keratin-melania-15-g.jpg', 'Pro Lash Keratin Melania 15 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pro-lash-keratin-melania-15-g-2.jpg', 'Pro Lash Keratin Melania 15 g', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pro Lash Botox Melania 15 g', 'pro-lash-botox-melania-15-g', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRO-LASH-BOTOX-MELANIA-15-G', null, null, null, 20680, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pro-lash-botox-melania-15-g.jpg', 'Pro Lash Botox Melania 15 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pro-lash-botox-melania-15-g-2.jpg', 'Pro Lash Botox Melania 15 g', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pro Hidraluxe Melania', 'pro-hidraluxe-melania', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRO-HIDRALUXE-MELANIA', null, null, null, 20730, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pro-hidraluxe-melania.jpg', 'Pro Hidraluxe Melania', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Paso 1 y 2 Melania monodosis', 'paso-1-y-2-melania-monodosis', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASO-1-Y-2-MELANIA-MONODOSIS', null, null, null, 4180, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/paso-1-y-2-melania-monodosis.jpg', 'Paso 1 y 2 Melania monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Keratina Melania monodosis', 'keratina-melania-monodosis', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'KERATINA-MELANIA-MONODOSIS', null, null, null, 1980, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/keratina-melania-monodosis.jpg', 'Keratina Melania monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Botox Melania monodosis', 'botox-melania-monodosis', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BOTOX-MELANIA-MONODOSIS', null, null, null, 1980, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/botox-melania-monodosis.jpg', 'Botox Melania monodosis', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Lash One crecimiento de cejas y pestañas Melania', 'lash-one-crecimiento-de-cejas-y-pestanas-melania', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'LASH-ONE-CRECIMIENTO-DE-CEJAS-Y-PESTANAS-MELANIA', null, null, null, 20350, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/lash-one-crecimiento-de-cejas-y-pestanas-melania.jpg', 'Lash One crecimiento de cejas y pestañas Melania', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pro Elixir Melania', 'pro-elixir-melania', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PRO-ELIXIR-MELANIA', null, null, null, 20730, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pro-elixir-melania.jpg', 'Pro Elixir Melania', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Easy Gel Melania', 'easy-gel-melania', (select id from brands where slug = 'melania'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'EASY-GEL-MELANIA', null, null, null, 18150, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/easy-gel-melania.jpg', 'Easy Gel Melania', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Paso 1 lifting Charito Ferrari 10 ml', 'paso-1-lifting-charito-ferrari-10-ml', (select id from brands where slug = 'charito-ferrari'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASO-1-LIFTING-CHARITO-FERRARI-10-ML', null, null, null, 18300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/paso-1-lifting-charito-ferrari-10-ml.jpg', 'Paso 1 lifting Charito Ferrari 10 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Paso 2 lifting Charito Ferrari 10 ml', 'paso-2-lifting-charito-ferrari-10-ml', (select id from brands where slug = 'charito-ferrari'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PASO-2-LIFTING-CHARITO-FERRARI-10-ML', null, null, null, 18300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/paso-2-lifting-charito-ferrari-10-ml.jpg', 'Paso 2 lifting Charito Ferrari 10 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Botox Charito Ferrari', 'botox-charito-ferrari', (select id from brands where slug = 'charito-ferrari'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BOTOX-CHARITO-FERRARI', null, null, null, 22700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/botox-charito-ferrari.jpg', 'Botox Charito Ferrari', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Gel nutritivo Iconsign 5 g', 'gel-nutritivo-iconsign-5-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'GEL-NUTRITIVO-ICONSIGN-5-G', null, null, null, 7560, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/gel-nutritivo-iconsign-5-g.jpg', 'Gel nutritivo Iconsign 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Oil nutritivo Iconsign 5 g', 'oil-nutritivo-iconsign-5-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'nutricion-botox'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'OIL-NUTRITIVO-ICONSIGN-5-G', null, null, null, 11350, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/oil-nutritivo-iconsign-5-g.jpg', 'Oil nutritivo Iconsign 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo para lifting Lomansa 10 g', 'balsamo-para-lifting-lomansa-10-g', (select id from brands where slug = 'lomansa'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-LOMANSA-10-G', null, null, null, 9800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-lomansa-10-g.jpg', 'Bálsamo para lifting Lomansa 10 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pegamento para lifting Lomansa 5 ml', 'pegamento-para-lifting-lomansa-5-ml', (select id from brands where slug = 'lomansa'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PEGAMENTO-PARA-LIFTING-LOMANSA-5-ML', null, null, null, 11550, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pegamento-para-lifting-lomansa-5-ml.jpg', 'Pegamento para lifting Lomansa 5 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo para bigudíes Iconsign', 'adhesivo-para-bigudies-iconsign', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-PARA-BIGUDIES-ICONSIGN', null, null, null, 4300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-para-bigudies-iconsign.jpg', 'Adhesivo para bigudíes Iconsign', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo para bigudíes CG', 'adhesivo-para-bigudies-cg', null, (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-PARA-BIGUDIES-CG', null, null, null, 4100, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-para-bigudies-cg.jpg', 'Adhesivo para bigudíes CG', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo para bigudíes Pro Glue Melania', 'adhesivo-para-bigudies-pro-glue-melania', (select id from brands where slug = 'melania'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-PARA-BIGUDIES-PRO-GLUE-MELANIA', null, null, null, 19580, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-para-bigudies-pro-glue-melania.jpg', 'Adhesivo para bigudíes Pro Glue Melania', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Fixing Gel adhesivo para bigudíes de silicona 8 ml', 'fixing-gel-adhesivo-para-bigudies-de-silicona-8-ml', null, (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'FIXING-GEL-ADHESIVO-PARA-BIGUDIES-DE-SILICONA-8-ML', null, null, null, 16120, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/fixing-gel-adhesivo-para-bigudies-de-silicona-8-ml.jpg', 'Fixing Gel adhesivo para bigudíes de silicona 8 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Royal Stick adhesivo para bigudíes 5 ml', 'royal-stick-adhesivo-para-bigudies-5-ml', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ROYAL-STICK-ADHESIVO-PARA-BIGUDIES-5-ML', null, null, null, 16500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/royal-stick-adhesivo-para-bigudies-5-ml.jpg', 'Royal Stick adhesivo para bigudíes 5 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Adhesivo para bigudíes Lumi Zaphiria', 'adhesivo-para-bigudies-lumi-zaphiria', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ADHESIVO-PARA-BIGUDIES-LUMI-ZAPHIRIA', null, null, null, 13120, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/adhesivo-para-bigudies-lumi-zaphiria.jpg', 'Adhesivo para bigudíes Lumi Zaphiria', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo Lumi Zaphiria 15 ml', 'balsamo-lumi-zaphiria-15-ml', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-LUMI-ZAPHIRIA-15-ML', null, null, null, 12000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-lumi-zaphiria-15-ml.jpg', 'Bálsamo Lumi Zaphiria 15 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo para lifting Cherimoya 5 g', 'balsamo-para-lifting-cherimoya-5-g', (select id from brands where slug = 'cherimoya'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-CHERIMOYA-5-G', null, null, null, 8900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-cherimoya-5-g.jpg', 'Bálsamo para lifting Cherimoya 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo para lifting Iconsign 8 g', 'balsamo-para-lifting-iconsign-8-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-ICONSIGN-8-G', null, null, null, 12570, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-iconsign-8-g.jpg', 'Bálsamo para lifting Iconsign 8 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo para lifting Iconsign 8 g peach o avocado', 'balsamo-para-lifting-iconsign-8-g-peach-o-avocado', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'adhesivo-bigudies'), 'variants', '{"Aroma"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-ICONSIGN-8-G-PEACH-O-AVOCADO-PEACH', 'Peach', null, null, 11666, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-ICONSIGN-8-G-PEACH-O-AVOCADO-AVOCADO', 'Avocado', null, null, 11666, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-iconsign-8-g-peach-o-avocado.jpg', 'Bálsamo para lifting Iconsign 8 g peach o avocado', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Polvo espesante Clione', 'polvo-espesante-clione', (select id from brands where slug = 'clione'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'POLVO-ESPESANTE-CLIONE', null, null, null, 32250, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/polvo-espesante-clione.jpg', 'Polvo espesante Clione', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Polvo espesador de paso 1 y 2 de lifting 5 g', 'polvo-espesador-de-paso-1-y-2-de-lifting-5-g', null, (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'POLVO-ESPESADOR-DE-PASO-1-Y-2-DE-LIFTING-5-G', null, null, null, 10250, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/polvo-espesador-de-paso-1-y-2-de-lifting-5-g.jpg', 'Polvo espesador de paso 1 y 2 de lifting 5 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo para lifting Awa Stick Lion Beauty 15 g', 'balsamo-para-lifting-awa-stick-lion-beauty-15-g', (select id from brands where slug = 'the-lion-beauty'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-AWA-STICK-LION-BEAUTY-15-G', null, null, null, 22120, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-awa-stick-lion-beauty-15-g.jpg', 'Bálsamo para lifting Awa Stick Lion Beauty 15 g', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-awa-stick-lion-beauty-15-g-2.jpg', 'Bálsamo para lifting Awa Stick Lion Beauty 15 g', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Bálsamo para lifting Iconsign super sticky 8 g', 'balsamo-para-lifting-iconsign-super-sticky-8-g', (select id from brands where slug = 'iconsign'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'BALSAMO-PARA-LIFTING-ICONSIGN-SUPER-STICKY-8-G', null, null, null, 10400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/balsamo-para-lifting-iconsign-super-sticky-8-g.jpg', 'Bálsamo para lifting Iconsign super sticky 8 g', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pegamento para lifting Stars Colors 5 ml', 'pegamento-para-lifting-stars-colors-5-ml', (select id from brands where slug = 'stars-colors'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PEGAMENTO-PARA-LIFTING-STARS-COLORS-5-ML', null, null, null, 4500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pegamento-para-lifting-stars-colors-5-ml.jpg', 'Pegamento para lifting Stars Colors 5 ml', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Zaphiria Lashes Spike gel para espigas', 'zaphiria-lashes-spike-gel-para-espigas', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'adhesivo-bigudies'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ZAPHIRIA-LASHES-SPIKE-GEL-PARA-ESPIGAS', null, null, null, 8000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/zaphiria-lashes-spike-gel-para-espigas.jpg', 'Zaphiria Lashes Spike gel para espigas', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/zaphiria-lashes-spike-gel-para-espigas-2.jpg', 'Zaphiria Lashes Spike gel para espigas', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix Nagaraku 0.03', 'pestanas-mix-nagaraku-0-03', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-0-03-D-0.03-MIX', 'D', '0.03', 'Mix', 7500, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-0-03-C-0.03-MEDIDANICA', 'C', '0.03', 'Medida única', 8100, 10, 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix Nagaraku Premium curva D', 'pestanas-mix-nagaraku-premium-curva-d', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-PREMIUM-CURVA-D-D-0.05-MIX', 'D', '0.05', 'Mix', 5600, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-PREMIUM-CURVA-D-D-0.07-MIX', 'D', '0.07', 'Mix', 5600, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-PREMIUM-CURVA-D-D-0.10-MIX', 'D', '0.10', 'Mix', 5600, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-PREMIUM-CURVA-D-D-0.12-MIX', 'D', '0.12', 'Mix', 5600, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-PREMIUM-CURVA-D-D-0.15-MIX', 'D', '0.15', 'Mix', 5600, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-PREMIUM-CURVA-D-D-0.20-MIX', 'D', '0.20', 'Mix', 5600, 10, 5);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Nagaraku Mix 0.07 N', 'pestanas-nagaraku-mix-0-07-n', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-MIX-0-07-N-D-0.07-MIX', 'D', '0.07', 'Mix', 10300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-nagaraku-mix-0-07-n.jpg', 'Pestañas Nagaraku Mix 0.07 N', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Nagaraku única medida curva D', 'pestanas-nagaraku-unica-medida-curva-d', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'medida-unica'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-UNICA-MEDIDA-CURVA-D-D-0.05-MEDIDANICA', 'D', '0.05', 'Medida única', 4830, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-UNICA-MEDIDA-CURVA-D-D-0.07-MEDIDANICA', 'D', '0.07', 'Medida única', 4830, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-UNICA-MEDIDA-CURVA-D-D-0.10-MEDIDANICA', 'D', '0.10', 'Medida única', 4830, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-UNICA-MEDIDA-CURVA-D-D-0.12-MEDIDANICA', 'D', '0.12', 'Medida única', 4830, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-UNICA-MEDIDA-CURVA-D-D-0.15-MEDIDANICA', 'D', '0.15', 'Medida única', 4830, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-UNICA-MEDIDA-CURVA-D-D-0.20-MEDIDANICA', 'D', '0.20', 'Medida única', 4830, 10, 5);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix Nagaraku Marrón', 'pestanas-mix-nagaraku-marron', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-MARRON-C-0.07-MIX', 'C', '0.07', 'Mix', 6860, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-MARRON-C-0.10-MIX', 'C', '0.10', 'Mix', 6860, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-MARRON-C-0.15-MIX', 'C', '0.15', 'Mix', 6860, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-MARRON-D-0.07-MIX', 'D', '0.07', 'Mix', 6860, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-MARRON-D-0.10-MIX', 'D', '0.10', 'Mix', 6860, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-MARRON-D-0.15-MIX', 'D', '0.15', 'Mix', 6860, 10, 5);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-mix-nagaraku-marron.jpg', 'Pestañas Mix Nagaraku Marrón', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Under curva J mix 5, 6 y 7 mm', 'pestanas-under-curva-j-mix-5-6-y-7-mm', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-UNDER-CURVA-J-MIX-5-6-Y-7-MM-J-NICA-MIX5-7MM', 'J', 'Única', 'Mix 5-7 mm', 6200, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix Nagaraku curva L', 'pestanas-mix-nagaraku-curva-l', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-CURVA-L-L-0.07-MIX', 'L', '0.07', 'Mix', 10900, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-CURVA-L-L-0.10-MIX', 'L', '0.10', 'Mix', 10900, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-mix-nagaraku-curva-l.jpg', 'Pestañas Mix Nagaraku curva L', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix 0.07 LD', 'pestanas-mix-0-07-ld', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-0-07-LD-LD-0.07-MIX', 'LD', '0.07', 'Mix', 11100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-mix-0-07-ld.jpg', 'Pestañas Mix 0.07 LD', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas V-Shape Bottom 0.07 C', 'pestanas-v-shape-bottom-0-07-c', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-V-SHAPE-BOTTOM-0-07-C', null, null, null, 5000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-v-shape-bottom-0-07-c.jpg', 'Pestañas V-Shape Bottom 0.07 C', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Under Bottom Ellipse 0.20 J', 'pestanas-under-bottom-ellipse-0-20-j', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-UNDER-BOTTOM-ELLIPSE-0-20-J', null, null, null, 7100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-under-bottom-ellipse-0-20-j.jpg', 'Pestañas Under Bottom Ellipse 0.20 J', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas YY-Shape Nagaraku 0.07 D medida única 8 a 14 mm', 'pestanas-yy-shape-nagaraku-0-07-d-medida-unica-8-a-14-mm', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-YY-SHAPE-NAGARAKU-0-07-D-MEDIDA-UNICA-8-A-14-MM', null, null, null, 9020, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-yy-shape-nagaraku-0-07-d-medida-unica-8-a-14-mm.jpg', 'Pestañas YY-Shape Nagaraku 0.07 D medida única 8 a 14 mm', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix YY-Shape Nagaraku', 'pestanas-mix-yy-shape-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Curva y grosor"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-YY-SHAPE-NAGARAKU-0.05D', '0.05 D', null, null, 9020, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-YY-SHAPE-NAGARAKU-0.07C', '0.07 C', null, null, 9020, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-YY-SHAPE-NAGARAKU-0.07D', '0.07 D', null, null, 9020, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-mix-yy-shape-nagaraku.jpg', 'Pestañas Mix YY-Shape Nagaraku', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas W-Shape Nagaraku mix 0.07 D', 'pestanas-w-shape-nagaraku-mix-0-07-d', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Tipo"}', 'active', false, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-3D', '3D', null, null, 10500, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-4D', '4D', null, null, 14700, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-5D', '5D', null, null, 16450, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-6D', '6D', null, null, 21347, 10, 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-w-shape-nagaraku-mix-0-07-d.jpg', 'Pestañas W-Shape Nagaraku mix 0.07 D', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Triple Tips Y-Shape (YYY) Nagaraku', 'pestanas-triple-tips-y-shape-yyy-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-TRIPLE-TIPS-Y-SHAPE-YYY-NAGARAKU', null, null, null, 8000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-triple-tips-y-shape-yyy-nagaraku.jpg', 'Pestañas Triple Tips Y-Shape (YYY) Nagaraku', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Nagaraku curvas L / LU', 'pestanas-nagaraku-curvas-l-lu', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-CURVAS-L-LU-2D', '2D', null, null, 9900, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-CURVAS-L-LU-3D', '3D', null, null, 9900, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-nagaraku-curvas-l-lu.jpg', 'Pestañas Nagaraku curvas L / LU', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-nagaraku-curvas-l-lu-2.jpg', 'Pestañas Nagaraku curvas L / LU', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-nagaraku-curvas-l-lu-3.jpg', 'Pestañas Nagaraku curvas L / LU', 2);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Single Tips 2D Y Nagaraku', 'pestanas-single-tips-2d-y-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-SINGLE-TIPS-2D-Y-NAGARAKU', null, null, null, 6650, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-single-tips-2d-y-nagaraku.jpg', 'Pestañas Single Tips 2D Y Nagaraku', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Big Box Nagaraku 54 filas', 'pestanas-big-box-nagaraku-54-filas', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-BIG-BOX-NAGARAKU-54-FILAS-3DW', '3D W', null, null, 26680, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-BIG-BOX-NAGARAKU-54-FILAS-CLSICAS0.07DMIX', 'Clásicas 0.07 D mix', null, null, 17150, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-BIG-BOX-NAGARAKU-54-FILAS-YY', 'YY', null, null, 20580, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-BIG-BOX-NAGARAKU-54-FILAS-4DW', '4D W', null, null, 30230, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-BIG-BOX-NAGARAKU-54-FILAS-5DW', '5D W', null, null, 33230, 10, 4);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-big-box-nagaraku-54-filas.jpg', 'Pestañas Big Box Nagaraku 54 filas', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-big-box-nagaraku-54-filas-2.jpg', 'Pestañas Big Box Nagaraku 54 filas', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-big-box-nagaraku-54-filas-3.jpg', 'Pestañas Big Box Nagaraku 54 filas', 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-big-box-nagaraku-54-filas-4.jpg', 'Pestañas Big Box Nagaraku 54 filas', 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-big-box-nagaraku-54-filas-5.jpg', 'Pestañas Big Box Nagaraku 54 filas', 4);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Nagaraku Spire, Wings y Fairy', 'pestanas-nagaraku-spire-wings-y-fairy', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-SPIRE-WINGS-Y-FAIRY-SPIRE', 'Spire', null, null, 6980, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-SPIRE-WINGS-Y-FAIRY-WINGS', 'Wings', null, null, 6980, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-SPIRE-WINGS-Y-FAIRY-FAIRY', 'Fairy', null, null, 6980, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-nagaraku-spire-wings-y-fairy.jpg', 'Pestañas Nagaraku Spire, Wings y Fairy', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Zaphiria Wings', 'pestanas-zaphiria-wings', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-WINGS', null, null, null, 7035, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-wings.jpg', 'Pestañas Zaphiria Wings', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-wings-2.jpg', 'Pestañas Zaphiria Wings', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Zaphiria Spire', 'pestanas-zaphiria-spire', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-SPIRE', null, null, null, 7035, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-spire.jpg', 'Pestañas Zaphiria Spire', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Zaphiria Spire Fan', 'pestanas-zaphiria-spire-fan', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-SPIRE-FAN', null, null, null, 7035, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-spire-fan.jpg', 'Pestañas Zaphiria Spire Fan', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Mix Nagaraku curva N', 'pestanas-mix-nagaraku-curva-n', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'pestanas-mix'), 'lash_matrix', '{"Curvatura","Grosor","Largo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-CURVA-N-N-0.07-MIX', 'N', '0.07', 'Mix', 9400, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-CURVA-N-N-0.10-MIX', 'N', '0.10', 'Mix', 9400, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MIX-NAGARAKU-CURVA-N-N-0.15-MIX', 'N', '0.15', 'Mix', 9400, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-mix-nagaraku-curva-n.jpg', 'Pestañas Mix Nagaraku curva N', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestaña de práctica 8 y 10 mm', 'pestana-de-practica-8-y-10-mm', null, (select id from categories where slug = 'pestanas-de-practica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANA-DE-PRACTICA-8-Y-10-MM', null, null, null, 2600, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestana-de-practica-8-y-10-mm.jpg', 'Pestaña de práctica 8 y 10 mm', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Y-Shape Brown mix 0.07 D', 'pestanas-y-shape-brown-mix-0-07-d', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-Y-SHAPE-BROWN-MIX-0-07-D', null, null, null, 10800, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-y-shape-brown-mix-0-07-d.jpg', 'Pestañas Y-Shape Brown mix 0.07 D', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Nagaraku curva J medida única (consultar medida)', 'pestanas-nagaraku-curva-j-medida-unica-consultar-medida', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'medida-unica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-NAGARAKU-CURVA-J-MEDIDA-UNICA-CONSULTAR-MEDIDA', null, null, null, 7000, 10, 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestaña de práctica x 10 pares', 'pestana-de-practica-x-10-pares', null, (select id from categories where slug = 'pestanas-de-practica'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANA-DE-PRACTICA-X-10-PARES', null, null, null, 5400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestana-de-practica-x-10-pares.jpg', 'Pestaña de práctica x 10 pares', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Zaphiria Lumi W mix 0.07', 'pestanas-zaphiria-lumi-w-mix-0-07', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'volumen-tecnologico'), 'lash_matrix', '{"Curvatura","Tipo","Largo"}', 'active', true, true, 'Fibras W prehechas para volumen tecnológico, grosor 0.07, en cajas mix de 8 a 14 mm. Elegí curva y tipo, y sumá todas las cajas que necesites.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-3D-MIX8-14MM', 'D', '3D', 'Mix 8-14 mm', 7000, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-4D-MIX8-14MM', 'D', '4D', 'Mix 8-14 mm', 7850, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-5D-MIX8-14MM', 'D', '5D', 'Mix 8-14 mm', 9100, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-6D-MIX8-14MM', 'D', '6D', 'Mix 8-14 mm', 9900, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-N-4D-MIX8-14MM', 'N', '4D', 'Mix 8-14 mm', 10100, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-N-5D-MIX8-14MM', 'N', '5D', 'Mix 8-14 mm', 12100, 10, 5);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-N-6D-MIX8-14MM', 'N', '6D', 'Mix 8-14 mm', 12600, 10, 6);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-lumi-w-mix-0-07.jpg', 'Pestañas Zaphiria Lumi W mix 0.07', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-lumi-w-mix-0-07-2.jpg', 'Pestañas Zaphiria Lumi W mix 0.07', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-lumi-w-mix-0-07-3.jpg', 'Pestañas Zaphiria Lumi W mix 0.07', 2);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Zaphiria W 0.07 D mix 8 a 14 mm', 'pestanas-zaphiria-w-0-07-d-mix-8-a-14-mm', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'volumen-tecnologico'), 'lash_matrix', '{"Curvatura","Tipo","Largo"}', 'active', false, true, 'Fibras W prehechas, grosor 0.07, curva D, en cajas mix de 8 a 14 mm. Elegí el tipo y sumá todas las cajas que necesites.')
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-3D-MIX8-14MM', 'D', '3D', 'Mix 8-14 mm', 8390, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-4D-MIX8-14MM', 'D', '4D', 'Mix 8-14 mm', 10185, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-5D-MIX8-14MM', 'D', '5D', 'Mix 8-14 mm', 10500, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-6D-MIX8-14MM', 'D', '6D', 'Mix 8-14 mm', 13650, 10, 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-w-0-07-d-mix-8-a-14-mm.jpg', 'Pestañas Zaphiria W 0.07 D mix 8 a 14 mm', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-w-0-07-d-mix-8-a-14-mm-2.jpg', 'Pestañas Zaphiria W 0.07 D mix 8 a 14 mm', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-zaphiria-w-0-07-d-mix-8-a-14-mm-3.jpg', 'Pestañas Zaphiria W 0.07 D mix 8 a 14 mm', 2);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas 2D UU Nagaraku', 'pestanas-2d-uu-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-2D-UU-NAGARAKU', null, null, null, 8500, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-2d-uu-nagaraku.jpg', 'Pestañas 2D UU Nagaraku', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas 2D UU Nagaraku 54 filas', 'pestanas-2d-uu-nagaraku-54-filas', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-2D-UU-NAGARAKU-54-FILAS', null, null, null, 27400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-2d-uu-nagaraku-54-filas.jpg', 'Pestañas 2D UU Nagaraku 54 filas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas 4D U Zaphiria', 'pestanas-4d-u-zaphiria', (select id from brands where slug = 'zaphiria'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-4D-U-ZAPHIRIA', null, null, null, 13000, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-4d-u-zaphiria.jpg', 'Pestañas 4D U Zaphiria', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-4d-u-zaphiria-2.jpg', 'Pestañas 4D U Zaphiria', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas U Nagaraku', 'pestanas-u-nagaraku', (select id from brands where slug = 'nagaraku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-U-NAGARAKU-3DU', '3D U', null, null, 15620, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-U-NAGARAKU-4DU', '4D U', null, null, 17400, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-U-NAGARAKU-5DU', '5D U', null, null, 19459, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-u-nagaraku.jpg', 'Pestañas U Nagaraku', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-u-nagaraku-2.jpg', 'Pestañas U Nagaraku', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-u-nagaraku-3.jpg', 'Pestañas U Nagaraku', 2);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas YY Mix D Abruxlashes', 'pestanas-yy-mix-d-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-YY-MIX-D-ABRUXLASHES', null, null, null, 21100, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-yy-mix-d-abruxlashes.jpg', 'Pestañas YY Mix D Abruxlashes', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-yy-mix-d-abruxlashes-2.jpg', 'Pestañas YY Mix D Abruxlashes', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Rimel Tech YY UU Mix M Abruxlashes', 'pestanas-rimel-tech-yy-uu-mix-m-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-RIMEL-TECH-YY-UU-MIX-M-ABRUXLASHES', null, null, null, 21100, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-rimel-tech-yy-uu-mix-m-abruxlashes.jpg', 'Pestañas Rimel Tech YY UU Mix M Abruxlashes', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-rimel-tech-yy-uu-mix-m-abruxlashes-2.jpg', 'Pestañas Rimel Tech YY UU Mix M Abruxlashes', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Eye Liner Effect 4U B+C+L Abruxlashes', 'pestanas-eye-liner-effect-4u-b-c-l-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-EYE-LINER-EFFECT-4U-B-C-L-ABRUXLASHES', null, null, null, 25000, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-eye-liner-effect-4u-b-c-l-abruxlashes.jpg', 'Pestañas Eye Liner Effect 4U B+C+L Abruxlashes', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-eye-liner-effect-4u-b-c-l-abruxlashes-2.jpg', 'Pestañas Eye Liner Effect 4U B+C+L Abruxlashes', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Foxy Effect 4U C+M Abruxlashes', 'pestanas-foxy-effect-4u-c-m-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-FOXY-EFFECT-4U-C-M-ABRUXLASHES', null, null, null, 25000, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-foxy-effect-4u-c-m-abruxlashes.jpg', 'Pestañas Foxy Effect 4U C+M Abruxlashes', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-foxy-effect-4u-c-m-abruxlashes-2.jpg', 'Pestañas Foxy Effect 4U C+M Abruxlashes', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Brown Chocolate Bar curva CC Abruxlashes', 'pestanas-brown-chocolate-bar-curva-cc-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'volumen-tecnologico'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-BROWN-CHOCOLATE-BAR-CURVA-CC-ABRUXLASHES', null, null, null, 25000, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-brown-chocolate-bar-curva-cc-abruxlashes.jpg', 'Pestañas Brown Chocolate Bar curva CC Abruxlashes', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-brown-chocolate-bar-curva-cc-abruxlashes-2.jpg', 'Pestañas Brown Chocolate Bar curva CC Abruxlashes', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pestañas Masscaku W prehechas', 'pestanas-masscaku-w-prehechas', (select id from brands where slug = 'masscaku'), (select id from categories where slug = 'volumen-tecnologico'), 'variants', '{"Tipo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-YYDOUBLETIPS', 'YY Double Tips', null, null, 8500, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-3D-W', '3D-W', null, null, 9000, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-4D-W', '4D-W', null, null, 10000, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-4D-WM', '4D-W M', null, null, 14000, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-5D-W', '5D-W', null, null, 10500, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-6D-WW', '6D-WW', null, null, 13900, 10, 5);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PESTANAS-MASSCAKU-W-PREHECHAS-2DUUYYUU', '2D UU (YY UU)', null, null, 10500, 10, 6);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-masscaku-w-prehechas.jpg', 'Pestañas Masscaku W prehechas', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-masscaku-w-prehechas-2.jpg', 'Pestañas Masscaku W prehechas', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-masscaku-w-prehechas-3.jpg', 'Pestañas Masscaku W prehechas', 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-masscaku-w-prehechas-4.jpg', 'Pestañas Masscaku W prehechas', 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-masscaku-w-prehechas-5.jpg', 'Pestañas Masscaku W prehechas', 4);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pestanas-masscaku-w-prehechas-6.jpg', 'Pestañas Masscaku W prehechas', 5);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Carrito ayudante de 4 pisos metálico', 'carrito-ayudante-de-4-pisos-metalico', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CARRITO-AYUDANTE-DE-4-PISOS-METALICO', null, null, null, 49245, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/carrito-ayudante-de-4-pisos-metalico.jpg', 'Carrito ayudante de 4 pisos metálico', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Carrito ayudante de 3 pisos plástico', 'carrito-ayudante-de-3-pisos-plastico', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CARRITO-AYUDANTE-DE-3-PISOS-PLASTICO', null, null, null, 23100, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/carrito-ayudante-de-3-pisos-plastico.jpg', 'Carrito ayudante de 3 pisos plástico', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Carrito ayudante de 3 pisos metálico', 'carrito-ayudante-de-3-pisos-metalico', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CARRITO-AYUDANTE-DE-3-PISOS-METALICO', null, null, null, 43700, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/carrito-ayudante-de-3-pisos-metalico.jpg', 'Carrito ayudante de 3 pisos metálico', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Organizador acrílico chico', 'organizador-acrilico-chico', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ORGANIZADOR-ACRILICO-CHICO', null, null, null, 9700, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/organizador-acrilico-chico.jpg', 'Organizador acrílico chico', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Organizador acrílico con cajones', 'organizador-acrilico-con-cajones', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ORGANIZADOR-ACRILICO-CON-CAJONES', null, null, null, 20874, 0, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/organizador-acrilico-con-cajones.jpg', 'Organizador acrílico con cajones', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Organizador acrílico grande con cajones', 'organizador-acrilico-grande-con-cajones', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ORGANIZADOR-ACRILICO-GRANDE-CON-CAJONES', null, null, null, 30650, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/organizador-acrilico-grande-con-cajones.jpg', 'Organizador acrílico grande con cajones', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Organizador blanco con cajones', 'organizador-blanco-con-cajones', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ORGANIZADOR-BLANCO-CON-CAJONES', null, null, null, 28000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/organizador-blanco-con-cajones.jpg', 'Organizador blanco con cajones', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Organizador acrílico con cajones negros', 'organizador-acrilico-con-cajones-negros', null, (select id from categories where slug = 'mobiliario'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ORGANIZADOR-ACRILICO-CON-CAJONES-NEGROS', null, null, null, 23200, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/organizador-acrilico-con-cajones-negros.jpg', 'Organizador acrílico con cajones negros', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Apoya cabezas', 'apoya-cabezas', null, (select id from categories where slug = 'mobiliario'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'APOYA-CABEZAS-CONSULTARCOLORES', 'Consultar colores', null, null, 19900, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/apoya-cabezas.jpg', 'Apoya cabezas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cubrecamilla importada', 'cubrecamilla-importada', null, (select id from categories where slug = 'mobiliario'), 'variants', '{"Modelo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CUBRECAMILLA-IMPORTADA-LYCRAROSA', 'Lycra rosa', null, null, 20800, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CUBRECAMILLA-IMPORTADA-LYCRANEGRA', 'Lycra negra', null, null, 20800, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CUBRECAMILLA-IMPORTADA-NEGRA180X60', 'Negra 180 x 60', null, null, 17900, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CUBRECAMILLA-IMPORTADA-NEGRA190X80', 'Negra 190 x 80', null, null, 22900, 10, 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cubrecamilla-importada.jpg', 'Cubrecamilla importada', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cubrecamilla-importada-2.jpg', 'Cubrecamilla importada', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Colchoneta para camilla', 'colchoneta-para-camilla', null, (select id from categories where slug = 'mobiliario'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'COLCHONETA-PARA-CAMILLA-CONSULTARCOLORES', 'Consultar colores', null, null, 45000, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/colchoneta-para-camilla.jpg', 'Colchoneta para camilla', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Cubrecamillas descartables', 'cubrecamillas-descartables', null, (select id from categories where slug = 'mobiliario'), 'variants', '{"Presentación"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CUBRECAMILLAS-DESCARTABLES-UNIDAD', 'Unidad', null, null, 1000, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'CUBRECAMILLAS-DESCARTABLES-X10', 'x 10', null, null, 9500, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/cubrecamillas-descartables.jpg', 'Cubrecamillas descartables', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Manta de polar 180 x 180', 'manta-de-polar-180-x-180', null, (select id from categories where slug = 'mobiliario'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MANTA-DE-POLAR-180-X-180-ROSA', 'Rosa', null, null, 27000, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'MANTA-DE-POLAR-180-X-180-NEGRO', 'Negro', null, null, 27000, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/manta-de-polar-180-x-180.jpg', 'Manta de polar 180 x 180', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Porta pinzas', 'porta-pinzas', null, (select id from categories where slug = 'pinzas'), 'variants', '{"Color"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTA-PINZAS-ROSA', 'Rosa', null, null, 7170, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTA-PINZAS-BLANCO', 'Blanco', null, null, 7170, 10, 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/porta-pinzas.jpg', 'Porta pinzas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Porta pinzas de lata', 'porta-pinzas-de-lata', null, (select id from categories where slug = 'pinzas'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTA-PINZAS-DE-LATA', null, null, null, 3300, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/porta-pinzas-de-lata.jpg', 'Porta pinzas de lata', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Porta pinzas de cuerina', 'porta-pinzas-de-cuerina', null, (select id from categories where slug = 'pinzas'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PORTA-PINZAS-DE-CUERINA', null, null, null, 2400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/porta-pinzas-de-cuerina.jpg', 'Porta pinzas de cuerina', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Tijeras', 'tijeras', null, (select id from categories where slug = 'pinzas'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'TIJERAS', null, null, null, 2310, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tijeras.jpg', 'Tijeras', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/tijeras-2.jpg', 'Tijeras', 1);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pinza de cejas Cherimoya', 'pinza-de-cejas-cherimoya', (select id from brands where slug = 'cherimoya'), (select id from categories where slug = 'pinzas'), 'variants', '{"Punta"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-DE-CEJAS-CHERIMOYA-OBLICUA', 'Oblicua', null, null, 2058, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-DE-CEJAS-CHERIMOYA-RECTA', 'Recta', null, null, 2058, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-DE-CEJAS-CHERIMOYA-DIAGONAL', 'Diagonal', null, null, 2058, 10, 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-de-cejas-cherimoya.jpg', 'Pinza de cejas Cherimoya', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pulsera anticaída para pinzas', 'pulsera-anticaida-para-pinzas', null, (select id from categories where slug = 'pinzas'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PULSERA-ANTICAIDA-PARA-PINZAS', null, null, null, 7400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pulsera-anticaida-para-pinzas.jpg', 'Pulsera anticaída para pinzas', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pinza Abruxlashes', 'pinza-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'pinzas'), 'variants', '{"Modelo"}', 'active', true, true, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-ABRUXLASHES-N-01', 'N-01', null, null, 14500, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-ABRUXLASHES-N-02', 'N-02', null, null, 13400, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-ABRUXLASHES-N-03', 'N-03', null, null, 14500, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-ABRUXLASHES-N-04', 'N-04', null, null, 12300, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-ABRUXLASHES-N-05', 'N-05', null, null, 12300, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-ABRUXLASHES-N-06', 'N-06', null, null, 13400, 10, 5);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-abruxlashes.jpg', 'Pinza Abruxlashes', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-abruxlashes-2.jpg', 'Pinza Abruxlashes', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-abruxlashes-3.jpg', 'Pinza Abruxlashes', 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-abruxlashes-4.jpg', 'Pinza Abruxlashes', 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-abruxlashes-5.jpg', 'Pinza Abruxlashes', 4);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-abruxlashes-6.jpg', 'Pinza Abruxlashes', 5);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Espejo Master Abruxlashes', 'espejo-master-abruxlashes', (select id from brands where slug = 'abruxlashes'), (select id from categories where slug = 'espejos'), 'simple', '{}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'ESPEJO-MASTER-ABRUXLASHES', null, null, null, 13400, 10, 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/espejo-master-abruxlashes.jpg', 'Espejo Master Abruxlashes', 0);

  insert into products (name, slug, brand_id, category_id, kind, option_names, status, featured, best_seller, description)
  values ('Pinza Lash Money Tweezer', 'pinza-lash-money-tweezer', null, (select id from categories where slug = 'pinzas'), 'variants', '{"Modelo"}', 'active', false, false, null)
  returning id into pid;
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-LASH-MONEY-TWEEZER-10K', '10K', null, null, 15500, 10, 0);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-LASH-MONEY-TWEEZER-20K', '20K', null, null, 13400, 10, 1);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-LASH-MONEY-TWEEZER-30K', '30K', null, null, 15600, 10, 2);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-LASH-MONEY-TWEEZER-40K', '40K', null, null, 13400, 10, 3);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-LASH-MONEY-TWEEZER-50K', '50K', null, null, 12300, 10, 4);
  insert into variants (product_id, sku, option1, option2, option3, price_list, stock, sort_order) values (pid, 'PINZA-LASH-MONEY-TWEEZER-60K', '60K', null, null, 12300, 10, 5);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-lash-money-tweezer.jpg', 'Pinza Lash Money Tweezer', 0);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-lash-money-tweezer-2.jpg', 'Pinza Lash Money Tweezer', 1);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-lash-money-tweezer-3.jpg', 'Pinza Lash Money Tweezer', 2);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-lash-money-tweezer-4.jpg', 'Pinza Lash Money Tweezer', 3);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-lash-money-tweezer-5.jpg', 'Pinza Lash Money Tweezer', 4);
  insert into product_images (product_id, url, alt, sort_order) values (pid, '/products/pinza-lash-money-tweezer-6.jpg', 'Pinza Lash Money Tweezer', 5);

end $$;
