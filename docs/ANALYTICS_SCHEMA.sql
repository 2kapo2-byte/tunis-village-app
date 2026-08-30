-- Applied to the live Tunis Village Supabase project as migrations:
-- add_privacy_safe_mobile_analytics + harden_mobile_analytics_privacy
--
-- Privacy rules:
-- * no user identifiers are stored
-- * only authenticated clients may insert
-- * no client read access is granted
-- * event names are whitelisted at database level
-- * no email, phone, payment data, booking notes, or device identifiers are stored
-- * event properties must remain coarse and non-sensitive

create table if not exists public.analytics_events (
  id uuid primary key default gen_random_uuid(),
  event_name text not null check (event_name in ('search_started','search_completed','property_viewed','booking_started','booking_completed','booking_cancelled')),
  properties jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.analytics_events enable row level security;
revoke all on public.analytics_events from anon;
grant insert on public.analytics_events to authenticated;
create policy analytics_events_insert_authenticated on public.analytics_events
for insert to authenticated with check (true);
