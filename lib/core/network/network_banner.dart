import 'package:flutter/material.dart';

import 'network_status.dart';

class NetworkBanner extends StatefulWidget {
  const NetworkBanner({required this.child, super.key});

  final Widget child;

  @override
  State<NetworkBanner> createState() => _NetworkBannerState();
}

class _NetworkBannerState extends State<NetworkBanner> {
  late final NetworkStatus _status;

  @override
  void initState() {
    super.initState();
    _status = NetworkStatus();
  }

  @override
  void dispose() {
    _status.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: _status,
        builder: (context, _) => Stack(
          children: [
            widget.child,
            if (_status.isOffline)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Material(
                  elevation: 8,
                  child: SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      child: const Row(
                        children: [
                          Icon(Icons.wifi_off_outlined),
                          SizedBox(width: 10),
                          Expanded(child: Text('لا يوجد اتصال بالإنترنت. بعض العمليات لن تعمل حتى يعود الاتصال.')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
