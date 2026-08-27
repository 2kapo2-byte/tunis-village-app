import 'guest_composition.dart';

enum BookingStatus {
  pending,
  confirmed,
  checkedIn,
  checkedOut,
  cancelled,
  rejected,
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

  factory Booking.fromMap(Map<String, dynamic> map) {
    final statusName = (map['status'] as String? ?? '').toLowerCase();
    final status = BookingStatus.values.where((item) => item.name == statusName).firstOrNull ?? BookingStatus.unknown;
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
        childAges: ((map['child_ages'] as List?) ?? const []).map((e) => (e as num).toInt()).toList(),
      ),
      status: status,
      totalAmount: map['total_amount'] as num?,
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
