# Tunis Village Mobile — Two-App Execution Plan

## Architecture decision

- Customer App: customer-only experience.
- Partner App: marketer + property owner experience.
- One Supabase backend and one database remain the source of truth.
- Shared domain contracts must not be duplicated between apps.
- Flutter clients never become an authority for booking, pricing, payment, cancellation, payout, review moderation, or permissions.

## Execution gates

Stages are strictly sequential. A stage is not complete until implementation, review, automated verification, and relevant integration/security checks pass. If a blocker is found, fix it before advancing.

00. Architecture freeze
01. Current app audit and backup
02. Extract shared core
03. Split customer app
04. Customer production completion
05. Customer security and contract audit
06. Partner app foundation
07. Marketer experience
08. Owner dashboard
09. Owner booking management
10. Owner reviews and media
11. Payouts and financials
12. Partner notifications and support
13. Privacy-safe analytics
14. Deep links and routing
15. Full integration testing
16. Final security/RLS audit
17. CI/CD and release engineering
18. Staging environment verification
19. Production QA
20. Store readiness
21. Final production certification

## Reuse policy

Prefer extracting and reusing existing authentication, Supabase access, domain models, RPC contracts, pricing/payment/cancellation/review contracts, notifications, analytics, networking, error handling, tests, and CI patterns from the current application. Do not rewrite working business logic merely to fit the new app split.

## Release rule

No APK/AAB/IPA is called production-ready until CI, integration tests, security review, and real-device/staging verification are green. Store credentials, signing keys, payment-provider credentials, and production secrets must never be committed to the repository.
