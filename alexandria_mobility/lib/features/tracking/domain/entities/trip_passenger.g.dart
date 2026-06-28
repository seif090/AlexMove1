// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_passenger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TripPassengerImpl _$$TripPassengerImplFromJson(Map<String, dynamic> json) =>
    _$TripPassengerImpl(
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String,
      pickupLocation: json['pickupLocation'] as String,
      isPickedUp: json['isPickedUp'] as bool? ?? false,
      pickupTime: json['pickupTime'] == null
          ? null
          : DateTime.parse(json['pickupTime'] as String),
    );

Map<String, dynamic> _$$TripPassengerImplToJson(_$TripPassengerImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'pickupLocation': instance.pickupLocation,
      'isPickedUp': instance.isPickedUp,
      'pickupTime': instance.pickupTime?.toIso8601String(),
    };
