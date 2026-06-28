// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_stop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TripStop _$TripStopFromJson(Map<String, dynamic> json) {
  return _TripStop.fromJson(json);
}

/// @nodoc
mixin _$TripStop {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  bool get isVisited => throw _privateConstructorUsedError;
  DateTime? get estimatedArrival => throw _privateConstructorUsedError;
  DateTime? get actualArrival => throw _privateConstructorUsedError;

  /// Serializes this TripStop to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripStopCopyWith<TripStop> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripStopCopyWith<$Res> {
  factory $TripStopCopyWith(TripStop value, $Res Function(TripStop) then) =
      _$TripStopCopyWithImpl<$Res, TripStop>;
  @useResult
  $Res call({
    int id,
    String name,
    double latitude,
    double longitude,
    int order,
    bool isVisited,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
  });
}

/// @nodoc
class _$TripStopCopyWithImpl<$Res, $Val extends TripStop>
    implements $TripStopCopyWith<$Res> {
  _$TripStopCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? order = null,
    Object? isVisited = null,
    Object? estimatedArrival = freezed,
    Object? actualArrival = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            isVisited: null == isVisited
                ? _value.isVisited
                : isVisited // ignore: cast_nullable_to_non_nullable
                      as bool,
            estimatedArrival: freezed == estimatedArrival
                ? _value.estimatedArrival
                : estimatedArrival // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            actualArrival: freezed == actualArrival
                ? _value.actualArrival
                : actualArrival // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripStopImplCopyWith<$Res>
    implements $TripStopCopyWith<$Res> {
  factory _$$TripStopImplCopyWith(
    _$TripStopImpl value,
    $Res Function(_$TripStopImpl) then,
  ) = __$$TripStopImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    double latitude,
    double longitude,
    int order,
    bool isVisited,
    DateTime? estimatedArrival,
    DateTime? actualArrival,
  });
}

/// @nodoc
class __$$TripStopImplCopyWithImpl<$Res>
    extends _$TripStopCopyWithImpl<$Res, _$TripStopImpl>
    implements _$$TripStopImplCopyWith<$Res> {
  __$$TripStopImplCopyWithImpl(
    _$TripStopImpl _value,
    $Res Function(_$TripStopImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? order = null,
    Object? isVisited = null,
    Object? estimatedArrival = freezed,
    Object? actualArrival = freezed,
  }) {
    return _then(
      _$TripStopImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        isVisited: null == isVisited
            ? _value.isVisited
            : isVisited // ignore: cast_nullable_to_non_nullable
                  as bool,
        estimatedArrival: freezed == estimatedArrival
            ? _value.estimatedArrival
            : estimatedArrival // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        actualArrival: freezed == actualArrival
            ? _value.actualArrival
            : actualArrival // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripStopImpl implements _TripStop {
  const _$TripStopImpl({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.order,
    this.isVisited = false,
    this.estimatedArrival,
    this.actualArrival,
  });

  factory _$TripStopImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripStopImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int order;
  @override
  @JsonKey()
  final bool isVisited;
  @override
  final DateTime? estimatedArrival;
  @override
  final DateTime? actualArrival;

  @override
  String toString() {
    return 'TripStop(id: $id, name: $name, latitude: $latitude, longitude: $longitude, order: $order, isVisited: $isVisited, estimatedArrival: $estimatedArrival, actualArrival: $actualArrival)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripStopImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.isVisited, isVisited) ||
                other.isVisited == isVisited) &&
            (identical(other.estimatedArrival, estimatedArrival) ||
                other.estimatedArrival == estimatedArrival) &&
            (identical(other.actualArrival, actualArrival) ||
                other.actualArrival == actualArrival));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    latitude,
    longitude,
    order,
    isVisited,
    estimatedArrival,
    actualArrival,
  );

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripStopImplCopyWith<_$TripStopImpl> get copyWith =>
      __$$TripStopImplCopyWithImpl<_$TripStopImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripStopImplToJson(this);
  }
}

abstract class _TripStop implements TripStop {
  const factory _TripStop({
    required final int id,
    required final String name,
    required final double latitude,
    required final double longitude,
    required final int order,
    final bool isVisited,
    final DateTime? estimatedArrival,
    final DateTime? actualArrival,
  }) = _$TripStopImpl;

  factory _TripStop.fromJson(Map<String, dynamic> json) =
      _$TripStopImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int get order;
  @override
  bool get isVisited;
  @override
  DateTime? get estimatedArrival;
  @override
  DateTime? get actualArrival;

  /// Create a copy of TripStop
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripStopImplCopyWith<_$TripStopImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
