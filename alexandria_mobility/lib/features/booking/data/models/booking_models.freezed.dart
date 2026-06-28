// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CreateBookingRequest _$CreateBookingRequestFromJson(Map<String, dynamic> json) {
  return _CreateBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateBookingRequest {
  int get groupId => throw _privateConstructorUsedError;
  String get bookingDate => throw _privateConstructorUsedError;
  String? get pickupLocation => throw _privateConstructorUsedError;
  String? get dropoffLocation => throw _privateConstructorUsedError;
  int get seats => throw _privateConstructorUsedError;

  /// Serializes this CreateBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateBookingRequestCopyWith<CreateBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateBookingRequestCopyWith<$Res> {
  factory $CreateBookingRequestCopyWith(
    CreateBookingRequest value,
    $Res Function(CreateBookingRequest) then,
  ) = _$CreateBookingRequestCopyWithImpl<$Res, CreateBookingRequest>;
  @useResult
  $Res call({
    int groupId,
    String bookingDate,
    String? pickupLocation,
    String? dropoffLocation,
    int seats,
  });
}

/// @nodoc
class _$CreateBookingRequestCopyWithImpl<
  $Res,
  $Val extends CreateBookingRequest
>
    implements $CreateBookingRequestCopyWith<$Res> {
  _$CreateBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? bookingDate = null,
    Object? pickupLocation = freezed,
    Object? dropoffLocation = freezed,
    Object? seats = null,
  }) {
    return _then(
      _value.copyWith(
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as int,
            bookingDate: null == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLocation: freezed == pickupLocation
                ? _value.pickupLocation
                : pickupLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            dropoffLocation: freezed == dropoffLocation
                ? _value.dropoffLocation
                : dropoffLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            seats: null == seats
                ? _value.seats
                : seats // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateBookingRequestImplCopyWith<$Res>
    implements $CreateBookingRequestCopyWith<$Res> {
  factory _$$CreateBookingRequestImplCopyWith(
    _$CreateBookingRequestImpl value,
    $Res Function(_$CreateBookingRequestImpl) then,
  ) = __$$CreateBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int groupId,
    String bookingDate,
    String? pickupLocation,
    String? dropoffLocation,
    int seats,
  });
}

/// @nodoc
class __$$CreateBookingRequestImplCopyWithImpl<$Res>
    extends _$CreateBookingRequestCopyWithImpl<$Res, _$CreateBookingRequestImpl>
    implements _$$CreateBookingRequestImplCopyWith<$Res> {
  __$$CreateBookingRequestImplCopyWithImpl(
    _$CreateBookingRequestImpl _value,
    $Res Function(_$CreateBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? bookingDate = null,
    Object? pickupLocation = freezed,
    Object? dropoffLocation = freezed,
    Object? seats = null,
  }) {
    return _then(
      _$CreateBookingRequestImpl(
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as int,
        bookingDate: null == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLocation: freezed == pickupLocation
            ? _value.pickupLocation
            : pickupLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        dropoffLocation: freezed == dropoffLocation
            ? _value.dropoffLocation
            : dropoffLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        seats: null == seats
            ? _value.seats
            : seats // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateBookingRequestImpl implements _CreateBookingRequest {
  const _$CreateBookingRequestImpl({
    required this.groupId,
    required this.bookingDate,
    this.pickupLocation,
    this.dropoffLocation,
    this.seats = 1,
  });

  factory _$CreateBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateBookingRequestImplFromJson(json);

  @override
  final int groupId;
  @override
  final String bookingDate;
  @override
  final String? pickupLocation;
  @override
  final String? dropoffLocation;
  @override
  @JsonKey()
  final int seats;

  @override
  String toString() {
    return 'CreateBookingRequest(groupId: $groupId, bookingDate: $bookingDate, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, seats: $seats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateBookingRequestImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.dropoffLocation, dropoffLocation) ||
                other.dropoffLocation == dropoffLocation) &&
            (identical(other.seats, seats) || other.seats == seats));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    groupId,
    bookingDate,
    pickupLocation,
    dropoffLocation,
    seats,
  );

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
  get copyWith =>
      __$$CreateBookingRequestImplCopyWithImpl<_$CreateBookingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateBookingRequestImplToJson(this);
  }
}

abstract class _CreateBookingRequest implements CreateBookingRequest {
  const factory _CreateBookingRequest({
    required final int groupId,
    required final String bookingDate,
    final String? pickupLocation,
    final String? dropoffLocation,
    final int seats,
  }) = _$CreateBookingRequestImpl;

  factory _CreateBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CreateBookingRequestImpl.fromJson;

  @override
  int get groupId;
  @override
  String get bookingDate;
  @override
  String? get pickupLocation;
  @override
  String? get dropoffLocation;
  @override
  int get seats;

  /// Create a copy of CreateBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateBookingRequestImplCopyWith<_$CreateBookingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CancelBookingRequest _$CancelBookingRequestFromJson(Map<String, dynamic> json) {
  return _CancelBookingRequest.fromJson(json);
}

/// @nodoc
mixin _$CancelBookingRequest {
  int get bookingId => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this CancelBookingRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CancelBookingRequestCopyWith<CancelBookingRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CancelBookingRequestCopyWith<$Res> {
  factory $CancelBookingRequestCopyWith(
    CancelBookingRequest value,
    $Res Function(CancelBookingRequest) then,
  ) = _$CancelBookingRequestCopyWithImpl<$Res, CancelBookingRequest>;
  @useResult
  $Res call({int bookingId, String? reason});
}

/// @nodoc
class _$CancelBookingRequestCopyWithImpl<
  $Res,
  $Val extends CancelBookingRequest
>
    implements $CancelBookingRequestCopyWith<$Res> {
  _$CancelBookingRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookingId = null, Object? reason = freezed}) {
    return _then(
      _value.copyWith(
            bookingId: null == bookingId
                ? _value.bookingId
                : bookingId // ignore: cast_nullable_to_non_nullable
                      as int,
            reason: freezed == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CancelBookingRequestImplCopyWith<$Res>
    implements $CancelBookingRequestCopyWith<$Res> {
  factory _$$CancelBookingRequestImplCopyWith(
    _$CancelBookingRequestImpl value,
    $Res Function(_$CancelBookingRequestImpl) then,
  ) = __$$CancelBookingRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int bookingId, String? reason});
}

/// @nodoc
class __$$CancelBookingRequestImplCopyWithImpl<$Res>
    extends _$CancelBookingRequestCopyWithImpl<$Res, _$CancelBookingRequestImpl>
    implements _$$CancelBookingRequestImplCopyWith<$Res> {
  __$$CancelBookingRequestImplCopyWithImpl(
    _$CancelBookingRequestImpl _value,
    $Res Function(_$CancelBookingRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? bookingId = null, Object? reason = freezed}) {
    return _then(
      _$CancelBookingRequestImpl(
        bookingId: null == bookingId
            ? _value.bookingId
            : bookingId // ignore: cast_nullable_to_non_nullable
                  as int,
        reason: freezed == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CancelBookingRequestImpl implements _CancelBookingRequest {
  const _$CancelBookingRequestImpl({required this.bookingId, this.reason});

  factory _$CancelBookingRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CancelBookingRequestImplFromJson(json);

  @override
  final int bookingId;
  @override
  final String? reason;

  @override
  String toString() {
    return 'CancelBookingRequest(bookingId: $bookingId, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CancelBookingRequestImpl &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookingId, reason);

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CancelBookingRequestImplCopyWith<_$CancelBookingRequestImpl>
  get copyWith =>
      __$$CancelBookingRequestImplCopyWithImpl<_$CancelBookingRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CancelBookingRequestImplToJson(this);
  }
}

abstract class _CancelBookingRequest implements CancelBookingRequest {
  const factory _CancelBookingRequest({
    required final int bookingId,
    final String? reason,
  }) = _$CancelBookingRequestImpl;

  factory _CancelBookingRequest.fromJson(Map<String, dynamic> json) =
      _$CancelBookingRequestImpl.fromJson;

  @override
  int get bookingId;
  @override
  String? get reason;

  /// Create a copy of CancelBookingRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CancelBookingRequestImplCopyWith<_$CancelBookingRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

BookingResponse _$BookingResponseFromJson(Map<String, dynamic> json) {
  return _BookingResponse.fromJson(json);
}

/// @nodoc
mixin _$BookingResponse {
  bool get isSuccess => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;
  dynamic get data => throw _privateConstructorUsedError;

  /// Serializes this BookingResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingResponseCopyWith<BookingResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingResponseCopyWith<$Res> {
  factory $BookingResponseCopyWith(
    BookingResponse value,
    $Res Function(BookingResponse) then,
  ) = _$BookingResponseCopyWithImpl<$Res, BookingResponse>;
  @useResult
  $Res call({bool isSuccess, String? message, dynamic data});
}

/// @nodoc
class _$BookingResponseCopyWithImpl<$Res, $Val extends BookingResponse>
    implements $BookingResponseCopyWith<$Res> {
  _$BookingResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _value.copyWith(
            isSuccess: null == isSuccess
                ? _value.isSuccess
                : isSuccess // ignore: cast_nullable_to_non_nullable
                      as bool,
            message: freezed == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String?,
            data: freezed == data
                ? _value.data
                : data // ignore: cast_nullable_to_non_nullable
                      as dynamic,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingResponseImplCopyWith<$Res>
    implements $BookingResponseCopyWith<$Res> {
  factory _$$BookingResponseImplCopyWith(
    _$BookingResponseImpl value,
    $Res Function(_$BookingResponseImpl) then,
  ) = __$$BookingResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSuccess, String? message, dynamic data});
}

/// @nodoc
class __$$BookingResponseImplCopyWithImpl<$Res>
    extends _$BookingResponseCopyWithImpl<$Res, _$BookingResponseImpl>
    implements _$$BookingResponseImplCopyWith<$Res> {
  __$$BookingResponseImplCopyWithImpl(
    _$BookingResponseImpl _value,
    $Res Function(_$BookingResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSuccess = null,
    Object? message = freezed,
    Object? data = freezed,
  }) {
    return _then(
      _$BookingResponseImpl(
        isSuccess: null == isSuccess
            ? _value.isSuccess
            : isSuccess // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: freezed == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String?,
        data: freezed == data
            ? _value.data
            : data // ignore: cast_nullable_to_non_nullable
                  as dynamic,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingResponseImpl implements _BookingResponse {
  const _$BookingResponseImpl({
    required this.isSuccess,
    this.message,
    this.data,
  });

  factory _$BookingResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingResponseImplFromJson(json);

  @override
  final bool isSuccess;
  @override
  final String? message;
  @override
  final dynamic data;

  @override
  String toString() {
    return 'BookingResponse(isSuccess: $isSuccess, message: $message, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingResponseImpl &&
            (identical(other.isSuccess, isSuccess) ||
                other.isSuccess == isSuccess) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.data, data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    isSuccess,
    message,
    const DeepCollectionEquality().hash(data),
  );

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingResponseImplCopyWith<_$BookingResponseImpl> get copyWith =>
      __$$BookingResponseImplCopyWithImpl<_$BookingResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingResponseImplToJson(this);
  }
}

abstract class _BookingResponse implements BookingResponse {
  const factory _BookingResponse({
    required final bool isSuccess,
    final String? message,
    final dynamic data,
  }) = _$BookingResponseImpl;

  factory _BookingResponse.fromJson(Map<String, dynamic> json) =
      _$BookingResponseImpl.fromJson;

  @override
  bool get isSuccess;
  @override
  String? get message;
  @override
  dynamic get data;

  /// Create a copy of BookingResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingResponseImplCopyWith<_$BookingResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
