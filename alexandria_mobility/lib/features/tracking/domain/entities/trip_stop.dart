import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_stop.freezed.dart';
part 'trip_stop.g.dart';

@freezed
class TripStop with _$TripStop {
  const factory TripStop({
    required int id,
    required String name,
    required double latitude,
    required double longitude,
    required int order,
    @Default(false) bool isVisited,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
  }) = _TripStop;

  factory TripStop.fromJson(Map<String, dynamic> json) =>
      _$TripStopFromJson(json);
}
