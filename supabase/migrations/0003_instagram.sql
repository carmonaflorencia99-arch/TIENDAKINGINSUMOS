-- =====================================================================
-- King Insumos — claves de integraciones (Instagram)
-- Tabla privada: sin políticas RLS, solo la lee el servidor (service role).
-- Ejecutar después de 0002_panel.sql. Se puede ejecutar más de una vez.
-- =====================================================================

create table if not exists integration_tokens (
  key         text primary key,          -- ej. 'instagram'
  value       text not null,             -- token de acceso
  account     text,                      -- usuario conectado (para mostrar en el panel)
  updated_at  timestamptz not null default now()
);

alter table integration_tokens enable row level security;
revoke all on table integration_tokens from anon, authenticated;
grant all on table integration_tokens to service_role;
