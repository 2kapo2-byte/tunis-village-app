# Tunis Village App — Implementation Roadmap

## M0 — Foundation (current)
- Repository
- Flutter project structure
- configuration
- architecture
- routing foundation
- theme/RTL foundation
- error handling
- data contract

## M1 — Authentication & Profile
- Supabase Auth
- session restoration
- sign in/register/reset password
- profile

## M2 — Discovery
- Home
- property listing
- search
- filters
- property details
- images/amenities
- favorites

## M3 — Availability & Pricing
- date selection
- availability
- adult/children composition
- child ages
- server price estimate

## M4 — Booking
- checkout
- booking creation
- booking confirmation
- booking details/history

## M5 — Payment
- payment methods exposed by backend
- payment initiation
- payment status
- remaining balance where applicable
- provider-specific UI only through safe contracts

## M6 — Post-booking
- cancellation
- refund status
- reviews
- notifications
- support

## M7 — Production
- Android release
- iOS release
- deep links
- push notifications
- analytics/crash reporting if approved
- security review
- performance/accessibility
- store compliance

## Rule
Do not advance a phase until its tests and integration checks pass. Each completed phase must be committed and pushed to the dedicated mobile repository.
