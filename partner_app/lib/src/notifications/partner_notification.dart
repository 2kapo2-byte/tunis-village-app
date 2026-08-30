enum PartnerNotificationType { booking, payment, payout, support, system, unknown }

class PartnerNotification {
  const PartnerNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final PartnerNotificationType type;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
}
