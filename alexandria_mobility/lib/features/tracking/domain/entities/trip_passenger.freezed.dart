// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_passenger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TripPassenger _$TripPassengerFromJson(Map<String, dynamic> json) {
  return _TripPassenger.fromJson(json);
}

/// @nodoc
mixin _$TripPassenger {
  int get userId => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get pickupLocation => throw _privateConstructorUsedError;
  bool get isPickedUp => throw _privateConstructorUsedError;
  DateTime? get pickupTime => throw _privateConstructorUsedError;

  /// Serializes this TripPassenger to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripPassengerCopyWith<TripPassenger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripPassengerCopyWith<$Res> {
  factory $TripPassengerCopyWith(
    TripPassenger value,
    $Res Function(TripPassenger) then,
  ) = _$TripPassengerCopyWithImpl<$Res, TripPassenger>;
  @useResult
  $Res call({
    int userId,
    String userName,
    String pickupLocation,
    bool isPickedUp,
    DateTime? pickupTime,
  });
}

/// @nodoc
class _$TripPassengerCopyWithImpl<$Res, $Val extends TripPassenger>
    implements $TripPassengerCopyWith<$Res> {
  _$TripPassengerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? pickupLocation = null,
    Object? isPickedUp = null,
    Object? pickupTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as int,
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            pickupLocation: null == pickupLocation
                ? _value.pickupLocation
                : pickupLocation // ignore: cast_nullable_to_non_nullable
                      as String,
            isPickedUp: null == isPickedUp
                ? _value.isPickedUp
                : isPickedUp // ignore: cast_nullable_to_non_nullable
                      as bool,
            pickupTime: freezed == pickupTime
                ? _value.pickupTime
                : pickupTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripPassengerImplCopyWith<$Res>
    implements $TripPassengerCopyWith<$Res> {
  factory _$$TripPassengerImplCopyWith(
    _$TripPassengerImpl value,
    $Res Function(_$TripPassengerImpl) then,
  ) = __$$TripPassengerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int userId,
    String userName,
    String pickupLocation,
    bool isPickedUp,
    DateTime? pickupTime,
  });
}

/// @nodoc
class __$$TripPassengerImplCopyWithImpl<$Res>
    extends _$TripPassengerCopyWithImpl<$Res, _$TripPassengerImpl>
    implements _$$TripPassengerImplCopyWith<$Res> {
  __$$TripPassengerImplCopyWithImpl(
    _$TripPassengerImpl _value,
    $Res Function(_$TripPassengerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? userName = null,
    Object? pickupLocation = null,
    Object? isPickedUp = null,
    Object? pickupTime = freezed,
  }) {
    return _then(
      _$TripPassengerImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as int,
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        pickupLocation: null == pickupLocation
            ? _value.pickupLocation
            : pickupLocation // ignore: cast_nullable_to_non_nullable
                  as String,
        isPickedUp: null == isPickedUp
            ? _value.isPickedUp
            : isPickedUp // ignore: cast_nullable_to_non_nullable
                  as bool,
        pickupTime: freezed == pickupTime
            ? _value.pickupTime
            : pickupTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripPassengerImpl implements _TripPassenger {
  const _$TripPassengerImpl({
    required this.userId,
    required this.userName,
    required this.pickupLocation,
    this.isPickedUp = false,
    this.pickupTime,
  });

  factory _$TripPassengerImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripPassengerImplFromJson(json);

  @override
  final int userId;
  @override
  final String userName;
  @override
  final String pickupLocation;
  @override
  @JsonKey()
  final bool isPickedUp;
  @override
  final DateTime? pickupTime;

  @override
  String toString() {
    return 'TripPassenger(userId: $userId, userName: $userName, pickupLocation: $pickupLocation, isPickedUp: $isPickedUp, pickupTime: $pickupTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripPassengerImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.pickupLocation, pickupLocation) ||
                other.pickupLocation == pickupLocation) &&
            (identical(other.isPickedUp, isPickedUp) ||
                other.isPickedUp == isPickedUp) &&
            (identical(other.pickupTime, pickupTime) ||
                other.pickupTime == pickupTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    userName,
    pickupLocation,
    isPickedUp,
    pickupTime,
  );

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripPassengerImplCopyWith<_$TripPassengerImpl> get copyWith =>
      __$$TripPassengerImplCopyWithImpl<_$TripPassengerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripPassengerImplToJson(this);
  }
}

abstract class _TripPassenger implements TripPassenger {
  const factory _TripPassenger({
    required final int userId,
    required final String userName,
    required final String pickupLocation,
    final bool isPickedUp,
    final DateTime? pickupTime,
  }) = _$TripPassengerImpl;

  factory _TripPassenger.fromJson(Map<String, dynamic> json) =
      _$TripPassengerImpl.fromJson;

  @override
  int get userId;
  @override
  String get userName;
  @override
  String get pickupLocation;
  @override
  bool get isPickedUp;
  @override
  DateTime? get pickupTime;

  /// Create a copy of TripPassenger
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripPassengerImplCopyWith<_$TripPassengerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
