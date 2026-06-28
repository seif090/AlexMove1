import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../features/authentication/presentation/screens/splash_screen.dart';
import '../../features/authentication/presentation/screens/onboarding_screen.dart';
import '../../features/authentication/presentation/screens/login_screen.dart';
import '../../features/authentication/presentation/screens/register_screen.dart';
import '../../features/authentication/presentation/screens/otp_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/home/presentation/screens/passenger_home_screen.dart';
import '../../features/communities/presentation/screens/community_list_screen.dart';
import '../../features/communities/presentation/screens/community_detail_screen.dart';
import '../../features/groups/presentation/screens/group_list_screen.dart';
import '../../features/groups/presentation/screens/group_detail_screen.dart';
import '../../features/booking/presentation/screens/booking_list_screen.dart';
import '../../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../../features/tracking/presentation/screens/tracking_map_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/notifications/presentation/screens/notification_screen.dart';
import '../../features/home/presentation/screens/driver_shell_screen.dart';
import '../../features/driver/presentation/screens/driver_dashboard_screen.dart';
import '../../features/driver/presentation/screens/driver_trips_screen.dart';
import '../../features/driver/presentation/screens/driver_trip_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _passengerShellNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _driverShellNavigatorKey =
    GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final onboardingCompleted = ref.watch(onboardingCompletedProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        name: 'otp',
        builder: (context, state) => OtpScreen(
          email: state.uri.queryParameters['email'] ?? '',
        ),
      ),
      ShellRoute(
        navigatorKey: _passengerShellNavigatorKey,
        builder: (context, state, child) => MainShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'passenger-home',
            builder: (context, state) => const PassengerHomeScreen(),
          ),
          GoRoute(
            path: '/communities',
            name: 'communities',
            builder: (context, state) => const CommunityListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'community-detail',
                builder: (context, state) => CommunityDetailScreen(
                  communityId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/groups',
            name: 'groups',
            builder: (context, state) => const GroupListScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'group-detail',
                builder: (context, state) => GroupDetailScreen(
                  groupId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/bookings',
            name: 'bookings',
            builder: (context, state) => const BookingListScreen(),
            routes: [
              GoRoute(
                path: 'confirm',
                name: 'booking-confirm',
                builder: (context, state) => BookingConfirmationScreen(
                  groupId: int.parse(state.uri.queryParameters['groupId'] ?? '0'),
                  groupName: state.uri.queryParameters['groupName'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: 'edit',
                name: 'profile-edit',
                builder: (context, state) => const EditProfileScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/tracking/:tripId',
        name: 'tracking',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TrackingMapScreen(
          tripId: int.parse(state.pathParameters['tripId']!),
        ),
      ),
      ShellRoute(
        navigatorKey: _driverShellNavigatorKey,
        builder: (context, state, child) => DriverShellScreen(child: child),
        routes: [
          GoRoute(
            path: '/driver/dashboard',
            name: 'driver-dashboard',
            builder: (context, state) => const DriverDashboardScreen(),
          ),
          GoRoute(
            path: '/driver/trips',
            name: 'driver-trips',
            builder: (context, state) => const DriverTripsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                name: 'driver-trip-detail',
                builder: (context, state) => DriverTripDetailScreen(
                  tripId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isOnboardingDone = onboardingCompleted;
      final location = state.matchedLocation;

      if (location == '/splash') return null;

      if (!isOnboardingDone && location != '/onboarding') {
        return '/onboarding';
      }

      if (!isLoggedIn) {
        if (location.startsWith('/auth')) return null;
        return '/auth/login';
      }

      if (location == '/auth/login' || location == '/auth/register') {
        return '/home';
      }

      if (location == '/') return '/home';

      return null;
    },
  );
});
