import 'package:freezed_annotation/freezed_annotation.dart';
import 'trip_stop.dart';
import 'trip_passenger.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

enum TripStatus { scheduled, inProgress, completed }

@freezed
class Trip with _$Trip {
  const factory Trip({
    required int id,
    required String groupName,
    required String routeName,
    required String driverName,
    required String driverPhone,
    required String vehiclePlate,
    @Default(TripStatus.scheduled) TripStatus status,
    required DateTime departureTime,
    DateTime? arrivalTime,
    double? currentLatitude,
    double? currentLongitude,
    @Default([]) List<TripStop> routeStops,
    @Default([]) List<TripPassenger> passengers,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
