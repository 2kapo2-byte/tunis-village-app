class BookingResult {
  const BookingResult({this.bookingId, this.bookingCode, this.status, this.totalAmount});

  final String? bookingId;
  final String? bookingCode;
  final String? status;
  final double? totalAmount;

  factory BookingResult.fromRpc(Object? value) {
    final map = value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
    return BookingResult(
      bookingId: map['booking_id']?.toString(),
      bookingCode: map['booking_code']?.toString(),
      status: map['status']?.toString(),
      totalAmount: double.tryParse((map['total_amount'] ?? '').toString()),
    );
  }
}
