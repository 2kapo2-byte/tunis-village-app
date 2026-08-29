# Tunis Village App

Official Flutter mobile application for the Tunis Village Booking Marketplace.

## Scope

The app is a mobile client for the existing Tunis Village marketplace. It uses the same backend, authentication, booking engine, pricing rules, availability, payments, reviews, cancellation/refund logic, and notifications as the web platform.

### Platforms

- Android
- iOS

### Architecture principle

The mobile app is a separate Flutter client. It must not duplicate backend business rules or create a second booking database.

## Current implementation

The requested mobile sequence has been implemented through the application layer:

1. **M1 — Guest Search & Availability** — implemented against the live schema.
2. **M2 — Guest Property/Unit Details** — implemented with property images, amenities, unit details, ratings, stay limits, and cancellation policy metadata.
3. **M3 — Guest Booking Completion** — implemented through the authoritative pricing and booking RPCs.
4. **M4 — Payment Integration** — implemented for payment record creation/status tracking without fake provider success.
5. **M5 — Booking Management** — booking history and booking details are available.
6. **M6 — Cancellation/Refund** — cancellation uses the backend state machine and exposes refund status.
7. **M7 — Reviews** — completed stays can submit immutable reviews; publication remains backend/admin controlled.
8. **M8 — Notifications** — in-app notifications can be listed and marked read.
9. **M9 — Production QA** — CI/analyze/test/build checks are configured; final production certification remains blocked by missing committed Android/iOS platform scaffolding and empty live property inventory.

## Development rules

- Keep secrets out of source control.
- Do not bypass backend/RLS/business-rule enforcement from the client.
- Do not implement fake production payment or booking success states.
- Use authoritative backend RPCs for booking, pricing, payment, cancellation/refund, and review rules.
- Every meaningful milestone must be tested, committed, and pushed.
