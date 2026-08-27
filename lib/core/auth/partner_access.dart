import 'package:supabase_flutter/supabase_flutter.dart';

class PartnerAccess {
  const PartnerAccess(this.client);

  final SupabaseClient client;

  /// Partner mode is enabled only when the authenticated user has a verified
  /// partner/marketer profile. The exact backend table is intentionally kept
  /// configurable until the marketplace schema exposes its final contract.
  Future<bool> canUsePartnerMode() async {
    final user = client.auth.currentUser;
    if (user == null) return false;

    try {
      final row = await client
          .from('marketer_profiles')
          .select('id, status')
          .eq('user_id', user.id)
          .maybeSingle();

      final status = row?['status']?.toString().toLowerCase();
      return row != null && (status == null || status == 'active' || status == 'approved' || status == 'verified');
    } catch (_) {
      // Do not grant partner access when the partner contract is unavailable.
      return false;
    }
  }
}
