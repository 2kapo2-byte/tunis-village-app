# Phase 14 — Partner Booking & Commission Operations

Status: CLOSED (backend contract integration boundary)

## Verified production contracts

- `create_partner_booking(json)` requires an authenticated approved partner and performs availability, guest composition, pricing, commission and booking creation server-side.
- `update_booking_status(uuid,text,text)` enforces owner/admin authorization and canonical booking transitions.
- `resolve_commission_rate(uuid,uuid)` resolves property → owner → platform commission rules server-side.
- Function EXECUTE privilege check: these functions are not executable by `anon`; they are executable by `authenticated` and contain their own authorization checks.

## Implemented

- Added Partner booking operation contract and deterministic error mapping.
- Unknown backend errors fail closed.
- Added tests for known and unknown operation results.
- No client-side commission calculation was introduced.
- No direct booking table writes were introduced.

## Security decision

Financial and booking state remain server authoritative. The mobile app must consume RPC results rather than reconstruct commission totals or booking transitions locally.

## Important observation

`create_partner_booking` is named for partner creation and currently checks for an approved `partner_accounts` record. The app must not infer marketer-vs-owner authorization from UI role alone; the backend contract must be tightened if the business rule is intended to restrict this RPC specifically to marketers. No production mutation was changed without an explicit verified business rule.

## Verification limitation

Static source and live Supabase contract/privilege checks completed. Flutter runtime tests are committed for CI execution; no local runtime pass is claimed because the available repository tool cannot execute Flutter.

Next: Phase 15 — Partner Payments & Payout Presentation.
