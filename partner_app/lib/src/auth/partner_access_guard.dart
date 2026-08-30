import '../partner_role.dart';
import '../partner_session.dart';

class PartnerAccessGuard {
  const PartnerAccessGuard();

  bool canEnter(PartnerSession? session) =>
      session != null && session.isAuthorized;

  bool canEnterRole(PartnerSession? session, PartnerRole requiredRole) =>
      session != null && session.role == requiredRole;
}
