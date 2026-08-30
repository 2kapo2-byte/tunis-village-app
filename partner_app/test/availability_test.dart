import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/availability/availability_permissions.dart';
import 'package:tunis_village_partner/src/availability/availability_status.dart';
import 'package:tunis_village_partner/src/partner_role.dart';

void main() {
  test('availability parsing fails closed', () {
    expect(availabilityStatusFromString('available'), AvailabilityStatus.available);
    expect(availabilityStatusFromString('booked'), AvailabilityStatus.booked);
    expect(availabilityStatusFromString('unexpected'), AvailabilityStatus.unknown);
  });

  test('owner can manage availability while marketer is read-only', () {
    const owner = AvailabilityPermissions(PartnerRole.owner);
    const marketer = AvailabilityPermissions(PartnerRole.marketer);
    const unknown = AvailabilityPermissions(PartnerRole.unknown);

    expect(owner.canView, isTrue);
    expect(owner.canManage, isTrue);
    expect(marketer.canView, isTrue);
    expect(marketer.canManage, isFalse);
    expect(unknown.canView, isFalse);
    expect(unknown.canManage, isFalse);
  });
}
