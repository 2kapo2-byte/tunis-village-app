enum AvailabilityStatus { available, blocked, booked, unknown }

AvailabilityStatus availabilityStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'available': return AvailabilityStatus.available;
    case 'blocked': return AvailabilityStatus.blocked;
    case 'booked': return AvailabilityStatus.booked;
    default: return AvailabilityStatus.unknown;
  }
}
