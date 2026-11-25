-- Sincronizzazione online di Budget e Giornate: una riga per utente e per app, visibile solo al proprietario.
create table if not exists public.app_dati (user_id uuid not null default auth.uid() references auth.users(id) on delete cascade, app text not null check (app in ('budget','giornate')), data jsonb not null default '{}'::jsonb, updated_at timestamptz not null default now(), primary key (user_id, app));
alter table public.app_dati enable row level security;
revoke all on public.app_dati from anon;
grant select, insert, update, delete on public.app_dati to authenticated;
drop policy if exists app_dati_proprietario on public.app_dati;
create policy app_dati_proprietario on public.app_dati for all to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
