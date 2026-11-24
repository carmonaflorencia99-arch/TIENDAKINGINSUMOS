-- =====================================================================
-- King Insumos — Pestañas separadas por Curvatura · Grosor · Largo
-- Ejecutar una vez en Supabase → SQL Editor, DESPUÉS de 8-stock-excel.sql.
-- Se puede volver a ejecutar sin problema.
-- Se conservan el stock y el precio de cada opción (se actualiza por SKU).
-- Generado con scripts/pestanas/generar_ejes.py
-- =====================================================================
begin;

-- 1) Opciones corregidas en el mismo producto
update products set kind = 'lash_matrix', option_names = '{"Curvatura","Grosor","Largo"}' where slug = 'pestanas-nagaraku-mix-0-07-n';
update variants set option1 = 'N', option2 = '0.07', option3 = 'Mix' where sku = 'PESTANAS-NAGARAKU-MIX-0-07-N-D-0.07-MIX';

update products set kind = 'lash_matrix', option_names = '{"Curvatura","Grosor","Largo"}' where slug = 'pestanas-under-curva-j-mix-5-6-y-7-mm';
update variants set option1 = 'J', option2 = '0.10', option3 = 'Mix 5-7 mm' where sku = 'PESTANAS-UNDER-CURVA-J-MIX-5-6-Y-7-MM-J-NICA-MIX5-7MM';

update products set kind = 'lash_matrix', option_names = '{"Curvatura","Grosor","Largo"}' where slug = 'pestanas-mix-yy-shape-nagaraku';
update variants set option1 = 'D', option2 = '0.05', option3 = 'Mix' where sku = 'PESTANAS-MIX-YY-SHAPE-NAGARAKU-0.05D';
update variants set option1 = 'C', option2 = '0.07', option3 = 'Mix' where sku = 'PESTANAS-MIX-YY-SHAPE-NAGARAKU-0.07C';
update variants set option1 = 'D', option2 = '0.07', option3 = 'Mix' where sku = 'PESTANAS-MIX-YY-SHAPE-NAGARAKU-0.07D';

update products set kind = 'lash_matrix', option_names = '{"Curvatura","Grosor","Largo"}' where slug = 'pestanas-y-shape-brown-mix-0-07-d';
update variants set option1 = 'D', option2 = '0.07', option3 = 'Mix' where sku = 'PESTANAS-Y-SHAPE-BROWN-MIX-0-07-D';

-- 2) Productos con eje 'Tipo': uno por tipo, con curva · grosor · largo
do $$
declare old_id bigint; new_id bigint;
begin
  select id into old_id from products where slug = 'pestanas-w-shape-nagaraku-mix-0-07-d';
  if old_id is not null then
    -- Pestañas W-Shape 3D Nagaraku mix 0.07 D
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas W-Shape 3D Nagaraku mix 0.07 D', 'pestanas-w-shape-3d-nagaraku-mix-0-07-d', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-w-shape-3d-nagaraku-mix-0-07-d';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas W-Shape 3D Nagaraku mix 0.07 D', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix', sort_order = 0 where sku = 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-3D';
    -- Pestañas W-Shape 4D Nagaraku mix 0.07 D
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas W-Shape 4D Nagaraku mix 0.07 D', 'pestanas-w-shape-4d-nagaraku-mix-0-07-d', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-w-shape-4d-nagaraku-mix-0-07-d';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas W-Shape 4D Nagaraku mix 0.07 D', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix', sort_order = 0 where sku = 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-4D';
    -- Pestañas W-Shape 5D Nagaraku mix 0.07 D
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas W-Shape 5D Nagaraku mix 0.07 D', 'pestanas-w-shape-5d-nagaraku-mix-0-07-d', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-w-shape-5d-nagaraku-mix-0-07-d';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas W-Shape 5D Nagaraku mix 0.07 D', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix', sort_order = 0 where sku = 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-5D';
    -- Pestañas W-Shape 6D Nagaraku mix 0.07 D
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas W-Shape 6D Nagaraku mix 0.07 D', 'pestanas-w-shape-6d-nagaraku-mix-0-07-d', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-w-shape-6d-nagaraku-mix-0-07-d';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas W-Shape 6D Nagaraku mix 0.07 D', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix', sort_order = 0 where sku = 'PESTANAS-W-SHAPE-NAGARAKU-MIX-0-07-D-6D';
    update products set status = 'archived' where id = old_id;  -- queda oculto, sin opciones
  end if;
  select id into old_id from products where slug = 'pestanas-zaphiria-w-0-07-d-mix-8-a-14-mm';
  if old_id is not null then
    -- Pestañas Zaphiria W 3D 0.07 D mix 8 a 14 mm
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria W 3D 0.07 D mix 8 a 14 mm', 'pestanas-zaphiria-w-3d-0-07-d-mix-8-a-14-mm', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-w-3d-0-07-d-mix-8-a-14-mm';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria W 3D 0.07 D mix 8 a 14 mm', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-3D-MIX8-14MM';
    -- Pestañas Zaphiria W 4D 0.07 D mix 8 a 14 mm
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria W 4D 0.07 D mix 8 a 14 mm', 'pestanas-zaphiria-w-4d-0-07-d-mix-8-a-14-mm', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-w-4d-0-07-d-mix-8-a-14-mm';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria W 4D 0.07 D mix 8 a 14 mm', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-4D-MIX8-14MM';
    -- Pestañas Zaphiria W 5D 0.07 D mix 8 a 14 mm
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria W 5D 0.07 D mix 8 a 14 mm', 'pestanas-zaphiria-w-5d-0-07-d-mix-8-a-14-mm', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-w-5d-0-07-d-mix-8-a-14-mm';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria W 5D 0.07 D mix 8 a 14 mm', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-5D-MIX8-14MM';
    -- Pestañas Zaphiria W 6D 0.07 D mix 8 a 14 mm
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria W 6D 0.07 D mix 8 a 14 mm', 'pestanas-zaphiria-w-6d-0-07-d-mix-8-a-14-mm', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-w-6d-0-07-d-mix-8-a-14-mm';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria W 6D 0.07 D mix 8 a 14 mm', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-W-0-07-D-MIX-8-A-14-MM-D-6D-MIX8-14MM';
    update products set status = 'archived' where id = old_id;  -- queda oculto, sin opciones
  end if;
  select id into old_id from products where slug = 'pestanas-zaphiria-lumi-w-mix-0-07';
  if old_id is not null then
    -- Pestañas Zaphiria Lumi W 3D mix 0.07
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria Lumi W 3D mix 0.07', 'pestanas-zaphiria-lumi-w-3d-mix-0-07', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-lumi-w-3d-mix-0-07';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria Lumi W 3D mix 0.07', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-3D-MIX8-14MM';
    -- Pestañas Zaphiria Lumi W 4D mix 0.07
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria Lumi W 4D mix 0.07', 'pestanas-zaphiria-lumi-w-4d-mix-0-07', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-lumi-w-4d-mix-0-07';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria Lumi W 4D mix 0.07', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-4D-MIX8-14MM';
    update variants set product_id = new_id, option1 = 'N', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 1 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-N-4D-MIX8-14MM';
    -- Pestañas Zaphiria Lumi W 5D mix 0.07
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria Lumi W 5D mix 0.07', 'pestanas-zaphiria-lumi-w-5d-mix-0-07', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-lumi-w-5d-mix-0-07';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria Lumi W 5D mix 0.07', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-5D-MIX8-14MM';
    update variants set product_id = new_id, option1 = 'N', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 1 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-N-5D-MIX8-14MM';
    -- Pestañas Zaphiria Lumi W 6D mix 0.07
    insert into products (name, slug, brand_id, category_id, description, kind, option_names, status, featured, best_seller)
      select 'Pestañas Zaphiria Lumi W 6D mix 0.07', 'pestanas-zaphiria-lumi-w-6d-mix-0-07', brand_id, category_id, description, 'lash_matrix', '{"Curvatura","Grosor","Largo"}', status, featured, best_seller
      from products where id = old_id on conflict (slug) do nothing;
    select id into new_id from products where slug = 'pestanas-zaphiria-lumi-w-6d-mix-0-07';
    if not exists (select 1 from product_images where product_id = new_id) then
      insert into product_images (product_id, url, alt, sort_order)
        select new_id, url, 'Pestañas Zaphiria Lumi W 6D mix 0.07', sort_order from product_images where product_id = old_id;
    end if;
    update variants set product_id = new_id, option1 = 'D', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 0 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-D-6D-MIX8-14MM';
    update variants set product_id = new_id, option1 = 'N', option2 = '0.07', option3 = 'Mix 8-14 mm', sort_order = 1 where sku = 'PESTANAS-ZAPHIRIA-LUMI-W-MIX-0-07-N-6D-MIX8-14MM';
    update products set status = 'archived' where id = old_id;  -- queda oculto, sin opciones
  end if;
end $$;

commit;

-- Comprobación: pestañas publicadas que todavía NO están en curva · grosor · largo
select p.name, p.kind, p.option_names
from products p join categories c on c.id = p.category_id
left join categories padre on padre.id = c.parent_id
where p.status = 'active'
  and coalesce(padre.slug, c.slug) = 'extensiones-de-pestanas'
  and c.slug <> 'pestanas-de-practica'
  and (p.kind <> 'lash_matrix' or p.option_names <> '{"Curvatura","Grosor","Largo"}')
order by p.name;
