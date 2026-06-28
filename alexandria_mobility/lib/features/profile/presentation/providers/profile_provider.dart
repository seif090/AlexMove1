import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../data/repositories/profile_repository_impl.dart';

final profileProvider = FutureProvider.autoDispose<AsyncValue<UserProfile>>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  final result = await repository.getProfile();

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final updateProfileProvider =
    StateNotifierProvider<UpdateProfileNotifier, AsyncValue<UserProfile?>>(
        (ref) {
  return UpdateProfileNotifier(ref);
});

class UpdateProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final Ref _ref;

  UpdateProfileNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
  }) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(profileRepositoryProvider);

    final result = await repository.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
      address: address,
    );

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (profile) {
        state = AsyncValue.data(profile);
        _ref.invalidate(profileProvider);
        return true;
      },
    );
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

final updateProfileImageProvider =
    StateNotifierProvider<UpdateProfileImageNotifier, AsyncValue<void>>((ref) {
  return UpdateProfileImageNotifier(ref);
});

class UpdateProfileImageNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  UpdateProfileImageNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> updateImage(String filePath) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(profileRepositoryProvider);

    final result = await repository.updateProfileImage(filePath);

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(profileProvider);
        return true;
      },
    );
  }
}
