import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/auth/partner_access_guard.dart';
import 'package:tunis_village_partner/src/partner_role.dart';
import 'package:tunis_village_partner/src/partner_session.dart';

void main() {
  const guard = PartnerAccessGuard();

  test('anonymous and unknown sessions are rejected', () {
    expect(guard.canEnter(null), isFalse);
    expect(
      guard.canEnter(const PartnerSession(userId: 'u', role: PartnerRole.unknown)),
      isFalse,
    );
  });

  test('role access is exact', () {
    const owner = PartnerSession(userId: 'o', role: PartnerRole.owner);
    const marketer = PartnerSession(userId: 'm', role: PartnerRole.marketer);

    expect(guard.canEnterRole(owner, PartnerRole.owner), isTrue);
    expect(guard.canEnterRole(owner, PartnerRole.marketer), isFalse);
    expect(guard.canEnterRole(marketer, PartnerRole.marketer), isTrue);
    expect(guard.canEnterRole(marketer, PartnerRole.owner), isFalse);
  });
}
