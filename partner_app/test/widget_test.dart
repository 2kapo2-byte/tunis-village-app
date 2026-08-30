import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/main.dart';

void main() {
  testWidgets('partner app boots with partner shell', (tester) async {
    await tester.pumpWidget(const TunisVillagePartnerApp());
    expect(find.text('Tunis Village Partners'), findsOneWidget);
  });
}
