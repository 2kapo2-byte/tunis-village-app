# Tunis Village App — Mobile Architecture v0.1

## Goal
A production-oriented Flutter Android/iOS customer application connected to the existing Tunis Village Booking Marketplace backend.

## Layers
```text
Presentation
  ↓
Feature State / ViewModels
  ↓
Repositories
  ↓
Services (Supabase/Auth/Storage/Notifications)
  ↓
Existing Tunis Village backend
```

## Feature modules
```text
lib/
  app/
  core/
    config/
    errors/
    routing/
    theme/
    widgets/
  features/
    auth/
    home/
    search/
    properties/
    availability/
    booking/
    payments/
    bookings/
    favorites/
    reviews/
    notifications/
    profile/
    support/
```

## State management
Use a predictable feature-scoped state approach. Do not introduce global mutable state for booking/payment business rules. Server state must remain authoritative.

## Navigation
Primary customer navigation:
- Home
- Search
- Favorites
- My Bookings
- Profile

Secondary routes:
- Property details
- Availability/date picker
- Guest composition
- Price summary
- Booking checkout
- Payment
- Booking confirmation
- Booking details
- Notifications
- Review creation
- Support

## Reuse policy
Reuse backend contracts and pure business logic where safe. Do not copy Web-only React components or browser-specific state into Flutter.

## Security
- Public/mobile Supabase configuration only.
- No service-role key.
- Authenticated user context required for private operations.
- Protected mutations through existing RPC/service contracts.
- Server totals and state transitions are authoritative.

## Localization
Arabic-first UX with RTL support. English can be added without redesigning the feature architecture.

## Release targets
Android and iOS from the same Flutter codebase, with platform-specific integrations isolated behind services/adapters.
