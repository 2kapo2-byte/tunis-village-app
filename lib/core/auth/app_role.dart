enum AppRole { customer, owner, staff, superAdmin }

extension AppRoleX on AppRole {
  String get value => switch (this) {
        AppRole.customer => 'customer',
        AppRole.owner => 'owner',
        AppRole.staff => 'staff',
        AppRole.superAdmin => 'super_admin',
      };

  bool get canUsePartnerMode => false;
}
