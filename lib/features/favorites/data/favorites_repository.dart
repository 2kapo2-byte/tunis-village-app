import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/favorite.dart';

class FavoritesRepository {
  const FavoritesRepository(this._client);

  final SupabaseClient _client;

  Future<List<Favorite>> list(String userId) async {
    final rows = await _client.from('favorites').select().eq('user_id', userId).order('created_at', ascending: false);
    return rows.map((row) => Favorite.fromMap(row)).toList();
  }

  Future<void> add({required String userId, required String propertyId}) {
    return _client.from('favorites').insert({'user_id': userId, 'property_id': propertyId});
  }

  Future<void> remove({required String userId, required String propertyId}) {
    return _client.from('favorites').delete().eq('user_id', userId).eq('property_id', propertyId);
  }
}
