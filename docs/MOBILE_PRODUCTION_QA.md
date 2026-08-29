# Mobile Production QA

## Scope verified

The mobile client was aligned against the live Tunis Village Supabase project and the authoritative backend contracts.

### Backend contract checks

- `create_booking(p_params json)` exists and is the customer booking entry point.
- `calculate_booking_price(p_params json)` exists and is used for server-authoritative checkout pricing.
- `create_partner_booking(p_params json)` validates partner access and child ages.
- `create_payment_for_booking(uuid,text,text)` exists and is idempotent.
- `cancel_own_booking(uuid,text)` enforces cancellation/refund rules server-side.
- `review_is_eligible(...)` requires a completed stay.
- `reviews_rating_summary(...)` exposes published-review aggregates.
- Notifications are stored in the existing `notifications` table and protected by RLS.

## Mobile sequence

- M1 Guest Search & Availability: implemented.
- M2 Guest Property/Unit Details: implemented.
- M3 Guest Booking Completion: implemented.
- M4 Payment Integration: implemented as backend payment lifecycle/status integration; no fake provider success.
- M5 Booking Management: implemented.
- M6 Cancellation/Refund: implemented through backend RPC and refund read model.
- M7 Reviews: implemented as create-only client flow; no edit/delete UI.
- M8 Notifications: implemented as in-app list/read flow.
- M9 Production QA: CI configured for analyze, tests, Android debug build, and iOS simulator build.

## Current blockers

1. The repository does not currently contain committed `android/` or `ios/` Flutter platform directories. A production release therefore still needs platform scaffolding and real app identifiers/signing configuration.
2. The connected live database currently reports zero approved properties, zero available units, and zero blocked calendar rows. This prevents a meaningful end-to-end reservation smoke test with real inventory without adding test/production inventory.
3. The GitHub Actions run was still in progress while this report was prepared; local Flutter tooling is not installed in the current execution environment, so no local `flutter analyze/test/build` result is claimed.
4. Real online payment provider credentials/configuration are not present in this repository. The app intentionally leaves online payments in a truthful pending state until the provider is configured in the backend.

## Security posture

The mobile app does not directly update payment status, review status, commission values, booking state, or refund amounts. Those transitions remain backend-controlled.

## Release decision

**NOT YET PRODUCTION CERTIFIED.** The application-layer sequence is implemented, but release certification should wait for platform scaffolding, CI green, populated test inventory, and a real provider-backed payment smoke test.
