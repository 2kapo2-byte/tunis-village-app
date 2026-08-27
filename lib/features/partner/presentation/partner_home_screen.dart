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
          const Text('ابحث عن الإقامة المتاحة واحجز بالنيابة عن عملائك.'),
          const SizedBox(height: 20),
          Card(child: ListTile(
            leading: const Icon(Icons.search),
            title: const Text('بحث وحجز لعميل'),
            subtitle: const Text('التاريخ والضيوف والتوافر'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/partner-customers'),
          )),
          const SizedBox(height: 12),
          Card(child: ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('العملاء'),
            subtitle: const Text('إضافة واختيار عميل قبل بدء الحجز'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/partner-customers'),
          )),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.receipt_long_outlined), title: Text('حجوزات العملاء'), subtitle: Text('ستُربط ببيانات الحجز الفعلية لاحقًا.'))),
          const SizedBox(height: 12),
          const Card(child: ListTile(leading: Icon(Icons.payments_outlined), title: Text('العمولات'), subtitle: Text('ستُعرض من بيانات العمولة المعتمدة من الخادم.'))),
        ],
      ),
    );
  }
}
