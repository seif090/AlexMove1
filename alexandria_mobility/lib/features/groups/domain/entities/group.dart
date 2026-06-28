import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  const factory Group({
    required int id,
    required String name,
    required String routeName,
    String? communityName,
    String? driverName,
    String? vehiclePlate,
    required String departureTime,
    required String returnTime,
    required int capacity,
    @Default(0) int availableSeats,
    required double price,
    required String status,
    @Default(false) bool isSubscribed,
    String? frequency,
    @Default([]) List<String> workingDays,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
