class Property {
  const Property({
    required this.id,
    required this.name,
    this.description,
    this.location,
    this.coverImageUrl,
  });

  final String id;
  final String name;
  final String? description;
  final String? location;
  final String? coverImageUrl;

  factory Property.fromMap(Map<String, dynamic> map) => Property(
        id: map['id'].toString(),
        name: map['name'] as String? ?? '',
        description: map['description'] as String?,
        location: map['location'] as String?,
        coverImageUrl: map['cover_image_url'] as String?,
      );
}
