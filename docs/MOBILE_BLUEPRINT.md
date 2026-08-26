# Tunis Village Mobile App Blueprint

**Status:** M0 — Foundation and architecture baseline
**Date:** 2026-08-26

## 1. Product role

Tunis Village App is the mobile client for the Tunis Village Booking Marketplace. It is not a second marketplace backend.

The app must consume the same authoritative backend and business rules used by the web platform.

## 2. Primary audience for v1

Guest / direct customer.

Owner, Marketer/Partner, and Platform Admin mobile experiences are intentionally out of scope for the first customer release. They may become separate apps or controlled role-based experiences later.

## 3. Core v1 journeys

1. App launch and session restoration
2. Sign in / registration
3. Home and discovery
4. Search by dates and guest composition
5. Property/unit details
6. Availability validation
7. Price calculation and breakdown
8. Booking creation
9. Payment handoff/status
10. Booking confirmation and details
11. My bookings
12. Cancellation according to backend policy
13. Favorites
14. Reviews
15. Notifications
16. Profile and account settings

## 4. Guest composition requirement

Search and booking must support:

- Adults
- Children count
- Individual child ages

The mobile client must not collapse this into a single guest integer because the platform's pricing and booking rules depend on the composition.

## 5. Navigation baseline

Primary navigation:

- Home
- Search
- Favorites
- My Bookings
- Profile

Secondary surfaces:

- Notifications
- Property details
- Booking flow
- Booking details
- Cancellation flow
- Review flow

## 6. Architecture

Use a feature-first Flutter architecture with clear separation between presentation, application/view-model logic, repositories, and services.

```text
lib/
  app/
  core/
  features/
    auth/
    home/
    search/
    properties/
    favorites/
    booking/
    payments/
    reviews/
    notifications/
    profile/
```

Repositories own data-source coordination. Services wrap external integrations such as Supabase/auth/storage/push notifications. UI must not directly contain privileged business operations.

## 7. Backend boundary

The mobile app must treat the existing Tunis Village platform backend as authoritative for:

- Authentication and authorization
- Availability
- Booking creation
- Booking state transitions
- Pricing
- Commission calculations where applicable
- Payment state
- Cancellation/refund rules
- Reviews permissions
- Owner/platform controls

The client must never bypass RLS or attempt privileged database writes with elevated credentials.

## 8. Data contract to define before feature implementation

The next architecture task is to map the existing backend to mobile-safe read/write contracts for:

- profiles
- properties
- property_units
- property_availability
- bookings
- booking_guests
- booking_child_ages
- payments
- commissions
- owner_payouts
- reviews
- favorites
- notifications

Where RPCs are the platform's intended command boundary, the mobile client will call those RPCs rather than reproducing their internal SQL logic.

## 9. Security baseline

- No service-role key in the app.
- Public configuration only where appropriate.
- Authenticated operations require the user's session.
- Authorization remains server-side.
- Booking/payment success must be based on authoritative backend state, not client assumptions.
- Secrets must never be committed.

## 10. Delivery phases

### M0 — Foundation

Repository, Flutter scaffold, architecture, environment strategy, documentation, CI baseline.

### M1 — Auth + Shell

Authentication, session restoration, app shell, navigation, error/loading states.

### M2 — Discovery

Home, search, filters, properties, units, media, availability.

### M3 — Booking

Guest composition, pricing, booking creation, booking state display.

### M4 — Payments

Integrate the platform's approved payment flow only after the backend payment contract is production-ready.

### M5 — Post-booking

My bookings, booking details, cancellation/refund status, notifications.

### M6 — Engagement

Favorites, reviews, offers/coupons, sharing, deep links.

### M7 — Release

Android/iOS testing, signing, privacy/store requirements, release candidate, production rollout, monitoring.

## 11. Explicit non-goals for M0

- No real payment provider integration.
- No fake payment success.
- No duplicate booking engine.
- No direct privileged database access.
- No owner/admin app.
- No production push-notification provider commitment before the notification contract is defined.

## 12. Source of truth

The web marketplace repository remains the source of truth for current backend/business-rule behavior. The mobile repository must adapt to that contract rather than changing it silently.
