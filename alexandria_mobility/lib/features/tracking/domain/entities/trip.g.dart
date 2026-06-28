// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripImpl _$$TripImplFromJson(Map<String, dynamic> json) => _$TripImpl(
  id: (json['id'] as num).toInt(),
  groupName: json['groupName'] as String,
  routeName: json['routeName'] as String,
  driverName: json['driverName'] as String,
  driverPhone: json['driverPhone'] as String,
  vehiclePlate: json['vehiclePlate'] as String,
  status:
      $enumDecodeNullable(_$TripStatusEnumMap, json['status']) ??
      TripStatus.scheduled,
  departureTime: DateTime.parse(json['departureTime'] as String),
  arrivalTime: json['arrivalTime'] == null
      ? null
      : DateTime.parse(json['arrivalTime'] as String),
  currentLatitude: (json['currentLatitude'] as num?)?.toDouble(),
  currentLongitude: (json['currentLongitude'] as num?)?.toDouble(),
  routeStops:
      (json['routeStops'] as List<dynamic>?)
          ?.map((e) => TripStop.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  passengers:
      (json['passengers'] as List<dynamic>?)
          ?.map((e) => TripPassenger.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$TripImplToJson(_$TripImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupName': instance.groupName,
      'routeName': instance.routeName,
      'driverName': instance.driverName,
      'driverPhone': instance.driverPhone,
      'vehiclePlate': instance.vehiclePlate,
      'status': _$TripStatusEnumMap[instance.status]!,
      'departureTime': instance.departureTime.toIso8601String(),
      'arrivalTime': instance.arrivalTime?.toIso8601String(),
      'currentLatitude': instance.currentLatitude,
      'currentLongitude': instance.currentLongitude,
      'routeStops': instance.routeStops,
      'passengers': instance.passengers,
    };

const _$TripStatusEnumMap = {
  TripStatus.scheduled: 'scheduled',
  TripStatus.inProgress: 'inProgress',
  TripStatus.completed: 'completed',
};
