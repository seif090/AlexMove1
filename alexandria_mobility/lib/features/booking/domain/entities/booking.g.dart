// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      userName: json['userName'] as String?,
      groupId: (json['groupId'] as num).toInt(),
      groupName: json['groupName'] as String,
      bookingDate: json['bookingDate'] as String,
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      pickupLocation: json['pickupLocation'] as String?,
      dropoffLocation: json['dropoffLocation'] as String?,
      seats: (json['seats'] as num?)?.toInt(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'bookingDate': instance.bookingDate,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'pickupLocation': instance.pickupLocation,
      'dropoffLocation': instance.dropoffLocation,
      'seats': instance.seats,
      'totalAmount': instance.totalAmount,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
