-- =====================================================================
-- King Insumos — panel de administración
-- Ejecutar DESPUÉS de 0001_init.sql (y de los seeds).
-- =====================================================================

-- Las funciones que mueven stock, cambian pedidos o precios solo las
-- puede ejecutar el servidor (service role), nunca el navegador.
revoke execute on function reserve_order_stock(bigint)  from public, anon, authenticated;
revoke execute on function release_order_stock(bigint)  from public, anon, authenticated;
revoke execute on function expire_deposits()            from public, anon, authenticated;
revoke execute on function cancel_stale_orders(int)     from public, anon, authenticated;
grant  execute on function reserve_order_stock(bigint)  to service_role;
grant  execute on function release_order_stock(bigint)  to service_role;
grant  execute on function expire_deposits()            to service_role;
grant  execute on function cancel_stale_orders(int)     to service_role;

-- Subida masiva de precios: la llama el panel desde el servidor
-- (después de comprobar que hay una sesión de administración).
drop function if exists bulk_update_prices(numeric, bigint, bigint, int);
create function bulk_update_prices(
  p_pct numeric, p_brand_id bigint default null, p_category_id bigint default null,
  p_round_to int default 10
) returns int language plpgsql security definer set search_path = public as $$
declare n int;
begin
  if p_pct is null or p_pct <= -90 or p_pct > 500 then
    raise exception 'porcentaje fuera de rango';
  end if;
  update variants v
     set price_list = greatest((round(v.price_list * (1 + p_pct / 100.0) / p_round_to) * p_round_to)::int, 0)
    from products p
   where v.product_id = p.id
     and (p_brand_id is null or p.brand_id = p_brand_id)
     and (p_category_id is null or p.category_id = p_category_id
          or p.category_id in (select id from categories where parent_id = p_category_id));
  get diagnostics n = row_count;
  return n;
end $$;
revoke execute on function bulk_update_prices(numeric, bigint, bigint, int) from public, anon, authenticated;
grant  execute on function bulk_update_prices(numeric, bigint, bigint, int) to service_role;
