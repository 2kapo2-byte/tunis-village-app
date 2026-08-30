# R3 — Environment & Secrets Hardening

## Status

R3 is implemented pending CI verification on `refactor/two-app-architecture`.

## Decisions

- Only public runtime configuration is allowed in source-controlled templates.
- `.env` and `.env.*` files are ignored; `.env.example` is the only allowed tracked environment template.
- Supabase privileged/service-role credentials must never be shipped in either mobile application.
- Customer runtime configuration is supplied through Dart compile-time environment values (`SUPABASE_URL` and `SUPABASE_ANON_KEY`).
- Supabase initialization uses the publishable/anonymous key and the configured URL only.
- Partner currently remains a shell application with shared-core dependency; partner Supabase wiring will be introduced when its production data flows are implemented, using the same public-config boundary.
- CI now performs a tracked-file secret hygiene check before release builds.

## Verification scope

The CI guard checks for:

1. tracked `.env` files other than `.env.example`;
2. Supabase service-role markers;
3. private-key markers;
4. common GitHub token markers;
5. required public variables in `.env.example`.

This stage does not create, rotate, or expose any production secret. Production secret values remain external to Git and must be supplied through the deployment environment when required.

## Follow-up

Production/staging secret injection and provider-specific signing credentials are intentionally deferred to the release/deployment stages. They must never be committed to this repository.
