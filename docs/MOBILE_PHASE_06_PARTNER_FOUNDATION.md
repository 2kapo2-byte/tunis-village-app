# Phase 06 — Partner App Foundation

Status: CLOSED (foundation scaffold)

## Implemented

- Added `partner_app/` as the isolated Partner application boundary.
- Added a dedicated Flutter package manifest.
- Added a dedicated Partner app entry point and smoke test.
- Partner app depends on the shared `tunis_village_core` package.
- No customer routes or customer UI were copied into the Partner app.
- No authorization is implemented in the UI; role enforcement remains backend/RLS authoritative.

## Gate

Foundation-only scope is complete. Marketer functionality is intentionally deferred to Phase 07, and Owner functionality to Phase 08.

## Verification limitation

The repository API can inspect and commit source, but cannot execute Flutter locally. CI/device execution remains the authoritative runtime verification gate in the release-engineering phases. The smoke test is included so CI can execute it.

Next: Phase 07 — Marketer App.
