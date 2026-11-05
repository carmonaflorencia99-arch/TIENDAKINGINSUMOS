-- =====================================================================
-- King Insumos — esquema inicial
-- Ejecutar en Supabase: SQL Editor → pegar todo → Run
-- Precios en pesos argentinos, enteros (sin centavos).
-- =====================================================================

-- ---------- Enums ----------
create type product_kind      as enum ('simple', 'variants', 'lash_matrix');
create type record_status     as enum ('draft', 'active', 'archived');
create type expertise_level   as enum ('inicial', 'intermedio', 'avanzado', 'super_avanzado');
create type payment_method    as enum ('mercadopago', 'transfer', 'cash');
create type delivery_method   as enum ('pickup', 'moto');
create type payment_plan      as enum ('full', 'deposit');
create type order_status      as enum (
  'pending_payment',    -- creado, esperando pago (MP o efectivo al retirar)
  'awaiting_proof',     -- eligió transferencia, falta comprobante
  'deposit_paid',       -- seña confirmada
  'paid',               -- pago total confirmado
  'preparing',
  'ready_pickup',
  'moto_coordinating',
  'delivered',
  'deposit_expired',    -- venció el plazo de la seña
  'cancelled'
);
create type item_type         as enum ('product', 'course');
create type deposit_type      as enum ('percent', 'fixed');
create type edition_status    as enum ('open', 'full', 'closed');
create type enrollment_status as enum ('reserved', 'paid', 'cancelled');
create type staff_role        as enum ('owner', 'staff');

-- ---------- Panel: usuarias con acceso ----------
create table staff (
  user_id    uuid primary key references auth.users(id) on delete cascade,
  name       text not null,
  role       staff_role not null default 'staff',
  created_at timestamptz not null default now()
);

create or replace function is_staff() returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from staff where user_id = auth.uid());
$$;

-- ---------- Catálogo ----------
create table brands (
  id         bigint generated always as identity primary key,
  name       text not null,
  slug       text not null unique,
  logo_url   text,
  featured   boolean not null default false,
  sort_order int not null default 0
);

create table categories (
  id         bigint generated always as identity primary key,
  parent_id  bigint references categories(id) on delete set null,
  name       text not null,
  slug       text not null unique,
  image_url  text,
  sort_order int not null default 0
);

create table products (
  id           bigint generated always as identity primary key,
  name         text not null,
  slug         text not null unique,
  brand_id     bigint references brands(id) on delete set null,
  category_id  bigint references categories(id) on delete set null,
  description  text,
  kind         product_kind not null default 'simple',
  option_names text[] not null default '{}',   -- ej. {Curvatura,Grosor,Largo}
  status       record_status not null default 'draft',
  featured     boolean not null default false,
  best_seller  boolean not null default false,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);
create index on products (category_id) where status = 'active';
create index on products (brand_id)    where status = 'active';
-- búsqueda simple en español
create index products_search_idx on products
  using gin (to_tsvector('spanish', name || ' ' || coalesce(description, '')));

create table variants (
  id             bigint generated always as identity primary key,
  product_id     bigint not null references products(id) on delete cascade,
  sku            text unique,
  option1        text,   -- ej. Curvatura: C
  option2        text,   -- ej. Grosor: 0.07
  option3        text,   -- ej. Largo: 10mm
  price_list     int not null check (price_list >= 0),
  price_override int check (price_override >= 0), -- excepción manual al precio con descuento
  stock          int not null default 0,
  track_stock    boolean not null default true,
  active         boolean not null default true,
  sort_order     int not null default 0
);
create index on variants (product_id);

create table product_images (
  id         bigint generated always as identity primary key,
  product_id bigint not null references products(id) on delete cascade,
  variant_id bigint references variants(id) on delete set null,
  url        text not null,
  alt        text,
  sort_order int not null default 0
);

create table adhesive_specs (
  product_id      bigint primary key references products(id) on delete cascade,
  drying_min_s    numeric(3,1),
  drying_max_s    numeric(3,1),
  level           expertise_level,
  humidity_min    int,
  humidity_max    int,
  temp_min        int,
  temp_max        int,
  retention_weeks text,
  viscosity       text,
  fumes           text,
  open_shelf_life text
);

-- ---------- Academia ----------
create table instructors (
  id        bigint generated always as identity primary key,
  name      text not null,
  bio       text,
  photo_url text,
  instagram text
);

create table courses (
  id                     bigint generated always as identity primary key,
  title                  text not null,
  slug                   text not null unique,
  description            text,
  level                  expertise_level,
  duration_text          text,
  instructor_id          bigint references instructors(id) on delete set null,
  price_full             int not null check (price_full >= 0),
  deposit_type           deposit_type not null default 'percent',
  deposit_value          int not null default 50,
  syllabus_pdf_url       text,
  includes_materials     boolean not null default false,
  gift_kit_product_id    bigint references products(id) on delete set null,
  student_kit_product_id bigint references products(id) on delete set null,
  student_kit_discount   int not null default 0,
  image_url              text,
  status                 record_status not null default 'draft'
);

create table course_editions (
  id             bigint generated always as identity primary key,
  course_id      bigint not null references courses(id) on delete cascade,
  starts_at      timestamptz not null,
  ends_at        timestamptz,
  schedule_text  text,
  location       text not null default 'Av. San Martín 1074, oficina 3° C, Ciudad de Mendoza',
  capacity       int not null check (capacity > 0),
  status         edition_status not null default 'open'
);

-- ---------- Configuración ----------
create table settings (
  id                       int primary key default 1 check (id = 1),
  whatsapp                 text not null default '5492612446705',
  bank_alias               text,
  cbu                      text,
  account_holder           text,
  announcement_text        text default 'Efectivo 10% OFF en todo · Transferencia 10% OFF (excepto pestañas)',
  store_hours              text default 'Lunes a sábados de 10 a 18 hs de corrido · Domingos cerrado',
  pickup_address           text default 'Av. San Martín 1074, oficina 3° C (esquina Peatonal Sarmiento), Ciudad de Mendoza',
  deposit_pct              int not null default 50,
  deposit_business_days    int not null default 10,
  deposit_count_saturdays  boolean not null default false, -- días hábiles legales = lunes a viernes
  holidays                 date[] not null default '{}'
);
insert into settings (id) values (1);

-- Descuentos por medio de pago
create table payment_rules (
  method                 payment_method primary key,
  label                  text not null,
  discount_pct           int not null default 0 check (discount_pct between 0 and 100),
  excluded_category_ids  bigint[] not null default '{}', -- se excluyen también sus subcategorías
  allowed_delivery       delivery_method[] not null,
  allows_deposit         boolean not null default false,
  active                 boolean not null default true
);

-- ---------- Pedidos ----------
create table orders (
  id                 bigint generated always as identity primary key,
  number             int generated always as identity (start with 1001) unique,
  public_token       uuid not null default gen_random_uuid() unique, -- para ver el pedido sin cuenta
  customer_name      text not null,
  customer_phone     text not null,
  customer_email     text,
  delivery           delivery_method not null,
  moto_address       text,
  moto_notes         text,
  payment            payment_method not null,
  plan               payment_plan not null default 'full',
  subtotal           int not null,  -- a precio de lista
  discount           int not null default 0,
  total              int not null,  -- con descuento del medio de pago
  amount_due_now     int not null,  -- total o seña
  amount_paid        int not null default 0,
  balance_due        int not null default 0,
  deposit_paid_at    timestamptz,
  deposit_expires_at timestamptz,
  status             order_status not null default 'pending_payment',
  stock_reserved     boolean not null default false,
  mp_preference_id   text,
  mp_payment_id      text,
  proof_received     boolean not null default false,
  notes              text,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now()
);
create index on orders (status);
create index on orders (created_at desc);

create table order_items (
  id               bigint generated always as identity primary key,
  order_id         bigint not null references orders(id) on delete cascade,
  type             item_type not null default 'product',
  variant_id       bigint references variants(id) on delete set null,
  edition_id       bigint references course_editions(id) on delete set null,
  name_snapshot    text not null,
  options_snapshot text,
  unit_list_price  int not null,
  unit_price       int not null, -- con descuento aplicado
  qty              int not null check (qty > 0)
);
create index on order_items (order_id);

create table enrollments (
  id            bigint generated always as identity primary key,
  edition_id    bigint not null references course_editions(id) on delete restrict,
  order_id      bigint references orders(id) on delete set null,
  student_name  text not null,
  phone         text not null,
  email         text,
  plan          payment_plan not null,
  amount_paid   int not null default 0,
  balance_due   int not null default 0,
  status        enrollment_status not null default 'reserved',
  created_at    timestamptz not null default now()
);

-- Cupos disponibles en tiempo real
create view edition_availability as
select e.id as edition_id,
       e.capacity,
       e.capacity - count(en.id) filter (where en.status in ('reserved', 'paid')) as seats_left
from course_editions e
left join enrollments en on en.edition_id = e.id
group by e.id;

-- ---------- Funciones ----------

-- Suma N días hábiles a una fecha (saltea domingos, sábados si corresponde, y feriados)
create or replace function add_business_days(p_start timestamptz, p_days int)
returns timestamptz language plpgsql stable as $$
declare
  d date := (p_start at time zone 'America/Argentina/Mendoza')::date;
  n int := 0;
  s settings;
begin
  select * into s from settings where id = 1;
  while n < p_days loop
    d := d + 1;
    if extract(isodow from d) = 7 then continue; end if;
    if extract(isodow from d) = 6 and not s.deposit_count_saturdays then continue; end if;
    if d = any (s.holidays) then continue; end if;
    n := n + 1;
  end loop;
  -- vence al final del día hábil, hora de Mendoza
  return (d + time '23:59:59') at time zone 'America/Argentina/Mendoza';
end $$;

-- Descuenta stock de un pedido (idempotente)
create or replace function reserve_order_stock(p_order_id bigint)
returns void language plpgsql security definer set search_path = public as $$
begin
  update orders set stock_reserved = true
   where id = p_order_id and stock_reserved = false;
  if not found then return; end if;

  update variants v
     set stock = v.stock - oi.qty
    from order_items oi
   where oi.order_id = p_order_id and oi.variant_id = v.id and v.track_stock;
end $$;

-- Devuelve stock (seña vencida o pedido cancelado)
create or replace function release_order_stock(p_order_id bigint)
returns void language plpgsql security definer set search_path = public as $$
begin
  update orders set stock_reserved = false
   where id = p_order_id and stock_reserved = true;
  if not found then return; end if;

  update variants v
     set stock = v.stock + oi.qty
    from order_items oi
   where oi.order_id = p_order_id and oi.variant_id = v.id and v.track_stock;
end $$;

-- Marca como vencidas las señas fuera de plazo (llamar desde un cron diario)
create or replace function expire_deposits()
returns int language plpgsql security definer set search_path = public as $$
declare r record; n int := 0;
begin
  for r in select id from orders
            where status = 'deposit_paid' and deposit_expires_at < now()
  loop
    update orders set status = 'deposit_expired', updated_at = now() where id = r.id;
    perform release_order_stock(r.id);
    n := n + 1;
  end loop;
  return n;
end $$;

-- Cancela pedidos sin ningún pago después de N horas (por defecto 48)
create or replace function cancel_stale_orders(p_hours int default 48)
returns int language plpgsql security definer set search_path = public as $$
declare n int;
begin
  update orders set status = 'cancelled', updated_at = now()
   where status in ('pending_payment', 'awaiting_proof')
     and amount_paid = 0
     and created_at < now() - make_interval(hours => p_hours);
  get diagnostics n = row_count;
  return n;
end $$;

-- Subida masiva de precios por % (panel → Precios)
create or replace function bulk_update_prices(
  p_pct numeric, p_brand_id bigint default null, p_category_id bigint default null,
  p_round_to int default 10
) returns int language plpgsql security definer set search_path = public as $$
declare n int;
begin
  if not is_staff() then raise exception 'sin permiso'; end if;
  update variants v
     set price_list = (round(v.price_list * (1 + p_pct / 100.0) / p_round_to) * p_round_to)::int
    from products p
   where v.product_id = p.id
     and (p_brand_id is null or p.brand_id = p_brand_id)
     and (p_category_id is null or p.category_id = p_category_id
          or p.category_id in (select id from categories where parent_id = p_category_id));
  get diagnostics n = row_count;
  return n;
end $$;

-- updated_at automático
create or replace function touch_updated_at() returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end $$;
create trigger products_touch before update on products for each row execute function touch_updated_at();
create trigger orders_touch   before update on orders   for each row execute function touch_updated_at();

-- ---------- Seguridad (RLS) ----------
-- Público: solo lee catálogo activo. Pedidos: solo el servidor (service role) y el panel.
alter table staff           enable row level security;
alter table brands          enable row level security;
alter table categories      enable row level security;
alter table products        enable row level security;
alter table variants        enable row level security;
alter table product_images  enable row level security;
alter table adhesive_specs  enable row level security;
alter table instructors     enable row level security;
alter table courses         enable row level security;
alter table course_editions enable row level security;
alter table settings        enable row level security;
alter table payment_rules   enable row level security;
alter table orders          enable row level security;
alter table order_items     enable row level security;
alter table enrollments     enable row level security;

create policy "lectura pública" on brands          for select using (true);
create policy "lectura pública" on categories      for select using (true);
create policy "lectura pública" on products        for select using (status = 'active' or is_staff());
create policy "lectura pública" on variants        for select using (active or is_staff());
create policy "lectura pública" on product_images  for select using (true);
create policy "lectura pública" on adhesive_specs  for select using (true);
create policy "lectura pública" on instructors     for select using (true);
create policy "lectura pública" on courses         for select using (status = 'active' or is_staff());
create policy "lectura pública" on course_editions for select using (true);
create policy "lectura pública" on settings        for select using (true);
create policy "lectura pública" on payment_rules   for select using (true);

-- El panel puede todo
do $$
declare t text;
begin
  foreach t in array array['brands','categories','products','variants','product_images',
    'adhesive_specs','instructors','courses','course_editions','settings','payment_rules',
    'orders','order_items','enrollments']
  loop
    execute format('create policy "panel" on %I for all using (is_staff()) with check (is_staff())', t);
  end loop;
end $$;
create policy "ver su propio registro" on staff for select using (user_id = auth.uid());

-- Fotos: bucket público de lectura, escritura solo panel
insert into storage.buckets (id, name, public) values ('products', 'products', true)
  on conflict do nothing;
create policy "panel sube fotos" on storage.objects for all
  using (bucket_id = 'products' and is_staff())
  with check (bucket_id = 'products' and is_staff());
