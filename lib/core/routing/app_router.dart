import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/booking.dart';
import '../../core/analytics/analytics_navigator_observer.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/domain/search_query.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/properties/data/property_repository.dart';
import '../../features/properties/domain/property_summary.dart';
import '../../features/properties/presentation/properties_results_screen.dart';
import '../../features/properties/presentation/property_details_screen.dart';
import '../../features/availability/data/availability_repository.dart';
import '../../features/booking/data/booking_repository.dart';
import '../../features/booking/data/pricing_repository.dart';
import '../../features/booking/domain/booking_result.dart';
import '../../features/booking/domain/create_booking_request.dart';
import '../../features/booking/presentation/booking_details_screen.dart';
import '../../features/booking/presentation/customer_booking_review_screen.dart';
import '../../features/booking/presentation/partner_booking_details_screen.dart';
import '../../features/booking/presentation/booking_confirmation_screen.dart';
import '../../features/booking/presentation/my_bookings_screen.dart';
import '../../features/cancellation/data/cancellation_repository.dart';
import '../../features/payment/data/payment_repository.dart';
import '../../features/payment/presentation/payment_status_screen.dart';
import '../../features/reviews/data/review_repository.dart';
import '../../features/reviews/presentation/create_review_screen.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../core/support/support_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  observers: [AnalyticsNavigatorObserver(Supabase.instance.client)],
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    const publicPaths = {'/login', '/register', '/forgot-password'};
    final isPublic = publicPaths.contains(state.matchedLocation);
    if (session == null && !isPublic) return '/login';
    if (session != null && isPublic) return '/';
    return null;
  },
  refreshListenable: GoRouterRefreshStream(Supabase.instance.client.auth.onAuthStateChange),
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(path: '/partner-search', builder: (context, state) => const SearchScreen(partnerMode: true)),
    GoRoute(path: '/support', builder: (context, state) => const SupportScreen()),
    GoRoute(path: '/properties', builder: (context, state) {
      final extra = state.extra;
      final query = extra is SearchQuery ? extra : extra is Map<String, dynamic> ? extra['query'] : null;
      final partnerMode = extra is Map<String, dynamic> ? extra['partnerMode'] == true : false;
      if (query is! SearchQuery) return const SearchScreen();
      return PropertiesResultsScreen(query: query, partnerMode: partnerMode, repository: AvailabilityRepository(Supabase.instance.client));
    }),
    GoRoute(name: 'property-details', path: '/property-details', builder: (context, state) {
      final args = state.extra;
      if (args is! Map<String, dynamic>) return const SearchScreen();
      final property = args['property'];
      final query = args['query'];
      final partnerMode = args['partnerMode'] == true;
      if (property is! PropertySummary || query is! SearchQuery) return const SearchScreen();
      return PropertyDetailsScreen(property: property, query: query, partnerMode: partnerMode, repository: PropertyRepository(Supabase.instance.client));
    }),
    GoRoute(path: '/partner-booking-details', builder: (context, state) {
      final request = state.extra;
      if (request is! CreateBookingRequest || !request.partnerMode) return const SearchScreen();
      return PartnerBookingDetailsScreen(request: request);
    }),
    GoRoute(path: '/booking-review', builder: (context, state) {
      final request = state.extra;
      if (request is! CreateBookingRequest) return const SearchScreen();
      return CustomerBookingReviewScreen(request: request, repository: BookingRepository(Supabase.instance.client), pricingRepository: PricingRepository(Supabase.instance.client));
    }),
    GoRoute(path: '/booking-confirmation', builder: (context, state) {
      final result = state.extra;
      if (result is! BookingResult) return const SearchScreen();
      return BookingConfirmationScreen(result: result, onViewPayment: result.bookingId == null ? null : () => context.push('/payment-status', extra: result), onViewBookings: () => context.go('/my-bookings'), onGoHome: () => context.go('/'));
    }),
    GoRoute(path: '/booking-details', builder: (context, state) {
      final booking = state.extra;
      if (booking is! Booking) return const SearchScreen();
      return BookingDetailsScreen(booking: booking, cancellationRepository: CancellationRepository(Supabase.instance.client));
    }),
    GoRoute(path: '/payment-status', builder: (context, state) {
      final extra = state.extra;
      if (extra is BookingResult && extra.bookingId != null) return PaymentStatusScreen(bookingId: extra.bookingId!, paymentId: extra.paymentId, repository: PaymentRepository(Supabase.instance.client));
      if (extra is String) return PaymentStatusScreen(bookingId: extra, repository: PaymentRepository(Supabase.instance.client));
      return const SearchScreen();
    }),
    GoRoute(path: '/create-review', builder: (context, state) {
      final booking = state.extra;
      if (booking is! Booking || booking.status != BookingStatus.completed) return const SearchScreen();
      return CreateReviewScreen(bookingId: booking.id, propertyId: booking.propertyId, repository: ReviewRepository(Supabase.instance.client));
    }),
    GoRoute(path: '/notifications', builder: (context, state) => NotificationsScreen(repository: NotificationsRepository(Supabase.instance.client))),
    GoRoute(path: '/my-bookings', builder: (context, state) => MyBookingsScreen(repository: BookingRepository(Supabase.instance.client))),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) { _subscription = stream.listen((_) => notifyListeners()); }
  late final StreamSubscription<AuthState> _subscription;
  @override
  void dispose() { _subscription.cancel(); super.dispose(); }
}
