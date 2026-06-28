import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

enum NotificationType { booking, trip, payment, system, promotion }

@freezed
class AppNotification with _$AppNotification {
  const factory AppNotification({
    required int id,
    required String title,
    required String message,
    @Default(NotificationType.system) NotificationType type,
    @Default(false) bool isRead,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}
