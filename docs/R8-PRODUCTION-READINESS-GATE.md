# R8 — Production Readiness Gate

## Status
OPEN — release blockers identified; not safe to close yet.

## Verified
- Flutter CI/release QA has passed through R7.
- Customer Android release configuration has a stable application ID and version metadata.
- Public configuration/secret hygiene gate is active.
- iOS validation is currently platform validation without code signing.
- No obvious placeholder/credential strings were found by repository search.

## Blocking finding
Customer Android `release` currently uses `signingConfigs.debug`. This is acceptable for CI artifact validation only, but it is NOT a production release signing configuration.

## Decision
Do not claim production-ready and do not silently convert the debug signing configuration into a fake production configuration. Production signing must be supplied through secure CI secrets/keystore configuration before store submission.

## Required before production release
1. Create/provide production Android keystore securely (never commit it).
2. Configure GitHub Actions secrets/variables for the keystore and signing credentials.
3. Wire release signing only when those secrets exist; fail closed when absent.
4. Configure Apple signing/certificates/profiles in the release environment for iOS distribution.
5. Run final signed Android/iOS release validation.
6. Verify artifacts and installation on real devices.

## Current conclusion
R8 cannot be CLOSED as a production-ready stage until signing infrastructure is available. The codebase is CI-release validated, but store-distribution signing remains an operational prerequisite.
