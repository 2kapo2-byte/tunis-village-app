import 'property_summary.dart';

class PropertyDetailsData {
  const PropertyDetailsData({
    required this.property,
    required this.images,
    required this.amenities,
    required this.unitName,
    required this.unitId,
    required this.unitCapacity,
    required this.unitPricePerNight,
    this.unitBedrooms,
    this.unitBathrooms,
    this.unitBeds,
  });

  final PropertySummary property;
  final List<String> images;
  final List<String> amenities;
  final String unitName;
  final String unitId;
  final int unitCapacity;
  final double unitPricePerNight;
  final int? unitBedrooms;
  final int? unitBathrooms;
  final int? unitBeds;
}
