import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ REQUEST: ${options.method} ${options.uri}');
      if (options.data != null) {
        debugPrint('│ BODY: ${options.data}');
      }
      debugPrint('└──────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      debugPrint('└──────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌──────────────────────────────────────────');
      debugPrint('│ ERROR: ${err.type} ${err.message}');
      debugPrint('│ URI: ${err.requestOptions.uri}');
      debugPrint('└──────────────────────────────────────────');
    }
    handler.next(err);
  }
}
