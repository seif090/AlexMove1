import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/booking.dart';
import '../models/booking_models.dart';

abstract class BookingRemoteDataSource {
  Future<PaginatedResponse<Booking>> getMyBookings({
    int pageNumber = 1,
    int pageSize = 20,
    String? status,
  });

  Future<Booking> createBooking(CreateBookingRequest request);

  Future<void> cancelBooking(CancelBookingRequest request);

  Future<Booking> getBookingDetails(int bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final Dio _dio;

  BookingRemoteDataSourceImpl(this._dio);

  @override
  Future<PaginatedResponse<Booking>> getMyBookings({
    int pageNumber = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
    };
    if (status != null) queryParams['status'] = status;

    final response = await _dio.get(
      '/bookings/my',
      queryParameters: queryParams,
    );

    final data = response.data['data'];
    return PaginatedResponse(
      items: (data['items'] as List)
          .map((item) => Booking.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCount: data['totalCount'] as int,
      pageNumber: data['pageNumber'] as int,
      totalPages: data['totalPages'] as int,
      hasPreviousPage: data['hasPreviousPage'] as bool,
      hasNextPage: data['hasNextPage'] as bool,
    );
  }

  @override
  Future<Booking> createBooking(CreateBookingRequest request) async {
    final response = await _dio.post(
      '/bookings',
      data: request.toJson(),
    );
    return Booking.fromJson(response.data['data']);
  }

  @override
  Future<void> cancelBooking(CancelBookingRequest request) async {
    await _dio.post(
      '/bookings/${request.bookingId}/cancel',
      data: request.reason != null ? {'reason': request.reason} : null,
    );
  }

  @override
  Future<Booking> getBookingDetails(int bookingId) async {
    final response = await _dio.get('/bookings/$bookingId');
    return Booking.fromJson(response.data['data']);
  }
}

final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingRemoteDataSourceImpl(dio);
});
