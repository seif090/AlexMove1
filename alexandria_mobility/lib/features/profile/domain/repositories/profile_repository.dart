import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Either<AppException, UserProfile>> getProfile();

  Future<Either<AppException, UserProfile>> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? address,
  });

  Future<Either<AppException, void>> updateProfileImage(String filePath);

  Future<Either<AppException, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Either<AppException, void>> deleteAccount();
}
