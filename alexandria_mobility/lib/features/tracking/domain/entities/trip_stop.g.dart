// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_stop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripStopImpl _$$TripStopImplFromJson(Map<String, dynamic> json) =>
    _$TripStopImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      order: (json['order'] as num).toInt(),
      isVisited: json['isVisited'] as bool? ?? false,
      estimatedArrival: json['estimatedArrival'] == null
          ? null
          : DateTime.parse(json['estimatedArrival'] as String),
      actualArrival: json['actualArrival'] == null
          ? null
          : DateTime.parse(json['actualArrival'] as String),
    );

Map<String, dynamic> _$$TripStopImplToJson(_$TripStopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'order': instance.order,
      'isVisited': instance.isVisited,
      'estimatedArrival': instance.estimatedArrival?.toIso8601String(),
      'actualArrival': instance.actualArrival?.toIso8601String(),
    };
