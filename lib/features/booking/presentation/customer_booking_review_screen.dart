import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/guest_composition.dart';
import '../data/booking_repository.dart';
import '../domain/create_booking_request.dart';

class CustomerBookingReviewScreen extends StatefulWidget {
  const CustomerBookingReviewScreen({super.key, required this.request, required this.repository});
  final CreateBookingRequest request;
  final BookingRepository repository;
  @override State<CustomerBookingReviewScreen> createState() => _CustomerBookingReviewScreenState();
}

class _CustomerBookingReviewScreenState extends State<CustomerBookingReviewScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _confirm() async {
    if (_submitting) return;
    setState(() { _submitting = true; _error = null; });
    try {
      final r = widget.request;
      final result = r.partnerMode
          ? await widget.repository.createPartnerBooking(request: r)
          : await widget.repository.createBooking(
              unitId: r.unitId,
              propertyId: r.propertyId,
              checkIn: r.checkIn,
              checkOut: r.checkOut,
              guests: GuestComposition(adults: r.adults, childAges: List<int>.from(r.childAges)),
            );
      if (!mounted) return;
      context.push('/booking-confirmation', extra: result);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final nights = r.checkOut.difference(r.checkIn).inDays;
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الحجز')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        if (r.partnerMode)
          Card(child: ListTile(leading: const Icon(Icons.business_center_outlined), title: const Text('حجز بالنيابة عن عميل'), subtitle: Text(r.guestFullName ?? 'بيانات العميل'))),
        Text('تفاصيل الإقامة', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ListTile(title: const Text('الوصول'), subtitle: Text(_date(r.checkIn))),
        ListTile(title: const Text('المغادرة'), subtitle: Text(_date(r.checkOut))),
        ListTile(title: const Text('الليالي'), subtitle: Text('$nights')),
        ListTile(title: const Text('الضيوف'), subtitle: Text('${r.adults} بالغ + ${r.childrenCount} طفل')),
        if (r.childAges.isNotEmpty) ListTile(title: const Text('أعمار الأطفال'), subtitle: Text(r.childAges.join('، '))),
        if (r.partnerMode && r.guestPhone != null) ListTile(title: const Text('هاتف العميل'), subtitle: Text(r.guestPhone!)),
        if (r.partnerMode && r.guestEmail != null) ListTile(title: const Text('بريد العميل'), subtitle: Text(r.guestEmail!)),
        if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
        const SizedBox(height: 24),
        FilledButton(onPressed: _submitting ? null : _confirm, child: Text(_submitting ? 'جاري التأكيد...' : 'تأكيد الحجز')),
      ]),
    );
  }

  static String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
