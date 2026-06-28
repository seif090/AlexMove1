import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

class LocalStorageService {
  static Box? _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('alexandria_mobility');
  }

  Box get box {
    assert(_box != null, 'LocalStorageService not initialized. Call init() first.');
    return _box!;
  }

  // Tokens
  String? getAccessToken() => box.get(AppConstants.tokenKey);
  String? getRefreshToken() => box.get(AppConstants.refreshTokenKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await box.put(AppConstants.tokenKey, accessToken);
    await box.put(AppConstants.refreshTokenKey, refreshToken);
  }

  Future<void> clearTokens() async {
    await box.delete(AppConstants.tokenKey);
    await box.delete(AppConstants.refreshTokenKey);
  }

  // User
  String? getUserJson() => box.get(AppConstants.userKey);
  Future<void> saveUserJson(String json) async => box.put(AppConstants.userKey, json);

  // Language
  String getLanguage() => box.get(AppConstants.languageKey, defaultValue: 'en');
  Future<void> saveLanguage(String lang) async => box.put(AppConstants.languageKey, lang);

  // Theme
  bool isDarkMode() => box.get(AppConstants.themeKey, defaultValue: false);
  Future<void> saveTheme(bool isDark) async => box.put(AppConstants.themeKey, isDark);

  // Onboarding
  bool isOnboardingCompleted() => box.get(AppConstants.onboardingKey, defaultValue: false);
  Future<void> completeOnboarding() async => box.put(AppConstants.onboardingKey, true);

  // FCM Token
  String? getFcmToken() => box.get(AppConstants.fcmTokenKey);
  Future<void> saveFcmToken(String token) async => box.put(AppConstants.fcmTokenKey, token);

  // Generic
  Future<void> save(String key, dynamic value) async => box.put(key, value);
  dynamic get(String key, {dynamic defaultValue}) => box.get(key, defaultValue: defaultValue);
  Future<void> delete(String key) async => box.delete(key);

  // Clear
  Future<void> clearAll() async => box.clear();
}
