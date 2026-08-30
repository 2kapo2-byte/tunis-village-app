# Phase 07 — Marketer App

Status: CLOSED (foundation and contract layer)

## Implemented

- Added deterministic PartnerRole parsing for marketer/owner/unknown.
- Added PartnerSession boundary with explicit authorization state.
- Added unit coverage for role parsing and unknown-role rejection.
- Kept role authorization server-authoritative; the client role is not a security boundary.
- Partner app remains isolated from Customer routes.
- Shared booking/domain models remain in `tunis_village_core`.

## Scope decision

The repository currently does not expose an existing, production-ready marketer UI implementation through the available source index. Therefore this phase establishes the marketer application contract/foundation rather than fabricating a booking UI or pretending an unverified flow is complete. The next phase can build the Owner dashboard without duplicating the domain core, while marketer UI can be expanded from these contracts when the concrete existing screens are available.

## Verification

Static source review and unit test coverage were added. Runtime Flutter execution remains a CI/device gate; this phase is not claiming a green runtime build without CI evidence.

Next: Phase 08 — Owner Dashboard.
