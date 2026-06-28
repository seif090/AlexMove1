import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_passenger.freezed.dart';
part 'trip_passenger.g.dart';

@freezed
class TripPassenger with _$TripPassenger {
  const factory TripPassenger({
    required int userId,
    required String userName,
    required String pickupLocation,
    @Default(false) bool isPickedUp,
    DateTime? pickupTime,
  }) = _TripPassenger;

  factory TripPassenger.fromJson(Map<String, dynamic> json) =>
      _$TripPassengerFromJson(json);
}
