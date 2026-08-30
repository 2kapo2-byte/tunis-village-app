# Tunis Village Core

This directory defines the reusable domain boundary for the Customer and Partner mobile apps.

## Shared responsibilities

- Authentication/session contracts
- Supabase access boundary
- Domain models and DTOs
- Booking, pricing, payment and cancellation contracts
- Reviews and notifications contracts
- Network/error handling
- Privacy-safe analytics
- Shared test fixtures and contract tests

## Rule

Business rules remain server-authoritative. This package must not contain service-role credentials or duplicate backend business logic.

The existing `lib/core` remains the source during the migration. Files are moved only after their imports and tests are updated. This marker prevents premature destructive moves while Phase 02 is executed incrementally.
