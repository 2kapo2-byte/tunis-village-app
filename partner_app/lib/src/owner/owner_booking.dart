enum OwnerBookingStatus {
  pending,
  confirmed,
  paymentPending,
  paid,
  cancelled,
  completed,
  rejected,
  expired,
  refunded,
  unknown,
}

class OwnerBookingSummary {
  const OwnerBookingSummary({
    required this.bookingId,
    required this.bookingCode,
    required this.propertyId,
    required this.unitId,
    required this.checkIn,
    required this.checkOut,
    required this.status,
  });

  final String bookingId;
  final String bookingCode;
  final String propertyId;
  final String unitId;
  final DateTime checkIn;
  final DateTime checkOut;
  final OwnerBookingStatus status;
}
