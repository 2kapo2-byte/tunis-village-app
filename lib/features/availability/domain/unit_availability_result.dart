class UnitAvailabilityResult {
  const UnitAvailabilityResult({required this.available, this.reason, this.error});

  final bool available;
  final String? reason;
  final String? error;

  factory UnitAvailabilityResult.fromMap(Map<String, dynamic> map) => UnitAvailabilityResult(
        available: map['available'] == true,
        reason: map['reason']?.toString(),
        error: map['error']?.toString(),
      );
}
