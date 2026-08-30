import 'package:supabase_flutter/supabase_flutter.dart';

class AnalyticsService {
  const AnalyticsService(this.client);

  final SupabaseClient client;

  Future<void> track(String event, {Map<String, Object?> properties = const {}}) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;
    try {
      await client.from('analytics_events').insert({
        'user_id': userId,
        'event_name': event,
        'properties': properties,
      });
    } catch (_) {
      // Analytics must never block or fail a user-facing operation.
    }
  }
}
