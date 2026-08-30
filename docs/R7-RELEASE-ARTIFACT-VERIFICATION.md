# R7 — Release Artifact & Installation Verification

## Status
CI verification in progress.

## Objective
Verify that Customer and Partner release artifacts are actually produced and non-empty, while keeping iOS validation as unsigned build verification until Apple signing credentials/certificates are configured.

## Changes
- Corrected Partner APK verification path: the verification command now runs from `partner_app` and checks `build/app/outputs/flutter-apk/app-release.apk`.
- Added file-type and SHA-256 checks for both generated APKs.
- Kept APK artifacts uploaded by GitHub Actions.
- Kept iOS builds explicitly `--no-codesign`; this verifies compilation/platform integrity, not App Store signing/distribution.

## Acceptance gates
1. Customer analyze/test passes.
2. Partner analyze/test passes.
3. Shared Core analyze/test passes.
4. Public config/secret hygiene passes.
5. Customer release APK exists, is non-empty, and is recognized as an APK file.
6. Partner release APK exists, is non-empty, and is recognized as an APK file.
7. Both APK SHA-256 hashes are produced.
8. Customer and Partner iOS unsigned release validation passes.

## Decision
Do not claim signed iOS distribution readiness until Apple signing credentials and certificates are configured in a protected release environment.

## Closure rule
R7 closes only after the post-change GitHub Actions run succeeds across all required gates. Any failure must be fixed and re-tested.
