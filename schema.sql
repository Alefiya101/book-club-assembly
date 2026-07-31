-- Book Club Assemble — Supabase schema
-- Run this once in your Supabase project's SQL editor (Database -> SQL Editor -> New query).

create extension if not exists pgcrypto;

create table if not exists shelf_config (
  id int primary key default 1,
  name_a text,
  name_b text,
  password_hash text
);

create table if not exists shelf_books (
  person text primary key check (person in ('A','B')),
  title text,
  author text,
  page int,
  total int,
  updated_at timestamptz default now()
);

create table if not exists shelf_entries (
  id uuid primary key default gen_random_uuid(),
  person text not null check (person in ('A','B')),
  type text not null check (type in ('thought','quote')),
  body text not null,
  book text,
  created_at timestamptz default now()
);

-- Row Level Security
alter table shelf_config enable row level security;
alter table shelf_books enable row level security;
alter table shelf_entries enable row level security;

create policy "public read config" on shelf_config for select using (true);
create policy "public write config" on shelf_config for insert with check (true);
create policy "public update config" on shelf_config for update using (true);

create policy "public read books" on shelf_books for select using (true);
create policy "public write books" on shelf_books for insert with check (true);
create policy "public update books" on shelf_books for update using (true);

create policy "public read entries" on shelf_entries for select using (true);
create policy "public write entries" on shelf_entries for insert with check (true);

-- Keep the password hash out of reach of the browser: revoke the blanket
-- column access RLS gives us and grant back only the columns the app
-- actually needs to read directly. The password itself is only ever
-- checked/set through the two functions below, which run server-side.
revoke select on shelf_config from anon, authenticated;
grant select (id, name_a, name_b) on shelf_config to anon, authenticated;
grant insert, update on shelf_config to anon, authenticated;

create or replace function check_shelf_password(attempt text)
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1 from shelf_config
    where id = 1 and password_hash = encode(digest(attempt, 'sha256'), 'hex')
  );
$$;
grant execute on function check_shelf_password(text) to anon, authenticated;

create or replace function set_shelf_password(new_password text, new_name_a text, new_name_b text)
returns void
language sql
security definer
set search_path = public
as $$
  insert into shelf_config (id, name_a, name_b, password_hash)
  values (1, new_name_a, new_name_b, encode(digest(new_password, 'sha256'), 'hex'))
  on conflict (id) do update
    set name_a = excluded.name_a,
        name_b = excluded.name_b,
        password_hash = excluded.password_hash;
$$;
grant execute on function set_shelf_password(text, text, text) to anon, authenticated;

-- Realtime so both phones see new posts/progress without refreshing.
alter publication supabase_realtime add table shelf_entries;
alter publication supabase_realtime add table shelf_books;
