enum PayoutStatus { pending, processing, paid, failed, cancelled, unknown }

PayoutStatus payoutStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'pending': return PayoutStatus.pending;
    case 'processing': return PayoutStatus.processing;
    case 'paid': return PayoutStatus.paid;
    case 'failed': return PayoutStatus.failed;
    case 'cancelled': return PayoutStatus.cancelled;
    default: return PayoutStatus.unknown;
  }
}

class OwnerPayoutSummary {
  const OwnerPayoutSummary({
    required this.payoutId,
    required this.amount,
    required this.status,
    this.periodStart,
    this.periodEnd,
    this.bookingId,
    this.paidAt,
  });

  final String payoutId;
  final num amount;
  final PayoutStatus status;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final String? bookingId;
  final DateTime? paidAt;
}

class OwnerBalanceSummary {
  const OwnerBalanceSummary({
    required this.grossCompleted,
    required this.commissionAmount,
    required this.netEligible,
    required this.reservedAmount,
    required this.availableAmount,
  });

  final num grossCompleted;
  final num commissionAmount;
  final num netEligible;
  final num reservedAmount;
  final num availableAmount;
}
