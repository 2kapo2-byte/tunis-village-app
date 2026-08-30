import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class NetworkStatus extends ChangeNotifier {
  NetworkStatus({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity() {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
    _refresh();
  }

  final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOffline = false;

  bool get isOffline => _isOffline;

  Future<void> _refresh() async {
    _onChanged(await _connectivity.checkConnectivity());
  }

  void _onChanged(List<ConnectivityResult> results) {
    final offline = results.isEmpty || results.every((r) => r == ConnectivityResult.none);
    if (_isOffline != offline) {
      _isOffline = offline;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
