import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/analytics/analytics_service.dart';
import '../../search/domain/search_query.dart';

class NetworkUnavailableException implements Exception {
  const NetworkUnavailableException();
  @override
  String toString() => 'network_unavailable';
}

class AvailableUnit {
  const AvailableUnit({required this.id, required this.propertyId, required this.name, required this.pricePerNight, required this.capacity, this.propertyName, this.location, this.description, this.minStay = 1, this.maxStay = 0});
  final String id;
  final String propertyId;
  final String name;
  final num pricePerNight;
  final int capacity;
  final String? propertyName;
  final String? location;
  final String? description;
  final int minStay;
  final int maxStay;
}

class AvailabilityRepository {
  const AvailabilityRepository(this._client);
  final SupabaseClient _client;

  Future<List<AvailableUnit>> search(SearchQuery query) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.isEmpty || connectivity.every((r) => r == ConnectivityResult.none)) throw const NetworkUnavailableException();
    if (query.nights <= 0) throw const FormatException('Check-out must be after check-in.');
    if (query.guests.adults < 1) throw const FormatException('At least one adult is required.');

    final unitRows = await _client.from('property_units').select('id, property_id, name, price_per_night, capacity, status').eq('status', 'available');
    final units = (unitRows as List).whereType<Map<String, dynamic>>().toList(growable: false);
    if (units.isEmpty) {
      await AnalyticsService(_client).track('search_completed');
      return const [];
    }

    final propertyIds = units.map((row) => row['property_id'].toString()).toSet().toList(growable: false);
    final propertyRows = await _client.from('properties').select('id, name, location, description, min_stay, max_stay, status').inFilter('id', propertyIds).eq('status', 'approved');
    final properties = <String, Map<String, dynamic>>{for (final row in (propertyRows as List).whereType<Map<String, dynamic>>()) row['id'].toString(): row};
    final eligibleUnits = units.where((row) {
      final property = properties[row['property_id'].toString()];
      if (property == null) return false;
      final capacity = (row['capacity'] as num?)?.toInt() ?? 0;
      final minStay = (property['min_stay'] as num?)?.toInt() ?? 1;
      final maxStay = (property['max_stay'] as num?)?.toInt() ?? 0;
      return capacity >= query.guests.totalGuests && query.nights >= minStay && (maxStay <= 0 || query.nights <= maxStay);
    }).toList(growable: false);
    if (eligibleUnits.isEmpty) {
      await AnalyticsService(_client).track('search_completed');
      return const [];
    }

    final unitIds = eligibleUnits.map((row) => row['id'].toString()).toList(growable: false);
    final availabilityRows = await _client.from('property_availability').select('unit_id, date, status').inFilter('unit_id', unitIds).gte('date', _date(query.checkIn)).lt('date', _date(query.checkOut));
    final blockedUnitIds = <String>{};
    for (final row in (availabilityRows as List).whereType<Map<String, dynamic>>()) {
      final status = row['status']?.toString();
      if (status == 'booked' || status == 'blocked' || status == 'external') blockedUnitIds.add(row['unit_id'].toString());
    }

    final result = List.unmodifiable(eligibleUnits.where((row) => !blockedUnitIds.contains(row['id'].toString())).map((row) {
      final property = properties[row['property_id'].toString()]!;
      return AvailableUnit(id: row['id'].toString(), propertyId: row['property_id'].toString(), name: (row['name'] ?? 'وحدة').toString(), pricePerNight: (row['price_per_night'] as num?) ?? 0, capacity: (row['capacity'] as num?)?.toInt() ?? 0, propertyName: property['name']?.toString(), location: property['location']?.toString(), description: property['description']?.toString(), minStay: (property['min_stay'] as num?)?.toInt() ?? 1, maxStay: (property['max_stay'] as num?)?.toInt() ?? 0);
    }));
    await AnalyticsService(_client).track('search_completed');
    return result;
  }

  String _date(DateTime value) => '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
