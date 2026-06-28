// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateBookingRequestImpl _$$CreateBookingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateBookingRequestImpl(
  groupId: (json['groupId'] as num).toInt(),
  bookingDate: json['bookingDate'] as String,
  pickupLocation: json['pickupLocation'] as String?,
  dropoffLocation: json['dropoffLocation'] as String?,
  seats: (json['seats'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$$CreateBookingRequestImplToJson(
  _$CreateBookingRequestImpl instance,
) => <String, dynamic>{
  'groupId': instance.groupId,
  'bookingDate': instance.bookingDate,
  'pickupLocation': instance.pickupLocation,
  'dropoffLocation': instance.dropoffLocation,
  'seats': instance.seats,
};

_$CancelBookingRequestImpl _$$CancelBookingRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CancelBookingRequestImpl(
  bookingId: (json['bookingId'] as num).toInt(),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$$CancelBookingRequestImplToJson(
  _$CancelBookingRequestImpl instance,
) => <String, dynamic>{
  'bookingId': instance.bookingId,
  'reason': instance.reason,
};

_$BookingResponseImpl _$$BookingResponseImplFromJson(
  Map<String, dynamic> json,
) => _$BookingResponseImpl(
  isSuccess: json['isSuccess'] as bool,
  message: json['message'] as String?,
  data: json['data'],
);

Map<String, dynamic> _$$BookingResponseImplToJson(
  _$BookingResponseImpl instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'message': instance.message,
  'data': instance.data,
};
