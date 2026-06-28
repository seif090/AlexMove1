import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../storage/local_storage_service.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  final dio = Dio();

  dio.options = BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: AppConstants.connectTimeout,
    receiveTimeout: AppConstants.apiTimeout,
    sendTimeout: AppConstants.apiTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  dio.interceptors.addAll([
    AuthInterceptor(storage: storage),
    ErrorInterceptor(),
    AppLoggingInterceptor(),
  ]);

  return dio;
});
