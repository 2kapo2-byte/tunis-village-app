import 'package:flutter/foundation.dart';

import 'app_mode.dart';
import 'app_role.dart';
import 'partner_access.dart';

class AppModeManager extends ChangeNotifier {
  AppModeManager({required this.role, required this.partnerAccess});

  final AppRole role;
  final PartnerAccess partnerAccess;
  AppMode _mode = AppMode.customer;
  bool _partnerAvailable = false;

  AppMode get mode => _mode;
  bool get partnerAvailable => _partnerAvailable;

  Future<void> load() async {
    if (role == AppRole.customer) {
      _partnerAvailable = await partnerAccess.canUsePartnerMode();
    }
    notifyListeners();
  }

  Future<bool> switchMode(AppMode next) async {
    if (next == AppMode.partner && !_partnerAvailable) return false;
    if (_mode == next) return true;
    _mode = next;
    notifyListeners();
    return true;
  }
}
