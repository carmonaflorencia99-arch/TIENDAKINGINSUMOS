-- King Insumos: pedidos por WhatsApp, solo envíos y solo transferencia (10% OFF en todo)
-- Se puede ejecutar más de una vez.
begin;

update payment_rules set active = false, allows_deposit = false where method in ('cash', 'mercadopago');
update payment_rules
set active = true, discount_pct = 10, excluded_category_ids = '{}', allows_deposit = false, allowed_delivery = '{moto}'
where method = 'transfer';

update settings
set announcement_text = 'Transferencia 10% OFF en todo · Pedidos por WhatsApp · Solo envíos'
where id = 1;

commit;

select method, active, discount_pct, excluded_category_ids, allows_deposit from payment_rules order by method;
