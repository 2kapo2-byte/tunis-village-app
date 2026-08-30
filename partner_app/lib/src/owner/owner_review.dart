enum OwnerReviewStatus { pending, published, rejected, hidden, unknown }

OwnerReviewStatus ownerReviewStatusFromString(String? value) {
  switch (value?.toLowerCase()) {
    case 'pending': return OwnerReviewStatus.pending;
    case 'published': return OwnerReviewStatus.published;
    case 'rejected': return OwnerReviewStatus.rejected;
    case 'hidden': return OwnerReviewStatus.hidden;
    default: return OwnerReviewStatus.unknown;
  }
}

class OwnerReviewSummary {
  const OwnerReviewSummary({
    required this.reviewId,
    required this.bookingId,
    required this.propertyId,
    required this.rating,
    required this.status,
  });

  final String reviewId;
  final String bookingId;
  final String propertyId;
  final int rating;
  final OwnerReviewStatus status;
}
