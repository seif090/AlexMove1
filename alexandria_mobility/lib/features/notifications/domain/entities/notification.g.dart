// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppNotificationImpl _$$AppNotificationImplFromJson(
  Map<String, dynamic> json,
) => _$AppNotificationImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  message: json['message'] as String,
  type:
      $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']) ??
      NotificationType.system,
  isRead: json['isRead'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$AppNotificationImplToJson(
  _$AppNotificationImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'message': instance.message,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'isRead': instance.isRead,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$NotificationTypeEnumMap = {
  NotificationType.booking: 'booking',
  NotificationType.trip: 'trip',
  NotificationType.payment: 'payment',
  NotificationType.system: 'system',
  NotificationType.promotion: 'promotion',
};
