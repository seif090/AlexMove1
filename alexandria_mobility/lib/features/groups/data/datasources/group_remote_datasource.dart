import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/group.dart';
import '../models/group_models.dart';

abstract class GroupRemoteDataSource {
  Future<PaginatedResponse<Group>> getGroups({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? status,
  });

  Future<Group> getGroup(int id);

  Future<PaginatedResponse<Group>> getMyGroups({
    int pageNumber = 1,
    int pageSize = 20,
  });

  Future<PaginatedResponse<Group>> searchGroups({
    required String query,
    int pageNumber = 1,
    int pageSize = 20,
  });
}

class GroupRemoteDataSourceImpl implements GroupRemoteDataSource {
  final Dio _dio;

  GroupRemoteDataSourceImpl(this._dio);

  @override
  Future<PaginatedResponse<Group>> getGroups({
    int pageNumber = 1,
    int pageSize = 20,
    String? search,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;

    final response = await _dio.get('/groups', queryParameters: queryParams);
    final groupResponse = GroupResponse.fromJson(response.data);
    if (groupResponse.data == null) {
      throw ServerException(message: groupResponse.message ?? 'No data');
    }
    return groupResponse.data!;
  }

  @override
  Future<Group> getGroup(int id) async {
    final response = await _dio.get('/groups/$id');
    return Group.fromJson(response.data['data']);
  }

  @override
  Future<PaginatedResponse<Group>> getMyGroups({
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      '/groups/my',
      queryParameters: {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    final groupResponse = GroupResponse.fromJson(response.data);
    if (groupResponse.data == null) {
      throw ServerException(message: groupResponse.message ?? 'No data');
    }
    return groupResponse.data!;
  }

  @override
  Future<PaginatedResponse<Group>> searchGroups({
    required String query,
    int pageNumber = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get(
      '/groups/search',
      queryParameters: {
        'query': query,
        'pageNumber': pageNumber,
        'pageSize': pageSize,
      },
    );
    final groupResponse = GroupResponse.fromJson(response.data);
    if (groupResponse.data == null) {
      throw ServerException(message: groupResponse.message ?? 'No data');
    }
    return groupResponse.data!;
  }
}

final groupRemoteDataSourceProvider = Provider<GroupRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return GroupRemoteDataSourceImpl(dio);
});
