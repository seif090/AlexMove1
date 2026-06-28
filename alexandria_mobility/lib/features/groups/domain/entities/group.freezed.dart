// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get routeName => throw _privateConstructorUsedError;
  String? get communityName => throw _privateConstructorUsedError;
  String? get driverName => throw _privateConstructorUsedError;
  String? get vehiclePlate => throw _privateConstructorUsedError;
  String get departureTime => throw _privateConstructorUsedError;
  String get returnTime => throw _privateConstructorUsedError;
  int get capacity => throw _privateConstructorUsedError;
  int get availableSeats => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isSubscribed => throw _privateConstructorUsedError;
  String? get frequency => throw _privateConstructorUsedError;
  List<String> get workingDays => throw _privateConstructorUsedError;

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call({
    int id,
    String name,
    String routeName,
    String? communityName,
    String? driverName,
    String? vehiclePlate,
    String departureTime,
    String returnTime,
    int capacity,
    int availableSeats,
    double price,
    String status,
    bool isSubscribed,
    String? frequency,
    List<String> workingDays,
  });
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? routeName = null,
    Object? communityName = freezed,
    Object? driverName = freezed,
    Object? vehiclePlate = freezed,
    Object? departureTime = null,
    Object? returnTime = null,
    Object? capacity = null,
    Object? availableSeats = null,
    Object? price = null,
    Object? status = null,
    Object? isSubscribed = null,
    Object? frequency = freezed,
    Object? workingDays = null,
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
            routeName: null == routeName
                ? _value.routeName
                : routeName // ignore: cast_nullable_to_non_nullable
                      as String,
            communityName: freezed == communityName
                ? _value.communityName
                : communityName // ignore: cast_nullable_to_non_nullable
                      as String?,
            driverName: freezed == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehiclePlate: freezed == vehiclePlate
                ? _value.vehiclePlate
                : vehiclePlate // ignore: cast_nullable_to_non_nullable
                      as String?,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as String,
            returnTime: null == returnTime
                ? _value.returnTime
                : returnTime // ignore: cast_nullable_to_non_nullable
                      as String,
            capacity: null == capacity
                ? _value.capacity
                : capacity // ignore: cast_nullable_to_non_nullable
                      as int,
            availableSeats: null == availableSeats
                ? _value.availableSeats
                : availableSeats // ignore: cast_nullable_to_non_nullable
                      as int,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            isSubscribed: null == isSubscribed
                ? _value.isSubscribed
                : isSubscribed // ignore: cast_nullable_to_non_nullable
                      as bool,
            frequency: freezed == frequency
                ? _value.frequency
                : frequency // ignore: cast_nullable_to_non_nullable
                      as String?,
            workingDays: null == workingDays
                ? _value.workingDays
                : workingDays // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
    _$GroupImpl value,
    $Res Function(_$GroupImpl) then,
  ) = __$$GroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    String routeName,
    String? communityName,
    String? driverName,
    String? vehiclePlate,
    String departureTime,
    String returnTime,
    int capacity,
    int availableSeats,
    double price,
    String status,
    bool isSubscribed,
    String? frequency,
    List<String> workingDays,
  });
}

/// @nodoc
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
    _$GroupImpl _value,
    $Res Function(_$GroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? routeName = null,
    Object? communityName = freezed,
    Object? driverName = freezed,
    Object? vehiclePlate = freezed,
    Object? departureTime = null,
    Object? returnTime = null,
    Object? capacity = null,
    Object? availableSeats = null,
    Object? price = null,
    Object? status = null,
    Object? isSubscribed = null,
    Object? frequency = freezed,
    Object? workingDays = null,
  }) {
    return _then(
      _$GroupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        routeName: null == routeName
            ? _value.routeName
            : routeName // ignore: cast_nullable_to_non_nullable
                  as String,
        communityName: freezed == communityName
            ? _value.communityName
            : communityName // ignore: cast_nullable_to_non_nullable
                  as String?,
        driverName: freezed == driverName
            ? _value.driverName
            : driverName // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehiclePlate: freezed == vehiclePlate
            ? _value.vehiclePlate
            : vehiclePlate // ignore: cast_nullable_to_non_nullable
                  as String?,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as String,
        returnTime: null == returnTime
            ? _value.returnTime
            : returnTime // ignore: cast_nullable_to_non_nullable
                  as String,
        capacity: null == capacity
            ? _value.capacity
            : capacity // ignore: cast_nullable_to_non_nullable
                  as int,
        availableSeats: null == availableSeats
            ? _value.availableSeats
            : availableSeats // ignore: cast_nullable_to_non_nullable
                  as int,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        isSubscribed: null == isSubscribed
            ? _value.isSubscribed
            : isSubscribed // ignore: cast_nullable_to_non_nullable
                  as bool,
        frequency: freezed == frequency
            ? _value.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String?,
        workingDays: null == workingDays
            ? _value._workingDays
            : workingDays // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupImpl implements _Group {
  const _$GroupImpl({
    required this.id,
    required this.name,
    required this.routeName,
    this.communityName,
    this.driverName,
    this.vehiclePlate,
    required this.departureTime,
    required this.returnTime,
    required this.capacity,
    this.availableSeats = 0,
    required this.price,
    required this.status,
    this.isSubscribed = false,
    this.frequency,
    final List<String> workingDays = const [],
  }) : _workingDays = workingDays;

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  final String routeName;
  @override
  final String? communityName;
  @override
  final String? driverName;
  @override
  final String? vehiclePlate;
  @override
  final String departureTime;
  @override
  final String returnTime;
  @override
  final int capacity;
  @override
  @JsonKey()
  final int availableSeats;
  @override
  final double price;
  @override
  final String status;
  @override
  @JsonKey()
  final bool isSubscribed;
  @override
  final String? frequency;
  final List<String> _workingDays;
  @override
  @JsonKey()
  List<String> get workingDays {
    if (_workingDays is EqualUnmodifiableListView) return _workingDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workingDays);
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name, routeName: $routeName, communityName: $communityName, driverName: $driverName, vehiclePlate: $vehiclePlate, departureTime: $departureTime, returnTime: $returnTime, capacity: $capacity, availableSeats: $availableSeats, price: $price, status: $status, isSubscribed: $isSubscribed, frequency: $frequency, workingDays: $workingDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.routeName, routeName) ||
                other.routeName == routeName) &&
            (identical(other.communityName, communityName) ||
                other.communityName == communityName) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.vehiclePlate, vehiclePlate) ||
                other.vehiclePlate == vehiclePlate) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.returnTime, returnTime) ||
                other.returnTime == returnTime) &&
            (identical(other.capacity, capacity) ||
                other.capacity == capacity) &&
            (identical(other.availableSeats, availableSeats) ||
                other.availableSeats == availableSeats) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isSubscribed, isSubscribed) ||
                other.isSubscribed == isSubscribed) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            const DeepCollectionEquality().equals(
              other._workingDays,
              _workingDays,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    routeName,
    communityName,
    driverName,
    vehiclePlate,
    departureTime,
    returnTime,
    capacity,
    availableSeats,
    price,
    status,
    isSubscribed,
    frequency,
    const DeepCollectionEquality().hash(_workingDays),
  );

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(this);
  }
}

abstract class _Group implements Group {
  const factory _Group({
    required final int id,
    required final String name,
    required final String routeName,
    final String? communityName,
    final String? driverName,
    final String? vehiclePlate,
    required final String departureTime,
    required final String returnTime,
    required final int capacity,
    final int availableSeats,
    required final double price,
    required final String status,
    final bool isSubscribed,
    final String? frequency,
    final List<String> workingDays,
  }) = _$GroupImpl;

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  String get routeName;
  @override
  String? get communityName;
  @override
  String? get driverName;
  @override
  String? get vehiclePlate;
  @override
  String get departureTime;
  @override
  String get returnTime;
  @override
  int get capacity;
  @override
  int get availableSeats;
  @override
  double get price;
  @override
  String get status;
  @override
  bool get isSubscribed;
  @override
  String? get frequency;
  @override
  List<String> get workingDays;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
