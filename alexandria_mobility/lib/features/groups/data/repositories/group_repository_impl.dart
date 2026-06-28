import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_datasource.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource _remoteDataSource;

  GroupRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<AppException, PaginatedResponse<Group>>> getGroups({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? status,
  }) async {
    try {
      final result = await _remoteDataSource.getGroups(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
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
  Future<Either<AppException, Group>> getGroup(int id) async {
    try {
      final result = await _remoteDataSource.getGroup(id);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerException(message: e.toString()));
    }
  }

  @override
  Future<Either<AppException, PaginatedResponse<Group>>> getMyGroups({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await _remoteDataSource.getMyGroups(
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

  @override
  Future<Either<AppException, PaginatedResponse<Group>>> searchGroups({
    required String query,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    try {
      final result = await _remoteDataSource.searchGroups(
        query: query,
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

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final remoteDataSource = ref.watch(groupRemoteDataSourceProvider);
  return GroupRepositoryImpl(remoteDataSource);
});
