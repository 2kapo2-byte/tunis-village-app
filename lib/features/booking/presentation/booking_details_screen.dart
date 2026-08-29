import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking.dart';
import '../../cancellation/data/cancellation_repository.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({
    super.key,
    required this.booking,
    required this.cancellationRepository,
  });

  final Booking booking;
  final CancellationRepository cancellationRepository;

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _cancelling = false;
  String? _message;
  String? _error;
  late Future<RefundStatus?> _refundFuture;

  @override
  void initState() {
    super.initState();
    _refundFuture = widget.cancellationRepository.getLatestRefund(widget.booking.id);
  }

  Future<void> _cancel() async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('إلغاء الحجز'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'سبب الإلغاء (اختياري)'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('رجوع')),
            FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('تأكيد الإلغاء')),
          ],
        );
      },
    );
    if (reason == null || _cancelling) return;
    setState(() {
      _cancelling = true;
      _error = null;
      _message = null;
    });
    try {
      final result = await widget.cancellationRepository.cancel(
        bookingId: widget.booking.id,
        reason: reason.isEmpty ? null : reason,
      );
      if (!mounted) return;
      setState(() {
        _message = 'تم إلغاء الحجز. المبلغ المتوقع رده: ${result.refundAmount.toStringAsFixed(2)} جنيه (${result.refundPercent.toStringAsFixed(0)}%).';
        _refundFuture = widget.cancellationRepository.getLatestRefund(widget.booking.id);
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final cancellable = booking.status != BookingStatus.cancelled &&
        booking.status != BookingStatus.completed &&
        booking.status != BookingStatus.refunded;
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
          if (booking.guests.childAges.isNotEmpty) _info('أعمار الأطفال', booking.guests.childAges.join('، ')),
          if (booking.basePrice != null) _info('سعر الإقامة', '${booking.basePrice!.toStringAsFixed(2)} جنيه'),
          if (booking.cleaningFee != null) _info('التنظيف', '${booking.cleaningFee!.toStringAsFixed(2)} جنيه'),
          if (booking.totalAmount != null) _info('الإجمالي', '${booking.totalAmount!.toStringAsFixed(2)} جنيه'),
          if (booking.paymentMethod != null) _info('طريقة الدفع', _methodLabel(booking.paymentMethod!)),
          if (booking.customerNotes?.isNotEmpty == true) _info('ملاحظات', booking.customerNotes!),
          const SizedBox(height: 16),
          FutureBuilder<RefundStatus?>(
            future: _refundFuture,
            builder: (context, snapshot) {
              final refund = snapshot.data;
              if (refund == null) return const SizedBox.shrink();
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: Text('استرداد: ${refund.status}'),
                  subtitle: Text('${refund.amount.toStringAsFixed(2)} جنيه${refund.reason == null ? '' : '\n${refund.reason}'}'),
                ),
              );
            },
          ),
          if (_message != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_message!)),
          if (_error != null) Padding(padding: const EdgeInsets.only(top: 8), child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))),
          const SizedBox(height: 20),
          if (booking.status != BookingStatus.cancelled && booking.status != BookingStatus.refunded)
            FilledButton.icon(
              onPressed: () => context.push('/payment-status', extra: booking.id),
              icon: const Icon(Icons.payments_outlined),
              label: const Text('حالة الدفع'),
            ),
          if (cancellable)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: OutlinedButton.icon(
                onPressed: _cancelling ? null : _cancel,
                icon: const Icon(Icons.cancel_outlined),
                label: Text(_cancelling ? 'جاري الإلغاء...' : 'إلغاء الحجز'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) => Card(child: ListTile(title: Text(label), trailing: Text(value, textAlign: TextAlign.end)));
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
