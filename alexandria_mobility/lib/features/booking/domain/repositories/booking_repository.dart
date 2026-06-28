import 'package:dartz/dartz.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/api_response.dart';
import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Either<AppException, PaginatedResponse<Booking>>> getMyBookings({
    int pageNumber = 1,
    int pageSize = 20,
    String? status,
  });

  Future<Either<AppException, Booking>> createBooking({
    required int groupId,
    required String bookingDate,
    String? pickupLocation,
    String? dropoffLocation,
    int seats = 1,
  });

  Future<Either<AppException, void>> cancelBooking({
    required int bookingId,
    String? reason,
  });

  Future<Either<AppException, Booking>> getBookingDetails(int bookingId);
}
