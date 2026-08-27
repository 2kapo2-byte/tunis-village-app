import 'package:flutter/material.dart';
import '../../../core/models/guest_composition.dart';
import '../data/booking_repository.dart';
import '../domain/create_booking_request.dart';

class CustomerBookingReviewScreen extends StatefulWidget {
  const CustomerBookingReviewScreen({super.key, required this.request, required this.repository});
  final CreateBookingRequest request;
  final BookingRepository repository;

  @override
  State<CustomerBookingReviewScreen> createState() => _CustomerBookingReviewScreenState();
}

class _CustomerBookingReviewScreenState extends State<CustomerBookingReviewScreen> {
  bool _submitting = false;
  String? _error;

  Future<void> _confirm() async {
    if (_submitting) return;
    setState(() { _submitting = true; _error = null; });
    try {
      final result = await widget.repository.createBooking(
        unitId: widget.request.unitId,
        propertyId: widget.request.propertyId,
        checkIn: widget.request.checkIn,
        checkOut: widget.request.checkOut,
        guests: GuestComposition(adults: widget.request.adults, childAges: widget.request.childAges),
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/booking-confirmation', arguments: result);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final nights = widget.request.checkOut.difference(widget.request.checkIn).inDays;
    return Scaffold(appBar: AppBar(title: const Text('مراجعة الحجز')), body: ListView(padding: const EdgeInsets.all(20), children: [
      Text('تفاصيل الإقامة', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 16),
      ListTile(title: const Text('الوصول'), subtitle: Text(_date(widget.request.checkIn))),
      ListTile(title: const Text('المغادرة'), subtitle: Text(_date(widget.request.checkOut))),
      ListTile(title: const Text('الليالي'), subtitle: Text('$nights')),
      ListTile(title: const Text('الضيوف'), subtitle: Text('${widget.request.adults} بالغ + ${widget.request.childrenCount} طفل')),
      if (widget.request.childAges.isNotEmpty) ListTile(title: const Text('أعمار الأطفال'), subtitle: Text(widget.request.childAges.join('، '))),
      if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
      const SizedBox(height: 24),
      FilledButton(onPressed: _submitting ? null : _confirm, child: Text(_submitting ? 'جاري التأكيد...' : 'تأكيد الحجز')),
    ]));
  }

  static String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
