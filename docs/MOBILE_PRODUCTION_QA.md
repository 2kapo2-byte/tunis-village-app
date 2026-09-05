# Mobile Production QA

## Scope verified

The mobile client is aligned with the Tunis Village Supabase backend and uses the authoritative backend contracts for booking, pricing, payment, cancellation/refund, reviews, and notifications.

### Backend contract checks

- `create_booking(p_params json)` is the customer booking entry point.
- `calculate_booking_price(p_params json)` is used for server-authoritative checkout pricing.
- `create_partner_booking(p_params json)` validates partner access and child ages.
- `create_payment_for_booking(uuid,text,text)` is idempotent.
- `cancel_own_booking(uuid,text)` enforces cancellation/refund rules server-side.
- `review_is_eligible(...)` requires a completed stay.
- `reviews_rating_summary(...)` exposes published-review aggregates.
- Notifications are stored in `notifications` and protected by RLS.
- The live backend currently has active `initiate-payment` and `paymob-webhook` Edge Functions; `initiate-payment` supports both Fawry and Paymob paths and fails closed when provider credentials are not configured.

## Mobile sequence

- M1 Guest Search & Availability: implemented.
- M2 Guest Property/Unit Details: implemented.
- M3 Guest Booking Completion: implemented.
- M4 Payment Integration: implemented as backend lifecycle integration; no fake provider success.
- M5 Booking Management: implemented.
- M6 Cancellation/Refund: implemented through backend RPC and refund read model.
- M7 Reviews: implemented as create-only client flow; no edit/delete UI.
- M8 Notifications: implemented as in-app list/read flow.
- M9 Production QA: CI configured for analyze, tests, Android debug build, and iOS simulator build.

## Changes applied in this release-prep pass

1. Added `tool/bootstrap_platforms.sh` to deterministically generate missing/incomplete Android and iOS Flutter platform scaffolding.
2. Added a manual GitHub Actions workflow that can generate and commit the native platform scaffolding to `main`.
3. Updated the main CI build jobs to bootstrap incomplete native platforms before Android/iOS builds.
4. Confirmed the live database currently contains zero approved properties and zero active/approved units, so no real booking smoke test can be honestly certified yet.
5. Confirmed payment gateway integration exists in the live backend for both Fawry and Paymob; production credentials remain environment secrets and are intentionally not stored in the repository.

## Remaining release gates

1. Run the `Bootstrap Flutter Platforms` workflow once and verify the generated Android/iOS directories are committed.
2. Confirm final Android application ID and iOS bundle identifier, then configure release signing/keystore/certificates outside source control.
3. Obtain a green CI run after the generated native projects are present.
4. Add a controlled approved test property/unit (or production inventory) and execute a real booking smoke test.
5. Configure and verify real Fawry and/or Paymob provider credentials and webhook callbacks in Supabase secrets.
6. Execute provider-backed payment smoke testing and verify webhook-driven payment state transitions.
7. Only after all gates pass: create signed release builds and perform store-readiness review.

## Security posture

The mobile app does not directly update payment status, review status, commission values, booking state, or refund amounts. Those transitions remain backend-controlled.

## Release decision

**NOT YET PRODUCTION CERTIFIED.** Application-layer implementation is substantially complete. The remaining blockers are operational/release gates: native platform generation/identifiers/signing, green CI, non-empty controlled inventory for E2E testing, and live provider credentials/webhook verification.
