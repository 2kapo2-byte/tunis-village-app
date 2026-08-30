# Phase 13 — Partner Dashboard & Availability

Status: CLOSED (verified contract foundation)

## Verified backend schema

- `properties.owner_id` is the ownership anchor.
- `property_units.property_id` links units to properties.
- `property_availability.unit_id`, `date`, `status`, and optional `booking_id` define daily availability.

## Implemented

- Added availability status contract: available / blocked / booked / unknown.
- Added explicit permission boundary: Owner can manage availability; Marketer can view only.
- Unknown roles fail closed.
- Added unit tests for status parsing and role permissions.
- No direct client-side mutation was invented; booked state remains backend authoritative.

## Decision

Because the schema is verified but a dedicated owner availability mutation RPC was not exposed by the inspected function inventory, the phase is closed at the safe contract boundary. UI CRUD will not bypass RLS by writing directly to tables. A verified server-side mutation contract is required before enabling actual block/unblock actions.

Next: Phase 14 — Partner Booking & Commission Operations.
