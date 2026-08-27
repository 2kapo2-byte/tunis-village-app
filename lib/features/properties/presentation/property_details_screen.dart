import 'package:flutter/material.dart';

import '../domain/property_summary.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key, required this.property, this.onBook});

  final PropertySummary property;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الإقامة')),
      body: ListView(
        children: [
          if (property.coverImageUrl != null)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                property.coverImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported_outlined, size: 48)),
              ),
            )
          else
            const AspectRatio(aspectRatio: 16 / 9, child: Center(child: Icon(Icons.home_work_outlined, size: 56))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(property.name, style: Theme.of(context).textTheme.headlineSmall),
          ),
          if (property.location != null)
            ListTile(leading: const Icon(Icons.location_on_outlined), title: Text(property.location!)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(property.description?.trim().isNotEmpty == true ? property.description! : 'لا يوجد وصف متاح حاليًا.'),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            child: FilledButton.icon(
              onPressed: onBook,
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('متابعة الحجز'),
            ),
          ),
        ],
      ),
    );
  }
}
