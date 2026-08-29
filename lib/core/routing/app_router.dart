import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/profile_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/domain/search_query.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/properties/domain/property_summary.dart';
import '../../features/properties/presentation/properties_results_screen.dart';
import '../../features/properties/presentation/property_details_screen.dart';
import '../../features/availability/data/availability_repository.dart';
import '../../features/booking/data/booking_repository.dart';
import '../../features/booking/domain/booking_result.dart';
import '../../features/booking/domain/create_booking_request.dart';
import '../../features/booking/presentation/customer_booking_review_screen.dart';
import '../../features/booking/presentation/partner_booking_details_screen.dart';
import '../../features/booking/presentation/booking_confirmation_screen.dart';
import '../../features/booking/presentation/my_bookings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    const publicPaths = {'/login', '/register', '/forgot-password'};
    final isPublic = publicPaths.contains(state.matchedLocation);
    if (session == null && !isPublic) return '/login';
    if (session != null && isPublic) return '/';
    return null;
  },
  refreshListenable: GoRouterRefreshStream(
    Supabase.instance.client.auth.onAuthStateChange,
  ),
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
    GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/search', builder: (context, state) => const SearchScreen()),
    GoRoute(
      path: '/partner-search',
      builder: (context, state) => const SearchScreen(partnerMode: true),
    ),
    GoRoute(path: '/properties', builder: (context, state) {
      final extra = state.extra;
      final query = extra is SearchQuery
          ? extra
          : extra is Map<String, dynamic>
              ? extra['query']
              : null;
      final partnerMode = extra is Map<String, dynamic>
          ? extra['partnerMode'] == true
          : false;
      if (query is! SearchQuery) return const SearchScreen();
      return PropertiesResultsScreen(
        query: query,
        partnerMode: partnerMode,
        repository: AvailabilityRepository(Supabase.instance.client),
      );
    }),
    GoRoute(path: '/property-details', builder: (context, state) {
      final args = state.extra;
      if (args is! Map<String, dynamic>) return const SearchScreen();
      final property = args['property'];
      final query = args['query'];
      final partnerMode = args['partnerMode'] == true;
      if (property is! PropertySummary || query is! SearchQuery) {
        return const SearchScreen();
      }
      return PropertyDetailsScreen(
        property: property,
        query: query,
        partnerMode: partnerMode,
      );
    }),
    GoRoute(path: '/partner-booking-details', builder: (context, state) {
      final request = state.extra;
      if (request is! CreateBookingRequest || !request.partnerMode) {
        return const SearchScreen();
      }
      return PartnerBookingDetailsScreen(request: request);
    }),
    GoRoute(path: '/booking-review', builder: (context, state) {
      final request = state.extra;
      if (request is! CreateBookingRequest) return const SearchScreen();
      return CustomerBookingReviewScreen(
        request: request,
        repository: BookingRepository(Supabase.instance.client),
      );
    }),
    GoRoute(path: '/booking-confirmation', builder: (context, state) {
      final result = state.extra;
      if (result is! BookingResult) return const SearchScreen();
      return BookingConfirmationScreen(
        result: result,
        onViewBookings: () => context.go('/my-bookings'),
        onGoHome: () => context.go('/'),
      );
    }),
    GoRoute(
      path: '/my-bookings',
      builder: (context, state) => MyBookingsScreen(
        repository: BookingRepository(Supabase.instance.client),
      ),
    ),
  ],
);

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
