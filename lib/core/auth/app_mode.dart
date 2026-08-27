enum AppMode { customer, partner }

extension AppModeX on AppMode {
  String get label => switch (this) {
        AppMode.customer => 'العميل',
        AppMode.partner => 'المسوق / الشريك',
      };
}
