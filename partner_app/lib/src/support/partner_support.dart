enum SupportPriority { low, normal, high, urgent }

class PartnerSupportRequest {
  const PartnerSupportRequest({
    required this.subject,
    required this.message,
    this.priority = SupportPriority.normal,
  });

  final String subject;
  final String message;
  final SupportPriority priority;
}
