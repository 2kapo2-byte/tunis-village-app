import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/owner/owner_booking.dart';

void main() {
  test('owner booking summary preserves booking identity and dates', () {
    final booking = OwnerBookingSummary(
      bookingId: 'b1',
      bookingCode: 'TV-1001',
      propertyId: 'p1',
      unitId: 'u1',
      checkIn: DateTime(2026, 9, 10),
      checkOut: DateTime(2026, 9, 12),
      status: OwnerBookingStatus.confirmed,
    );

    expect(booking.bookingCode, 'TV-1001');
    expect(booking.propertyId, 'p1');
    expect(booking.unitId, 'u1');
    expect(booking.checkOut.isAfter(booking.checkIn), isTrue);
    expect(booking.status, OwnerBookingStatus.confirmed);
  });
}
