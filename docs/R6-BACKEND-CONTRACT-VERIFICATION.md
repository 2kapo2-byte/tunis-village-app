# R6 — Backend Contract Verification

## Status
IN VERIFICATION

## Objective
Verify that the mobile architecture follows the existing Tunis Village Booking Marketplace backend as the source of truth and does not invent or duplicate protected business logic.

## Verified contract source
`docs/MOBILE_DATA_CONTRACT.md` is the mobile contract baseline.

### Customer contracts
- Authentication/profile are server-authoritative.
- Property/unit/image/amenity data is server-authoritative.
- Availability is server-authoritative.
- Pricing uses `calculate_booking_price` and client totals are estimates only.
- Booking creation uses `create_booking` with adults, children_count and child_ages preserved.
- Booking state and payment transitions remain server-authoritative.
- Cancellation uses `cancel_own_booking`.
- Reviews are read/create only for mobile users and immutable after creation.

### Security contracts
- No service-role or provider secrets may ship in either app.
- Protected transitions must use existing RPC/backend boundaries.
- RLS remains the authorization boundary.
- Client input is untrusted and server validation is authoritative.

### Partner contracts
Partner authentication, availability, booking/commission, financial presentation, notifications and support boundaries are already covered by the repository's prior phases and their CI tests. R6 does not duplicate those rules in the client.

## Decision log
1. Do not add local booking/pricing/payment/cancellation state machines.
2. Do not add client-side financial authority.
3. Do not bypass RPCs for protected transitions.
4. Do not add privileged Supabase credentials.
5. Where a backend contract is not directly executable from repository-only CI, record it as a runtime integration gate rather than falsely marking it passed.

## Verification matrix
| Area | Expected authority | Repository action | Gate |
|---|---|---|---|
| Auth/profile | Supabase/backend | Contract mapping only | CI + runtime integration |
| Properties | Backend | Contract mapping only | CI + runtime integration |
| Availability | Backend | Server-authoritative | CI + runtime integration |
| Pricing | Backend RPC | Server total authoritative | CI + runtime integration |
| Booking | Backend RPC | Required guest composition preserved | CI + runtime integration |
| Payment | Backend | No provider secrets/client authority | CI + runtime integration |
| Cancellation/refund | Backend RPC | No local transition authority | CI + runtime integration |
| Reviews | Backend/RLS | Immutable after creation | CI + runtime integration |

## Closure rule
R6 may be closed only after the post-change Flutter CI passes all existing analysis, tests, release builds and public-secret hygiene gates. Repository CI passing does not by itself claim live Supabase credentials or production transactions were exercised.

## Next
R7 — End-to-End Release Readiness.
