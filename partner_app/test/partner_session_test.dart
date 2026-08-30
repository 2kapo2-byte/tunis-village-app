import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/partner_role.dart';
import 'package:tunis_village_partner/src/partner_session.dart';

void main() {
  test('role parsing and authorization are deterministic', () {
    expect(partnerRoleFromString('marketer'), PartnerRole.marketer);
    expect(partnerRoleFromString('OWNER'), PartnerRole.owner);
    expect(partnerRoleFromString('unknown'), PartnerRole.unknown);

    expect(
      const PartnerSession(userId: 'u1', role: PartnerRole.marketer).isAuthorized,
      isTrue,
    );
    expect(
      const PartnerSession(userId: 'u2', role: PartnerRole.unknown).isAuthorized,
      isFalse,
    );
  });
}
