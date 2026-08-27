import 'package:flutter/material.dart';
import '../domain/booking_result.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({super.key, required this.result, this.onViewBookings, this.onGoHome});
  final BookingResult result;
  final VoidCallback? onViewBookings;
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الحجز')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Icon(Icons.check_circle, size: 76),
            const SizedBox(height: 20),
            Text('تم إنشاء الحجز بنجاح', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            if (result.bookingCode != null) _Info(label: 'رقم الحجز', value: result.bookingCode!),
            if (result.status != null) _Info(label: 'الحالة', value: result.status!),
            if (result.totalAmount != null) _Info(label: 'الإجمالي', value: '${result.totalAmount!.toStringAsFixed(2)} جنيه'),
            const SizedBox(height: 28),
            if (onViewBookings != null) SizedBox(width: double.infinity, child: FilledButton(onPressed: onViewBookings, child: const Text('حجوزاتي'))),
            if (onGoHome != null) SizedBox(width: double.infinity, child: TextButton(onPressed: onGoHome, child: const Text('العودة للرئيسية'))),
          ]),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Card(child: ListTile(title: Text(label), trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))));
}
