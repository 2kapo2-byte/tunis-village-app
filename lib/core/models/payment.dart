enum PaymentStatus { pending, processing, paid, failed, refunded, partiallyRefunded, unknown }

class Payment {
  const Payment({
    required this.id,
    required this.bookingId,
    required this.status,
    this.amount,
    this.method,
    this.currency,
    this.paymentType,
    this.provider,
    this.providerReference,
  });

  final String id;
  final String bookingId;
  final PaymentStatus status;
  final num? amount;
  final String? method;
  final String? currency;
  final String? paymentType;
  final String? provider;
  final String? providerReference;

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
        id: map['id'].toString(),
        bookingId: map['booking_id'].toString(),
        status: _status(map['status']),
        amount: map['amount'] as num?,
        method: map['method']?.toString(),
        currency: map['currency']?.toString(),
        paymentType: map['payment_type']?.toString(),
        provider: map['provider']?.toString(),
        providerReference: map['provider_reference']?.toString(),
      );

  static PaymentStatus _status(Object? value) {
    switch (value?.toString().toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'paid':
        return PaymentStatus.paid;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      case 'partially_refunded':
        return PaymentStatus.partiallyRefunded;
      default:
        return PaymentStatus.unknown;
    }
  }
}
