import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_models.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource _remoteDataSource;

  BookingRepositoryImpl({required this._remoteDataSource});

  @override
  Future<Either<AppException, PaginatedResponse<Booking>>> getMyBookings({
    int pageNumber = 1,
    int pageSize = 20,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.getMyBookings(
        pageNumber: pageNumber,
        pageSize: pageSize,
        status: status,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, Booking>> createBooking({
    required int groupId,
    required String bookingDate,
    String? pickupLocation,
    String? dropoffLocation,
    int seats = 1,
  }) async {
    try {
      final result = await _remoteDataSource.createBooking(
        CreateBookingRequest(
          groupId: groupId,
          bookingDate: bookingDate,
          pickupLocation: pickupLocation,
          dropoffLocation: dropoffLocation,
          seats: seats,
        ),
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> cancelBooking({
    required int bookingId,
    String? reason,
  }) async {
    try {
      await _remoteDataSource.cancelBooking(
        CancelBookingRequest(bookingId: bookingId, reason: reason),
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, Booking>> getBookingDetails(int bookingId) async {
    try {
      final result = await _remoteDataSource.getBookingDetails(bookingId);
      return Right(result);
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

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final remoteDataSource = ref.watch(bookingRemoteDataSourceProvider);
  return BookingRepositoryImpl(remoteDataSource: remoteDataSource);
});
