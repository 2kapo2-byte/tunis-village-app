# R1 — Repository Architecture Audit

Status: COMPLETE
Date: 2026-08-30
Branch: `refactor/two-app-architecture`
Base commit reviewed: `a302d48ede462e3efc11954b9a8ab7c61d415271`

## Scope

Reviewed the current two-app repository boundaries for Customer, Partner, and Shared Core; dependency direction; duplicate/shared models; environment configuration; routing; authentication; Supabase integration; and CI verification.

## Findings

### Customer application
- Customer application entrypoint is `lib/main.dart` and composes `TunisVillageApp`.
- Customer routing is isolated to customer-facing flows in `lib/core/routing/app_router.dart`.
- Customer routes cover authentication, discovery, property details, booking, payment status, bookings, reviews, notifications, and support.
- No partner route is registered in the customer router.

### Partner application
- Dedicated `partner_app/` exists with its own entrypoint and partner-only source tree.
- Partner code includes explicit access guard, partner role/session contracts, availability permissions, owner permissions, financial read models, booking operations, notifications, and support.
- Partner app depends on the shared core package rather than the customer application's feature layer.

### Shared Core
- `packages/tunis_village_core` exists and currently contains shared domain models, analytics contracts, and network result contracts.
- The root customer app still contains some copies of shared model concepts (for example booking and guest composition). These are architectural debt, not a safe R1 deletion target because downstream imports must be migrated atomically in R2.

### Dependency boundaries
- Partner app -> shared core is explicit via a path dependency.
- Customer app currently owns most customer feature implementations.
- No partner feature imports were found in the customer router.
- Do not move business rules into either client; backend remains authoritative.

### Environment configuration
- `.env.example` contains only public Supabase URL and publishable/anon key placeholders.
- Runtime configuration uses `String.fromEnvironment`.
- No service-role key or privileged secret is intended for repository storage.
- Production secret injection remains a release/staging concern.

### Routing
- Customer router uses GoRouter with Supabase auth state refresh.
- Unauthenticated users are redirected to authentication except public auth paths.
- Authenticated users are redirected away from public auth paths.
- Customer routes validate route payload types and fall back safely to search where applicable.

### Authentication / authorization
- Customer authentication is backed by Supabase auth.
- Partner access is represented separately in `partner_app` and has a fail-closed access guard.
- UI guards are not treated as the security boundary; backend/RLS remains authoritative.

### Supabase integration
- Supabase initialization is centralized in `lib/core/services/supabase_service.dart`.
- The client uses the publishable/anon key only.
- Booking, pricing, payment, cancellation, reviews, and notifications remain repository/service boundaries over the existing backend contracts.

## R1 decisions

1. **No destructive code deletion in R1.** Existing duplicate model files are recorded for R2 extraction/migration.
2. **No business-rule rewrite.** Existing server-authoritative contracts remain intact.
3. **No new authentication boundary.** Current Supabase + partner fail-closed model is retained.
4. **No environment secret changes.** Current public-only configuration is safe for repository storage.
5. **No routing rewrite.** Current customer routing is coherent and does not expose partner routes.

## Verification gate

Required automated verification is delegated to the repository's existing Flutter CI on this commit. The stage is closed only when the CI run for this audit commit is green.

## Next stage

R2 — Production Platform Stabilization: make Android/iOS platform projects first-class repository assets, remove temporary platform generation from release validation, and preserve the current two-app boundaries while doing so.
