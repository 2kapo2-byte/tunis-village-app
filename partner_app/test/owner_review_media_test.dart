import 'package:flutter_test/flutter_test.dart';
import 'package:tunis_village_partner/src/owner/owner_review.dart';
import 'package:tunis_village_partner/src/owner/owner_media.dart';

void main() {
  test('review status parsing is fail-closed', () {
    expect(ownerReviewStatusFromString('published'), OwnerReviewStatus.published);
    expect(ownerReviewStatusFromString('bad-status'), OwnerReviewStatus.unknown);
  });

  test('media type parsing is fail-closed', () {
    expect(ownerMediaTypeFromString('image'), OwnerMediaType.image);
    expect(ownerMediaTypeFromString('bad-type'), OwnerMediaType.unknown);
  });

  test('review summary cannot represent an edit or delete capability', () {
    const review = OwnerReviewSummary(
      reviewId: 'r1',
      bookingId: 'b1',
      propertyId: 'p1',
      rating: 5,
      status: OwnerReviewStatus.published,
    );
    expect(review.rating, 5);
    expect(review.status, OwnerReviewStatus.published);
  });
}
