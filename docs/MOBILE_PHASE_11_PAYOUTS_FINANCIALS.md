# Phase 11 — Payouts & Financials

Status: CLOSED

## Backend contract verified

The connected production Supabase project exposes and contains:

- `owner_payouts`
- `commissions`
- `marketer_commissions`
- `partner_accounts`
- `calculate_owner_payout_available(uuid)`
- `create_owner_payout_for_booking(uuid)`
- `request_owner_payout(numeric,date,date)`
- `update_owner_payout_status(...)`
- `resolve_commission_rate(uuid,uuid)`

## Security hardening applied

`calculate_owner_payout_available` was hardened so a caller can only retrieve the balance for their own user ID, or when authorized as platform admin. This prevents a signed-in user from requesting another owner's financial balance by changing the UUID argument.

The function remains server-authoritative and does not trust a client-supplied owner identity for authorization.

## Mobile implementation

Partner financial read models were added for:

- Owner payout summaries and balance summaries.
- Marketer commission summaries.

Status parsers fail closed to `unknown` for unexpected backend values.

No client-side financial calculation, payout status mutation, or provider settlement logic was introduced.

## Verification

- Live Supabase schema inspected.
- Financial tables and foreign keys verified.
- Payout/commission functions inspected from the live database.
- RLS policies verified: owners can read own payouts/commissions; marketers can read own commissions; admin manages financial records.
- Security Advisor re-run. Remaining SECURITY DEFINER warnings are broader existing API warnings; payout balance access is now explicitly owner/admin scoped.
- Runtime Flutter execution remains a CI/device gate.

## Gate decision

Phase 11 is closed because the real backend financial contract exists, its ownership boundary was hardened, and the Partner app has safe read models without duplicating financial authority in the client.

Next: Phase 12 — Partner Authentication & Role Routing.
