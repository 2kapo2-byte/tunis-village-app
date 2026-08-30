enum FinancialStatus { pending, approved, paid, rejected, cancelled, unknown }

FinancialStatus financialStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'pending': return FinancialStatus.pending;
    case 'approved': return FinancialStatus.approved;
    case 'paid': return FinancialStatus.paid;
    case 'rejected': return FinancialStatus.rejected;
    case 'cancelled': return FinancialStatus.cancelled;
    default: return FinancialStatus.unknown;
  }
}

class OwnerPayoutSummary {
  const OwnerPayoutSummary({required this.id, required this.amount, required this.status});
  final String id;
  final num amount;
  final FinancialStatus status;
}

class MarketerCommissionSummary {
  const MarketerCommissionSummary({required this.id, required this.amount, required this.status});
  final String id;
  final num amount;
  final FinancialStatus status;
}
