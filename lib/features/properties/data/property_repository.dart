import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/property.dart';

class PropertyRepository {
  const PropertyRepository(this._client);

  final SupabaseClient _client;

  Future<List<Property>> search({String? query}) async {
    final builder = _client.from('properties').select();
    final rows = query == null || query.trim().isEmpty
        ? await builder
        : await builder.ilike('name', '%${query.trim()}%');
    return rows.map((row) => Property.fromMap(row)).toList();
  }
}
