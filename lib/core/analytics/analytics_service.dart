import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsService {
  const AnalyticsService(this.client);

  final SupabaseClient client;

  static const allowedEvents = {
    'search_started',
    'search_completed',
    'property_viewed',
    'booking_started',
    'booking_completed',
    'booking_cancelled',
  };

  Future<void> track(String event, {Map<String, Object?> properties = const {}}) async {
    if (!allowedEvents.contains(event)) return;
    if (client.auth.currentSession == null) return;
    try {
      // Only coarse, non-sensitive event properties should be supplied by callers.
      await client.from('analytics_events').insert({
        'event_name': event,
        'properties': properties,
      });
    } catch (_) {
      // Analytics must never block or fail a user-facing operation.
    }
  }
}
