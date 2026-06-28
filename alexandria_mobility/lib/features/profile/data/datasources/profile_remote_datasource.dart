import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile> getProfile();

  Future<UserProfile> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
  });

  Future<void> updateProfileImage(String filePath);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio _dio;

  ProfileRemoteDataSourceImpl(this._dio);

  @override
  Future<UserProfile> getProfile() async {
    final response = await _dio.get('/profile');
    return UserProfile.fromJson(response.data['data']);
  }

  @override
  Future<UserProfile> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (address != null) data['address'] = address;

    final response = await _dio.put('/profile', data: data);
    return UserProfile.fromJson(response.data['data']);
  }

  @override
  Future<void> updateProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    await _dio.post('/profile/image', data: formData);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post('/profile/change-password', data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  @override
  Future<void> deleteAccount() async {
    await _dio.delete('/profile');
  }
}

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRemoteDataSourceImpl(dio);
});
