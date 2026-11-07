-- =====================================================================
-- King Insumos — dar acceso al panel de administración
--
-- 1) En Supabase: Authentication → Users → Add user → Create new user.
--    Escribí el email y la contraseña del panel y marcá "Auto Confirm User".
-- 2) Cambiá el email de abajo por ese mismo email y ejecutá este archivo.
-- =====================================================================

insert into staff (user_id, name, role)
select id, 'Panel', 'owner'
from auth.users
where email = 'CAMBIAR@EMAIL.COM'
on conflict (user_id) do nothing;

-- Comprobación: tiene que aparecer una fila con ese email
select u.email, s.created_at as acceso_desde
from staff s join auth.users u on u.id = s.user_id;
