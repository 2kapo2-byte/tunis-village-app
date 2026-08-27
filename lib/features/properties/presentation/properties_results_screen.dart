import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../availability/data/availability_repository.dart';
import '../../search/domain/search_query.dart';

class PropertiesResultsScreen extends StatefulWidget {
  const PropertiesResultsScreen({super.key, required this.query, required this.repository});
  final SearchQuery query;
  final AvailabilityRepository repository;
  @override
  State<PropertiesResultsScreen> createState() => _PropertiesResultsScreenState();
}

class _PropertiesResultsScreenState extends State<PropertiesResultsScreen> {
  late Future<List<AvailableUnit>> _future;
  @override
  void initState() { super.initState(); _future = widget.repository.search(widget.query); }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('الوحدات المتاحة')),
    body: FutureBuilder<List<AvailableUnit>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('تعذر التحقق من التوافر. حاول مرة أخرى.')));
        final items = snapshot.data ?? const <AvailableUnit>[];
        if (items.isEmpty) return const Center(child: Text('لا توجد وحدات متاحة لهذه التواريخ وعدد الضيوف.'));
        return ListView.separated(
          padding: const EdgeInsets.all(16), itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final unit = items[index];
            return Card(child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.home_work_outlined)),
              title: Text(unit.name),
              subtitle: Text('${unit.pricePerNight.toStringAsFixed(0)} جنيه / ليلة • حتى ${unit.capacity} ضيف'),
              trailing: const Icon(Icons.chevron_left),
              onTap: () => context.push('/property-details', extra: {
                'property': {
                  'id': unit.propertyId,
                  'unit_id': unit.id,
                  'name': unit.name,
                  'price_per_night': unit.pricePerNight,
                  'max_guests': unit.capacity,
                },
                'query': widget.query,
              }),
            ));
          },
        );
      },
    ),
  );
}
