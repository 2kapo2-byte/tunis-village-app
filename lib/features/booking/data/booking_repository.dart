import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/booking.dart';
import '../../../core/models/guest_composition.dart';
import '../domain/booking_result.dart';
import '../domain/create_booking_request.dart';

class BookingRepository {
  const BookingRepository(this._client);

  final SupabaseClient _client;

  Future<BookingResult> createBooking({
    required String unitId,
    required String propertyId,
    required DateTime checkIn,
    required DateTime checkOut,
    required GuestComposition guests,
    String? paymentMethod,
    String? customerNotes,
  }) async {
    final data = await _client.rpc('create_booking', params: {
      'p_params': {
        'unit_id': unitId,
        'property_id': propertyId,
        'check_in': _date(checkIn),
        'check_out': _date(checkOut),
        'guests': guests.totalGuests,
        'adults': guests.adults,
        'children_count': guests.childrenCount,
        'child_ages': guests.childAges,
        'payment_method': paymentMethod,
        'customer_notes': customerNotes,
      },
    });
    return _bookingResult(data);
  }

  Future<BookingResult> createBookingFromRequest(CreateBookingRequest request) {
    return createBooking(
      unitId: request.unitId,
      propertyId: request.propertyId,
      checkIn: request.checkIn,
      checkOut: request.checkOut,
      guests: GuestComposition(adults: request.adults, childAges: request.childAges),
      paymentMethod: request.paymentMethod,
      customerNotes: request.customerNotes,
    );
  }

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
        'child_ages': guests.childAges,
        'guest_full_name': guestFullName.trim(),
        'guest_phone': guestPhone.trim(),
        'guest_email': guestEmail?.trim(),
        'payment_method': paymentMethod,
        'customer_notes': customerNotes,
      },
    });
    return _bookingResult(data);
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

  BookingResult _bookingResult(Object? data) {
    final map = data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    if (map['success'] == false || map['error'] != null) {
      throw StateError((map['error'] ?? 'booking_failed').toString());
    }
    return BookingResult.fromRpc(map);
  }

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
