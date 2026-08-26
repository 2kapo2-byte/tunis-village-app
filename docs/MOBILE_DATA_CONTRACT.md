# Tunis Village Mobile — Data Contract v0.1

## Source of truth
The mobile app consumes the existing Tunis Village Booking Marketplace backend. It must not duplicate booking, pricing, payment, cancellation, commission, or state-machine business rules locally.

## Architecture
Flutter UI → feature ViewModel/state → repository → Supabase service/RPC → existing backend.

## Customer scope (v1)
- Auth/Profile
- Properties/Units/Images/Amenities
- Availability
- Price estimate
- Booking creation
- Booking details/history
- Payment lifecycle
- Cancellation/refund status
- Favorites
- Reviews (read/create only; immutable after creation for customer/owner)
- Notifications
- Support

## Existing backend contracts identified

### Booking creation
RPC: `create_booking`
Parameter: `p_params`
Required fields:
- `unit_id`
- `property_id`
- `check_in`
- `check_out`
- `guests`
- `adults`
- `children_count`
- `child_ages`
- `payment_method`
- `customer_notes` nullable

Expected result may include:
- `success`
- `booking_id`
- `booking_code`
- `total_amount`
- `status`
- `error`

### Pricing
RPC: `calculate_booking_price`
Parameter: `p_params`
- `unit_id`
- `property_id`
- `check_in`
- `check_out`
- `adults`
- `children_count`
- `child_ages`

Returned pricing fields:
- nights
- base_price
- seasonal_adjustment
- weekend_adjustment
- extra_guest_amount
- children_amount
- cleaning_fee
- discount
- taxes
- total_amount
- effective_min_stay
- included_guests
- extra_adults
- extra_children

### Customer bookings
Table: `bookings`
Customer filter: `customer_id = authenticated user id`.
Expected related data:
- property: id, name, slug, location, type
- unit: id, name, capacity, bedrooms, bathrooms
- payment: id, amount, method, status, created_at

### Customer cancellation
RPC: `cancel_own_booking`
Parameter: `p_booking_id`

## Mobile safety rules
1. Never put service-role keys in the app.
2. Never bypass existing RPCs for protected booking/payment transitions.
3. Never trust client-calculated totals; display estimates only and treat server totals as authoritative.
4. Availability is server authoritative.
5. Guest composition must preserve adults, children_count and child_ages.
6. Booking state is server authoritative.
7. Payment provider secrets and webhook processing stay server-side.
8. RLS remains the access-control boundary.

## Models to mirror in Flutter
Profile, Property, PropertyUnit, PropertyImage, PropertyAmenity, PropertyAvailability, Booking, BookingGuest, BookingChildAge, PriceEstimate, Payment, PaymentAttempt, Review, Favorite, Notification, SupportTicket.

## Next integration work
- Verify auth/profile queries and enum values.
- Verify property listing/detail queries and image/amenity relationships.
- Verify availability query contract.
- Map payment initiation/remaining balance/attempt/webhook result types for mobile-facing flows.
- Map cancellation/refund response types.
- Add repository interfaces and DTO/domain mapping in the mobile project.
