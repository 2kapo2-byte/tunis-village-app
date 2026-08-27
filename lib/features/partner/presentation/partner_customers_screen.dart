import 'package:flutter/material.dart';
import '../domain/partner_customer.dart';

class PartnerCustomersScreen extends StatefulWidget {
  const PartnerCustomersScreen({super.key});
  @override State<PartnerCustomersScreen> createState() => _PartnerCustomersScreenState();
}

class _PartnerCustomersScreenState extends State<PartnerCustomersScreen> {
  final List<PartnerCustomer> _customers = [];
  Future<void> _addCustomer() async {
    final customer = await showDialog<PartnerCustomer>(context: context, builder: (_) => const _AddCustomerDialog());
    if (customer != null) setState(() => _customers.add(customer));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('عملائي')),
    floatingActionButton: FloatingActionButton.extended(onPressed: _addCustomer, icon: const Icon(Icons.person_add_alt_1), label: const Text('إضافة عميل')),
    body: _customers.isEmpty ? const Center(child: Text('لا يوجد عملاء مضافون حاليًا.')) : ListView.separated(
      padding: const EdgeInsets.all(16), itemCount: _customers.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (_, i) { final c = _customers[i]; return ListTile(leading: const CircleAvatar(child: Icon(Icons.person_outline)), title: Text(c.fullName), subtitle: Text(c.phone ?? c.email ?? 'بدون بيانات اتصال')); },
    ),
  );
}

class _AddCustomerDialog extends StatefulWidget { const _AddCustomerDialog(); @override State<_AddCustomerDialog> createState() => _AddCustomerDialogState(); }
class _AddCustomerDialogState extends State<_AddCustomerDialog> {
  final name = TextEditingController(), phone = TextEditingController(), email = TextEditingController();
  @override void dispose() { name.dispose(); phone.dispose(); email.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('إضافة عميل'),
    content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
      TextField(controller: name, decoration: const InputDecoration(labelText: 'اسم العميل *')),
      TextField(controller: phone, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'رقم الهاتف')),
      TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'البريد الإلكتروني')),
    ])),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
      FilledButton(onPressed: () { final n = name.text.trim(); if (n.isEmpty) return; Navigator.pop(context, PartnerCustomer(id: DateTime.now().microsecondsSinceEpoch.toString(), fullName: n, phone: phone.text.trim().isEmpty ? null : phone.text.trim(), email: email.text.trim().isEmpty ? null : email.text.trim())); }, child: const Text('حفظ')),
    ],
  );
}
