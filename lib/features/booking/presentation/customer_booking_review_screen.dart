import 'package:flutter/material.dart';

import '../domain/create_booking_request.dart';
import '../data/booking_repository.dart';

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
        guests: widget.request.guests,
      );
      if (!mounted) return;
      if (result == null) {
        setState(() { _error = 'تعذر إنشاء الحجز حاليًا.'; });
      } else {
        Navigator.of(context).pop(result);
      }
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); });
    } finally {
      if (mounted) setState(() { _submitting = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nights = widget.request.checkOut.difference(widget.request.checkIn).inDays;
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الحجز')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('تفاصيل الإقامة', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ListTile(leading: const Icon(Icons.login_outlined), title: const Text('تاريخ الوصول'), subtitle: Text(_date(widget.request.checkIn))),
          ListTile(leading: const Icon(Icons.logout_outlined), title: const Text('تاريخ المغادرة'), subtitle: Text(_date(widget.request.checkOut))),
          ListTile(leading: const Icon(Icons.bed_outlined), title: const Text('الليالي'), subtitle: Text('$nights ليلة')),
          ListTile(leading: const Icon(Icons.people_outline), title: const Text('الضيوف'), subtitle: Text('${widget.request.adults} بالغ + ${widget.request.childrenCount} طفل')),
          if (widget.request.childAges.isNotEmpty)
            ListTile(leading: const Icon(Icons.child_care_outlined), title: const Text('أعمار الأطفال'), subtitle: Text(widget.request.childAges.join('، '))),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _submitting ? null : _confirm,
            icon: _submitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_circle_outline),
            label: Text(_submitting ? 'جاري تأكيد الحجز...' : 'تأكيد الحجز'),
          ),
        ],
      ),
    );
  }

  static String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
