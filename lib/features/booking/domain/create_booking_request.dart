class CreateBookingRequest {
  const CreateBookingRequest({
    required this.unitId,
    required this.propertyId,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.childrenCount,
    required this.childAges,
    this.customerNotes,
    this.paymentMethod,
  });

  final String unitId;
  final String propertyId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int childrenCount;
  final List<int> childAges;
  final String? customerNotes;
  final String? paymentMethod;

  int get guests => adults + childrenCount;

  Map<String, dynamic> toRpcParams() => {
        'unit_id': unitId,
        'property_id': propertyId,
        'check_in': _date(checkIn),
        'check_out': _date(checkOut),
        'guests': guests,
        'adults': adults,
        'children_count': childrenCount,
        'child_ages': childAges,
        'payment_method': paymentMethod,
        'customer_notes': customerNotes,
      };

  static String _date(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
