import '../partner_role.dart';

class OwnerPermissions {
  const OwnerPermissions(this.role);

  final PartnerRole role;

  bool get canManageProperties => role == PartnerRole.owner;
  bool get canManageUnits => role == PartnerRole.owner;
  bool get canManageAvailability => role == PartnerRole.owner;
  bool get canViewOwnerBookings => role == PartnerRole.owner;
}
