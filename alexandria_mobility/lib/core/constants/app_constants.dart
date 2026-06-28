class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'http://10.0.2.2:5063/api';
  static const String signalRUrl = 'http://10.0.2.2:5063/hubs';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // Storage Keys
  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'current_user';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';
  static const String onboardingKey = 'onboarding_completed';
  static const String fcmTokenKey = 'fcm_token';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Map Defaults
  static const double defaultLatitude = 31.2001;
  static const double defaultLongitude = 29.9187;
  static const double defaultZoom = 13.0;
  static const double markerZoom = 16.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
}
