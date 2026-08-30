import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/owner/owner_permissions.dart';
import 'package:tunis_village_partner/src/partner_role.dart';

void main() {
  test('owner permissions are not granted to marketer', () {
    const owner = OwnerPermissions(PartnerRole.owner);
    const marketer = OwnerPermissions(PartnerRole.marketer);

    expect(owner.canManageProperties, isTrue);
    expect(owner.canManageUnits, isTrue);
    expect(owner.canManageAvailability, isTrue);
    expect(owner.canViewOwnerBookings, isTrue);

    expect(marketer.canManageProperties, isFalse);
    expect(marketer.canManageUnits, isFalse);
    expect(marketer.canManageAvailability, isFalse);
    expect(marketer.canViewOwnerBookings, isFalse);
  });
}
