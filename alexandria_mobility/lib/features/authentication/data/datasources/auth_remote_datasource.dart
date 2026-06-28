import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../models/auth_models.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequest request);

  Future<User> register(RegisterRequest request);

  Future<void> verifyOtp(OtpRequest request);

  Future<void> resendOtp(String email);

  Future<void> forgotPassword(String email);

  Future<void> resetPassword(ResetPasswordRequest request);

  Future<User> getCurrentUser();

  Future<User> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/auth/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data['data']);
  }

  @override
  Future<User> register(RegisterRequest request) async {
    final response = await _dio.post(
      '/auth/register',
      data: request.toJson(),
    );
    return User.fromJson(response.data['data']);
  }

  @override
  Future<void> verifyOtp(OtpRequest request) async {
    await _dio.post(
      '/auth/verify-otp',
      data: request.toJson(),
    );
  }

  @override
  Future<void> resendOtp(String email) async {
    await _dio.post(
      '/auth/resend-otp',
      data: {'email': email},
    );
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _dio.post(
      '/auth/forgot-password',
      data: {'email': email},
    );
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _dio.post(
      '/auth/reset-password',
      data: request.toJson(),
    );
  }

  @override
  Future<User> getCurrentUser() async {
    final response = await _dio.get('/auth/me');
    return User.fromJson(response.data['data']);
  }

  @override
  Future<User> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (profileImageUrl != null) data['profileImageUrl'] = profileImageUrl;

    final response = await _dio.put(
      '/auth/profile',
      data: data,
    );
    return User.fromJson(response.data['data']);
  }
}

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
});
