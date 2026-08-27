import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('قرية تونس')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('أهلاً بك 👋', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          const Text('ابحث عن إقامتك القادمة في قرية تونس.'),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: const Text('ابحث عن إقامة'),
              subtitle: const Text('التاريخ والضيوف والتوافر'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/search'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.auto_awesome), title: Text('وحدات مميزة'), subtitle: Text('سيتم ربطها بالبيانات الحقيقية في مرحلة النتائج.'))),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.favorite_border), title: Text('المفضلة'), subtitle: Text('الوحدات التي تحفظها للعودة إليها لاحقًا.'))),
        ],
      ),
    );
  }
}
