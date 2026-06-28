import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl({required this._remoteDataSource});

  @override
  Future<Either<AppException, List<AppNotification>>> getNotifications({
    int pageNumber = 1,
    int pageSize = 20,
    bool? unreadOnly,
  }) async {
    try {
      final result = await _remoteDataSource.getNotifications(
        pageNumber: pageNumber,
        pageSize: pageSize,
        unreadOnly: unreadOnly,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, int>> getUnreadCount() async {
    try {
      final result = await _remoteDataSource.getUnreadCount();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> markAsRead(int notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> deleteNotification(int notificationId) async {
    try {
      await _remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  AppException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionTimeoutException();
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] as String?;
        switch (statusCode) {
          case 400:
            return BadRequestException(message: message);
          case 401:
            return UnauthorizedException(message: message);
          case 403:
            return ForbiddenException(message: message);
          case 404:
            return NotFoundException(message: message);
          case 422:
            return ValidationException(message: message);
          case 429:
            return const TooManyRequestsException();
          default:
            return ServerException(message: message, statusCode: statusCode);
        }
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      default:
        return ServerException(message: e.message);
    }
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource: remoteDataSource);
});
