class PropertySummary {
  const PropertySummary({
    required this.id,
    required this.name,
    this.description,
    this.coverImageUrl,
    this.location,
  });

  final String id;
  final String name;
  final String? description;
  final String? coverImageUrl;
  final String? location;

  factory PropertySummary.fromMap(Map<String, dynamic> map) => PropertySummary(
        id: map['id'].toString(),
        name: (map['name'] ?? map['title'] ?? 'بدون اسم').toString(),
        description: map['description']?.toString(),
        coverImageUrl: map['cover_image_url']?.toString() ?? map['coverImageUrl']?.toString(),
        location: map['location']?.toString(),
      );
}
