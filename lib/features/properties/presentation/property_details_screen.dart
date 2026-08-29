import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../booking/domain/create_booking_request.dart';
import '../../search/domain/search_query.dart';
import '../data/property_repository.dart';
import '../domain/property_details_data.dart';
import '../domain/property_summary.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({
    super.key,
    required this.property,
    required this.repository,
    this.query,
    this.partnerMode = false,
  });

  final PropertySummary property;
  final PropertyRepository repository;
  final SearchQuery? query;
  final bool partnerMode;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late Future<PropertyDetailsData> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.getDetails(
      propertyId: widget.property.id,
      unitId: widget.property.unitId,
    );
  }

  void _retry() {
    setState(() {
      _future = widget.repository.getDetails(
        propertyId: widget.property.id,
        unitId: widget.property.unitId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الإقامة')),
      body: FutureBuilder<PropertyDetailsData>(
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
                  const Text('تعذر تحميل تفاصيل الإقامة.'),
                  const SizedBox(height: 12),
                  OutlinedButton(onPressed: _retry, child: const Text('إعادة المحاولة')),
                ],
              ),
            );
          }
          final data = snapshot.data!;
          return _DetailsBody(data: data, query: widget.query, partnerMode: widget.partnerMode);
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.data, required this.query, required this.partnerMode});

  final PropertyDetailsData data;
  final SearchQuery? query;
  final bool partnerMode;

  @override
  Widget build(BuildContext context) {
    final property = data.property;
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (data.images.isNotEmpty)
          SizedBox(
            height: 240,
            child: PageView.builder(
              itemCount: data.images.length,
              itemBuilder: (_, index) => Image.network(
                data.images[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 48),
                ),
              ),
            ),
          )
        else
          const SizedBox(
            height: 180,
            child: Center(child: Icon(Icons.home_work_outlined, size: 64)),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(property.name, style: Theme.of(context).textTheme.headlineSmall),
        ),
        if (property.location != null)
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(property.location!),
          ),
        if (property.rating != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.star, size: 20),
                const SizedBox(width: 6),
                Text(property.rating!.toStringAsFixed(1)),
                if ((property.reviewsCount ?? 0) > 0) ...[
                  const SizedBox(width: 6),
                  Text('(${property.reviewsCount} تقييم)'),
                ],
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text(data.unitName, style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(avatar: const Icon(Icons.people_outline, size: 18), label: Text('حتى ${data.unitCapacity} ضيف')),
              Chip(avatar: const Icon(Icons.payments_outlined, size: 18), label: Text('${data.unitPricePerNight.toStringAsFixed(0)} جنيه / ليلة')),
              if (data.unitBedrooms != null)
                Chip(label: Text('${data.unitBedrooms} غرف نوم')),
              if (data.unitBathrooms != null)
                Chip(label: Text('${data.unitBathrooms} حمام')),
              if (data.unitBeds != null)
                Chip(label: Text('${data.unitBeds} سرير')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            property.description?.trim().isNotEmpty == true
                ? property.description!
                : 'لا يوجد وصف متاح حاليًا.',
          ),
        ),
        if (data.amenities.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('المرافق', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: data.amenities.map((amenity) => Chip(label: Text(amenity))).toList(),
                ),
              ],
            ),
          ),
        if (query != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: FilledButton.icon(
              onPressed: () {
                final q = query!;
                final request = CreateBookingRequest(
                  unitId: data.unitId,
                  propertyId: property.id,
                  checkIn: q.checkIn,
                  checkOut: q.checkOut,
                  adults: q.guests.adults,
                  childrenCount: q.guests.childrenCount,
                  childAges: List<int>.from(q.guests.childAges),
                  partnerMode: partnerMode,
                );
                context.push(
                  partnerMode ? '/partner-booking-details' : '/booking-review',
                  extra: request,
                );
              },
              icon: const Icon(Icons.calendar_month_outlined),
              label: Text(partnerMode ? 'بيانات العميل ومتابعة الحجز' : 'متابعة الحجز'),
            ),
          ),
      ],
    );
  }
}
