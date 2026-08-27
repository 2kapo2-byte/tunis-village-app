import 'package:supabase_flutter/supabase_flutter.dart';

import '../../search/domain/search_query.dart';

class AvailableUnit {
  const AvailableUnit({
    required this.id,
    required this.propertyId,
    required this.name,
    required this.pricePerNight,
    required this.capacity,
  });

  final String id;
  final String propertyId;
  final String name;
  final num pricePerNight;
  final int capacity;
}

class AvailabilityRepository {
  const AvailabilityRepository(this._client);

  final SupabaseClient _client;

  Future<List<AvailableUnit>> search(SearchQuery query) async {
    final rows = await _client
        .from('property_units')
        .select('id, property_id, name, price_per_night, capacity, status')
        .eq('status', 'active');

    final requiredGuests = query.adults + query.childrenCount;
    final candidates = (rows as List).whereType<Map<String, dynamic>>().where((row) {
      final capacity = (row['capacity'] as num?)?.toInt() ?? 0;
      return capacity >= requiredGuests;
    });

    final results = <AvailableUnit>[];
    for (final row in candidates) {
      final result = await _client.rpc('check_unit_availability', params: {
        'p_unit_id': row['id'],
        'p_check_in': _date(query.checkIn),
        'p_check_out': _date(query.checkOut),
      });
      final available = result is Map && result['available'] == true;
      if (!available) continue;
      results.add(AvailableUnit(
        id: row['id'].toString(),
        propertyId: row['property_id'].toString(),
        name: (row['name'] ?? 'وحدة').toString(),
        pricePerNight: (row['price_per_night'] as num?) ?? 0,
        capacity: (row['capacity'] as num?)?.toInt() ?? 0,
      ));
    }
    return List.unmodifiable(results);
  }

  String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
