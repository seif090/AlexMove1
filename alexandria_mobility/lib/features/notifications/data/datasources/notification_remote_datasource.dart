import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/notification.dart';

abstract class NotificationRemoteDataSource {
  Future<List<AppNotification>> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    bool? unreadOnly,
  });

  Future<int> getUnreadCount();

  Future<void> markAsRead(int notificationId);

  Future<void> markAllAsRead();

  Future<void> deleteNotification(int notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<AppNotification>> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    bool? unreadOnly,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    if (unreadOnly != null) queryParams['unreadOnly'] = unreadOnly;

    final response = await _dio.get(
      '/notifications',
      queryParameters: queryParams,
    );
    return (response.data['data']['items'] as List)
        .map((item) => AppNotification.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dio.get('/notifications/unread-count');
    return response.data['data'] as int;
  }

  @override
  Future<void> markAsRead(int notificationId) async {
    await _dio.post('/notifications/$notificationId/read');
  }

  @override
  Future<void> markAllAsRead() async {
    await _dio.post('/notifications/read-all');
  }

  @override
  Future<void> deleteNotification(int notificationId) async {
    await _dio.delete('/notifications/$notificationId');
  }
}

final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRemoteDataSourceImpl(dio);
});
