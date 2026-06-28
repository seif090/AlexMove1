import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/group.dart';

abstract class GroupRepository {
  Future<Either<AppException, PaginatedResponse<Group>>> getGroups({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? status,
  });

  Future<Either<AppException, Group>> getGroup(int id);

  Future<Either<AppException, PaginatedResponse<Group>>> getMyGroups({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<Either<AppException, PaginatedResponse<Group>>> searchGroups({
    required String query,
    int pageNumber = 1,
    int pageSize = 20,
  });
}
