import 'package:supabase_flutter/supabase_flutter.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    this.message,
    required this.isRead,
    this.link,
    this.createdAt,
  });

  final String id;
  final String type;
  final String title;
  final String? message;
  final bool isRead;
  final String? link;
  final DateTime? createdAt;

  factory AppNotification.fromMap(Map<String, dynamic> map) => AppNotification(
        id: map['id'].toString(),
        type: map['type']?.toString() ?? 'system',
        title: map['title']?.toString() ?? '',
        message: map['message']?.toString(),
        isRead: map['is_read'] == true,
        link: map['link']?.toString(),
        createdAt: map['created_at'] == null ? null : DateTime.tryParse(map['created_at'].toString()),
      );
}

class NotificationsRepository {
  const NotificationsRepository(this._client);
  final SupabaseClient _client;

  Future<List<AppNotification>> list() async {
    final rows = await _client
        .from('notifications')
        .select('id, type, title, message, is_read, link, created_at')
        .order('created_at', ascending: false);
    return rows
        .map<AppNotification>((row) => AppNotification.fromMap(Map<String, dynamic>.from(row)))
        .toList(growable: false);
  }

  Future<int> unreadCount() async {
    final rows = await _client.from('notifications').select('id').eq('is_read', false);
    return rows.length;
  }

  Future<void> markRead(String id) async {
    await _client.from('notifications').update({'is_read': true}).eq('id', id);
  }

  Future<void> markAllRead() async {
    await _client.from('notifications').update({'is_read': true}).eq('is_read', false);
  }
}
