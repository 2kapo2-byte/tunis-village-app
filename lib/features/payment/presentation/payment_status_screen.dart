import 'package:flutter/material.dart';
import '../../../core/models/payment.dart';
import '../data/payment_repository.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({
    super.key,
    required this.bookingId,
    this.paymentId,
    this.initialMethod,
    required this.repository,
  });

  final String bookingId;
  final String? paymentId;
  final String? initialMethod;
  final PaymentRepository repository;

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  late Future<Payment> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Payment> _load() async {
    if (widget.paymentId != null) {
      return widget.repository.getOwnPayment(widget.paymentId!);
    }
    return widget.repository.createOrGetForBooking(
      bookingId: widget.bookingId,
      method: widget.initialMethod,
    );
  }

  void _refresh() => setState(() => _future = _load());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدفع')), 
      body: FutureBuilder<Payment>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('تعذر تحميل حالة الدفع.'),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: _refresh, child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }
          final payment = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Icon(Icons.payments_outlined, size: 64),
              const SizedBox(height: 16),
              Text('حالة الدفع: ${_statusLabel(payment.status)}', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ListTile(title: const Text('المبلغ'), trailing: Text('${payment.amount?.toStringAsFixed(2) ?? '—'} ${payment.currency ?? 'EGP'}')),
              ListTile(title: const Text('الطريقة'), trailing: Text(_methodLabel(payment.method))),
              if (payment.provider != null)
                ListTile(title: const Text('مزود الدفع'), trailing: Text(payment.provider!)),
              if (payment.providerReference != null)
                ListTile(title: const Text('مرجع العملية'), trailing: Text(payment.providerReference!)),
              const SizedBox(height: 20),
              if (payment.status == PaymentStatus.pending && payment.method == 'online')
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('الدفع الإلكتروني لم يتم ربطه بمزود فعلي بعد. لن نعرض نجاحًا وهميًا؛ ستظل العملية pending حتى يؤكدها الـ backend/provider.'),
                  ),
                ),
              if (payment.status == PaymentStatus.pending && payment.method == 'cash_on_arrival')
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('الدفع عند الوصول: تم تسجيل وسيلة الدفع، وحالة التحصيل تظل تحت إدارة المنصة.'),
                  ),
                ),
              const SizedBox(height: 16),
              OutlinedButton.icon(onPressed: _refresh, icon: const Icon(Icons.refresh), label: const Text('تحديث الحالة')),
            ],
          );
        },
      ),
    );
  }

  String _statusLabel(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending: return 'قيد الانتظار';
      case PaymentStatus.processing: return 'جاري المعالجة';
      case PaymentStatus.paid: return 'تم الدفع';
      case PaymentStatus.failed: return 'فشل الدفع';
      case PaymentStatus.refunded: return 'تم رد المبلغ';
      case PaymentStatus.partiallyRefunded: return 'رد جزئي';
      case PaymentStatus.unknown: return 'غير معروف';
    }
  }

  String _methodLabel(String? method) {
    switch (method) {
      case 'cash_on_arrival': return 'الدفع عند الوصول';
      case 'bank_transfer': return 'تحويل بنكي';
      case 'online': return 'دفع إلكتروني';
      default: return method ?? '—';
    }
  }
}
