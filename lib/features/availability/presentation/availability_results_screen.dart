import 'package:flutter/material.dart';

import '../../search/domain/search_query.dart';
import '../data/availability_repository.dart';

class AvailabilityResultsScreen extends StatelessWidget {
  const AvailabilityResultsScreen({super.key, required this.query, required this.repository});

  final SearchQuery query;
  final AvailabilityRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإقامات المتاحة')),
      body: FutureBuilder<List<AvailableUnit>>(
        future: repository.search(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('تعذر التحقق من التوافر. حاول مرة أخرى.\n${snapshot.error}', textAlign: TextAlign.center)));
          }
          final units = snapshot.data ?? const <AvailableUnit>[];
          if (units.isEmpty) {
            return const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('لا توجد وحدات متاحة لهذه التواريخ وعدد الضيوف.', textAlign: TextAlign.center)));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: units.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final unit = units[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.home_work_outlined)),
                  title: Text(unit.name),
                  subtitle: Text('${unit.pricePerNight} جنيه / ليلة • حتى ${unit.capacity} ضيف'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
