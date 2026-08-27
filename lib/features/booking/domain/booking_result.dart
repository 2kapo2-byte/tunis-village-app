class BookingResult {
  const BookingResult({
    this.bookingId,
    this.bookingCode,
    this.status,
    this.totalAmount,
    this.platformCommissionAmount,
    this.marketerCommissionAmount,
    this.marketerCommissionRate,
  });

  final String? bookingId;
  final String? bookingCode;
  final String? status;
  final double? totalAmount;
  final double? platformCommissionAmount;
  final double? marketerCommissionAmount;
  final double? marketerCommissionRate;

  factory BookingResult.fromRpc(Object? value) {
    final map = value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
    return BookingResult(
      bookingId: map['booking_id']?.toString(),
      bookingCode: map['booking_code']?.toString(),
      status: map['status']?.toString(),
      totalAmount: _number(map['total_amount']),
      platformCommissionAmount: _number(map['platform_commission_amount']),
      marketerCommissionAmount: _number(map['marketer_commission_amount']),
      marketerCommissionRate: _number(map['marketer_commission_rate']),
    );
  }

  static double? _number(Object? value) =>
      value == null ? null : double.tryParse(value.toString());
}
