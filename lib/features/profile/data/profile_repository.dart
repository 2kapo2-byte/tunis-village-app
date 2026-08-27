import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/profile.dart';

class ProfileRepository {
  const ProfileRepository(this._client);

  final SupabaseClient _client;

  Future<Profile?> getCurrentProfile(String userId) async {
    final row = await _client.from('profiles').select().eq('id', userId).maybeSingle();
    return row == null ? null : Profile.fromMap(row);
  }

  Future<Profile> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? avatarUrl,
  }) async {
    final row = await _client.from('profiles').update({
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
    }).eq('id', userId).select().single();
    return Profile.fromMap(row);
  }
}
