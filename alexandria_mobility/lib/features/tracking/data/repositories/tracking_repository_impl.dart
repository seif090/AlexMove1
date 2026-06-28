import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_datasource.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource _remoteDataSource;

  TrackingRepositoryImpl({required this._remoteDataSource});

  @override
  Future<Either<AppException, Trip>> getTripDetails(int tripId) async {
    try {
      final result = await _remoteDataSource.getTripDetails(tripId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, List<Trip>>> getActiveTrips() async {
    try {
      final result = await _remoteDataSource.getActiveTrips();
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, Trip>> getTripByGroupId(int groupId) async {
    try {
      final result = await _remoteDataSource.getTripByGroupId(groupId);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> updateDriverLocation({
    required int tripId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _remoteDataSource.updateDriverLocation(
        tripId: tripId,
        latitude: latitude,
        longitude: longitude,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> markStopVisited({
    required int tripId,
    required int stopId,
  }) async {
    try {
      await _remoteDataSource.markStopVisited(tripId: tripId, stopId: stopId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> pickupPassenger({
    required int tripId,
    required int userId,
  }) async {
    try {
      await _remoteDataSource.pickupPassenger(tripId: tripId, userId: userId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Stream<Trip> watchTripLocation(int tripId) async* {
    while (true) {
      try {
        final trip = await _remoteDataSource.getTripDetails(tripId);
        yield trip;
        await Future.delayed(const Duration(seconds: 5));
      } catch (_) {
        await Future.delayed(const Duration(seconds: 10));
      }
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

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  final remoteDataSource = ref.watch(trackingRemoteDataSourceProvider);
  return TrackingRepositoryImpl(remoteDataSource: remoteDataSource);
});
