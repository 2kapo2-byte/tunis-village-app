import 'package:supabase_flutter/supabase_flutter.dart';

import '../../search/domain/search_query.dart';
import '../domain/property_details_data.dart';
import '../domain/property_summary.dart';

class PropertyRepository {
  const PropertyRepository(this._client);

  final SupabaseClient _client;

  Future<List<PropertySummary>> search({SearchQuery? searchQuery, String? query}) async {
    var request = _client
        .from('properties')
        .select('id, name, description, location, price_per_night, capacity, rating, reviews_count, status')
        .eq('status', 'approved');
    if (query != null && query.trim().isNotEmpty) {
      request = request.ilike('name', '%${query.trim()}%');
    }
    final rows = await request;
    return rows
        .map<PropertySummary>(
          (row) => PropertySummary.fromMap(Map<String, dynamic>.from(row)),
        )
        .toList(growable: false);
  }

  Future<PropertyDetailsData> getDetails({
    required String propertyId,
    String? unitId,
  }) async {
    final propertyRows = await _client
        .from('properties')
        .select(
          'id, name, description, location, address, price_per_night, cleaning_fee, capacity, bedrooms, bathrooms, min_stay, max_stay, cancellation_policy, rating, reviews_count, status',
        )
        .eq('id', propertyId)
        .eq('status', 'approved')
        .limit(1);
    if (propertyRows.isEmpty) {
      throw StateError('property_not_found');
    }

    final property = PropertySummary.fromMap(
      Map<String, dynamic>.from(propertyRows.first),
    );

    var unitQuery = _client
        .from('property_units')
        .select('id, name, capacity, bedrooms, bathrooms, beds, price_per_night, status')
        .eq('property_id', propertyId)
        .eq('status', 'available');
    if (unitId != null) {
      unitQuery = unitQuery.eq('id', unitId);
    }
    final unitRows = await unitQuery.limit(1);
    if (unitRows.isEmpty) {
      throw StateError('unit_not_found');
    }
    final unit = Map<String, dynamic>.from(unitRows.first);

    final imageRows = await _client
        .from('property_images')
        .select('image_url, sort_order')
        .eq('property_id', propertyId)
        .order('sort_order', ascending: true);
    final images = (imageRows as List)
        .whereType<Map<String, dynamic>>()
        .map((row) => row['image_url']?.toString())
        .whereType<String>()
        .where((url) => url.isNotEmpty)
        .toList(growable: false);

    final amenityRows = await _client
        .from('property_amenities')
        .select('amenity_key')
        .eq('property_id', propertyId);
    final amenities = (amenityRows as List)
        .whereType<Map<String, dynamic>>()
        .map((row) => row['amenity_key']?.toString())
        .whereType<String>()
        .where((key) => key.isNotEmpty)
        .toList(growable: false);

    return PropertyDetailsData(
      property: property,
      images: images,
      amenities: amenities,
      unitName: (unit['name'] ?? 'الوحدة').toString(),
      unitId: unit['id'].toString(),
      unitCapacity: (unit['capacity'] as num?)?.toInt() ?? property.maxGuests ?? 1,
      unitPricePerNight: (unit['price_per_night'] as num?)?.toDouble() ?? property.pricePerNight ?? 0,
      unitBedrooms: (unit['bedrooms'] as num?)?.toInt(),
      unitBathrooms: (unit['bathrooms'] as num?)?.toInt(),
      unitBeds: (unit['beds'] as num?)?.toInt(),
    );
  }
}
