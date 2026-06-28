import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    required int groupId,
    required String bookingDate,
    String? pickupLocation,
    String? dropoffLocation,
    @Default(1) int seats,
  }) = _CreateBookingRequest;

  factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);
}

@freezed
class CancelBookingRequest with _$CancelBookingRequest {
  const factory CancelBookingRequest({
    required int bookingId,
    String? reason,
  }) = _CancelBookingRequest;

  factory CancelBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingRequestFromJson(json);
}

@freezed
class BookingResponse with _$BookingResponse {
  const factory BookingResponse({
    required bool isSuccess,
    String? message,
    dynamic data,
  }) = _BookingResponse;

  factory BookingResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingResponseFromJson(json);
}
