import 'package:flutter/material.dart';

import '../../search/domain/search_query.dart';
import '../data/property_repository.dart';
import '../domain/property_summary.dart';

class PropertiesResultsScreen extends StatefulWidget {
  const PropertiesResultsScreen({super.key, required this.query, required this.repository});

  final SearchQuery query;
  final PropertyRepository repository;

  @override
  State<PropertiesResultsScreen> createState() => _PropertiesResultsScreenState();
}

class _PropertiesResultsScreenState extends State<PropertiesResultsScreen> {
  late Future<List<PropertySummary>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.searchProperties().then((items) => items);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الوحدات المتاحة')),
      body: FutureBuilder<List<PropertySummary>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('تعذر تحميل الوحدات. ${snapshot.error}')));
          final items = snapshot.data ?? const <PropertySummary>[];
          if (items.isEmpty) return const Center(child: Text('لا توجد وحدات لعرضها حاليًا.'));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final property = items[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: property.coverImageUrl == null
                      ? const CircleAvatar(child: Icon(Icons.home_work_outlined))
                      : Image.network(property.coverImageUrl!, width: 72, height: 72, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined)),
                  title: Text(property.name),
                  subtitle: Text(property.location ?? property.description ?? 'قرية تونس'),
                  isThreeLine: property.description != null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
