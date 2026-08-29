import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_app/core/models/guest_composition.dart';
import 'package:tunis_village_app/core/models/booking.dart';
import 'package:tunis_village_app/core/models/payment.dart';
import 'package:tunis_village_app/features/booking/domain/price_estimate.dart';

void main() {
  test('guest composition calculates totals and preserves child ages', () {
    const guests = GuestComposition(adults: 2, childAges: [4, 9]);
    expect(guests.childrenCount, 2);
    expect(guests.totalGuests, 4);
    expect(guests.toMap()['child_ages'], [4, 9]);
  });

  test('booking status maps backend payment lifecycle states', () {
    final booking = Booking.fromMap({
      'id': 'b',
      'booking_code': 'TV-2026-000001',
      'property_id': 'p',
      'unit_id': 'u',
      'check_in': '2026-09-01',
      'check_out': '2026-09-03',
      'nights': 2,
      'adults': 2,
      'status': 'payment_pending',
      'total_amount': 1000,
    });
    expect(booking.status, BookingStatus.paymentPending);
  });

  test('payment model maps backend statuses and method', () {
    final payment = Payment.fromMap({
      'id': 'pay',
      'booking_id': 'b',
      'amount': 1000,
      'method': 'online',
      'status': 'partially_refunded',
      'currency': 'EGP',
    });
    expect(payment.status, PaymentStatus.partiallyRefunded);
    expect(payment.method, 'online');
  });

  test('price estimate rejects explicit server error', () {
    expect(
      () => PriceEstimate.fromRpc({'success': false, 'error': 'unit_unavailable'}),
      throwsStateError,
    );
  });
}
