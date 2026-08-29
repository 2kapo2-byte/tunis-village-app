import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewItem {
  const ReviewItem({
    required this.id,
    required this.bookingId,
    required this.propertyId,
    required this.overall,
    this.title,
    this.body,
    this.status,
    this.createdAt,
  });

  final String id;
  final String bookingId;
  final String propertyId;
  final int overall;
  final String? title;
  final String? body;
  final String? status;
  final DateTime? createdAt;

  factory ReviewItem.fromMap(Map<String, dynamic> map) => ReviewItem(
        id: map['id'].toString(),
        bookingId: map['booking_id'].toString(),
        propertyId: map['property_id'].toString(),
        overall: (map['overall'] as num?)?.toInt() ?? 0,
        title: map['title']?.toString(),
        body: map['body']?.toString() ?? map['comment']?.toString(),
        status: map['status']?.toString(),
        createdAt: map['created_at'] == null ? null : DateTime.tryParse(map['created_at'].toString()),
      );
}

class RatingSummary {
  const RatingSummary({required this.average, required this.count});
  final double average;
  final int count;
}

class ReviewRepository {
  const ReviewRepository(this._client);

  final SupabaseClient _client;

  Future<List<ReviewItem>> publishedForProperty(String propertyId) async {
    final rows = await _client
        .from('reviews')
        .select('id, booking_id, property_id, overall, title, body, comment, status, created_at')
        .eq('property_id', propertyId)
        .eq('status', 'published')
        .order('created_at', ascending: false);
    return rows
        .map<ReviewItem>((row) => ReviewItem.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<RatingSummary> ratingSummary(String propertyId) async {
    final rows = await _client.rpc('reviews_rating_summary', params: {'p_property_id': propertyId});
    final row = rows is List && rows.isNotEmpty ? Map<String, dynamic>.from(rows.first) : <String, dynamic>{};
    return RatingSummary(
      average: double.tryParse(row['average_rating']?.toString() ?? '') ?? 0,
      count: int.tryParse(row['review_count']?.toString() ?? '') ?? 0,
    );
  }

  Future<ReviewItem> create({
    required String bookingId,
    required String propertyId,
    required int overall,
    String? title,
    String? body,
    int? cleanliness,
    int? location,
    int? communication,
    int? value,
    int? comfort,
  }) async {
    if (overall < 1 || overall > 5) throw const FormatException('Rating must be between 1 and 5.');
    final row = await _client
        .from('reviews')
        .insert({
          'booking_id': bookingId,
          'property_id': propertyId,
          'overall': overall,
          'title': title?.trim(),
          'body': body?.trim(),
          'cleanliness': cleanliness,
          'location': location,
          'communication': communication,
          'value': value,
          'comfort': comfort,
        })
        .select('id, booking_id, property_id, overall, title, body, comment, status, created_at')
        .single();
    return ReviewItem.fromMap(Map<String, dynamic>.from(row));
  }
}
