import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/notification.dart';
import '../../data/repositories/notification_repository_impl.dart';

final unreadCountProvider = FutureProvider.autoDispose<AsyncValue<int>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final result = await repository.getUnreadCount();

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final notificationsProvider =
    FutureProvider.autoDispose<AsyncValue<List<AppNotification>>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final result = await repository.getNotifications();

  return result.fold(
    (error) => AsyncValue.error(error, StackTrace.current),
    (data) => AsyncValue.data(data),
  );
});

final markAsReadProvider =
    StateNotifierProvider<MarkAsReadNotifier, AsyncValue<void>>((ref) {
  return MarkAsReadNotifier(ref);
});

class MarkAsReadNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  MarkAsReadNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> markAsRead(int notificationId) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(notificationRepositoryProvider);

    final result = await repository.markAsRead(notificationId);

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(notificationsProvider);
        _ref.invalidate(unreadCountProvider);
        return true;
      },
    );
  }
}

final markAllAsReadProvider =
    StateNotifierProvider<MarkAllAsReadNotifier, AsyncValue<void>>((ref) {
  return MarkAllAsReadNotifier(ref);
});

class MarkAllAsReadNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  MarkAllAsReadNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> markAllAsRead() async {
    state = const AsyncValue.loading();
    final repository = _ref.read(notificationRepositoryProvider);

    final result = await repository.markAllAsRead();

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(notificationsProvider);
        _ref.invalidate(unreadCountProvider);
        return true;
      },
    );
  }
}

final deleteNotificationProvider =
    StateNotifierProvider<DeleteNotificationNotifier, AsyncValue<void>>((ref) {
  return DeleteNotificationNotifier(ref);
});

class DeleteNotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  DeleteNotificationNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<bool> deleteNotification(int notificationId) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(notificationRepositoryProvider);

    final result = await repository.deleteNotification(notificationId);

    return result.fold(
      (exception) {
        state = AsyncValue.error(exception, StackTrace.current);
        return false;
      },
      (_) {
        state = const AsyncValue.data(null);
        _ref.invalidate(notificationsProvider);
        _ref.invalidate(unreadCountProvider);
        return true;
      },
    );
  }
}
