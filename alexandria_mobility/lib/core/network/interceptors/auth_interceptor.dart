import 'package:dio/dio.dart';
import '../../storage/local_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService storage;

  AuthInterceptor({required this.storage});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        storage.clearAll();
        handler.next(err);
        return;
      }

      try {
        final dio = Dio();
        final response = await dio.post(
          '${err.requestOptions.baseUrl}/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200) {
          final data = response.data;
          final newToken = data['data']['accessToken'];
          final newRefreshToken = data['data']['refreshToken'];

          storage.saveTokens(
            accessToken: newToken,
            refreshToken: newRefreshToken,
          );

          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);
          return;
        }
      } catch (_) {
        storage.clearAll();
      }
    }
    handler.next(err);
  }
}
