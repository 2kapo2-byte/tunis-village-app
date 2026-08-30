enum MarketerCommissionStatus { pending, approved, paid, cancelled, unknown }

MarketerCommissionStatus marketerCommissionStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'pending': return MarketerCommissionStatus.pending;
    case 'approved': return MarketerCommissionStatus.approved;
    case 'paid': return MarketerCommissionStatus.paid;
    case 'cancelled': return MarketerCommissionStatus.cancelled;
    default: return MarketerCommissionStatus.unknown;
  }
}

class MarketerCommissionSummary {
  const MarketerCommissionSummary({
    required this.commissionId,
    required this.bookingId,
    required this.rate,
    required this.amount,
    required this.status,
  });

  final String commissionId;
  final String bookingId;
  final num rate;
  final num amount;
  final MarketerCommissionStatus status;
}
