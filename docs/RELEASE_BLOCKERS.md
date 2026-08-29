# Mobile Release Blockers

This checklist tracks the remaining release-gate items for the Flutter mobile app.

## Current blockers

1. Complete and verify native Android/iOS platform scaffolding from a real Flutter toolchain.
2. Confirm `flutter analyze`, `flutter test`, and release builds are green in CI.
3. Populate a controlled staging dataset with at least one approved property and available unit for end-to-end verification. Do not seed production with fake inventory.
4. Configure and verify the real payment provider before enabling online-payment success states.
5. Perform device-level smoke tests for authentication, search, booking, payment, cancellation/refund, reviews, and notifications.

## Rule

Do not mark the application Production Ready until all blockers above have evidence of successful verification.
