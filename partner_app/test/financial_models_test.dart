import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/finance/financial_models.dart';

void main() {
  test('financial status parsing fails closed', () {
    expect(financialStatusFromString('paid'), FinancialStatus.paid);
    expect(financialStatusFromString('pending'), FinancialStatus.pending);
    expect(financialStatusFromString('unexpected'), FinancialStatus.unknown);
  });

  test('financial read models carry server-provided values only', () {
    const payout = OwnerPayoutSummary(id: 'p1', amount: 1250, status: FinancialStatus.paid);
    const commission = MarketerCommissionSummary(id: 'c1', amount: 100, status: FinancialStatus.approved);
    expect(payout.amount, 1250);
    expect(commission.amount, 100);
  });
}
