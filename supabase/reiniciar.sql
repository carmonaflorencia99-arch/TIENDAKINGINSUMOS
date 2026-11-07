-- =====================================================================
-- King Insumos — REINICIAR la base de datos
-- Borra TODAS las tablas, datos y funciones de la tienda para volver a
-- ejecutar desde cero: migrations/0001_init.sql → seed.sql → seed-productos.sql
-- ⚠️ No usar una vez que la tienda tenga pedidos reales.
-- =====================================================================

-- Fotos (bucket y política creados por 0001_init.sql)
drop policy if exists "panel sube fotos" on storage.objects;

-- Esquema público completo
drop schema if exists public cascade;
create schema public;

-- Permisos estándar de Supabase
grant usage on schema public to postgres, anon, authenticated, service_role;
grant all on all tables in schema public to postgres, anon, authenticated, service_role;
grant all on all functions in schema public to postgres, anon, authenticated, service_role;
grant all on all sequences in schema public to postgres, anon, authenticated, service_role;
alter default privileges in schema public grant all on tables to postgres, anon, authenticated, service_role;
alter default privileges in schema public grant all on functions to postgres, anon, authenticated, service_role;
alter default privileges in schema public grant all on sequences to postgres, anon, authenticated, service_role;
