import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../entities/user.dart';
import '../../data/models/auth_models.dart';

abstract class AuthRepository {
  Future<Either<AppException, LoginResponse>> login(LoginRequest request);

  Future<Either<AppException, User>> register(RegisterRequest request);

  Future<Either<AppException, void>> verifyOtp(OtpRequest request);

  Future<Either<AppException, void>> resendOtp(String email);

  Future<Either<AppException, void>> forgotPassword(String email);

  Future<Either<AppException, void>> resetPassword(ResetPasswordRequest request);

  Future<Either<AppException, User>> getCurrentUser();

  Future<Either<AppException, void>> logout();

  Future<Either<AppException, bool>> isLoggedIn();

  Future<Either<AppException, User>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? profileImageUrl,
  });
}
