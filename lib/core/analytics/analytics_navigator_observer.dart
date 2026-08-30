import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'analytics_service.dart';

class AnalyticsNavigatorObserver extends NavigatorObserver {
  AnalyticsNavigatorObserver(this._client);
  final SupabaseClient _client;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _track(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _track(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _track(Route<dynamic> route) {
    final event = switch (route.settings.name) {
      'property-details' => 'property_viewed',
      'booking-review' => 'booking_started',
      'booking-confirmation' => 'booking_completed',
      _ => null,
    };
    if (event != null) AnalyticsService(_client).track(event);
  }
}
