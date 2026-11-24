-- =====================================================================
-- King Insumos — Pedidos por WhatsApp: solo envíos y solo transferencia
-- Ejecutar una vez en Supabase → SQL Editor. Se puede volver a ejecutar.
--  - Sin efectivo, sin retiro en el local, sin seña, sin Mercado Pago.
--  - Transferencia: sigue el 10% OFF excepto pestañas.
-- Los pedidos viejos no se tocan.
-- =====================================================================
begin;

update payment_rules set active = false, allows_deposit = false where method in ('cash', 'mercadopago');
update payment_rules set active = true, allows_deposit = false, allowed_delivery = '{moto}' where method = 'transfer';

update settings
set announcement_text = 'Transferencia 10% OFF (excepto pestañas) · Pedidos por WhatsApp · Solo envíos'
where id = 1;

commit;

-- Comprobación: solo "transfer" tiene que quedar activo
select method, active, discount_pct, allowed_delivery, allows_deposit from payment_rules order by method;
