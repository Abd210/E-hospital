// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  String? get photoUrl => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get profile => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      UserRole role,
      String? photoUrl,
      String? phone,
      String? address,
      bool isActive,
      DateTime? lastLogin,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic>? profile,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? role = null,
    Object? photoUrl = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? isActive = null,
    Object? lastLogin = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? profile = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      String name,
      UserRole role,
      String? photoUrl,
      String? phone,
      String? address,
      bool isActive,
      DateTime? lastLogin,
      DateTime? createdAt,
      DateTime? updatedAt,
      Map<String, dynamic>? profile,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? role = null,
    Object? photoUrl = freezed,
    Object? phone = freezed,
    Object? address = freezed,
    Object? isActive = null,
    Object? lastLogin = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? profile = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      profile: freezed == profile
          ? _value._profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.name,
      required this.role,
      this.photoUrl,
      this.phone,
      this.address,
      this.isActive = false,
      this.lastLogin,
      this.createdAt,
      this.updatedAt,
      final Map<String, dynamic>? profile,
      final Map<String, dynamic>? metadata})
      : _profile = profile,
        _metadata = metadata,
        super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final String name;
  @override
  final UserRole role;
  @override
  final String? photoUrl;
  @override
  final String? phone;
  @override
  final String? address;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime? lastLogin;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  final Map<String, dynamic>? _profile;
  @override
  Map<String, dynamic>? get profile {
    final value = _profile;
    if (value == null) return null;
    if (_profile is EqualUnmodifiableMapView) return _profile;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, photoUrl: $photoUrl, phone: $phone, address: $address, isActive: $isActive, lastLogin: $lastLogin, createdAt: $createdAt, updatedAt: $updatedAt, profile: $profile, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._profile, _profile) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      name,
      role,
      photoUrl,
      phone,
      address,
      isActive,
      lastLogin,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_profile),
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User extends User {
  const factory _User(
      {required final String id,
      required final String email,
      required final String name,
      required final UserRole role,
      final String? photoUrl,
      final String? phone,
      final String? address,
      final bool isActive,
      final DateTime? lastLogin,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final Map<String, dynamic>? profile,
      final Map<String, dynamic>? metadata}) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  String get name;
  @override
  UserRole get role;
  @override
  String? get photoUrl;
  @override
  String? get phone;
  @override
  String? get address;
  @override
  bool get isActive;
  @override
  DateTime? get lastLogin;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  Map<String, dynamic>? get profile;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AdminProfile _$AdminProfileFromJson(Map<String, dynamic> json) {
  return _AdminProfile.fromJson(json);
}

/// @nodoc
mixin _$AdminProfile {
  String get userId => throw _privateConstructorUsedError;
  String get department => throw _privateConstructorUsedError;
  String? get position => throw _privateConstructorUsedError;
  String? get employeeId => throw _privateConstructorUsedError;
  String? get officeLocation => throw _privateConstructorUsedError;
  List<String>? get managedDepartments => throw _privateConstructorUsedError;
  List<String>? get responsibilities => throw _privateConstructorUsedError;
  DateTime? get hireDate => throw _privateConstructorUsedError;

  /// Serializes this AdminProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminProfileCopyWith<AdminProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminProfileCopyWith<$Res> {
  factory $AdminProfileCopyWith(
          AdminProfile value, $Res Function(AdminProfile) then) =
      _$AdminProfileCopyWithImpl<$Res, AdminProfile>;
  @useResult
  $Res call(
      {String userId,
      String department,
      String? position,
      String? employeeId,
      String? officeLocation,
      List<String>? managedDepartments,
      List<String>? responsibilities,
      DateTime? hireDate});
}

/// @nodoc
class _$AdminProfileCopyWithImpl<$Res, $Val extends AdminProfile>
    implements $AdminProfileCopyWith<$Res> {
  _$AdminProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? department = null,
    Object? position = freezed,
    Object? employeeId = freezed,
    Object? officeLocation = freezed,
    Object? managedDepartments = freezed,
    Object? responsibilities = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String?,
      officeLocation: freezed == officeLocation
          ? _value.officeLocation
          : officeLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      managedDepartments: freezed == managedDepartments
          ? _value.managedDepartments
          : managedDepartments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminProfileImplCopyWith<$Res>
    implements $AdminProfileCopyWith<$Res> {
  factory _$$AdminProfileImplCopyWith(
          _$AdminProfileImpl value, $Res Function(_$AdminProfileImpl) then) =
      __$$AdminProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String department,
      String? position,
      String? employeeId,
      String? officeLocation,
      List<String>? managedDepartments,
      List<String>? responsibilities,
      DateTime? hireDate});
}

/// @nodoc
class __$$AdminProfileImplCopyWithImpl<$Res>
    extends _$AdminProfileCopyWithImpl<$Res, _$AdminProfileImpl>
    implements _$$AdminProfileImplCopyWith<$Res> {
  __$$AdminProfileImplCopyWithImpl(
      _$AdminProfileImpl _value, $Res Function(_$AdminProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdminProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? department = null,
    Object? position = freezed,
    Object? employeeId = freezed,
    Object? officeLocation = freezed,
    Object? managedDepartments = freezed,
    Object? responsibilities = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_$AdminProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      department: null == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      employeeId: freezed == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String?,
      officeLocation: freezed == officeLocation
          ? _value.officeLocation
          : officeLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      managedDepartments: freezed == managedDepartments
          ? _value._managedDepartments
          : managedDepartments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      responsibilities: freezed == responsibilities
          ? _value._responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminProfileImpl implements _AdminProfile {
  const _$AdminProfileImpl(
      {required this.userId,
      required this.department,
      this.position,
      this.employeeId,
      this.officeLocation,
      final List<String>? managedDepartments,
      final List<String>? responsibilities,
      this.hireDate})
      : _managedDepartments = managedDepartments,
        _responsibilities = responsibilities;

  factory _$AdminProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String department;
  @override
  final String? position;
  @override
  final String? employeeId;
  @override
  final String? officeLocation;
  final List<String>? _managedDepartments;
  @override
  List<String>? get managedDepartments {
    final value = _managedDepartments;
    if (value == null) return null;
    if (_managedDepartments is EqualUnmodifiableListView)
      return _managedDepartments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _responsibilities;
  @override
  List<String>? get responsibilities {
    final value = _responsibilities;
    if (value == null) return null;
    if (_responsibilities is EqualUnmodifiableListView)
      return _responsibilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? hireDate;

  @override
  String toString() {
    return 'AdminProfile(userId: $userId, department: $department, position: $position, employeeId: $employeeId, officeLocation: $officeLocation, managedDepartments: $managedDepartments, responsibilities: $responsibilities, hireDate: $hireDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.officeLocation, officeLocation) ||
                other.officeLocation == officeLocation) &&
            const DeepCollectionEquality()
                .equals(other._managedDepartments, _managedDepartments) &&
            const DeepCollectionEquality()
                .equals(other._responsibilities, _responsibilities) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      department,
      position,
      employeeId,
      officeLocation,
      const DeepCollectionEquality().hash(_managedDepartments),
      const DeepCollectionEquality().hash(_responsibilities),
      hireDate);

  /// Create a copy of AdminProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminProfileImplCopyWith<_$AdminProfileImpl> get copyWith =>
      __$$AdminProfileImplCopyWithImpl<_$AdminProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminProfileImplToJson(
      this,
    );
  }
}

abstract class _AdminProfile implements AdminProfile {
  const factory _AdminProfile(
      {required final String userId,
      required final String department,
      final String? position,
      final String? employeeId,
      final String? officeLocation,
      final List<String>? managedDepartments,
      final List<String>? responsibilities,
      final DateTime? hireDate}) = _$AdminProfileImpl;

  factory _AdminProfile.fromJson(Map<String, dynamic> json) =
      _$AdminProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get department;
  @override
  String? get position;
  @override
  String? get employeeId;
  @override
  String? get officeLocation;
  @override
  List<String>? get managedDepartments;
  @override
  List<String>? get responsibilities;
  @override
  DateTime? get hireDate;

  /// Create a copy of AdminProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminProfileImplCopyWith<_$AdminProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalPersonnelProfile _$MedicalPersonnelProfileFromJson(
    Map<String, dynamic> json) {
  return _MedicalPersonnelProfile.fromJson(json);
}

/// @nodoc
mixin _$MedicalPersonnelProfile {
  String get userId => throw _privateConstructorUsedError;
  String get specialization => throw _privateConstructorUsedError;
  String get licenseNumber => throw _privateConstructorUsedError;
  String get experience => throw _privateConstructorUsedError;
  List<String>? get assignedPatientIds => throw _privateConstructorUsedError;
  List<String>? get qualifications => throw _privateConstructorUsedError;
  List<String>? get certifications => throw _privateConstructorUsedError;
  String? get biography => throw _privateConstructorUsedError;
  String? get officeHours => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  Map<String, dynamic>? get schedule => throw _privateConstructorUsedError;
  int get patientCount => throw _privateConstructorUsedError;
  int get appointmentCount => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;

  /// Serializes this MedicalPersonnelProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalPersonnelProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalPersonnelProfileCopyWith<MedicalPersonnelProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalPersonnelProfileCopyWith<$Res> {
  factory $MedicalPersonnelProfileCopyWith(MedicalPersonnelProfile value,
          $Res Function(MedicalPersonnelProfile) then) =
      _$MedicalPersonnelProfileCopyWithImpl<$Res, MedicalPersonnelProfile>;
  @useResult
  $Res call(
      {String userId,
      String specialization,
      String licenseNumber,
      String experience,
      List<String>? assignedPatientIds,
      List<String>? qualifications,
      List<String>? certifications,
      String? biography,
      String? officeHours,
      String? department,
      Map<String, dynamic>? schedule,
      int patientCount,
      int appointmentCount,
      double rating,
      int reviewCount});
}

/// @nodoc
class _$MedicalPersonnelProfileCopyWithImpl<$Res,
        $Val extends MedicalPersonnelProfile>
    implements $MedicalPersonnelProfileCopyWith<$Res> {
  _$MedicalPersonnelProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalPersonnelProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? specialization = null,
    Object? licenseNumber = null,
    Object? experience = null,
    Object? assignedPatientIds = freezed,
    Object? qualifications = freezed,
    Object? certifications = freezed,
    Object? biography = freezed,
    Object? officeHours = freezed,
    Object? department = freezed,
    Object? schedule = freezed,
    Object? patientCount = null,
    Object? appointmentCount = null,
    Object? rating = null,
    Object? reviewCount = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String,
      assignedPatientIds: freezed == assignedPatientIds
          ? _value.assignedPatientIds
          : assignedPatientIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      qualifications: freezed == qualifications
          ? _value.qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      biography: freezed == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String?,
      officeHours: freezed == officeHours
          ? _value.officeHours
          : officeHours // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      patientCount: null == patientCount
          ? _value.patientCount
          : patientCount // ignore: cast_nullable_to_non_nullable
              as int,
      appointmentCount: null == appointmentCount
          ? _value.appointmentCount
          : appointmentCount // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicalPersonnelProfileImplCopyWith<$Res>
    implements $MedicalPersonnelProfileCopyWith<$Res> {
  factory _$$MedicalPersonnelProfileImplCopyWith(
          _$MedicalPersonnelProfileImpl value,
          $Res Function(_$MedicalPersonnelProfileImpl) then) =
      __$$MedicalPersonnelProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String specialization,
      String licenseNumber,
      String experience,
      List<String>? assignedPatientIds,
      List<String>? qualifications,
      List<String>? certifications,
      String? biography,
      String? officeHours,
      String? department,
      Map<String, dynamic>? schedule,
      int patientCount,
      int appointmentCount,
      double rating,
      int reviewCount});
}

/// @nodoc
class __$$MedicalPersonnelProfileImplCopyWithImpl<$Res>
    extends _$MedicalPersonnelProfileCopyWithImpl<$Res,
        _$MedicalPersonnelProfileImpl>
    implements _$$MedicalPersonnelProfileImplCopyWith<$Res> {
  __$$MedicalPersonnelProfileImplCopyWithImpl(
      _$MedicalPersonnelProfileImpl _value,
      $Res Function(_$MedicalPersonnelProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicalPersonnelProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? specialization = null,
    Object? licenseNumber = null,
    Object? experience = null,
    Object? assignedPatientIds = freezed,
    Object? qualifications = freezed,
    Object? certifications = freezed,
    Object? biography = freezed,
    Object? officeHours = freezed,
    Object? department = freezed,
    Object? schedule = freezed,
    Object? patientCount = null,
    Object? appointmentCount = null,
    Object? rating = null,
    Object? reviewCount = null,
  }) {
    return _then(_$MedicalPersonnelProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      specialization: null == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      experience: null == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String,
      assignedPatientIds: freezed == assignedPatientIds
          ? _value._assignedPatientIds
          : assignedPatientIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      qualifications: freezed == qualifications
          ? _value._qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      biography: freezed == biography
          ? _value.biography
          : biography // ignore: cast_nullable_to_non_nullable
              as String?,
      officeHours: freezed == officeHours
          ? _value.officeHours
          : officeHours // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      schedule: freezed == schedule
          ? _value._schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      patientCount: null == patientCount
          ? _value.patientCount
          : patientCount // ignore: cast_nullable_to_non_nullable
              as int,
      appointmentCount: null == appointmentCount
          ? _value.appointmentCount
          : appointmentCount // ignore: cast_nullable_to_non_nullable
              as int,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalPersonnelProfileImpl implements _MedicalPersonnelProfile {
  const _$MedicalPersonnelProfileImpl(
      {required this.userId,
      required this.specialization,
      required this.licenseNumber,
      required this.experience,
      final List<String>? assignedPatientIds,
      final List<String>? qualifications,
      final List<String>? certifications,
      this.biography,
      this.officeHours,
      this.department,
      final Map<String, dynamic>? schedule,
      this.patientCount = 0,
      this.appointmentCount = 0,
      this.rating = 0,
      this.reviewCount = 0})
      : _assignedPatientIds = assignedPatientIds,
        _qualifications = qualifications,
        _certifications = certifications,
        _schedule = schedule;

  factory _$MedicalPersonnelProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalPersonnelProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String specialization;
  @override
  final String licenseNumber;
  @override
  final String experience;
  final List<String>? _assignedPatientIds;
  @override
  List<String>? get assignedPatientIds {
    final value = _assignedPatientIds;
    if (value == null) return null;
    if (_assignedPatientIds is EqualUnmodifiableListView)
      return _assignedPatientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _qualifications;
  @override
  List<String>? get qualifications {
    final value = _qualifications;
    if (value == null) return null;
    if (_qualifications is EqualUnmodifiableListView) return _qualifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _certifications;
  @override
  List<String>? get certifications {
    final value = _certifications;
    if (value == null) return null;
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? biography;
  @override
  final String? officeHours;
  @override
  final String? department;
  final Map<String, dynamic>? _schedule;
  @override
  Map<String, dynamic>? get schedule {
    final value = _schedule;
    if (value == null) return null;
    if (_schedule is EqualUnmodifiableMapView) return _schedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey()
  final int patientCount;
  @override
  @JsonKey()
  final int appointmentCount;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;

  @override
  String toString() {
    return 'MedicalPersonnelProfile(userId: $userId, specialization: $specialization, licenseNumber: $licenseNumber, experience: $experience, assignedPatientIds: $assignedPatientIds, qualifications: $qualifications, certifications: $certifications, biography: $biography, officeHours: $officeHours, department: $department, schedule: $schedule, patientCount: $patientCount, appointmentCount: $appointmentCount, rating: $rating, reviewCount: $reviewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalPersonnelProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            const DeepCollectionEquality()
                .equals(other._assignedPatientIds, _assignedPatientIds) &&
            const DeepCollectionEquality()
                .equals(other._qualifications, _qualifications) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            (identical(other.biography, biography) ||
                other.biography == biography) &&
            (identical(other.officeHours, officeHours) ||
                other.officeHours == officeHours) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality().equals(other._schedule, _schedule) &&
            (identical(other.patientCount, patientCount) ||
                other.patientCount == patientCount) &&
            (identical(other.appointmentCount, appointmentCount) ||
                other.appointmentCount == appointmentCount) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      specialization,
      licenseNumber,
      experience,
      const DeepCollectionEquality().hash(_assignedPatientIds),
      const DeepCollectionEquality().hash(_qualifications),
      const DeepCollectionEquality().hash(_certifications),
      biography,
      officeHours,
      department,
      const DeepCollectionEquality().hash(_schedule),
      patientCount,
      appointmentCount,
      rating,
      reviewCount);

  /// Create a copy of MedicalPersonnelProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalPersonnelProfileImplCopyWith<_$MedicalPersonnelProfileImpl>
      get copyWith => __$$MedicalPersonnelProfileImplCopyWithImpl<
          _$MedicalPersonnelProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalPersonnelProfileImplToJson(
      this,
    );
  }
}

abstract class _MedicalPersonnelProfile implements MedicalPersonnelProfile {
  const factory _MedicalPersonnelProfile(
      {required final String userId,
      required final String specialization,
      required final String licenseNumber,
      required final String experience,
      final List<String>? assignedPatientIds,
      final List<String>? qualifications,
      final List<String>? certifications,
      final String? biography,
      final String? officeHours,
      final String? department,
      final Map<String, dynamic>? schedule,
      final int patientCount,
      final int appointmentCount,
      final double rating,
      final int reviewCount}) = _$MedicalPersonnelProfileImpl;

  factory _MedicalPersonnelProfile.fromJson(Map<String, dynamic> json) =
      _$MedicalPersonnelProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get specialization;
  @override
  String get licenseNumber;
  @override
  String get experience;
  @override
  List<String>? get assignedPatientIds;
  @override
  List<String>? get qualifications;
  @override
  List<String>? get certifications;
  @override
  String? get biography;
  @override
  String? get officeHours;
  @override
  String? get department;
  @override
  Map<String, dynamic>? get schedule;
  @override
  int get patientCount;
  @override
  int get appointmentCount;
  @override
  double get rating;
  @override
  int get reviewCount;

  /// Create a copy of MedicalPersonnelProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalPersonnelProfileImplCopyWith<_$MedicalPersonnelProfileImpl>
      get copyWith => throw _privateConstructorUsedError;
}

PatientProfile _$PatientProfileFromJson(Map<String, dynamic> json) {
  return _PatientProfile.fromJson(json);
}

/// @nodoc
mixin _$PatientProfile {
  String get userId => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get gender => throw _privateConstructorUsedError;
  String? get medicalCondition => throw _privateConstructorUsedError;
  String? get bloodType => throw _privateConstructorUsedError;
  String? get emergencyContact => throw _privateConstructorUsedError;
  String? get insuranceProvider => throw _privateConstructorUsedError;
  String? get insuranceNumber => throw _privateConstructorUsedError;
  String? get allergies => throw _privateConstructorUsedError;
  String? get chronicDiseases => throw _privateConstructorUsedError;
  String? get currentMedication => throw _privateConstructorUsedError;
  Map<String, dynamic>? get vitals => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get medicalHistory =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get treatments =>
      throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get diagnostics =>
      throw _privateConstructorUsedError;
  List<String>? get assignedDoctorIds => throw _privateConstructorUsedError;
  DateTime? get lastCheckup => throw _privateConstructorUsedError;

  /// Serializes this PatientProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PatientProfileCopyWith<PatientProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PatientProfileCopyWith<$Res> {
  factory $PatientProfileCopyWith(
          PatientProfile value, $Res Function(PatientProfile) then) =
      _$PatientProfileCopyWithImpl<$Res, PatientProfile>;
  @useResult
  $Res call(
      {String userId,
      int age,
      String gender,
      String? medicalCondition,
      String? bloodType,
      String? emergencyContact,
      String? insuranceProvider,
      String? insuranceNumber,
      String? allergies,
      String? chronicDiseases,
      String? currentMedication,
      Map<String, dynamic>? vitals,
      List<Map<String, dynamic>>? medicalHistory,
      List<Map<String, dynamic>>? treatments,
      List<Map<String, dynamic>>? diagnostics,
      List<String>? assignedDoctorIds,
      DateTime? lastCheckup});
}

/// @nodoc
class _$PatientProfileCopyWithImpl<$Res, $Val extends PatientProfile>
    implements $PatientProfileCopyWith<$Res> {
  _$PatientProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? age = null,
    Object? gender = null,
    Object? medicalCondition = freezed,
    Object? bloodType = freezed,
    Object? emergencyContact = freezed,
    Object? insuranceProvider = freezed,
    Object? insuranceNumber = freezed,
    Object? allergies = freezed,
    Object? chronicDiseases = freezed,
    Object? currentMedication = freezed,
    Object? vitals = freezed,
    Object? medicalHistory = freezed,
    Object? treatments = freezed,
    Object? diagnostics = freezed,
    Object? assignedDoctorIds = freezed,
    Object? lastCheckup = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      medicalCondition: freezed == medicalCondition
          ? _value.medicalCondition
          : medicalCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceProvider: freezed == insuranceProvider
          ? _value.insuranceProvider
          : insuranceProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as String?,
      chronicDiseases: freezed == chronicDiseases
          ? _value.chronicDiseases
          : chronicDiseases // ignore: cast_nullable_to_non_nullable
              as String?,
      currentMedication: freezed == currentMedication
          ? _value.currentMedication
          : currentMedication // ignore: cast_nullable_to_non_nullable
              as String?,
      vitals: freezed == vitals
          ? _value.vitals
          : vitals // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      medicalHistory: freezed == medicalHistory
          ? _value.medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      treatments: freezed == treatments
          ? _value.treatments
          : treatments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      diagnostics: freezed == diagnostics
          ? _value.diagnostics
          : diagnostics // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      assignedDoctorIds: freezed == assignedDoctorIds
          ? _value.assignedDoctorIds
          : assignedDoctorIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastCheckup: freezed == lastCheckup
          ? _value.lastCheckup
          : lastCheckup // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PatientProfileImplCopyWith<$Res>
    implements $PatientProfileCopyWith<$Res> {
  factory _$$PatientProfileImplCopyWith(_$PatientProfileImpl value,
          $Res Function(_$PatientProfileImpl) then) =
      __$$PatientProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      int age,
      String gender,
      String? medicalCondition,
      String? bloodType,
      String? emergencyContact,
      String? insuranceProvider,
      String? insuranceNumber,
      String? allergies,
      String? chronicDiseases,
      String? currentMedication,
      Map<String, dynamic>? vitals,
      List<Map<String, dynamic>>? medicalHistory,
      List<Map<String, dynamic>>? treatments,
      List<Map<String, dynamic>>? diagnostics,
      List<String>? assignedDoctorIds,
      DateTime? lastCheckup});
}

/// @nodoc
class __$$PatientProfileImplCopyWithImpl<$Res>
    extends _$PatientProfileCopyWithImpl<$Res, _$PatientProfileImpl>
    implements _$$PatientProfileImplCopyWith<$Res> {
  __$$PatientProfileImplCopyWithImpl(
      _$PatientProfileImpl _value, $Res Function(_$PatientProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? age = null,
    Object? gender = null,
    Object? medicalCondition = freezed,
    Object? bloodType = freezed,
    Object? emergencyContact = freezed,
    Object? insuranceProvider = freezed,
    Object? insuranceNumber = freezed,
    Object? allergies = freezed,
    Object? chronicDiseases = freezed,
    Object? currentMedication = freezed,
    Object? vitals = freezed,
    Object? medicalHistory = freezed,
    Object? treatments = freezed,
    Object? diagnostics = freezed,
    Object? assignedDoctorIds = freezed,
    Object? lastCheckup = freezed,
  }) {
    return _then(_$PatientProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      medicalCondition: freezed == medicalCondition
          ? _value.medicalCondition
          : medicalCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      emergencyContact: freezed == emergencyContact
          ? _value.emergencyContact
          : emergencyContact // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceProvider: freezed == insuranceProvider
          ? _value.insuranceProvider
          : insuranceProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      insuranceNumber: freezed == insuranceNumber
          ? _value.insuranceNumber
          : insuranceNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      allergies: freezed == allergies
          ? _value.allergies
          : allergies // ignore: cast_nullable_to_non_nullable
              as String?,
      chronicDiseases: freezed == chronicDiseases
          ? _value.chronicDiseases
          : chronicDiseases // ignore: cast_nullable_to_non_nullable
              as String?,
      currentMedication: freezed == currentMedication
          ? _value.currentMedication
          : currentMedication // ignore: cast_nullable_to_non_nullable
              as String?,
      vitals: freezed == vitals
          ? _value._vitals
          : vitals // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      medicalHistory: freezed == medicalHistory
          ? _value._medicalHistory
          : medicalHistory // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      treatments: freezed == treatments
          ? _value._treatments
          : treatments // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      diagnostics: freezed == diagnostics
          ? _value._diagnostics
          : diagnostics // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
      assignedDoctorIds: freezed == assignedDoctorIds
          ? _value._assignedDoctorIds
          : assignedDoctorIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastCheckup: freezed == lastCheckup
          ? _value.lastCheckup
          : lastCheckup // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PatientProfileImpl implements _PatientProfile {
  const _$PatientProfileImpl(
      {required this.userId,
      required this.age,
      required this.gender,
      this.medicalCondition,
      this.bloodType,
      this.emergencyContact,
      this.insuranceProvider,
      this.insuranceNumber,
      this.allergies,
      this.chronicDiseases,
      this.currentMedication,
      final Map<String, dynamic>? vitals,
      final List<Map<String, dynamic>>? medicalHistory,
      final List<Map<String, dynamic>>? treatments,
      final List<Map<String, dynamic>>? diagnostics,
      final List<String>? assignedDoctorIds,
      this.lastCheckup})
      : _vitals = vitals,
        _medicalHistory = medicalHistory,
        _treatments = treatments,
        _diagnostics = diagnostics,
        _assignedDoctorIds = assignedDoctorIds;

  factory _$PatientProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PatientProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final int age;
  @override
  final String gender;
  @override
  final String? medicalCondition;
  @override
  final String? bloodType;
  @override
  final String? emergencyContact;
  @override
  final String? insuranceProvider;
  @override
  final String? insuranceNumber;
  @override
  final String? allergies;
  @override
  final String? chronicDiseases;
  @override
  final String? currentMedication;
  final Map<String, dynamic>? _vitals;
  @override
  Map<String, dynamic>? get vitals {
    final value = _vitals;
    if (value == null) return null;
    if (_vitals is EqualUnmodifiableMapView) return _vitals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Map<String, dynamic>>? _medicalHistory;
  @override
  List<Map<String, dynamic>>? get medicalHistory {
    final value = _medicalHistory;
    if (value == null) return null;
    if (_medicalHistory is EqualUnmodifiableListView) return _medicalHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _treatments;
  @override
  List<Map<String, dynamic>>? get treatments {
    final value = _treatments;
    if (value == null) return null;
    if (_treatments is EqualUnmodifiableListView) return _treatments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _diagnostics;
  @override
  List<Map<String, dynamic>>? get diagnostics {
    final value = _diagnostics;
    if (value == null) return null;
    if (_diagnostics is EqualUnmodifiableListView) return _diagnostics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _assignedDoctorIds;
  @override
  List<String>? get assignedDoctorIds {
    final value = _assignedDoctorIds;
    if (value == null) return null;
    if (_assignedDoctorIds is EqualUnmodifiableListView)
      return _assignedDoctorIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastCheckup;

  @override
  String toString() {
    return 'PatientProfile(userId: $userId, age: $age, gender: $gender, medicalCondition: $medicalCondition, bloodType: $bloodType, emergencyContact: $emergencyContact, insuranceProvider: $insuranceProvider, insuranceNumber: $insuranceNumber, allergies: $allergies, chronicDiseases: $chronicDiseases, currentMedication: $currentMedication, vitals: $vitals, medicalHistory: $medicalHistory, treatments: $treatments, diagnostics: $diagnostics, assignedDoctorIds: $assignedDoctorIds, lastCheckup: $lastCheckup)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PatientProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.medicalCondition, medicalCondition) ||
                other.medicalCondition == medicalCondition) &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            (identical(other.emergencyContact, emergencyContact) ||
                other.emergencyContact == emergencyContact) &&
            (identical(other.insuranceProvider, insuranceProvider) ||
                other.insuranceProvider == insuranceProvider) &&
            (identical(other.insuranceNumber, insuranceNumber) ||
                other.insuranceNumber == insuranceNumber) &&
            (identical(other.allergies, allergies) ||
                other.allergies == allergies) &&
            (identical(other.chronicDiseases, chronicDiseases) ||
                other.chronicDiseases == chronicDiseases) &&
            (identical(other.currentMedication, currentMedication) ||
                other.currentMedication == currentMedication) &&
            const DeepCollectionEquality().equals(other._vitals, _vitals) &&
            const DeepCollectionEquality()
                .equals(other._medicalHistory, _medicalHistory) &&
            const DeepCollectionEquality()
                .equals(other._treatments, _treatments) &&
            const DeepCollectionEquality()
                .equals(other._diagnostics, _diagnostics) &&
            const DeepCollectionEquality()
                .equals(other._assignedDoctorIds, _assignedDoctorIds) &&
            (identical(other.lastCheckup, lastCheckup) ||
                other.lastCheckup == lastCheckup));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      age,
      gender,
      medicalCondition,
      bloodType,
      emergencyContact,
      insuranceProvider,
      insuranceNumber,
      allergies,
      chronicDiseases,
      currentMedication,
      const DeepCollectionEquality().hash(_vitals),
      const DeepCollectionEquality().hash(_medicalHistory),
      const DeepCollectionEquality().hash(_treatments),
      const DeepCollectionEquality().hash(_diagnostics),
      const DeepCollectionEquality().hash(_assignedDoctorIds),
      lastCheckup);

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PatientProfileImplCopyWith<_$PatientProfileImpl> get copyWith =>
      __$$PatientProfileImplCopyWithImpl<_$PatientProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PatientProfileImplToJson(
      this,
    );
  }
}

abstract class _PatientProfile implements PatientProfile {
  const factory _PatientProfile(
      {required final String userId,
      required final int age,
      required final String gender,
      final String? medicalCondition,
      final String? bloodType,
      final String? emergencyContact,
      final String? insuranceProvider,
      final String? insuranceNumber,
      final String? allergies,
      final String? chronicDiseases,
      final String? currentMedication,
      final Map<String, dynamic>? vitals,
      final List<Map<String, dynamic>>? medicalHistory,
      final List<Map<String, dynamic>>? treatments,
      final List<Map<String, dynamic>>? diagnostics,
      final List<String>? assignedDoctorIds,
      final DateTime? lastCheckup}) = _$PatientProfileImpl;

  factory _PatientProfile.fromJson(Map<String, dynamic> json) =
      _$PatientProfileImpl.fromJson;

  @override
  String get userId;
  @override
  int get age;
  @override
  String get gender;
  @override
  String? get medicalCondition;
  @override
  String? get bloodType;
  @override
  String? get emergencyContact;
  @override
  String? get insuranceProvider;
  @override
  String? get insuranceNumber;
  @override
  String? get allergies;
  @override
  String? get chronicDiseases;
  @override
  String? get currentMedication;
  @override
  Map<String, dynamic>? get vitals;
  @override
  List<Map<String, dynamic>>? get medicalHistory;
  @override
  List<Map<String, dynamic>>? get treatments;
  @override
  List<Map<String, dynamic>>? get diagnostics;
  @override
  List<String>? get assignedDoctorIds;
  @override
  DateTime? get lastCheckup;

  /// Create a copy of PatientProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PatientProfileImplCopyWith<_$PatientProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NurseProfile _$NurseProfileFromJson(Map<String, dynamic> json) {
  return _NurseProfile.fromJson(json);
}

/// @nodoc
mixin _$NurseProfile {
  String get userId => throw _privateConstructorUsedError;
  String get nurseType => throw _privateConstructorUsedError;
  String get licenseNumber => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  List<String>? get assignedPatientIds => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  String? get experience => throw _privateConstructorUsedError;
  List<String>? get qualifications => throw _privateConstructorUsedError;
  Map<String, dynamic>? get schedule => throw _privateConstructorUsedError;

  /// Serializes this NurseProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NurseProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NurseProfileCopyWith<NurseProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NurseProfileCopyWith<$Res> {
  factory $NurseProfileCopyWith(
          NurseProfile value, $Res Function(NurseProfile) then) =
      _$NurseProfileCopyWithImpl<$Res, NurseProfile>;
  @useResult
  $Res call(
      {String userId,
      String nurseType,
      String licenseNumber,
      String? department,
      List<String>? assignedPatientIds,
      String? specialization,
      String? experience,
      List<String>? qualifications,
      Map<String, dynamic>? schedule});
}

/// @nodoc
class _$NurseProfileCopyWithImpl<$Res, $Val extends NurseProfile>
    implements $NurseProfileCopyWith<$Res> {
  _$NurseProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NurseProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nurseType = null,
    Object? licenseNumber = null,
    Object? department = freezed,
    Object? assignedPatientIds = freezed,
    Object? specialization = freezed,
    Object? experience = freezed,
    Object? qualifications = freezed,
    Object? schedule = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nurseType: null == nurseType
          ? _value.nurseType
          : nurseType // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedPatientIds: freezed == assignedPatientIds
          ? _value.assignedPatientIds
          : assignedPatientIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String?,
      qualifications: freezed == qualifications
          ? _value.qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      schedule: freezed == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NurseProfileImplCopyWith<$Res>
    implements $NurseProfileCopyWith<$Res> {
  factory _$$NurseProfileImplCopyWith(
          _$NurseProfileImpl value, $Res Function(_$NurseProfileImpl) then) =
      __$$NurseProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String nurseType,
      String licenseNumber,
      String? department,
      List<String>? assignedPatientIds,
      String? specialization,
      String? experience,
      List<String>? qualifications,
      Map<String, dynamic>? schedule});
}

/// @nodoc
class __$$NurseProfileImplCopyWithImpl<$Res>
    extends _$NurseProfileCopyWithImpl<$Res, _$NurseProfileImpl>
    implements _$$NurseProfileImplCopyWith<$Res> {
  __$$NurseProfileImplCopyWithImpl(
      _$NurseProfileImpl _value, $Res Function(_$NurseProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of NurseProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nurseType = null,
    Object? licenseNumber = null,
    Object? department = freezed,
    Object? assignedPatientIds = freezed,
    Object? specialization = freezed,
    Object? experience = freezed,
    Object? qualifications = freezed,
    Object? schedule = freezed,
  }) {
    return _then(_$NurseProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nurseType: null == nurseType
          ? _value.nurseType
          : nurseType // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      assignedPatientIds: freezed == assignedPatientIds
          ? _value._assignedPatientIds
          : assignedPatientIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String?,
      qualifications: freezed == qualifications
          ? _value._qualifications
          : qualifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      schedule: freezed == schedule
          ? _value._schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NurseProfileImpl implements _NurseProfile {
  const _$NurseProfileImpl(
      {required this.userId,
      required this.nurseType,
      required this.licenseNumber,
      this.department,
      final List<String>? assignedPatientIds,
      this.specialization,
      this.experience,
      final List<String>? qualifications,
      final Map<String, dynamic>? schedule})
      : _assignedPatientIds = assignedPatientIds,
        _qualifications = qualifications,
        _schedule = schedule;

  factory _$NurseProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$NurseProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String nurseType;
  @override
  final String licenseNumber;
  @override
  final String? department;
  final List<String>? _assignedPatientIds;
  @override
  List<String>? get assignedPatientIds {
    final value = _assignedPatientIds;
    if (value == null) return null;
    if (_assignedPatientIds is EqualUnmodifiableListView)
      return _assignedPatientIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? specialization;
  @override
  final String? experience;
  final List<String>? _qualifications;
  @override
  List<String>? get qualifications {
    final value = _qualifications;
    if (value == null) return null;
    if (_qualifications is EqualUnmodifiableListView) return _qualifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _schedule;
  @override
  Map<String, dynamic>? get schedule {
    final value = _schedule;
    if (value == null) return null;
    if (_schedule is EqualUnmodifiableMapView) return _schedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'NurseProfile(userId: $userId, nurseType: $nurseType, licenseNumber: $licenseNumber, department: $department, assignedPatientIds: $assignedPatientIds, specialization: $specialization, experience: $experience, qualifications: $qualifications, schedule: $schedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NurseProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nurseType, nurseType) ||
                other.nurseType == nurseType) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality()
                .equals(other._assignedPatientIds, _assignedPatientIds) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            const DeepCollectionEquality()
                .equals(other._qualifications, _qualifications) &&
            const DeepCollectionEquality().equals(other._schedule, _schedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      nurseType,
      licenseNumber,
      department,
      const DeepCollectionEquality().hash(_assignedPatientIds),
      specialization,
      experience,
      const DeepCollectionEquality().hash(_qualifications),
      const DeepCollectionEquality().hash(_schedule));

  /// Create a copy of NurseProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NurseProfileImplCopyWith<_$NurseProfileImpl> get copyWith =>
      __$$NurseProfileImplCopyWithImpl<_$NurseProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NurseProfileImplToJson(
      this,
    );
  }
}

abstract class _NurseProfile implements NurseProfile {
  const factory _NurseProfile(
      {required final String userId,
      required final String nurseType,
      required final String licenseNumber,
      final String? department,
      final List<String>? assignedPatientIds,
      final String? specialization,
      final String? experience,
      final List<String>? qualifications,
      final Map<String, dynamic>? schedule}) = _$NurseProfileImpl;

  factory _NurseProfile.fromJson(Map<String, dynamic> json) =
      _$NurseProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get nurseType;
  @override
  String get licenseNumber;
  @override
  String? get department;
  @override
  List<String>? get assignedPatientIds;
  @override
  String? get specialization;
  @override
  String? get experience;
  @override
  List<String>? get qualifications;
  @override
  Map<String, dynamic>? get schedule;

  /// Create a copy of NurseProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NurseProfileImplCopyWith<_$NurseProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReceptionistProfile _$ReceptionistProfileFromJson(Map<String, dynamic> json) {
  return _ReceptionistProfile.fromJson(json);
}

/// @nodoc
mixin _$ReceptionistProfile {
  String get userId => throw _privateConstructorUsedError;
  String get employeeId => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get shiftHours => throw _privateConstructorUsedError;
  String? get responsibilities => throw _privateConstructorUsedError;
  DateTime? get hireDate => throw _privateConstructorUsedError;

  /// Serializes this ReceptionistProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReceptionistProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReceptionistProfileCopyWith<ReceptionistProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReceptionistProfileCopyWith<$Res> {
  factory $ReceptionistProfileCopyWith(
          ReceptionistProfile value, $Res Function(ReceptionistProfile) then) =
      _$ReceptionistProfileCopyWithImpl<$Res, ReceptionistProfile>;
  @useResult
  $Res call(
      {String userId,
      String employeeId,
      String? department,
      String? shiftHours,
      String? responsibilities,
      DateTime? hireDate});
}

/// @nodoc
class _$ReceptionistProfileCopyWithImpl<$Res, $Val extends ReceptionistProfile>
    implements $ReceptionistProfileCopyWith<$Res> {
  _$ReceptionistProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReceptionistProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? employeeId = null,
    Object? department = freezed,
    Object? shiftHours = freezed,
    Object? responsibilities = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftHours: freezed == shiftHours
          ? _value.shiftHours
          : shiftHours // ignore: cast_nullable_to_non_nullable
              as String?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as String?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReceptionistProfileImplCopyWith<$Res>
    implements $ReceptionistProfileCopyWith<$Res> {
  factory _$$ReceptionistProfileImplCopyWith(_$ReceptionistProfileImpl value,
          $Res Function(_$ReceptionistProfileImpl) then) =
      __$$ReceptionistProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String employeeId,
      String? department,
      String? shiftHours,
      String? responsibilities,
      DateTime? hireDate});
}

/// @nodoc
class __$$ReceptionistProfileImplCopyWithImpl<$Res>
    extends _$ReceptionistProfileCopyWithImpl<$Res, _$ReceptionistProfileImpl>
    implements _$$ReceptionistProfileImplCopyWith<$Res> {
  __$$ReceptionistProfileImplCopyWithImpl(_$ReceptionistProfileImpl _value,
      $Res Function(_$ReceptionistProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReceptionistProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? employeeId = null,
    Object? department = freezed,
    Object? shiftHours = freezed,
    Object? responsibilities = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_$ReceptionistProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      employeeId: null == employeeId
          ? _value.employeeId
          : employeeId // ignore: cast_nullable_to_non_nullable
              as String,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      shiftHours: freezed == shiftHours
          ? _value.shiftHours
          : shiftHours // ignore: cast_nullable_to_non_nullable
              as String?,
      responsibilities: freezed == responsibilities
          ? _value.responsibilities
          : responsibilities // ignore: cast_nullable_to_non_nullable
              as String?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReceptionistProfileImpl implements _ReceptionistProfile {
  const _$ReceptionistProfileImpl(
      {required this.userId,
      required this.employeeId,
      this.department,
      this.shiftHours,
      this.responsibilities,
      this.hireDate});

  factory _$ReceptionistProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReceptionistProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String employeeId;
  @override
  final String? department;
  @override
  final String? shiftHours;
  @override
  final String? responsibilities;
  @override
  final DateTime? hireDate;

  @override
  String toString() {
    return 'ReceptionistProfile(userId: $userId, employeeId: $employeeId, department: $department, shiftHours: $shiftHours, responsibilities: $responsibilities, hireDate: $hireDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReceptionistProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.employeeId, employeeId) ||
                other.employeeId == employeeId) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.shiftHours, shiftHours) ||
                other.shiftHours == shiftHours) &&
            (identical(other.responsibilities, responsibilities) ||
                other.responsibilities == responsibilities) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, employeeId, department,
      shiftHours, responsibilities, hireDate);

  /// Create a copy of ReceptionistProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReceptionistProfileImplCopyWith<_$ReceptionistProfileImpl> get copyWith =>
      __$$ReceptionistProfileImplCopyWithImpl<_$ReceptionistProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReceptionistProfileImplToJson(
      this,
    );
  }
}

abstract class _ReceptionistProfile implements ReceptionistProfile {
  const factory _ReceptionistProfile(
      {required final String userId,
      required final String employeeId,
      final String? department,
      final String? shiftHours,
      final String? responsibilities,
      final DateTime? hireDate}) = _$ReceptionistProfileImpl;

  factory _ReceptionistProfile.fromJson(Map<String, dynamic> json) =
      _$ReceptionistProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get employeeId;
  @override
  String? get department;
  @override
  String? get shiftHours;
  @override
  String? get responsibilities;
  @override
  DateTime? get hireDate;

  /// Create a copy of ReceptionistProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReceptionistProfileImplCopyWith<_$ReceptionistProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PharmacistProfile _$PharmacistProfileFromJson(Map<String, dynamic> json) {
  return _PharmacistProfile.fromJson(json);
}

/// @nodoc
mixin _$PharmacistProfile {
  String get userId => throw _privateConstructorUsedError;
  String get licenseNumber => throw _privateConstructorUsedError;
  String? get experience => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  String? get specialization => throw _privateConstructorUsedError;
  List<String>? get certifications => throw _privateConstructorUsedError;
  DateTime? get hireDate => throw _privateConstructorUsedError;

  /// Serializes this PharmacistProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PharmacistProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PharmacistProfileCopyWith<PharmacistProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PharmacistProfileCopyWith<$Res> {
  factory $PharmacistProfileCopyWith(
          PharmacistProfile value, $Res Function(PharmacistProfile) then) =
      _$PharmacistProfileCopyWithImpl<$Res, PharmacistProfile>;
  @useResult
  $Res call(
      {String userId,
      String licenseNumber,
      String? experience,
      String? department,
      String? specialization,
      List<String>? certifications,
      DateTime? hireDate});
}

/// @nodoc
class _$PharmacistProfileCopyWithImpl<$Res, $Val extends PharmacistProfile>
    implements $PharmacistProfileCopyWith<$Res> {
  _$PharmacistProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PharmacistProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? licenseNumber = null,
    Object? experience = freezed,
    Object? department = freezed,
    Object? specialization = freezed,
    Object? certifications = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      certifications: freezed == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PharmacistProfileImplCopyWith<$Res>
    implements $PharmacistProfileCopyWith<$Res> {
  factory _$$PharmacistProfileImplCopyWith(_$PharmacistProfileImpl value,
          $Res Function(_$PharmacistProfileImpl) then) =
      __$$PharmacistProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String licenseNumber,
      String? experience,
      String? department,
      String? specialization,
      List<String>? certifications,
      DateTime? hireDate});
}

/// @nodoc
class __$$PharmacistProfileImplCopyWithImpl<$Res>
    extends _$PharmacistProfileCopyWithImpl<$Res, _$PharmacistProfileImpl>
    implements _$$PharmacistProfileImplCopyWith<$Res> {
  __$$PharmacistProfileImplCopyWithImpl(_$PharmacistProfileImpl _value,
      $Res Function(_$PharmacistProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of PharmacistProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? licenseNumber = null,
    Object? experience = freezed,
    Object? department = freezed,
    Object? specialization = freezed,
    Object? certifications = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_$PharmacistProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      specialization: freezed == specialization
          ? _value.specialization
          : specialization // ignore: cast_nullable_to_non_nullable
              as String?,
      certifications: freezed == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PharmacistProfileImpl implements _PharmacistProfile {
  const _$PharmacistProfileImpl(
      {required this.userId,
      required this.licenseNumber,
      this.experience,
      this.department,
      this.specialization,
      final List<String>? certifications,
      this.hireDate})
      : _certifications = certifications;

  factory _$PharmacistProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$PharmacistProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String licenseNumber;
  @override
  final String? experience;
  @override
  final String? department;
  @override
  final String? specialization;
  final List<String>? _certifications;
  @override
  List<String>? get certifications {
    final value = _certifications;
    if (value == null) return null;
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? hireDate;

  @override
  String toString() {
    return 'PharmacistProfile(userId: $userId, licenseNumber: $licenseNumber, experience: $experience, department: $department, specialization: $specialization, certifications: $certifications, hireDate: $hireDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PharmacistProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.specialization, specialization) ||
                other.specialization == specialization) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      licenseNumber,
      experience,
      department,
      specialization,
      const DeepCollectionEquality().hash(_certifications),
      hireDate);

  /// Create a copy of PharmacistProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PharmacistProfileImplCopyWith<_$PharmacistProfileImpl> get copyWith =>
      __$$PharmacistProfileImplCopyWithImpl<_$PharmacistProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PharmacistProfileImplToJson(
      this,
    );
  }
}

abstract class _PharmacistProfile implements PharmacistProfile {
  const factory _PharmacistProfile(
      {required final String userId,
      required final String licenseNumber,
      final String? experience,
      final String? department,
      final String? specialization,
      final List<String>? certifications,
      final DateTime? hireDate}) = _$PharmacistProfileImpl;

  factory _PharmacistProfile.fromJson(Map<String, dynamic> json) =
      _$PharmacistProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get licenseNumber;
  @override
  String? get experience;
  @override
  String? get department;
  @override
  String? get specialization;
  @override
  List<String>? get certifications;
  @override
  DateTime? get hireDate;

  /// Create a copy of PharmacistProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PharmacistProfileImplCopyWith<_$PharmacistProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LabTechnicianProfile _$LabTechnicianProfileFromJson(Map<String, dynamic> json) {
  return _LabTechnicianProfile.fromJson(json);
}

/// @nodoc
mixin _$LabTechnicianProfile {
  String get userId => throw _privateConstructorUsedError;
  String get licenseNumber => throw _privateConstructorUsedError;
  String? get experience => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  List<String>? get specializations => throw _privateConstructorUsedError;
  List<String>? get certifications => throw _privateConstructorUsedError;
  DateTime? get hireDate => throw _privateConstructorUsedError;

  /// Serializes this LabTechnicianProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabTechnicianProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabTechnicianProfileCopyWith<LabTechnicianProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabTechnicianProfileCopyWith<$Res> {
  factory $LabTechnicianProfileCopyWith(LabTechnicianProfile value,
          $Res Function(LabTechnicianProfile) then) =
      _$LabTechnicianProfileCopyWithImpl<$Res, LabTechnicianProfile>;
  @useResult
  $Res call(
      {String userId,
      String licenseNumber,
      String? experience,
      String? department,
      List<String>? specializations,
      List<String>? certifications,
      DateTime? hireDate});
}

/// @nodoc
class _$LabTechnicianProfileCopyWithImpl<$Res,
        $Val extends LabTechnicianProfile>
    implements $LabTechnicianProfileCopyWith<$Res> {
  _$LabTechnicianProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabTechnicianProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? licenseNumber = null,
    Object? experience = freezed,
    Object? department = freezed,
    Object? specializations = freezed,
    Object? certifications = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      specializations: freezed == specializations
          ? _value.specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LabTechnicianProfileImplCopyWith<$Res>
    implements $LabTechnicianProfileCopyWith<$Res> {
  factory _$$LabTechnicianProfileImplCopyWith(_$LabTechnicianProfileImpl value,
          $Res Function(_$LabTechnicianProfileImpl) then) =
      __$$LabTechnicianProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String licenseNumber,
      String? experience,
      String? department,
      List<String>? specializations,
      List<String>? certifications,
      DateTime? hireDate});
}

/// @nodoc
class __$$LabTechnicianProfileImplCopyWithImpl<$Res>
    extends _$LabTechnicianProfileCopyWithImpl<$Res, _$LabTechnicianProfileImpl>
    implements _$$LabTechnicianProfileImplCopyWith<$Res> {
  __$$LabTechnicianProfileImplCopyWithImpl(_$LabTechnicianProfileImpl _value,
      $Res Function(_$LabTechnicianProfileImpl) _then)
      : super(_value, _then);

  /// Create a copy of LabTechnicianProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? licenseNumber = null,
    Object? experience = freezed,
    Object? department = freezed,
    Object? specializations = freezed,
    Object? certifications = freezed,
    Object? hireDate = freezed,
  }) {
    return _then(_$LabTechnicianProfileImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      licenseNumber: null == licenseNumber
          ? _value.licenseNumber
          : licenseNumber // ignore: cast_nullable_to_non_nullable
              as String,
      experience: freezed == experience
          ? _value.experience
          : experience // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      specializations: freezed == specializations
          ? _value._specializations
          : specializations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      certifications: freezed == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      hireDate: freezed == hireDate
          ? _value.hireDate
          : hireDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LabTechnicianProfileImpl implements _LabTechnicianProfile {
  const _$LabTechnicianProfileImpl(
      {required this.userId,
      required this.licenseNumber,
      this.experience,
      this.department,
      final List<String>? specializations,
      final List<String>? certifications,
      this.hireDate})
      : _specializations = specializations,
        _certifications = certifications;

  factory _$LabTechnicianProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabTechnicianProfileImplFromJson(json);

  @override
  final String userId;
  @override
  final String licenseNumber;
  @override
  final String? experience;
  @override
  final String? department;
  final List<String>? _specializations;
  @override
  List<String>? get specializations {
    final value = _specializations;
    if (value == null) return null;
    if (_specializations is EqualUnmodifiableListView) return _specializations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _certifications;
  @override
  List<String>? get certifications {
    final value = _certifications;
    if (value == null) return null;
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? hireDate;

  @override
  String toString() {
    return 'LabTechnicianProfile(userId: $userId, licenseNumber: $licenseNumber, experience: $experience, department: $department, specializations: $specializations, certifications: $certifications, hireDate: $hireDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabTechnicianProfileImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.licenseNumber, licenseNumber) ||
                other.licenseNumber == licenseNumber) &&
            (identical(other.experience, experience) ||
                other.experience == experience) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality()
                .equals(other._specializations, _specializations) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            (identical(other.hireDate, hireDate) ||
                other.hireDate == hireDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      licenseNumber,
      experience,
      department,
      const DeepCollectionEquality().hash(_specializations),
      const DeepCollectionEquality().hash(_certifications),
      hireDate);

  /// Create a copy of LabTechnicianProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabTechnicianProfileImplCopyWith<_$LabTechnicianProfileImpl>
      get copyWith =>
          __$$LabTechnicianProfileImplCopyWithImpl<_$LabTechnicianProfileImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabTechnicianProfileImplToJson(
      this,
    );
  }
}

abstract class _LabTechnicianProfile implements LabTechnicianProfile {
  const factory _LabTechnicianProfile(
      {required final String userId,
      required final String licenseNumber,
      final String? experience,
      final String? department,
      final List<String>? specializations,
      final List<String>? certifications,
      final DateTime? hireDate}) = _$LabTechnicianProfileImpl;

  factory _LabTechnicianProfile.fromJson(Map<String, dynamic> json) =
      _$LabTechnicianProfileImpl.fromJson;

  @override
  String get userId;
  @override
  String get licenseNumber;
  @override
  String? get experience;
  @override
  String? get department;
  @override
  List<String>? get specializations;
  @override
  List<String>? get certifications;
  @override
  DateTime? get hireDate;

  /// Create a copy of LabTechnicianProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabTechnicianProfileImplCopyWith<_$LabTechnicianProfileImpl>
      get copyWith => throw _privateConstructorUsedError;
}
