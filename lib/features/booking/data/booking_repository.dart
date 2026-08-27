import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/booking.dart';
import '../../../core/models/guest_composition.dart';
import '../domain/booking_result.dart';

class BookingRepository {
  const BookingRepository(this._client);

  final SupabaseClient _client;

  Future<BookingResult> createBooking({
    required String unitId,
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required GuestComposition guests,
  }) async {
    final data = await _client.rpc('create_booking', params: {
      'p_unit_id': unitId,
      'p_property_id': propertyId,
      'p_check_in': checkIn.toIso8601String(),
      'p_check_out': checkOut.toIso8601String(),
      'p_adults': guests.adults,
      'p_children_count': guests.childrenCount,
      'p_child_ages': guests.childAges,
    });
    return BookingResult.fromRpc(data);
  }

  /// Creates a booking on behalf of a guest through the server-authoritative
  /// partner RPC. The authenticated user is resolved as marketer_id by the
  /// database; the client cannot choose attribution or commission values.
  Future<BookingResult> createPartnerBooking({
    required String unitId,
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required GuestComposition guests,
    required String guestFullName,
    required String guestPhone,
    String? guestEmail,
    String? paymentMethod,
    String? customerNotes,
  }) async {
    final data = await _client.rpc('create_partner_booking', params: {
      'p_params': {
        'unit_id': unitId,
        'property_id': propertyId,
        'check_in': _date(checkIn),
        'check_out': _date(checkOut),
        'adults': guests.adults,
        'children_count': guests.childrenCount,
        // The Partner RPC expects a JSON array of integer ages.
        'child_ages': guests.childAges,
        'guest_full_name': guestFullName.trim(),
        'guest_phone': guestPhone.trim(),
        'guest_email': guestEmail?.trim(),
        'payment_method': paymentMethod,
        'customer_notes': customerNotes,
      },
    });
    return BookingResult.fromRpc(data);
  }

  Future<List<Booking>> myBookings() async {
    final user = _client.auth.currentUser;
    if (user == null) return const [];
    final rows = await _client
        .from('bookings')
        .select()
        .eq('customer_id', user.id)
        .order('created_at', ascending: false);
    return rows.map((row) => Booking.fromMap(row)).toList(growable: false);
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
