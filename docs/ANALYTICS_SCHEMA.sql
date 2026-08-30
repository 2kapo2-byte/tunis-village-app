-- Applied to the live Tunis Village Supabase project as migration:
-- add_privacy_safe_mobile_analytics
--
-- Privacy rules:
-- * authenticated users may insert only their own user_id
-- * users may read only their own events
-- * no email, phone, payment data, booking notes, or device identifiers are stored
-- * event properties must remain coarse and non-sensitive

create table if not exists public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  event_name text not null check (char_length(event_name) between 1 and 80),
  properties jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.analytics_events enable row level security;

revoke all on public.analytics_events from anon;
grant insert, select on public.analytics_events to authenticated;

create policy analytics_events_insert_own on public.analytics_events
for insert to authenticated with check (auth.uid() = user_id);

create policy analytics_events_select_own on public.analytics_events
for select to authenticated using (auth.uid() = user_id);
