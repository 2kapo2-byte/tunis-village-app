import 'package:tunis_village_core/tunis_village_core.dart';

void main() {
  final guests = GuestComposition(adults: 2, childAges: [4, 9]);
  assert(guests.childrenCount == 2);
  assert(guests.totalGuests == 4);
  assert(guests.toMap()['children_count'] == 2);

  final booking = Booking(
    id: 'b1',
    bookingCode: 'TV-1',
    propertyId: 'p1',
    unitId: 'u1',
    checkIn: DateTime(2026, 9, 1),
    checkOut: DateTime(2026, 9, 4),
    nights: 3,
    guests: guests,
    status: BookingStatus.confirmed,
  );
  assert(booking.status == BookingStatus.confirmed);
  assert(AnalyticsEvent.bookingCompleted.name == 'booking_completed');
}
