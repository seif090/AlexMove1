import 'package:dio/dio.dart';
import '../../errors/app_exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final exception = _handleError(err);
    handler.next(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: exception,
      message: exception.message,
    ));
  }

  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ConnectionTimeoutException();
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.cancel:
        return const RequestCancelledException();
      default:
        return const ServerException();
    }
  }

  AppException _handleBadResponse(Response? response) {
    if (response == null) return const ServerException();

    final statusCode = response.statusCode;
    final data = response.data;

    switch (statusCode) {
      case 400:
        final message = _extractMessage(data);
        return BadRequestException(message: message);
      case 401:
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return const NotFoundException();
      case 422:
        final message = _extractMessage(data);
        return ValidationException(message: message);
      case 429:
        return const TooManyRequestsException();
      case 500:
      case 502:
      case 503:
        return const ServerException();
      default:
        return ServerException(
          message: 'Server error: $statusCode',
        );
    }
  }

  String _extractMessage(dynamic data) {
    if (data == null) return 'An error occurred';
    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) return data['message'].toString();
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
        if (errors is Map) {
          final firstKey = errors.keys.first;
          final firstValue = errors[firstKey];
          if (firstValue is List && firstValue.isNotEmpty) {
            return firstValue.first.toString();
          }
        }
      }
    }
    return data.toString();
  }
}
