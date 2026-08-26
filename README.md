# Tunis Village App

Official Flutter mobile application for the Tunis Village Booking Marketplace.

## Scope

The app is a mobile client for the existing Tunis Village marketplace. It will use the same backend, authentication, booking engine, pricing rules, availability, payments, reviews, and notifications as the web platform.

### Platforms

- Android
- iOS

### Architecture principle

The mobile app is a separate repository and a separate Flutter client. It must not duplicate backend business rules or create a second booking database.

## Current phase

**M0 — Mobile Foundation & Blueprint**

Initial foundation only. No production booking or payment flow is enabled yet.

## Source platform

Backend and business rules are maintained in the separate repository:
`Tunis-Village-Booking-Marketplace`

## Development rules

- Keep secrets out of source control.
- Do not bypass backend/RLS/business-rule enforcement from the client.
- Do not implement fake production payment or booking success states.
- Every meaningful milestone must be tested, committed, and pushed.
