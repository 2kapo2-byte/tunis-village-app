import 'package:supabase_flutter/supabase_flutter.dart';

import 'app_role.dart';

class RoleResolver {
  const RoleResolver(this.client);

  final SupabaseClient client;

  Future<AppRole> resolveCurrentRole() async {
    final user = client.auth.currentUser;
    if (user == null) return AppRole.guest;

    final row = await client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .maybeSingle();

    final value = row?['role']?.toString().toLowerCase();
    return switch (value) {
      'admin' || 'platform_admin' => AppRole.admin,
      'marketer' || 'partner' => AppRole.marketer,
      _ => AppRole.guest,
    };
  }
}
