import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/booking.dart';
import '../../../core/models/guest_composition.dart';

class BookingRepository {
  const BookingRepository(this._client);

  final SupabaseClient _client;

  Future<dynamic> createBooking({
    required String unitId,
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required GuestComposition guests,
  }) {
    return _client.rpc('create_booking', params: {
      'p_unit_id': unitId,
      'p_property_id': propertyId,
      'p_check_in': checkIn.toIso8601String(),
      'p_check_out': checkOut.toIso8601String(),
      'p_adults': guests.adults,
      'p_children_count': guests.childrenCount,
      'p_child_ages': guests.childAges,
    });
  }

  Future<List<Booking>> myBookings(String customerId) async {
    final rows = await _client.from('bookings').select().eq('customer_id', customerId).order('created_at', ascending: false);
    return rows.map((row) => Booking.fromMap(row)).toList();
  }
}
