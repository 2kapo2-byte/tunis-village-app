# Tunis Village Mobile App — Master Blueprint

## Product
Customer-facing mobile application for the Tunis Village Booking Marketplace. The app targets Android and iOS and shares the existing platform backend and business rules; it is not a copy of the React/Vite web code.

## Principles
- Flutter UI with feature-first architecture.
- Supabase is the shared backend; mobile must respect existing RLS/RPC rules.
- Never ship service-role credentials in the mobile app.
- Booking rules remain server-authoritative.
- Reuse existing booking state machine, availability protection, guest composition, pricing, commission, payment, cancellation/refund, payout and review rules where applicable.
- Do not create a second source of truth for bookings or availability.

## Modules
1. Authentication — login, registration, password reset, session restoration.
2. Profile — customer profile and preferences.
3. Home — discovery, featured properties, search entry points.
4. Search — dates, adults, children, child ages, filters, sorting.
5. Properties — property details, units, media, amenities, policies.
6. Availability — server-authoritative unit/date availability.
7. Booking — quote, guest composition, customer details, confirmation.
8. Payments — payment method selection and payment status; provider integration only when approved.
9. My Bookings — upcoming, active, completed and cancelled bookings.
10. Cancellation — policy display and cancellation/refund status.
11. Favorites — save and remove properties/units.
12. Reviews — read reviews and submit only when business rules permit; immutable after creation unless platform administration deletes.
13. Notifications — booking/payment/status notifications.
14. Settings — language, notification preferences, account actions.

## Layering
Presentation -> Controller/State -> Repository -> Supabase/RPC.

UI must not directly implement booking business rules. Repositories should call the existing backend contracts. Controllers coordinate loading/error/success state.

## Navigation
Public: Home, Search, Property Details, Login/Register.
Authenticated: Profile, Booking flow, My Bookings, Favorites, Reviews, Settings.
Route guards must be session-aware.

## Booking contract
Search and booking must support:
- check-in/check-out
- adults
- children count
- individual child ages
- selected property/unit
- server-calculated nights and pricing
- authoritative availability check
- booking state transitions through existing backend RPC/business rules

## Delivery order
M0 Foundation -> M1 Authentication/Profile -> M2 Home/Search -> M3 Property/Availability -> M4 Booking -> M5 Payments -> M6 Cancellation/Refund -> M7 Favorites/Reviews -> M8 Notifications/Settings -> M9 Production Verification.

## Verification gate
Every module requires analyzer/tests and a backend contract check before being marked complete. Do not claim production readiness from source creation alone.
