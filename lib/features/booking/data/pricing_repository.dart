import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/guest_composition.dart';
import '../domain/price_estimate.dart';

class PricingRepository {
  const PricingRepository(this._client);

  final SupabaseClient _client;

  Future<PriceEstimate> estimate({
    required String unitId,
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required GuestComposition guests,
  }) async {
    final result = await _client.rpc('calculate_booking_price', params: {
      'p_params': {
        'unit_id': unitId,
        'property_id': propertyId,
        'check_in': _date(checkIn),
        'check_out': _date(checkOut),
        'adults': guests.adults,
        'children_count': guests.childrenCount,
        'child_ages': guests.childAges,
      },
    });
    return PriceEstimate.fromRpc(result);
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
