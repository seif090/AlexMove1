// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Booking _$BookingFromJson(Map<String, dynamic> json) {
  return _Booking.fromJson(json);
}

/// @nodoc
mixin _$Booking {
  int get id => throw _privateConstructorUsedError;
  int get userId => throw _privateConstructorUsedError;
  String? get userName => throw _privateConstructorUsedError;
  int get groupId => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String get bookingDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get paymentStatus => throw _privateConstructorUsedError;
  String? get pickupLocation => throw _privateConstructorUsedError;
  String? get dropoffLocation => throw _privateConstructorUsedError;
  int? get seats => throw _privateConstructorUsedError;
  double? get totalAmount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingCopyWith<Booking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingCopyWith<$Res> {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) then) =
      _$BookingCopyWithImpl<$Res, Booking>;
  @useResult
  $Res call({
    int id,
    int userId,
    String? userName,
    int groupId,
    String groupName,
    String bookingDate,
    String status,
    String paymentStatus,
    String? pickupLocation,
    String? dropoffLocation,
    int? seats,
    double? totalAmount,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$BookingCopyWithImpl<$Res, $Val extends Booking>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = freezed,
    Object? groupId = null,
    Object? groupName = null,
    Object? bookingDate = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? pickupLocation = freezed,
    Object? dropoffLocation = freezed,
    Object? seats = freezed,
    Object? totalAmount = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            userName: freezed == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as int,
            groupName: null == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String,
            bookingDate: null == bookingDate
                ? _value.bookingDate
                : bookingDate // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            paymentStatus: null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLocation: freezed == pickupLocation
                ? _value.pickupLocation
                : pickupLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            dropoffLocation: freezed == dropoffLocation
                ? _value.dropoffLocation
                : dropoffLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            seats: freezed == seats
                ? _value.seats
                : seats // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalAmount: freezed == totalAmount
                ? _value.totalAmount
                : totalAmount // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingImplCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$$BookingImplCopyWith(
    _$BookingImpl value,
    $Res Function(_$BookingImpl) then,
  ) = __$$BookingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    int userId,
    String? userName,
    int groupId,
    String groupName,
    String bookingDate,
    String status,
    String paymentStatus,
    String? pickupLocation,
    String? dropoffLocation,
    int? seats,
    double? totalAmount,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$BookingImplCopyWithImpl<$Res>
    extends _$BookingCopyWithImpl<$Res, _$BookingImpl>
    implements _$$BookingImplCopyWith<$Res> {
  __$$BookingImplCopyWithImpl(
    _$BookingImpl _value,
    $Res Function(_$BookingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? userName = freezed,
    Object? groupId = null,
    Object? groupName = null,
    Object? bookingDate = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? pickupLocation = freezed,
    Object? dropoffLocation = freezed,
    Object? seats = freezed,
    Object? totalAmount = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$BookingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        userName: freezed == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as int,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        bookingDate: null == bookingDate
            ? _value.bookingDate
            : bookingDate // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        paymentStatus: null == paymentStatus
            ? _value.paymentStatus
            : paymentStatus // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLocation: freezed == pickupLocation
            ? _value.pickupLocation
            : pickupLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        dropoffLocation: freezed == dropoffLocation
            ? _value.dropoffLocation
            : dropoffLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        seats: freezed == seats
            ? _value.seats
            : seats // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalAmount: freezed == totalAmount
            ? _value.totalAmount
            : totalAmount // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingImpl implements _Booking {
  const _$BookingImpl({
    required this.id,
    required this.userId,
    this.userName,
    required this.groupId,
    required this.groupName,
    required this.bookingDate,
    required this.status,
    required this.paymentStatus,
    this.pickupLocation,
    this.dropoffLocation,
    this.seats,
    this.totalAmount,
    this.createdAt,
  });

  factory _$BookingImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingImplFromJson(json);

  @override
  final int id;
  @override
  final int userId;
  @override
  final String? userName;
  @override
  final int groupId;
  @override
  final String groupName;
  @override
  final String bookingDate;
  @override
  final String status;
  @override
  final String paymentStatus;
  @override
  final String? pickupLocation;
  @override
  final String? dropoffLocation;
  @override
  final int? seats;
  @override
  final double? totalAmount;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, userName: $userName, groupId: $groupId, groupName: $groupName, bookingDate: $bookingDate, status: $status, paymentStatus: $paymentStatus, pickupLocation: $pickupLocation, dropoffLocation: $dropoffLocation, seats: $seats, totalAmount: $totalAmount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.bookingDate, bookingDate) ||
                other.bookingDate == bookingDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.dropoffLocation, dropoffLocation) ||
                other.dropoffLocation == dropoffLocation) &&
            (identical(other.seats, seats) || other.seats == seats) &&
            (identical(other.totalAmount, totalAmount) ||
                other.totalAmount == totalAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    userName,
    groupId,
    groupName,
    bookingDate,
    status,
    paymentStatus,
    pickupLocation,
    dropoffLocation,
    seats,
    totalAmount,
    createdAt,
  );

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      __$$BookingImplCopyWithImpl<_$BookingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingImplToJson(this);
  }
}

abstract class _Booking implements Booking {
  const factory _Booking({
    required final int id,
    required final int userId,
    final String? userName,
    required final int groupId,
    required final String groupName,
    required final String bookingDate,
    required final String status,
    required final String paymentStatus,
    final String? pickupLocation,
    final String? dropoffLocation,
    final int? seats,
    final double? totalAmount,
    final DateTime? createdAt,
  }) = _$BookingImpl;

  factory _Booking.fromJson(Map<String, dynamic> json) = _$BookingImpl.fromJson;

  @override
  int get id;
  @override
  int get userId;
  @override
  String? get userName;
  @override
  int get groupId;
  @override
  String get groupName;
  @override
  String get bookingDate;
  @override
  String get status;
  @override
  String get paymentStatus;
  @override
  String? get pickupLocation;
  @override
  String? get dropoffLocation;
  @override
  int? get seats;
  @override
  double? get totalAmount;
  @override
  DateTime? get createdAt;

  /// Create a copy of Booking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingImplCopyWith<_$BookingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
