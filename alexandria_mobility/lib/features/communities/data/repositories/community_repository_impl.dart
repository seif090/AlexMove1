import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/community.dart';
import '../../domain/repositories/community_repository.dart';
import '../datasources/community_remote_datasource.dart';

class CommunityRepositoryImpl implements CommunityRepository {
  final CommunityRemoteDataSource _remoteDataSource;

  CommunityRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, PaginatedResponse<Community>>> getCommunities({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? type,
  }) async {
    try {
      final result = await _remoteDataSource.getCommunities(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
        type: type,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, Community>> getCommunity(int id) async {
    try {
      final result = await _remoteDataSource.getCommunity(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> joinCommunity(int communityId) async {
    try {
      await _remoteDataSource.joinCommunity(communityId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, PaginatedResponse<Community>>> getMyCommunities({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getMyCommunities(
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
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

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final remoteDataSource = ref.watch(communityRemoteDataSourceProvider);
  return CommunityRepositoryImpl(remoteDataSource);
});
