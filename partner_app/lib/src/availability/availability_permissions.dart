import '../partner_role.dart';

class AvailabilityPermissions {
  const AvailabilityPermissions(this.role);
  final PartnerRole role;

  bool get canView => role == PartnerRole.owner || role == PartnerRole.marketer;
  bool get canManage => role == PartnerRole.owner;
}
