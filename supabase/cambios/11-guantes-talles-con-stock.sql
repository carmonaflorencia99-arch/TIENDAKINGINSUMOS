-- King Insumos: Guantes 100% nitrilo caja x 100 por color (Rosa / Negro) y talle (S / M / L),
-- con el stock del Excel del sistema. Se puede ejecutar más de una vez.
do $$
declare
  pid   bigint;
  price int;
begin
  select id into pid from products where slug = 'guantes-100-nitrilo-caja-x-100';
  if pid is null then
    raise exception 'No se encontró el producto "Guantes 100%% nitrilo caja x 100"';
  end if;

  -- mantiene el precio que tenga hoy
  select coalesce(max(price_list), 9780) into price from variants where product_id = pid;

  update products set kind = 'variants', option_names = '{"Color","Talle"}' where id = pid;
  delete from variants where product_id = pid;

  insert into variants (product_id, sku, option1, option2, price_list, stock, sort_order) values
    (pid, 'GUANTES-100-NITRILO-CAJA-X-100-ROSA-S',  'Rosa',  'S', price, 5, 0),
    (pid, 'GUANTES-100-NITRILO-CAJA-X-100-ROSA-M',  'Rosa',  'M', price, 1, 1),
    (pid, 'GUANTES-100-NITRILO-CAJA-X-100-ROSA-L',  'Rosa',  'L', price, 0, 2),
    (pid, 'GUANTES-100-NITRILO-CAJA-X-100-NEGRO-S', 'Negro', 'S', price, 2, 3),
    (pid, 'GUANTES-100-NITRILO-CAJA-X-100-NEGRO-M', 'Negro', 'M', price, 4, 4),
    (pid, 'GUANTES-100-NITRILO-CAJA-X-100-NEGRO-L', 'Negro', 'L', price, 0, 5);

  -- saca la foto del guante azul
  delete from product_images where product_id = pid and url like '%/guantes-100-nitrilo-caja-x-100.jpg';
end $$;

-- Comprobación: 6 filas (Rosa y Negro, S/M/L)
select v.option1 as color, v.option2 as talle, v.price_list as precio, v.stock
from variants v join products p on p.id = v.product_id
where p.slug = 'guantes-100-nitrilo-caja-x-100'
order by v.sort_order;
