class PriceEstimate {
  const PriceEstimate({
    required this.nights,
    required this.basePrice,
    required this.seasonalAdjustment,
    required this.weekendAdjustment,
    required this.extraGuestAmount,
    required this.childrenAmount,
    required this.cleaningFee,
    required this.discount,
    required this.taxes,
    required this.totalAmount,
    required this.includedGuests,
    required this.extraAdults,
    required this.extraChildren,
  });

  final int nights;
  final double basePrice;
  final double seasonalAdjustment;
  final double weekendAdjustment;
  final double extraGuestAmount;
  final double childrenAmount;
  final double cleaningFee;
  final double discount;
  final double taxes;
  final double totalAmount;
  final int includedGuests;
  final int extraAdults;
  final int extraChildren;

  factory PriceEstimate.fromRpc(Object? value) {
    final map = value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
    if (map['success'] == false || map['error'] != null) {
      throw StateError((map['error'] ?? 'pricing_failed').toString());
    }
    return PriceEstimate(
      nights: _int(map['nights']),
      basePrice: _double(map['base_price']),
      seasonalAdjustment: _double(map['seasonal_adjustment']),
      weekendAdjustment: _double(map['weekend_adjustment']),
      extraGuestAmount: _double(map['extra_guest_amount']),
      childrenAmount: _double(map['children_amount']),
      cleaningFee: _double(map['cleaning_fee']),
      discount: _double(map['discount']),
      taxes: _double(map['taxes']),
      totalAmount: _double(map['total_amount']),
      includedGuests: _int(map['included_guests']),
      extraAdults: _int(map['extra_adults']),
      extraChildren: _int(map['extra_children']),
    );
  }

  static int _int(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
  static double _double(Object? value) => double.tryParse(value?.toString() ?? '') ?? 0;
}
