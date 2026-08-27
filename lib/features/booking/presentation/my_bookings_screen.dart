import 'package:flutter/material.dart';

import '../../../core/models/booking.dart';
import '../data/booking_repository.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key, required this.repository, required this.customerId});
  final BookingRepository repository;
  final String customerId;

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late Future<List<Booking>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.myBookings(widget.customerId);
  }

  Future<void> _refresh() async {
    setState(() => _future = widget.repository.myBookings(widget.customerId));
    await _future;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('حجوزاتي')),
        body: FutureBuilder<List<Booking>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return _Message(text: 'تعذر تحميل الحجوزات.', action: _refresh);
            final bookings = snapshot.data ?? const <Booking>[];
            if (bookings.isEmpty) return _Message(text: 'لا توجد حجوزات حتى الآن.', action: _refresh);
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, index) {
                  final booking = bookings[index];
                  return Card(child: ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(booking.bookingCode ?? 'حجز'),
                    subtitle: Text('${_date(booking.checkIn)} → ${_date(booking.checkOut)}'),
                    trailing: Text(booking.status ?? ''),
                  ));
                },
              ),
            );
          },
        ),
      );

  static String _date(DateTime? value) => value == null ? '—' : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.action});
  final String text;
  final Future<void> Function() action;
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Text(text), const SizedBox(height: 12), OutlinedButton(onPressed: action, child: const Text('إعادة المحاولة'))]));
}
