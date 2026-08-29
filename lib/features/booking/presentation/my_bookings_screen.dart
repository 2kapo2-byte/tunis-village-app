import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/booking.dart';
import '../data/booking_repository.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key, required this.repository});
  final BookingRepository repository;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.myBookings();
  }

  Future<void> _refresh() async {
    setState(() => _future = widget.repository.myBookings());
    await _future;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('حجوزاتي')),
        body: FutureBuilder<List<Booking>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return _Message(text: 'تعذر تحميل الحجوزات.', action: _refresh);
            }
            final bookings = snapshot.data ?? const <Booking>[];
            if (bookings.isEmpty) {
              return _Message(text: 'لا توجد حجوزات حتى الآن.', action: _refresh);
            }
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final booking = bookings[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.receipt_long_outlined),
                      title: Text(booking.bookingCode.isEmpty ? 'حجز' : booking.bookingCode),
                      subtitle: Text('${_date(booking.checkIn)} → ${_date(booking.checkOut)}\n${booking.guests.adults} بالغ + ${booking.guests.childrenCount} طفل'),
                      trailing: Text(_statusLabel(booking.status)),
                      isThreeLine: true,
                      onTap: () => context.push('/booking-details', extra: booking),
                    ),
                  );
                },
              ),
            );
          },
        ),
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
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.action});
  final String text;
  final Future<void> Function() action;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: action, child: const Text('إعادة المحاولة')),
          ],
        ),
      );
}
