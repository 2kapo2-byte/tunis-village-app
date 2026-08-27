import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/property.dart';
import '../../search/domain/search_query.dart';

class PropertyRepository {
  const PropertyRepository(this._client);

  final SupabaseClient _client;

  Future<List<Property>> search({SearchQuery? searchQuery, String? query}) async {
    var request = _client.from('properties').select();
    if (query != null && query.trim().isNotEmpty) {
      request = request.ilike('name', '%${query.trim()}%');
    }

    final rows = await request;
    // Date/guest availability must be resolved by the backend availability
    // contract; this repository deliberately does not fabricate it locally.
    return rows.map((row) => Property.fromMap(row)).toList(growable: false);
  }
}
