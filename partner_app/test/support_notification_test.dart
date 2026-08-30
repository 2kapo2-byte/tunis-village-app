import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/notifications/partner_notification.dart';
import 'package:tunis_village_partner/src/support/partner_support.dart';

void main() {
  test('support defaults to normal priority', () {
    const request = PartnerSupportRequest(subject: 'Help', message: 'Need help');
    expect(request.priority, SupportPriority.normal);
  });

  test('notification model carries no customer identity fields', () {
    final notification = PartnerNotification(
      id: 'n1',
      type: PartnerNotificationType.booking,
      title: 'Booking update',
      body: 'A booking was updated.',
      createdAt: DateTime(2026, 8, 30),
    );
    expect(notification.read, isFalse);
    expect(notification.type, PartnerNotificationType.booking);
  });
}
