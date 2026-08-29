import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/models/payment.dart';

class PaymentRepository {
  const PaymentRepository(this._client);

  final SupabaseClient _client;

  Future<Payment> createOrGetForBooking({
    required String bookingId,
    String? method,
  }) async {
    final row = await _client.rpc('create_payment_for_booking', params: {
      'p_booking_id': bookingId,
      'p_method': method,
      'p_idempotency_key': 'mobile:booking:$bookingId:initial-payment',
    });
    return Payment.fromMap(Map<String, dynamic>.from(row as Map));
  }

  Future<Payment> getOwnPayment(String paymentId) async {
    final row = await _client
        .from('payments')
        .select('id, booking_id, amount, method, status, currency, payment_type, provider, provider_reference')
        .eq('id', paymentId)
        .single();
    return Payment.fromMap(Map<String, dynamic>.from(row));
  }

  Future<List<Payment>> getOwnPaymentsForBooking(String bookingId) async {
    final rows = await _client
        .from('payments')
        .select('id, booking_id, amount, method, status, currency, payment_type, provider, provider_reference')
        .eq('booking_id', bookingId)
        .order('created_at', ascending: false);
    return rows
        .map<Payment>((row) => Payment.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }
}
