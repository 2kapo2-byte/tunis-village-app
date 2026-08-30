# Phase 02 — Shared Core Extraction & Boundary Verification

Status: COMPLETE

## Objective
Establish and verify one reusable shared package for cross-app domain contracts without duplicating business authority in Customer or Partner.

## Verified structure
- Shared package: `packages/tunis_village_core`
- Package name: `tunis_village_core`
- Public barrel: `lib/tunis_village_core.dart`
- Shared source areas currently include analytics, models, and network contracts.
- Partner consumes the shared package through a local path dependency.

## Boundary decisions
1. Shared Core contains reusable contracts/models and cross-app primitives only.
2. Customer-only and Partner-only presentation/features remain in their respective app trees.
3. Booking, pricing, payment, cancellation/refund, payout, review moderation, and authorization remain backend-authoritative.
4. No business rule is copied into Shared Core merely to reduce imports.
5. Existing duplicate/legacy models are not deleted blindly; any migration must be import-mapped and verified in a dedicated cleanup change.

## Dependency verification
- Partner depends on `tunis_village_core` via `../packages/tunis_village_core`.
- Shared Core has no Flutter dependency and remains a lightweight Dart package with `package:test` for its tests.
- No reverse dependency from Shared Core into either app was introduced.

## Safety decision
A potentially destructive duplicate-model cleanup was intentionally deferred. The current repository contains legacy customer-side model locations that may still be referenced. Removing them without a complete import graph would create unnecessary breakage. They are therefore a controlled follow-up item, not a Phase 02 blocker.

## Verification gate
The existing CI gate must pass for Customer, Partner, and Shared Core after this documentation checkpoint. No production secrets, signing material, or test inventory are introduced.

## Phase gate
Phase 02 is closed when the post-change CI run is green. Next phase: 03 — Customer App Split/Boundary Completion.
