class PropertyUnit {
  const PropertyUnit({
    required this.id,
    required this.propertyId,
    required this.name,
    this.maxGuests,
    this.basePrice,
  });

  final String id;
  final String propertyId;
  final String name;
  final int? maxGuests;
  final num? basePrice;

  factory PropertyUnit.fromMap(Map<String, dynamic> map) => PropertyUnit(
        id: map['id'].toString(),
        propertyId: map['property_id'].toString(),
        name: map['name'] as String? ?? '',
        maxGuests: (map['max_guests'] as num?)?.toInt(),
        basePrice: map['base_price'] as num?,
      );
}
