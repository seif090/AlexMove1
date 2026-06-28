// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  routeName: json['routeName'] as String,
  communityName: json['communityName'] as String?,
  driverName: json['driverName'] as String?,
  vehiclePlate: json['vehiclePlate'] as String?,
  departureTime: json['departureTime'] as String,
  returnTime: json['returnTime'] as String,
  capacity: (json['capacity'] as num).toInt(),
  availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 0,
  price: (json['price'] as num).toDouble(),
  status: json['status'] as String,
  isSubscribed: json['isSubscribed'] as bool? ?? false,
  frequency: json['frequency'] as String?,
  workingDays:
      (json['workingDays'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'routeName': instance.routeName,
      'communityName': instance.communityName,
      'driverName': instance.driverName,
      'vehiclePlate': instance.vehiclePlate,
      'departureTime': instance.departureTime,
      'returnTime': instance.returnTime,
      'capacity': instance.capacity,
      'availableSeats': instance.availableSeats,
      'price': instance.price,
      'status': instance.status,
      'isSubscribed': instance.isSubscribed,
      'frequency': instance.frequency,
      'workingDays': instance.workingDays,
    };
