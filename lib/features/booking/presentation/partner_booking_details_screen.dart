import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../domain/create_booking_request.dart';

class PartnerBookingDetailsScreen extends StatefulWidget {
  const PartnerBookingDetailsScreen({super.key, required this.request});
  final CreateBookingRequest request;
  @override State<PartnerBookingDetailsScreen> createState() => _PartnerBookingDetailsScreenState();
}

class _PartnerBookingDetailsScreenState extends State<PartnerBookingDetailsScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _notes = TextEditingController();

  @override void dispose() { _name.dispose(); _phone.dispose(); _email.dispose(); _notes.dispose(); super.dispose(); }

  void _continue() {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('اكتب اسم العميل ورقم الهاتف للمتابعة.')));
      return;
    }
    final r = widget.request;
    context.push('/booking-review', extra: CreateBookingRequest(
      unitId: r.unitId, propertyId: r.propertyId, checkIn: r.checkIn, checkOut: r.checkOut,
      adults: r.adults, childrenCount: r.childrenCount, childAges: List<int>.from(r.childAges),
      customerNotes: _notes.text.trim().isEmpty ? null : _notes.text.trim(), paymentMethod: r.paymentMethod,
      partnerMode: true, guestFullName: name, guestPhone: phone, guestEmail: _email.text.trim().isEmpty ? null : _email.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('بيانات العميل')),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      const Card(child: ListTile(leading: Icon(Icons.business_center_outlined), title: Text('الحجز بالنيابة عن العميل'), subtitle: Text('لن يتم حفظ العميل كملف دائم قبل إتمام الحجز.'))),
      const SizedBox(height: 20),
      TextField(controller: _name, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'اسم العميل *', prefixIcon: Icon(Icons.person_outline))),
      const SizedBox(height: 12),
      TextField(controller: _phone, keyboardType: TextInputType.phone, textInputAction: TextInputAction.next, decoration: const InputDecoration(labelText: 'رقم الهاتف *', prefixIcon: Icon(Icons.phone_outlined))),
      const SizedBox(height: 12),
      TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'البريد الإلكتروني (اختياري)', prefixIcon: Icon(Icons.email_outlined))),
      const SizedBox(height: 12),
      TextField(controller: _notes, maxLines: 3, decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)', prefixIcon: Icon(Icons.notes_outlined))),
      const SizedBox(height: 28),
      FilledButton.icon(onPressed: _continue, icon: const Icon(Icons.arrow_forward), label: const Text('مراجعة الحجز')),
    ]),
  );
}
