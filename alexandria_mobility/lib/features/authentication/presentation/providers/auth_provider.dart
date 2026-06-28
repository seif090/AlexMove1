import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../../../core/storage/local_storage_service.dart';

final authStateProvider = StreamProvider<User?>((ref) async* {
  final repository = ref.watch(authRepositoryProvider);
  final isLoggedInResult = await repository.isLoggedIn();
  final isLoggedIn = isLoggedInResult.getOrElse(() => false);

  if (!isLoggedIn) {
    yield null;
    return;
  }

  final userResult = await repository.getCurrentUser();
  yield userResult.fold((_) => null, (user) => user);

  yield* Stream.periodic(const Duration(seconds: 30), (_) async* {
    final result = await repository.getCurrentUser();
    yield result.fold((_) => null, (user) => user);
  }).asyncExpand((stream) => stream);
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    final repository = _ref.read(authRepositoryProvider);
    final isLoggedInResult = await repository.isLoggedIn();
    final isLoggedIn = isLoggedInResult.getOrElse(() => false);

    if (!isLoggedIn) {
      state = const AsyncValue.data(null);
      return;
    }

    final userResult = await repository.getCurrentUser();
    state = userResult.fold(
      (l) => const AsyncValue.data(null),
      (user) => AsyncValue.data(user),
    );
  }

  Future<bool> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final result = await repository.login(LoginRequest(
      email: email,
      password: password,
      rememberMe: rememberMe,
    ));

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (response) {
        state = AsyncValue.data(response.user);
        return true;
      },
    );
  }

  Future<bool> register({
    required String fullName,
    required String email,
    String? phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final result = await repository.register(RegisterRequest(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      confirmPassword: confirmPassword,
    ));

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final result = await repository.verifyOtp(OtpRequest(
      email: email,
      otp: otp,
    ));

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<void> resendOtp(String email) async {
    final repository = _ref.read(authRepositoryProvider);
    await repository.resendOtp(email);
  }

  Future<bool> forgotPassword(String email) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final result = await repository.forgotPassword(email);

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final result = await repository.resetPassword(ResetPasswordRequest(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    ));

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        return true;
      },
    );
  }

  Future<void> logout() async {
    final repository = _ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(null);
  }

  void resetLoading() {
    state = const AsyncValue.data(null);
  }
}

final onboardingCompletedProvider = Provider<bool>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.isOnboardingCompleted();
});

final rememberMeProvider = StateProvider<bool>((ref) => false);

final savedEmailProvider = Provider<String>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return storage.get('saved_email', defaultValue: '') as String;
});
