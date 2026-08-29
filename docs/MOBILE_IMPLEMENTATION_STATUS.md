# Mobile Implementation Status

## Completed sequence

1. **M1 — Guest Search & Availability**
   - Guest date selection and composition (adults + child ages).
   - Availability filtering against approved properties, available units, capacity, stay limits, and public availability calendar.
   - Removed the stale `check_unit_availability` RPC dependency because it does not exist in the live backend.

2. **M2 — Guest Property/Unit Details**
   - Authoritative property/unit details.
   - Property images and amenities.
   - Unit capacity, bedrooms, bathrooms, beds, price.
   - Rating metadata.

3. **M3 — Guest Booking Completion**
   - Server-authoritative pricing via `calculate_booking_price`.
   - Booking creation via `create_booking(p_params json)`.
   - Child ages and guest composition preserved.
   - Payment method captured without fake payment success.

4. **M4 — Payment Integration**
   - Idempotent payment creation/status retrieval via `create_payment_for_booking`.
   - Truthful pending/processing/paid/failed/refunded states.
   - No client-side payment status mutation.

5. **M5 — Booking Management**
   - Customer booking history.
   - Booking details.
   - Child ages and pricing/payment metadata.

6. **M6 — Cancellation/Refund**
   - Cancellation through `cancel_own_booking`.
   - Backend-calculated refund percentage/amount.
   - Customer-visible refund status.

7. **M7 — Reviews**
   - Completed-stay review creation.
   - Backend eligibility enforcement.
   - No edit/delete client actions; review moderation remains backend/admin controlled.

8. **M8 — Notifications**
   - In-app notifications.
   - Read/unread state.
   - Mark one/all read.

9. **M9 — Production QA**
   - Flutter CI configured for analyze/test plus Android debug and iOS simulator build checks.
   - Core contract tests added.
   - Production QA report added in `docs/MOBILE_PRODUCTION_QA.md`.

## Remaining release blockers

- Commit Android/iOS platform scaffolding and configure real application identifiers/signing.
- Obtain a green CI run after the full latest commit chain.
- Populate approved test inventory and run a real end-to-end booking smoke test.
- Configure the actual online payment provider/backend credentials before claiming online-payment readiness.

## Architecture rule

The repository layer remains a thin client boundary. Booking, pricing, payment state, cancellation/refund, review eligibility/moderation, commissions, and security remain authoritative in the existing Tunis Village backend.
