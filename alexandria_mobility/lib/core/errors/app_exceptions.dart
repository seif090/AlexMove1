import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable implements Exception {
  final String? message;
  final int? statusCode;

  const AppException({this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ConnectionTimeoutException extends AppException {
  const ConnectionTimeoutException({String? message})
      : super(message: message ?? 'Connection timed out. Please try again.');
}

class NoInternetException extends AppException {
  const NoInternetException({String? message})
      : super(message: message ?? 'No internet connection. Please check your network.');
}

class ServerException extends AppException {
  const ServerException({String? message, super.statusCode})
      : super(message: message ?? 'Server error. Please try again later.');
}

class BadRequestException extends AppException {
  const BadRequestException({String? message})
      : super(message: message ?? 'Bad request. Please check your input.');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({String? message})
      : super(message: message ?? 'Session expired. Please login again.');
}

class ForbiddenException extends AppException {
  const ForbiddenException({String? message})
      : super(message: message ?? 'You do not have permission to perform this action.');
}

class NotFoundException extends AppException {
  const NotFoundException({String? message})
      : super(message: message ?? 'Resource not found.');
}

class ValidationException extends AppException {
  const ValidationException({String? message})
      : super(message: message ?? 'Validation failed. Please check your input.');
}

class TooManyRequestsException extends AppException {
  const TooManyRequestsException({String? message})
      : super(message: message ?? 'Too many requests. Please try again later.');
}

class RequestCancelledException extends AppException {
  const RequestCancelledException({String? message})
      : super(message: message ?? 'Request was cancelled.');
}

class CacheException extends AppException {
  const CacheException({String? message})
      : super(message: message ?? 'Cache error.');
}
