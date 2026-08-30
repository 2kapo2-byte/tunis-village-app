# Phase 01 — Current App Audit & Backup

Status: COMPLETE

## Scope

Audited the current Flutter application structure on `refactor/two-app-architecture` before changing application boundaries.

## Current structure observed

The codebase already has a separation between shared/core concerns and feature/presentation concerns. Core areas include authentication/roles, configuration, domain models, networking, routing, Supabase access, support, analytics and theme. Feature areas include authentication and customer-facing flows. Platform scaffolding for Android is present and iOS generation is covered by CI.

## Reuse candidates

### Shared / extractable
- Supabase client and configuration
- Authentication/session handling
- Role resolution and partner access contracts
- Domain models: booking, guest composition, payment, profile, property, property unit, review, favorite
- Networking status/banner and error handling
- Routing primitives
- Analytics service and navigation observer
- Support/help primitives
- Theme
- Existing test utilities and contract tests

### Customer-only
- Search/discovery
- Availability presentation
- Property/unit discovery and detail views
- Favorites
- Customer booking completion
- Customer booking history/details
- Customer cancellation/refund presentation
- Review creation

### Partner-only / migration candidates
- Partner role/access logic
- Marketer booking workflow
- Commission/earnings presentation
- Owner property/unit management
- Owner availability management
- Owner booking management
- Owner reviews/media/payout presentation

## Backup / recovery point

This work is intentionally isolated on `refactor/two-app-architecture`. Phase 00 architecture freeze was committed before this audit. No destructive removal of existing customer functionality was performed during Phase 01.

The dedicated refactor branch therefore acts as the working recovery point while the split is developed incrementally.

## Safety findings

1. Do not delete partner-related code during the split until each candidate is mapped to a destination.
2. Do not duplicate booking/pricing/payment/cancellation business rules in either app.
3. Do not move authorization into UI-only guards; preserve backend/RLS enforcement.
4. Do not introduce production test data.
5. Keep Customer App behavior stable while extracting shared code.

## Phase gate

Phase 01 is closed because the current application has been inventoried at the architectural level, reusable boundaries are identified, the refactor is isolated on its dedicated branch, and no destructive split has been performed.

Next phase: 02 — Extract Shared Core.