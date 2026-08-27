import 'package:supabase_flutter/supabase_flutter.dart';

import '../../search/domain/search_query.dart';
import '../domain/property_summary.dart';

class PropertyRepository {
  const PropertyRepository(this._client);
  final SupabaseClient _client;

  Future<List<PropertySummary>> search({SearchQuery? searchQuery, String? query}) async {
    var request = _client.from('properties').select();
    if (query != null && query.trim().isNotEmpty) {
      request = request.ilike('name', '%${query.trim()}%');
    }
    final rows = await request;
    return rows.map<PropertySummary>((row) => PropertySummary.fromMap(Map<String, dynamic>.from(row))).toList(growable: false);
  }
}
