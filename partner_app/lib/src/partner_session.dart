import 'partner_role.dart';

class PartnerSession {
  const PartnerSession({required this.userId, required this.role});

  final String userId;
  final PartnerRole role;

  bool get isMarketer => role == PartnerRole.marketer;
  bool get isOwner => role == PartnerRole.owner;
  bool get isAuthorized => role != PartnerRole.unknown;
}
