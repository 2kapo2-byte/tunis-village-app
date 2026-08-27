class Favorite {
  const Favorite({required this.id, required this.userId, required this.propertyId, this.createdAt});

  final String id;
  final String userId;
  final String propertyId;
  final DateTime? createdAt;

  factory Favorite.fromMap(Map<String, dynamic> map) => Favorite(
        id: map['id'].toString(),
        userId: map['user_id'].toString(),
        propertyId: map['property_id'].toString(),
        createdAt: map['created_at'] == null ? null : DateTime.tryParse(map['created_at'].toString()),
      );
}
