import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/community.dart';
import '../models/community_models.dart';

abstract class CommunityRemoteDataSource {
  Future<PaginatedResponse<Community>> getCommunities({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? type,
  });

  Future<Community> getCommunity(int id);

  Future<void> joinCommunity(int communityId);

  Future<PaginatedResponse<Community>> getMyCommunities({
    int pageNumber = 1,
    int pageSize = 20,
  });
}

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final Dio _dio;

  CommunityRemoteDataSourceImpl(this._dio);

  @override
  Future<PaginatedResponse<Community>> getCommunities({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? type,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (type != null && type.isNotEmpty) queryParams['type'] = type;

    final response = await _dio.get('/communities', queryParameters: queryParams);
    final communityResponse = CommunityResponse.fromJson(response.data);
    if (communityResponse.data == null) {
      throw ServerException(message: communityResponse.message ?? 'No data');
    }
    return communityResponse.data!;
  }

  @override
  Future<Community> getCommunity(int id) async {
    final response = await _dio.get('/communities/$id');
    return Community.fromJson(response.data['data']);
  }

  @override
  Future<void> joinCommunity(int communityId) async {
    await _dio.post('/communities/$communityId/join');
  }

  @override
  Future<PaginatedResponse<Community>> getMyCommunities({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      '/communities/my',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    final communityResponse = CommunityResponse.fromJson(response.data);
    if (communityResponse.data == null) {
      throw ServerException(message: communityResponse.message ?? 'No data');
    }
    return communityResponse.data!;
  }
}

final communityRemoteDataSourceProvider =
    Provider<CommunityRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return CommunityRemoteDataSourceImpl(dio);
});
