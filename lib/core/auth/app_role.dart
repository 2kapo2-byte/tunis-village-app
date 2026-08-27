enum AppRole { guest, marketer, admin }

extension AppRoleX on AppRole {
  String get value => switch (this) {
        AppRole.guest => 'guest',
        AppRole.marketer => 'marketer',
        AppRole.admin => 'admin',
      };

  bool get canUsePartnerMode => this == AppRole.marketer || this == AppRole.admin;
}
