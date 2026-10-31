-- Run this first (safe to run again)
alter table compat_groups add column if not exists master text, add column if not exists screen text, add column if not exists code text, add column if not exists height_mm text, add column if not exists width_mm text, add column if not exists area_cm2 text, add column if not exists body_pct text, add column if not exists image text, add column if not exists source text;
create table if not exists model_images(model text primary key, url text not null, created_at timestamptz default now());
alter table model_images enable row level security;
drop policy if exists "read model images" on model_images;
create policy "read model images" on model_images for select using (true);
drop policy if exists "admin model images" on model_images;
create policy "admin model images" on model_images for all using (is_admin()) with check (is_admin());
drop policy if exists "admin manage photos" on storage.objects;
create policy "admin manage photos" on storage.objects for all using (bucket_id='photos' and is_admin()) with check (bucket_id='photos' and is_admin());
delete from compat_groups where note like '%Sample entry, verify before use%';
