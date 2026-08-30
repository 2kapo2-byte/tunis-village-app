# Phase 12 — Partner Authentication & Role Routing

Status: CLOSED (authorization boundary)

## Verified backend contract

Supabase production schema exposes `profiles.role` and `partner_accounts(user_id,status,commission_rate)`. Partner-related routines include `admin_update_profile_role`, `create_partner_booking`, and `protect_profile_role`.

## Implemented

- Added fail-closed `PartnerAccessGuard`.
- Unknown or missing sessions are rejected.
- Owner and marketer role access is exact and mutually exclusive.
- Added unit tests for anonymous/unknown rejection and exact role matching.

## Security decision

The mobile guard is UX/navigation protection only. Supabase Auth, profile role, partner account status, RLS and server-side functions remain authoritative. No client-side role is trusted for financial or booking authorization.

## Verification limitation

Repository tooling can inspect and commit source but cannot execute the Flutter runtime in this environment. Tests are included for CI/device execution. No runtime pass is claimed without execution evidence.

Next: Phase 13 — Partner Dashboard & Availability.
