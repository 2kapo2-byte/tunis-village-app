# Tunis Village Mobile — Two-App Architecture Freeze

Status: Phase 00 — COMPLETE

## Decision

The mobile product will consist of two applications sharing one Supabase backend and one domain contract layer:

1. Tunis Village Customer — customer discovery, booking, payment, cancellation, reviews, notifications, help and privacy-safe analytics.
2. Tunis Village Partners — marketer and property-owner workflows, with server-enforced role separation.

## Non-negotiable architecture rules

- Supabase is the single backend/database source of truth.
- Booking, pricing, payment, cancellation/refund, commission, payout and review business rules remain server-side.
- Flutter clients must not embed service-role secrets or bypass RLS/RPC contracts.
- Customer UI must not contain owner/marketer management workflows.
- Partner UI may expose marketer/owner features, but authorization is enforced by backend/RLS, not UI hiding.
- Shared models, services, contracts, networking, error handling, analytics and tests should be reusable rather than duplicated.
- Existing validated booking flows must be preserved during refactor.
- No production data is to be fabricated for testing.

## Reuse map

Shared: auth, Supabase client, models, booking contracts, pricing contracts, payment/cancellation contracts, reviews, notifications, analytics, network resilience, errors and test utilities.

Customer-only: discovery/search, property/unit browsing, favorites, customer booking, customer bookings, cancellation UX, review creation.

Partner-only: marketer booking, commissions, owner dashboard, properties, units, availability, owner booking management, payouts, owner reviews and media management.

## Phase gate

Phase 00 is closed only when the architecture decision is documented and subsequent work occurs on the dedicated refactor branch. No application split or shared-core extraction is considered part of Phase 00.

Next phase: 01 — Current App Audit & Backup.