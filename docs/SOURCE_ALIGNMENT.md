# Source Alignment — 2026-08-26

## Important finding

The current `master` branch of `Tunis-Village-Booking-Marketplace` is a Vite + React + TypeScript web application, not a Flutter application. Its `package.json` uses React 18, Vite 5, TypeScript, Supabase JS, React Router, Zustand, and Vitest.

This does **not** block the mobile plan.

## Correct mobile strategy

`Tunis-Village-App` will be a new, native Flutter client that connects to the existing Supabase/backend contract.

We will **not** copy the web frontend into the mobile repository and we will not attempt to convert the web UI into Flutter automatically.

## Reuse targets

We should reuse the platform's authoritative:

- Supabase project/database
- Authentication model
- RLS policies
- RPC command boundaries
- Booking state machine
- Availability rules
- Pricing rules
- Payment state model
- Cancellation/refund rules
- Reviews rules
- Media/storage conventions

## Mobile-specific work

The following must be implemented specifically for Flutter:

- Android/iOS project shells
- Mobile navigation
- Responsive mobile UI
- Mobile state management
- Mobile repositories/services
- Secure local session handling
- Push notification integration
- Deep links
- App lifecycle handling
- Android/iOS permissions and release configuration

## Safety rule

Do not invent mobile-only business rules when the existing backend already owns the rule. When the backend contract is incomplete, document the gap instead of silently implementing a conflicting client-side version.
