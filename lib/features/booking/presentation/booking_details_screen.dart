import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key, required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحجز')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(booking.bookingCode, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _info('الحالة', _statusLabel(booking.status)),
          _info('الوصول', _date(booking.checkIn)),
          _info('المغادرة', _date(booking.checkOut)),
          _info('الليالي', '${booking.nights}'),
          _info('الضيوف', '${booking.guests.adults} بالغ + ${booking.guests.childrenCount} طفل'),
          if (booking.guests.childAges.isNotEmpty)
            _info('أعمار الأطفال', booking.guests.childAges.join('، ')),
          if (booking.basePrice != null) _info('سعر الإقامة', '${booking.basePrice!.toStringAsFixed(2)} جنيه'),
          if (booking.cleaningFee != null) _info('التنظيف', '${booking.cleaningFee!.toStringAsFixed(2)} جنيه'),
          if (booking.totalAmount != null) _info('الإجمالي', '${booking.totalAmount!.toStringAsFixed(2)} جنيه'),
          if (booking.paymentMethod != null) _info('طريقة الدفع', _methodLabel(booking.paymentMethod!)),
          if (booking.customerNotes?.isNotEmpty == true) _info('ملاحظات', booking.customerNotes!),
          const SizedBox(height: 24),
          if (booking.status != BookingStatus.cancelled && booking.status != BookingStatus.refunded)
            FilledButton.icon(
              onPressed: () => context.push('/payment-status', extra: booking.id),
              icon: const Icon(Icons.payments_outlined),
              label: const Text('حالة الدفع'),
            ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) => Card(
        child: ListTile(title: Text(label), trailing: Text(value, textAlign: TextAlign.end)),
      );

  static String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';

  static String _statusLabel(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending: return 'قيد الانتظار';
      case BookingStatus.confirmed: return 'مؤكد';
      case BookingStatus.paymentPending: return 'بانتظار الدفع';
      case BookingStatus.paid: return 'مدفوع';
      case BookingStatus.partiallyPaid: return 'مدفوع جزئيًا';
      case BookingStatus.cancelled: return 'ملغي';
      case BookingStatus.rejected: return 'مرفوض';
      case BookingStatus.completed: return 'مكتمل';
      case BookingStatus.expired: return 'منتهي';
      case BookingStatus.refunded: return 'مسترد';
      case BookingStatus.unknown: return 'غير معروف';
    }
  }

  static String _methodLabel(String method) {
    switch (method) {
      case 'cash_on_arrival': return 'الدفع عند الوصول';
      case 'bank_transfer': return 'تحويل بنكي';
      case 'online': return 'دفع إلكتروني';
      default: return method;
    }
  }
}
