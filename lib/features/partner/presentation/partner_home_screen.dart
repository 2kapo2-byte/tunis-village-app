import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PartnerHomeScreen extends StatelessWidget {
  const PartnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة الشريك')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('أهلاً بك في Partner Mode 💼', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          const Text('ابحث واحجز لعملائك من نفس محرك البحث.'),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.search),
              title: const Text('بحث وحجز لعميل'),
              subtitle: const Text('التاريخ والضيوف والتوافر'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/search'),
            ),
          ),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.people_outline), title: Text('العملاء'), subtitle: Text('إدارة بيانات العملاء في المرحلة القادمة.'))),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.receipt_long_outlined), title: Text('حجوزات العملاء'), subtitle: Text('متابعة حجوزاتك وحجوزات عملائك.'))),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.payments_outlined), title: Text('العمولات'), subtitle: Text('سيتم ربط العمولات بمحرك العمولة في المرحلة القادمة.'))),
        ],
      ),
    );
  }
}
