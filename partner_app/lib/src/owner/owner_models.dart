class OwnerPropertySummary {
  const OwnerPropertySummary({
    required this.propertyId,
    required this.name,
    required this.active,
    required this.unitCount,
  });

  final String propertyId;
  final String name;
  final bool active;
  final int unitCount;
}

class OwnerUnitSummary {
  const OwnerUnitSummary({
    required this.unitId,
    required this.propertyId,
    required this.name,
    required this.active,
  });

  final String unitId;
  final String propertyId;
  final String name;
  final bool active;
}
