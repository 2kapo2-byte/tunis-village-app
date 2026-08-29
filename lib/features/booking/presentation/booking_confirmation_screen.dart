import 'package:flutter/material.dart';
import '../domain/booking_result.dart';

class BookingConfirmationScreen extends StatelessWidget {
  const BookingConfirmationScreen({
    super.key,
    required this.result,
    this.onViewBookings,
    this.onViewPayment,
    this.onGoHome,
  });

  final BookingResult result;
  final VoidCallback? onViewBookings;
  final VoidCallback? onViewPayment;
  final VoidCallback? onGoHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تأكيد الحجز')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.check_circle, size: 76),
              const SizedBox(height: 20),
              Text(
                'تم إنشاء الحجز بنجاح',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (result.bookingCode != null) _Info(label: 'رقم الحجز', value: result.bookingCode!),
              if (result.status != null) _Info(label: 'الحالة', value: result.status!),
              if (result.totalAmount != null) _Info(label: 'الإجمالي', value: '${result.totalAmount!.toStringAsFixed(2)} جنيه'),
              if (result.paymentStatus != null) _Info(label: 'حالة الدفع', value: result.paymentStatus!),
              const SizedBox(height: 28),
              if (onViewPayment != null && result.bookingId != null)
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onViewPayment,
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text('متابعة حالة الدفع'),
                  ),
                ),
              if (onViewBookings != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: onViewBookings,
                    child: const Text('حجوزاتي'),
                  ),
                ),
              if (onGoHome != null)
                SizedBox(
                  width: double.infinity,
                  child: TextButton(onPressed: onGoHome, child: const Text('العودة للرئيسية')),
                ),
            ],
          ),
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
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(label),
          trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      );
}
