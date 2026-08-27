class Review {
  const Review({
    required this.id,
    required this.propertyId,
    required this.authorId,
    required this.rating,
    required this.content,
    this.createdAt,
  });

  final String id;
  final String propertyId;
  final String authorId;
  final int rating;
  final String content;
  final DateTime? createdAt;

  factory Review.fromMap(Map<String, dynamic> map) => Review(
        id: map['id'].toString(),
        propertyId: map['property_id'].toString(),
        authorId: map['author_id'].toString(),
        rating: (map['rating'] as num?)?.toInt() ?? 0,
        content: map['content'] as String? ?? '',
        createdAt: map['created_at'] == null ? null : DateTime.tryParse(map['created_at'].toString()),
      );
}
