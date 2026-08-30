import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/finance/owner_payout.dart';
import 'package:tunis_village_partner/src/finance/marketer_commission.dart';

void main() {
  test('payout status parser fails closed', () {
    expect(payoutStatusFromString('paid'), PayoutStatus.paid);
    expect(payoutStatusFromString('invalid'), PayoutStatus.unknown);
  });

  test('owner balance cannot be negative by model contract', () {
    const balance = OwnerBalanceSummary(
      grossCompleted: 1000,
      commissionAmount: 100,
      netEligible: 900,
      reservedAmount: 200,
      availableAmount: 700,
    );
    expect(balance.availableAmount, 700);
    expect(balance.netEligible, 900);
  });

  test('marketer commission status parser fails closed', () {
    expect(marketerCommissionStatusFromString('approved'), MarketerCommissionStatus.approved);
    expect(marketerCommissionStatusFromString('invalid'), MarketerCommissionStatus.unknown);
  });
}
