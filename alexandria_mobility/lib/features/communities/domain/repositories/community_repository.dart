import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../domain/entities/community.dart';

abstract class CommunityRepository {
  Future<Either<AppException, PaginatedResponse<Community>>> getCommunities({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? type,
  });

  Future<Either<AppException, Community>> getCommunity(int id);

  Future<Either<AppException, void>> joinCommunity(int communityId);

  Future<Either<AppException, PaginatedResponse<Community>>> getMyCommunities({
    int pageNumber = 1,
    int pageSize = 20,
  });
}
