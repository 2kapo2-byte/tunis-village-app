import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../booking/domain/create_booking_request.dart';
import '../../search/domain/search_query.dart';
import '../domain/property_summary.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key, required this.property, this.query, this.onBook});
  final PropertySummary property;
  final SearchQuery? query;
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final price = property.pricePerNight;
    final capacity = property.maxGuests;
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الإقامة')),
      body: ListView(children: [
        if (property.coverImageUrl != null)
          AspectRatio(aspectRatio: 16 / 9, child: Image.network(property.coverImageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.image_not_supported_outlined, size: 48))))
        else
          const AspectRatio(aspectRatio: 16 / 9, child: Center(child: Icon(Icons.home_work_outlined, size: 56))),
        Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 8), child: Text(property.name, style: Theme.of(context).textTheme.headlineSmall)),
        if (property.location != null) ListTile(leading: const Icon(Icons.location_on_outlined), title: Text(property.location!)),
        if (capacity != null || price != null)
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Wrap(spacing: 10, children: [
            if (capacity != null) Chip(avatar: const Icon(Icons.people_outline, size: 18), label: Text('حتى $capacity ضيف')),
            if (price != null) Chip(avatar: const Icon(Icons.payments_outlined, size: 18), label: Text('${price.toStringAsFixed(0)} جنيه / ليلة')),
          ])),
        Padding(padding: const EdgeInsets.all(20), child: Text(property.description?.trim().isNotEmpty == true ? property.description! : 'لا يوجد وصف متاح حاليًا.')),
        Padding(padding: const EdgeInsets.fromLTRB(20, 8, 20, 32), child: FilledButton.icon(
          onPressed: onBook ?? (query == null ? null : () {
            final q = query!;
            final request = CreateBookingRequest(
              unitId: property.unitId ?? property.id,
              propertyId: property.id,
              checkIn: q.checkIn,
              checkOut: q.checkOut,
              adults: q.guests.adults,
              childrenCount: q.guests.childrenCount,
              childAges: List<int>.from(q.guests.childAges),
              partnerMode: q.partnerMode,
            );
            context.push(q.partnerMode ? '/partner-booking-details' : '/booking-review', extra: request);
          }),
          icon: const Icon(Icons.calendar_month_outlined),
          label: Text(query?.partnerMode == true ? 'بيانات العميل ومتابعة الحجز' : 'متابعة الحجز'),
        )),
      ]),
    );
  }
}
