-- =====================================================================
-- King Insumos — Guantes 100% nitrilo caja x 100: solo Rosa y Negro, por talle S / M / L
-- Ejecutar una vez en Supabase → SQL Editor. Se puede volver a ejecutar sin problema.
-- El stock de cada talle queda en 0: cargalo desde el panel (Productos → buscar "guantes").
-- Los pedidos viejos no se tocan (guardan nombre y precio del momento).
-- =====================================================================
do $$
declare
  pid   bigint;
  price int;
  n     int := 0;
  c     text;
  t     text;
begin
  select id into pid from products where slug = 'guantes-100-nitrilo-caja-x-100';
  if pid is null then
    raise exception 'No se encontró el producto "Guantes 100%% nitrilo caja x 100"';
  end if;

  -- mantiene el precio que tenga hoy (por si se cambió desde el panel)
  select coalesce(max(price_list), 9780) into price from variants where product_id = pid;

  update products set kind = 'variants', option_names = '{"Color","Talle"}' where id = pid;

  delete from variants where product_id = pid;
  foreach c in array array['Rosa', 'Negro'] loop
    foreach t in array array['S', 'M', 'L'] loop
      insert into variants (product_id, sku, option1, option2, price_list, stock, sort_order)
      values (pid, 'GUANTES-100-NITRILO-CAJA-X-100-' || upper(c) || '-' || t, c, t, price, 0, n);
      n := n + 1;
    end loop;
  end loop;

  -- saca la foto del guante azul
  delete from product_images where product_id = pid and url like '%/guantes-100-nitrilo-caja-x-100.jpg';
end $$;

-- Comprobación: tienen que aparecer 6 filas (Rosa y Negro, S/M/L)
select v.option1 as color, v.option2 as talle, v.price_list as precio, v.stock
from variants v join products p on p.id = v.product_id
where p.slug = 'guantes-100-nitrilo-caja-x-100'
order by v.sort_order;
