# Phase 18 — Production Release Foundation

## Status
IN PROGRESS

## Scope
- Establish explicit Android/iOS release-platform requirements for both customer and partner apps.
- Document stable application IDs, signing requirements, and release prerequisites.
- Keep signing secrets out of source control.
- Make CI/release readiness auditable before store submission.

## Application identities
Customer application:
- Android application ID: `com.tunisvillage.customer`
- iOS bundle identifier: `com.tunisvillage.customer`

Partner application:
- Android application ID: `com.tunisvillage.partner`
- iOS bundle identifier: `com.tunisvillage.partner`

> These identifiers are the intended production identities. They must be verified against the actual Android/iOS project files before store release.

## Security rules
- Never commit keystores, provisioning profiles, certificates, passwords, API keys, or signing secrets.
- CI must consume signing material only from GitHub Actions secrets/secure files when release signing is enabled.
- Debug signing is not production signing.

## Release gates
1. `flutter analyze` passes for customer, partner, and shared core.
2. Unit/widget tests pass for all packages.
3. Customer release APK builds successfully.
4. Partner release APK builds successfully.
5. APK artifacts are present and non-empty.
6. Android application IDs are stable and verified.
7. iOS platform configuration exists before iOS release work is considered complete.
8. Production signing is configured only through secure CI secrets.

## Current limitation
The repository currently needs an explicit verification of the generated/checked-in Android and iOS platform configuration before this phase can be closed. CI-only platform generation is not considered a final production configuration.
