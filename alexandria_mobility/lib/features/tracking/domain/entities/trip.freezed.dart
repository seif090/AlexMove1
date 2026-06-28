// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Trip _$TripFromJson(Map<String, dynamic> json) {
  return _Trip.fromJson(json);
}

/// @nodoc
mixin _$Trip {
  int get id => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  String get routeName => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  String get driverPhone => throw _privateConstructorUsedError;
  String get vehiclePlate => throw _privateConstructorUsedError;
  TripStatus get status => throw _privateConstructorUsedError;
  DateTime get departureTime => throw _privateConstructorUsedError;
  DateTime? get arrivalTime => throw _privateConstructorUsedError;
  double? get currentLatitude => throw _privateConstructorUsedError;
  double? get currentLongitude => throw _privateConstructorUsedError;
  List<TripStop> get routeStops => throw _privateConstructorUsedError;
  List<TripPassenger> get passengers => throw _privateConstructorUsedError;

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TripCopyWith<Trip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TripCopyWith<$Res> {
  factory $TripCopyWith(Trip value, $Res Function(Trip) then) =
      _$TripCopyWithImpl<$Res, Trip>;
  @useResult
  $Res call({
    int id,
    String groupName,
    String routeName,
    String driverName,
    String driverPhone,
    String vehiclePlate,
    TripStatus status,
    DateTime departureTime,
    DateTime? arrivalTime,
    double? currentLatitude,
    double? currentLongitude,
    List<TripStop> routeStops,
    List<TripPassenger> passengers,
  });
}

/// @nodoc
class _$TripCopyWithImpl<$Res, $Val extends Trip>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupName = null,
    Object? routeName = null,
    Object? driverName = null,
    Object? driverPhone = null,
    Object? vehiclePlate = null,
    Object? status = null,
    Object? departureTime = null,
    Object? arrivalTime = freezed,
    Object? currentLatitude = freezed,
    Object? currentLongitude = freezed,
    Object? routeStops = null,
    Object? passengers = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            groupName: null == groupName
                ? _value.groupName
                : groupName // ignore: cast_nullable_to_non_nullable
                      as String,
            routeName: null == routeName
                ? _value.routeName
                : routeName // ignore: cast_nullable_to_non_nullable
                      as String,
            driverName: null == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                      as String,
            driverPhone: null == driverPhone
                ? _value.driverPhone
                : driverPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            vehiclePlate: null == vehiclePlate
                ? _value.vehiclePlate
                : vehiclePlate // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TripStatus,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            arrivalTime: freezed == arrivalTime
                ? _value.arrivalTime
                : arrivalTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            currentLatitude: freezed == currentLatitude
                ? _value.currentLatitude
                : currentLatitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            currentLongitude: freezed == currentLongitude
                ? _value.currentLongitude
                : currentLongitude // ignore: cast_nullable_to_non_nullable
                      as double?,
            routeStops: null == routeStops
                ? _value.routeStops
                : routeStops // ignore: cast_nullable_to_non_nullable
                      as List<TripStop>,
            passengers: null == passengers
                ? _value.passengers
                : passengers // ignore: cast_nullable_to_non_nullable
                      as List<TripPassenger>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TripImplCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$$TripImplCopyWith(
    _$TripImpl value,
    $Res Function(_$TripImpl) then,
  ) = __$$TripImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String groupName,
    String routeName,
    String driverName,
    String driverPhone,
    String vehiclePlate,
    TripStatus status,
    DateTime departureTime,
    DateTime? arrivalTime,
    double? currentLatitude,
    double? currentLongitude,
    List<TripStop> routeStops,
    List<TripPassenger> passengers,
  });
}

/// @nodoc
class __$$TripImplCopyWithImpl<$Res>
    extends _$TripCopyWithImpl<$Res, _$TripImpl>
    implements _$$TripImplCopyWith<$Res> {
  __$$TripImplCopyWithImpl(_$TripImpl _value, $Res Function(_$TripImpl) _then)
    : super(_value, _then);

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupName = null,
    Object? routeName = null,
    Object? driverName = null,
    Object? driverPhone = null,
    Object? vehiclePlate = null,
    Object? status = null,
    Object? departureTime = null,
    Object? arrivalTime = freezed,
    Object? currentLatitude = freezed,
    Object? currentLongitude = freezed,
    Object? routeStops = null,
    Object? passengers = null,
  }) {
    return _then(
      _$TripImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        groupName: null == groupName
            ? _value.groupName
            : groupName // ignore: cast_nullable_to_non_nullable
                  as String,
        routeName: null == routeName
            ? _value.routeName
            : routeName // ignore: cast_nullable_to_non_nullable
                  as String,
        driverName: null == driverName
            ? _value.driverName
            : driverName // ignore: cast_nullable_to_non_nullable
                  as String,
        driverPhone: null == driverPhone
            ? _value.driverPhone
            : driverPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        vehiclePlate: null == vehiclePlate
            ? _value.vehiclePlate
            : vehiclePlate // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TripStatus,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        arrivalTime: freezed == arrivalTime
            ? _value.arrivalTime
            : arrivalTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        currentLatitude: freezed == currentLatitude
            ? _value.currentLatitude
            : currentLatitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        currentLongitude: freezed == currentLongitude
            ? _value.currentLongitude
            : currentLongitude // ignore: cast_nullable_to_non_nullable
                  as double?,
        routeStops: null == routeStops
            ? _value._routeStops
            : routeStops // ignore: cast_nullable_to_non_nullable
                  as List<TripStop>,
        passengers: null == passengers
            ? _value._passengers
            : passengers // ignore: cast_nullable_to_non_nullable
                  as List<TripPassenger>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TripImpl implements _Trip {
  const _$TripImpl({
    required this.id,
    required this.groupName,
    required this.routeName,
    required this.driverName,
    required this.driverPhone,
    required this.vehiclePlate,
    this.status = TripStatus.scheduled,
    required this.departureTime,
    this.arrivalTime,
    this.currentLatitude,
    this.currentLongitude,
    final List<TripStop> routeStops = const [],
    final List<TripPassenger> passengers = const [],
  }) : _routeStops = routeStops,
       _passengers = passengers;

  factory _$TripImpl.fromJson(Map<String, dynamic> json) =>
      _$$TripImplFromJson(json);

  @override
  final int id;
  @override
  final String groupName;
  @override
  final String routeName;
  @override
  final String driverName;
  @override
  final String driverPhone;
  @override
  final String vehiclePlate;
  @override
  @JsonKey()
  final TripStatus status;
  @override
  final DateTime departureTime;
  @override
  final DateTime? arrivalTime;
  @override
  final double? currentLatitude;
  @override
  final double? currentLongitude;
  final List<TripStop> _routeStops;
  @override
  @JsonKey()
  List<TripStop> get routeStops {
    if (_routeStops is EqualUnmodifiableListView) return _routeStops;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_routeStops);
  }

  final List<TripPassenger> _passengers;
  @override
  @JsonKey()
  List<TripPassenger> get passengers {
    if (_passengers is EqualUnmodifiableListView) return _passengers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_passengers);
  }

  @override
  String toString() {
    return 'Trip(id: $id, groupName: $groupName, routeName: $routeName, driverName: $driverName, driverPhone: $driverPhone, vehiclePlate: $vehiclePlate, status: $status, departureTime: $departureTime, arrivalTime: $arrivalTime, currentLatitude: $currentLatitude, currentLongitude: $currentLongitude, routeStops: $routeStops, passengers: $passengers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TripImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.routeName, routeName) ||
                other.routeName == routeName) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverPhone, driverPhone) ||
                other.driverPhone == driverPhone) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.arrivalTime, arrivalTime) ||
                other.arrivalTime == arrivalTime) &&
            (identical(other.currentLatitude, currentLatitude) ||
                other.currentLatitude == currentLatitude) &&
            (identical(other.currentLongitude, currentLongitude) ||
                other.currentLongitude == currentLongitude) &&
            const DeepCollectionEquality().equals(
              other._routeStops,
              _routeStops,
            ) &&
            const DeepCollectionEquality().equals(
              other._passengers,
              _passengers,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    groupName,
    routeName,
    driverName,
    driverPhone,
    vehiclePlate,
    status,
    departureTime,
    arrivalTime,
    currentLatitude,
    currentLongitude,
    const DeepCollectionEquality().hash(_routeStops),
    const DeepCollectionEquality().hash(_passengers),
  );

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      __$$TripImplCopyWithImpl<_$TripImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TripImplToJson(this);
  }
}

abstract class _Trip implements Trip {
  const factory _Trip({
    required final int id,
    required final String groupName,
    required final String routeName,
    required final String driverName,
    required final String driverPhone,
    required final String vehiclePlate,
    final TripStatus status,
    required final DateTime departureTime,
    final DateTime? arrivalTime,
    final double? currentLatitude,
    final double? currentLongitude,
    final List<TripStop> routeStops,
    final List<TripPassenger> passengers,
  }) = _$TripImpl;

  factory _Trip.fromJson(Map<String, dynamic> json) = _$TripImpl.fromJson;

  @override
  int get id;
  @override
  String get groupName;
  @override
  String get routeName;
  @override
  String get driverName;
  @override
  String get driverPhone;
  @override
  String get vehiclePlate;
  @override
  TripStatus get status;
  @override
  DateTime get departureTime;
  @override
  DateTime? get arrivalTime;
  @override
  double? get currentLatitude;
  @override
  double? get currentLongitude;
  @override
  List<TripStop> get routeStops;
  @override
  List<TripPassenger> get passengers;

  /// Create a copy of Trip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TripImplCopyWith<_$TripImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
