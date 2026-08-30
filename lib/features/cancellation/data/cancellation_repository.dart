import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/analytics/analytics_service.dart';

class CancellationResult {
  const CancellationResult({required this.bookingId, this.refundId, required this.refundAmount, required this.refundPercent});
  final String bookingId;
  final String? refundId;
  final double refundAmount;
  final double refundPercent;

  factory CancellationResult.fromRpc(Object? value) {
    final map = value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
    if (map['success'] == false || map['error'] != null) throw StateError((map['error'] ?? 'cancellation_failed').toString());
    return CancellationResult(
      bookingId: map['booking_id'].toString(),
      refundId: map['refund_id']?.toString(),
      refundAmount: double.tryParse(map['refund_amount']?.toString() ?? '') ?? 0,
      refundPercent: double.tryParse(map['refund_percent']?.toString() ?? '') ?? 0,
    );
  }
}

class RefundStatus {
  const RefundStatus({required this.id, required this.amount, required this.status, this.reason, this.providerReference});
  final String id;
  final double amount;
  final String status;
  final String? reason;
  final String? providerReference;

  factory RefundStatus.fromMap(Map<String, dynamic> map) => RefundStatus(
        id: map['id'].toString(),
        amount: double.tryParse(map['amount']?.toString() ?? '') ?? 0,
        status: map['status']?.toString() ?? 'unknown',
        reason: map['reason']?.toString(),
        providerReference: map['provider_reference']?.toString(),
      );
}

class CancellationRepository {
  const CancellationRepository(this._client);
  final SupabaseClient _client;

  Future<CancellationResult> cancel({required String bookingId, String? reason}) async {
    final result = await _client.rpc('cancel_own_booking', params: {'p_booking_id': bookingId, 'p_reason': reason});
    final parsed = CancellationResult.fromRpc(result);
    await AnalyticsService(_client).track('booking_cancelled');
    return parsed;
  }

  Future<RefundStatus?> getLatestRefund(String bookingId) async {
    final rows = await _client.from('refunds').select('id, amount, status, reason, provider_reference').eq('booking_id', bookingId).order('created_at', ascending: false).limit(1);
    if (rows.isEmpty) return null;
    return RefundStatus.fromMap(Map<String, dynamic>.from(rows.first));
  }
}
