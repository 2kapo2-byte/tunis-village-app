import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  void initState() { super.initState(); _future = widget.repository.search(searchQuery: widget.query); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('نتائج البحث')),
    body: FutureBuilder<List<PropertySummary>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('تعذر تحميل النتائج: ${snapshot.error}'));
        final items = snapshot.data ?? const <PropertySummary>[];
        if (items.isEmpty) return const Center(child: Text('لا توجد نتائج متاحة حاليًا.'));
        return ListView.separated(
          padding: const EdgeInsets.all(16), itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final property = items[index];
            return Card(clipBehavior: Clip.antiAlias, child: ListTile(
              onTap: () => context.push('/property-details', extra: {'property': property, 'query': widget.query}),
              leading: property.coverImageUrl == null ? const CircleAvatar(child: Icon(Icons.home_work_outlined)) : Image.network(property.coverImageUrl!, width: 72, height: 72, fit: BoxFit.cover),
              title: Text(property.name), subtitle: Text(property.location ?? property.description ?? 'قرية تونس'), trailing: const Icon(Icons.chevron_left),
            ));
          },
        );
      },
    ),
  );
}
