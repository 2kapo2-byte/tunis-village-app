enum PartnerRole { marketer, owner, unknown }

PartnerRole partnerRoleFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'marketer':
      return PartnerRole.marketer;
    case 'owner':
      return PartnerRole.owner;
    default:
      return PartnerRole.unknown;
  }
}
