import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/operations/partner_booking_operation.dart';

void main() {
  test('known backend booking errors map deterministically', () {
    expect(
      partnerBookingResultStatusFromError('partner_not_approved'),
      PartnerBookingResultStatus.notApproved,
    );
    expect(
      partnerBookingResultStatusFromError('unit_unavailable'),
      PartnerBookingResultStatus.unavailable,
    );
    expect(
      partnerBookingResultStatusFromError('invalid_transition'),
      PartnerBookingResultStatus.invalidTransition,
    );
  });

  test('unknown backend errors fail closed', () {
    expect(
      partnerBookingResultStatusFromError('something_new'),
      PartnerBookingResultStatus.unknown,
    );
  });
}
