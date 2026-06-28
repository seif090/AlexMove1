import 'dart:convert';

// ignore_for_file: prefer_initializing_formals
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorageService _storage;

  AuthRepositoryImpl({
    required this._remoteDataSource,
    required LocalStorageService storage,
  })  : _storage = storage;


  @override
  Future<Either<AppException, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _remoteDataSource.login(request);
      await _storage.saveTokens(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
      );
      await _storage.saveUserJson(jsonEncode(response.user.toJson()));
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, User>> register(RegisterRequest request) async {
    try {
      final user = await _remoteDataSource.register(request);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> verifyOtp(OtpRequest request) async {
    try {
      await _remoteDataSource.verifyOtp(request);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> resendOtp(String email) async {
    try {
      await _remoteDataSource.resendOtp(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> resetPassword(
      ResetPasswordRequest request) async {
    try {
      await _remoteDataSource.resetPassword(request);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, User>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      await _storage.saveUserJson(jsonEncode(user.toJson()));
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> logout() async {
    try {
      await _storage.clearTokens();
      await _storage.delete(AppConstants.userKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, bool>> isLoggedIn() async {
    try {
      final token = _storage.getAccessToken();
      final userJson = _storage.getUserJson();
      return Right(token != null && token.isNotEmpty && userJson != null);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<AppException, User>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final user = await _remoteDataSource.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );
      await _storage.saveUserJson(jsonEncode(user.toJson()));
      return Right(user);
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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(localStorageServiceProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    storage: storage,
  );
});
