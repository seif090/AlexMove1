import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<AppException, List<AppNotification>>> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    bool? unreadOnly,
  });

  Future<Either<AppException, int>> getUnreadCount();

  Future<Either<AppException, void>> markAsRead(int notificationId);

  Future<Either<AppException, void>> markAllAsRead();

  Future<Either<AppException, void>> deleteNotification(int notificationId);
}
