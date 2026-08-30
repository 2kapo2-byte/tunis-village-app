import 'guest_composition.dart';

enum BookingStatus {
  pending,
  confirmed,
  paymentPending,
  paid,
  partiallyPaid,
  cancelled,
  rejected,
  completed,
  expired,
  refunded,
  unknown,
}

class Booking {
  const Booking({
    required this.id,
    required this.bookingCode,
    required this.propertyId,
    required this.unitId,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.guests,
    required this.status,
    this.totalAmount,
    this.basePrice,
    this.cleaningFee,
    this.paymentMethod,
    this.customerNotes,
  });

  final String id;
  final String bookingCode;
  final String propertyId;
  final String unitId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final GuestComposition guests;
  final BookingStatus status;
  final num? totalAmount;
  final num? basePrice;
  final num? cleaningFee;
  final String? paymentMethod;
  final String? customerNotes;

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'].toString(),
      bookingCode: map['booking_code'] as String? ?? '',
      propertyId: map['property_id'].toString(),
      unitId: map['unit_id'].toString(),
      checkIn: DateTime.parse(map['check_in'].toString()),
      checkOut: DateTime.parse(map['check_out'].toString()),
      nights: (map['nights'] as num?)?.toInt() ?? 0,
      guests: GuestComposition(
        adults: (map['adults'] as num?)?.toInt() ?? 1,
        childAges: ((map['child_ages'] as List?) ?? const [])
            .whereType<num>()
            .map((e) => e.toInt())
            .toList(growable: false),
      ),
      status: _status(map['status']),
      totalAmount: map['total_amount'] as num?,
      basePrice: map['base_price'] as num?,
      cleaningFee: map['cleaning_fee'] as num?,
      paymentMethod: map['payment_method']?.toString(),
      customerNotes: map['customer_notes']?.toString(),
    );
  }

  static BookingStatus _status(Object? value) {
    switch (value?.toString().toLowerCase()) {
      case 'pending': return BookingStatus.pending;
      case 'confirmed': return BookingStatus.confirmed;
      case 'payment_pending': return BookingStatus.paymentPending;
      case 'paid': return BookingStatus.paid;
      case 'partially_paid': return BookingStatus.partiallyPaid;
      case 'cancelled': return BookingStatus.cancelled;
      case 'rejected': return BookingStatus.rejected;
      case 'completed': return BookingStatus.completed;
      case 'expired': return BookingStatus.expired;
      case 'refunded': return BookingStatus.refunded;
      default: return BookingStatus.unknown;
    }
  }
}
