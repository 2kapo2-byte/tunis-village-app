import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/guest_composition.dart';
import '../data/booking_repository.dart';
import '../data/pricing_repository.dart';
import '../domain/create_booking_request.dart';
import '../domain/price_estimate.dart';

class CustomerBookingReviewScreen extends StatefulWidget {
  const CustomerBookingReviewScreen({
    super.key,
    required this.request,
    required this.repository,
    required this.pricingRepository,
  });

  final CreateBookingRequest request;
  final BookingRepository repository;
  final PricingRepository pricingRepository;

  @override
  State<CustomerBookingReviewScreen> createState() => _CustomerBookingReviewScreenState();
}

class _CustomerBookingReviewScreenState extends State<CustomerBookingReviewScreen> {
  late Future<PriceEstimate> _quote;
  String _paymentMethod = 'cash_on_arrival';
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _quote = _loadQuote();
  }

  Future<PriceEstimate> _loadQuote() {
    final r = widget.request;
    return widget.pricingRepository.estimate(
      unitId: r.unitId,
      propertyId: r.propertyId,
      checkIn: r.checkIn,
      checkOut: r.checkOut,
      guests: GuestComposition(adults: r.adults, childAges: r.childAges),
    );
  }

  Future<void> _confirm() async {
    if (_submitting) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final r = widget.request;
      final result = await widget.repository.createBooking(
        unitId: r.unitId,
        propertyId: r.propertyId,
        checkIn: r.checkIn,
        checkOut: r.checkOut,
        guests: GuestComposition(adults: r.adults, childAges: r.childAges),
        paymentMethod: _paymentMethod,
        customerNotes: r.customerNotes,
      );
      if (!mounted) return;
      context.go('/booking-confirmation', extra: result);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    return Scaffold(
      appBar: AppBar(title: const Text('مراجعة الحجز')),
      body: FutureBuilder<PriceEstimate>(
        future: _quote,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('تعذر حساب السعر من الخادم.'),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: () => setState(() => _quote = _loadQuote()), child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }
          final quote = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text('تفاصيل الإقامة', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ListTile(title: const Text('الوصول'), subtitle: Text(_date(r.checkIn))),
              ListTile(title: const Text('المغادرة'), subtitle: Text(_date(r.checkOut))),
              ListTile(title: const Text('الضيوف'), subtitle: Text('${r.adults} بالغ + ${r.childrenCount} طفل')),
              if (r.childAges.isNotEmpty)
                ListTile(title: const Text('أعمار الأطفال'), subtitle: Text(r.childAges.join('، '))),
              const Divider(height: 28),
              Text('السعر من الخادم', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              _line('سعر الإقامة', quote.basePrice),
              _line('تعديل موسمي', quote.seasonalAdjustment),
              _line('تعديل نهاية الأسبوع', quote.weekendAdjustment),
              _line('ضيوف إضافيون', quote.extraGuestAmount),
              _line('الأطفال', quote.childrenAmount),
              _line('التنظيف', quote.cleaningFee),
              if (quote.discount != 0) _line('الخصم', -quote.discount),
              if (quote.taxes != 0) _line('الضرائب', quote.taxes),
              const Divider(height: 24),
              _line('الإجمالي', quote.totalAmount, emphasized: true),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: 'طريقة الدفع'),
                items: const [
                  DropdownMenuItem(value: 'cash_on_arrival', child: Text('الدفع عند الوصول')),
                  DropdownMenuItem(value: 'bank_transfer', child: Text('تحويل بنكي')),
                  DropdownMenuItem(value: 'online', child: Text('دفع إلكتروني')),
                ],
                onChanged: _submitting ? null : (value) => setState(() => _paymentMethod = value ?? 'cash_on_arrival'),
              ),
              if (_paymentMethod == 'online')
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text('سيتم إنشاء دفعة بحالة pending. تنفيذ بوابة الدفع الفعلية يتم من خلال backend/provider لاحقًا، ولا يوجد نجاح دفع وهمي.'),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _confirm,
                child: Text(_submitting ? 'جاري إنشاء الحجز...' : 'تأكيد الحجز'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _line(String label, double value, {bool emphasized = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: emphasized ? const TextStyle(fontWeight: FontWeight.bold) : null),
            Text('${value.toStringAsFixed(2)} جنيه', style: emphasized ? const TextStyle(fontWeight: FontWeight.bold) : null),
          ],
        ),
      );

  static String _date(DateTime value) => '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
