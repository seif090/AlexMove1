import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
class Booking with _$Booking {
  const factory Booking({
    required int id,
    required int userId,
    String? userName,
    required int groupId,
    required String groupName,
    required String bookingDate,
    required String status,
    required String paymentStatus,
    String? pickupLocation,
    String? dropoffLocation,
    int? seats,
    double? totalAmount,
    DateTime? createdAt,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}
