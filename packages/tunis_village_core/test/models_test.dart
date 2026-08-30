import 'package:test/test.dart';
import 'package:tunis_village_core/tunis_village_core.dart';

void main() {
  test('guest composition exposes children and total guests', () {
    final guests = GuestComposition(adults: 2, childAges: [4, 9]);
    expect(guests.childrenCount, 2);
    expect(guests.totalGuests, 4);
    expect(guests.toMap()['children_count'], 2);
  });

  test('booking and analytics contracts are exported', () {
    final booking = Booking(
      id: 'b1',
      bookingCode: 'TV-1',
      propertyId: 'p1',
      unitId: 'u1',
      checkIn: DateTime(2026, 9, 1),
      checkOut: DateTime(2026, 9, 4),
      nights: 3,
      guests: GuestComposition(adults: 2),
      status: BookingStatus.confirmed,
    );
    expect(booking.status, BookingStatus.confirmed);
    expect(AnalyticsEvent.bookingCompleted.name, 'booking_completed');
  });
}
