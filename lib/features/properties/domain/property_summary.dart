class PropertySummary {
  const PropertySummary({
    required this.id,
    required this.name,
    this.unitId,
    this.description,
    this.coverImageUrl,
    this.location,
    this.maxGuests,
    this.pricePerNight,
    this.rating,
    this.reviewsCount,
  });

  final String id;
  final String name;
  final String? unitId;
  final String? description;
  final String? coverImageUrl;
  final String? location;
  final int? maxGuests;
  final double? pricePerNight;
  final double? rating;
  final int? reviewsCount;

  factory PropertySummary.fromMap(Map<String, dynamic> map) => PropertySummary(
        id: (map['property_id'] ?? map['id']).toString(),
        name: (map['name'] ?? map['title'] ?? 'بدون اسم').toString(),
        unitId: map['unit_id']?.toString(),
        description: map['description']?.toString(),
        coverImageUrl: map['cover_image_url']?.toString() ?? map['coverImageUrl']?.toString(),
        location: map['location']?.toString(),
        maxGuests: _toInt(map['max_guests'] ?? map['maxGuests'] ?? map['capacity']),
        pricePerNight: _toDouble(map['price_per_night'] ?? map['pricePerNight']),
        rating: _toDouble(map['rating']),
        reviewsCount: _toInt(map['reviews_count']),
      );

  static int? _toInt(Object? value) => value == null ? null : int.tryParse(value.toString());
  static double? _toDouble(Object? value) => value == null ? null : double.tryParse(value.toString());
}
