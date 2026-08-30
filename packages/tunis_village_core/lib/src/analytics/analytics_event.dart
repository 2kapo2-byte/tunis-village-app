enum AnalyticsEvent {
  searchStarted,
  searchCompleted,
  propertyViewed,
  bookingStarted,
  bookingCompleted,
  bookingCancelled,
}

extension AnalyticsEventName on AnalyticsEvent {
  String get name {
    switch (this) {
      case AnalyticsEvent.searchStarted:
        return 'search_started';
      case AnalyticsEvent.searchCompleted:
        return 'search_completed';
      case AnalyticsEvent.propertyViewed:
        return 'property_viewed';
      case AnalyticsEvent.bookingStarted:
        return 'booking_started';
      case AnalyticsEvent.bookingCompleted:
        return 'booking_completed';
      case AnalyticsEvent.bookingCancelled:
        return 'booking_cancelled';
    }
  }
}
