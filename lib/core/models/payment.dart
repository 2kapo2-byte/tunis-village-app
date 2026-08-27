enum PaymentStatus { pending, authorized, paid, failed, refunded, cancelled, unknown }

class Payment {
  const Payment({
    required this.id,
    required this.bookingId,
    required this.status,
    this.amount,
    this.method,
  });

  final String id;
  final String bookingId;
  final PaymentStatus status;
  final num? amount;
  final String? method;

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
        id: map['id'].toString(),
        bookingId: map['booking_id'].toString(),
        status: PaymentStatus.values.where((e) => e.name == (map['status'] as String? ?? '').toLowerCase()).firstOrNull ?? PaymentStatus.unknown,
        amount: map['amount'] as num?,
        method: map['payment_method'] as String?,
      );
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
