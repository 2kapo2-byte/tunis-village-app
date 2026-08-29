import 'package:flutter/material.dart';
import '../data/notifications_repository.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.repository});
  final NotificationsRepository repository;

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.list();
  }

  Future<void> _refresh() async {
    setState(() => _future = widget.repository.list());
    await _future;
  }

  Future<void> _markAllRead() async {
    await widget.repository.markAllRead();
    await _refresh();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('الإشعارات'),
          actions: [IconButton(onPressed: _markAllRead, icon: const Icon(Icons.done_all))],
        ),
        body: FutureBuilder<List<AppNotification>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: OutlinedButton(onPressed: _refresh, child: const Text('إعادة المحاولة')));
            final items = snapshot.data ?? const <AppNotification>[];
            if (items.isEmpty) return const Center(child: Text('لا توجد إشعارات.'));
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, index) {
                  final item = items[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(item.isRead ? Icons.notifications_none : Icons.notifications_active),
                      title: Text(item.title),
                      subtitle: item.message == null ? null : Text(item.message!),
                      trailing: item.isRead ? null : const Icon(Icons.circle, size: 10),
                      onTap: () async {
                        if (!item.isRead) {
                          await widget.repository.markRead(item.id);
                          await _refresh();
                        }
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
}
