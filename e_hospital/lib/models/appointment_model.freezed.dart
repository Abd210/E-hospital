// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Appointment _$AppointmentFromJson(Map<String, dynamic> json) {
  return _Appointment.fromJson(json);
}

/// @nodoc
mixin _$Appointment {
  String get id => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  String get patientName => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  String get doctorName => throw _privateConstructorUsedError;
  DateTime get appointmentDate => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get purpose => throw _privateConstructorUsedError;
  AppointmentStatus get status => throw _privateConstructorUsedError;
  AppointmentType get type => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  String? get symptoms => throw _privateConstructorUsedError;
  String? get patientPhoneNumber => throw _privateConstructorUsedError;
  String? get doctorSpecialty => throw _privateConstructorUsedError;
  bool? get isVirtual => throw _privateConstructorUsedError;
  String? get virtualMeetingLink => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  DateTime? get checkedInTime => throw _privateConstructorUsedError;
  DateTime? get checkedOutTime => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  /// Serializes this Appointment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentCopyWith<Appointment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentCopyWith<$Res> {
  factory $AppointmentCopyWith(
          Appointment value, $Res Function(Appointment) then) =
      _$AppointmentCopyWithImpl<$Res, Appointment>;
  @useResult
  $Res call(
      {String id,
      String patientId,
      String patientName,
      String doctorId,
      String doctorName,
      DateTime appointmentDate,
      String time,
      String purpose,
      AppointmentStatus status,
      AppointmentType type,
      String? notes,
      String? location,
      String? department,
      int? duration,
      String? symptoms,
      String? patientPhoneNumber,
      String? doctorSpecialty,
      bool? isVirtual,
      String? virtualMeetingLink,
      List<String>? attachments,
      DateTime? checkedInTime,
      DateTime? checkedOutTime,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$AppointmentCopyWithImpl<$Res, $Val extends Appointment>
    implements $AppointmentCopyWith<$Res> {
  _$AppointmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? appointmentDate = null,
    Object? time = null,
    Object? purpose = null,
    Object? status = null,
    Object? type = null,
    Object? notes = freezed,
    Object? location = freezed,
    Object? department = freezed,
    Object? duration = freezed,
    Object? symptoms = freezed,
    Object? patientPhoneNumber = freezed,
    Object? doctorSpecialty = freezed,
    Object? isVirtual = freezed,
    Object? virtualMeetingLink = freezed,
    Object? attachments = freezed,
    Object? checkedInTime = freezed,
    Object? checkedOutTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      patientName: null == patientName
          ? _value.patientName
          : patientName // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentDate: null == appointmentDate
          ? _value.appointmentDate
          : appointmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AppointmentStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AppointmentType,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      symptoms: freezed == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as String?,
      patientPhoneNumber: freezed == patientPhoneNumber
          ? _value.patientPhoneNumber
          : patientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      doctorSpecialty: freezed == doctorSpecialty
          ? _value.doctorSpecialty
          : doctorSpecialty // ignore: cast_nullable_to_non_nullable
              as String?,
      isVirtual: freezed == isVirtual
          ? _value.isVirtual
          : isVirtual // ignore: cast_nullable_to_non_nullable
              as bool?,
      virtualMeetingLink: freezed == virtualMeetingLink
          ? _value.virtualMeetingLink
          : virtualMeetingLink // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      checkedInTime: freezed == checkedInTime
          ? _value.checkedInTime
          : checkedInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkedOutTime: freezed == checkedOutTime
          ? _value.checkedOutTime
          : checkedOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentImplCopyWith<$Res>
    implements $AppointmentCopyWith<$Res> {
  factory _$$AppointmentImplCopyWith(
          _$AppointmentImpl value, $Res Function(_$AppointmentImpl) then) =
      __$$AppointmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String patientId,
      String patientName,
      String doctorId,
      String doctorName,
      DateTime appointmentDate,
      String time,
      String purpose,
      AppointmentStatus status,
      AppointmentType type,
      String? notes,
      String? location,
      String? department,
      int? duration,
      String? symptoms,
      String? patientPhoneNumber,
      String? doctorSpecialty,
      bool? isVirtual,
      String? virtualMeetingLink,
      List<String>? attachments,
      DateTime? checkedInTime,
      DateTime? checkedOutTime,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? createdBy,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$AppointmentImplCopyWithImpl<$Res>
    extends _$AppointmentCopyWithImpl<$Res, _$AppointmentImpl>
    implements _$$AppointmentImplCopyWith<$Res> {
  __$$AppointmentImplCopyWithImpl(
      _$AppointmentImpl _value, $Res Function(_$AppointmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? appointmentDate = null,
    Object? time = null,
    Object? purpose = null,
    Object? status = null,
    Object? type = null,
    Object? notes = freezed,
    Object? location = freezed,
    Object? department = freezed,
    Object? duration = freezed,
    Object? symptoms = freezed,
    Object? patientPhoneNumber = freezed,
    Object? doctorSpecialty = freezed,
    Object? isVirtual = freezed,
    Object? virtualMeetingLink = freezed,
    Object? attachments = freezed,
    Object? checkedInTime = freezed,
    Object? checkedOutTime = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? createdBy = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$AppointmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      patientId: null == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String,
      patientName: null == patientName
          ? _value.patientName
          : patientName // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      appointmentDate: null == appointmentDate
          ? _value.appointmentDate
          : appointmentDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      purpose: null == purpose
          ? _value.purpose
          : purpose // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as AppointmentStatus,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AppointmentType,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      department: freezed == department
          ? _value.department
          : department // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      symptoms: freezed == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as String?,
      patientPhoneNumber: freezed == patientPhoneNumber
          ? _value.patientPhoneNumber
          : patientPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      doctorSpecialty: freezed == doctorSpecialty
          ? _value.doctorSpecialty
          : doctorSpecialty // ignore: cast_nullable_to_non_nullable
              as String?,
      isVirtual: freezed == isVirtual
          ? _value.isVirtual
          : isVirtual // ignore: cast_nullable_to_non_nullable
              as bool?,
      virtualMeetingLink: freezed == virtualMeetingLink
          ? _value.virtualMeetingLink
          : virtualMeetingLink // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      checkedInTime: freezed == checkedInTime
          ? _value.checkedInTime
          : checkedInTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      checkedOutTime: freezed == checkedOutTime
          ? _value.checkedOutTime
          : checkedOutTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentImpl extends _Appointment with DiagnosticableTreeMixin {
  const _$AppointmentImpl(
      {required this.id,
      required this.patientId,
      required this.patientName,
      required this.doctorId,
      required this.doctorName,
      required this.appointmentDate,
      required this.time,
      required this.purpose,
      this.status = AppointmentStatus.scheduled,
      this.type = AppointmentType.checkup,
      this.notes,
      this.location,
      this.department,
      this.duration,
      this.symptoms,
      this.patientPhoneNumber,
      this.doctorSpecialty,
      this.isVirtual,
      this.virtualMeetingLink,
      final List<String>? attachments,
      this.checkedInTime,
      this.checkedOutTime,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      final Map<String, dynamic>? metadata})
      : _attachments = attachments,
        _metadata = metadata,
        super._();

  factory _$AppointmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentImplFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final String patientName;
  @override
  final String doctorId;
  @override
  final String doctorName;
  @override
  final DateTime appointmentDate;
  @override
  final String time;
  @override
  final String purpose;
  @override
  @JsonKey()
  final AppointmentStatus status;
  @override
  @JsonKey()
  final AppointmentType type;
  @override
  final String? notes;
  @override
  final String? location;
  @override
  final String? department;
  @override
  final int? duration;
  @override
  final String? symptoms;
  @override
  final String? patientPhoneNumber;
  @override
  final String? doctorSpecialty;
  @override
  final bool? isVirtual;
  @override
  final String? virtualMeetingLink;
  final List<String>? _attachments;
  @override
  List<String>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? checkedInTime;
  @override
  final DateTime? checkedOutTime;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? createdBy;
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Appointment(id: $id, patientId: $patientId, patientName: $patientName, doctorId: $doctorId, doctorName: $doctorName, appointmentDate: $appointmentDate, time: $time, purpose: $purpose, status: $status, type: $type, notes: $notes, location: $location, department: $department, duration: $duration, symptoms: $symptoms, patientPhoneNumber: $patientPhoneNumber, doctorSpecialty: $doctorSpecialty, isVirtual: $isVirtual, virtualMeetingLink: $virtualMeetingLink, attachments: $attachments, checkedInTime: $checkedInTime, checkedOutTime: $checkedOutTime, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, metadata: $metadata)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Appointment'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('patientId', patientId))
      ..add(DiagnosticsProperty('patientName', patientName))
      ..add(DiagnosticsProperty('doctorId', doctorId))
      ..add(DiagnosticsProperty('doctorName', doctorName))
      ..add(DiagnosticsProperty('appointmentDate', appointmentDate))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('purpose', purpose))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('type', type))
      ..add(DiagnosticsProperty('notes', notes))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('department', department))
      ..add(DiagnosticsProperty('duration', duration))
      ..add(DiagnosticsProperty('symptoms', symptoms))
      ..add(DiagnosticsProperty('patientPhoneNumber', patientPhoneNumber))
      ..add(DiagnosticsProperty('doctorSpecialty', doctorSpecialty))
      ..add(DiagnosticsProperty('isVirtual', isVirtual))
      ..add(DiagnosticsProperty('virtualMeetingLink', virtualMeetingLink))
      ..add(DiagnosticsProperty('attachments', attachments))
      ..add(DiagnosticsProperty('checkedInTime', checkedInTime))
      ..add(DiagnosticsProperty('checkedOutTime', checkedOutTime))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt))
      ..add(DiagnosticsProperty('createdBy', createdBy))
      ..add(DiagnosticsProperty('metadata', metadata));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.appointmentDate, appointmentDate) ||
                other.appointmentDate == appointmentDate) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.purpose, purpose) || other.purpose == purpose) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.department, department) ||
                other.department == department) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.symptoms, symptoms) ||
                other.symptoms == symptoms) &&
            (identical(other.patientPhoneNumber, patientPhoneNumber) ||
                other.patientPhoneNumber == patientPhoneNumber) &&
            (identical(other.doctorSpecialty, doctorSpecialty) ||
                other.doctorSpecialty == doctorSpecialty) &&
            (identical(other.isVirtual, isVirtual) ||
                other.isVirtual == isVirtual) &&
            (identical(other.virtualMeetingLink, virtualMeetingLink) ||
                other.virtualMeetingLink == virtualMeetingLink) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.checkedInTime, checkedInTime) ||
                other.checkedInTime == checkedInTime) &&
            (identical(other.checkedOutTime, checkedOutTime) ||
                other.checkedOutTime == checkedOutTime) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        patientId,
        patientName,
        doctorId,
        doctorName,
        appointmentDate,
        time,
        purpose,
        status,
        type,
        notes,
        location,
        department,
        duration,
        symptoms,
        patientPhoneNumber,
        doctorSpecialty,
        isVirtual,
        virtualMeetingLink,
        const DeepCollectionEquality().hash(_attachments),
        checkedInTime,
        checkedOutTime,
        createdAt,
        updatedAt,
        createdBy,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      __$$AppointmentImplCopyWithImpl<_$AppointmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentImplToJson(
      this,
    );
  }
}

abstract class _Appointment extends Appointment {
  const factory _Appointment(
      {required final String id,
      required final String patientId,
      required final String patientName,
      required final String doctorId,
      required final String doctorName,
      required final DateTime appointmentDate,
      required final String time,
      required final String purpose,
      final AppointmentStatus status,
      final AppointmentType type,
      final String? notes,
      final String? location,
      final String? department,
      final int? duration,
      final String? symptoms,
      final String? patientPhoneNumber,
      final String? doctorSpecialty,
      final bool? isVirtual,
      final String? virtualMeetingLink,
      final List<String>? attachments,
      final DateTime? checkedInTime,
      final DateTime? checkedOutTime,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      final String? createdBy,
      final Map<String, dynamic>? metadata}) = _$AppointmentImpl;
  const _Appointment._() : super._();

  factory _Appointment.fromJson(Map<String, dynamic> json) =
      _$AppointmentImpl.fromJson;

  @override
  String get id;
  @override
  String get patientId;
  @override
  String get patientName;
  @override
  String get doctorId;
  @override
  String get doctorName;
  @override
  DateTime get appointmentDate;
  @override
  String get time;
  @override
  String get purpose;
  @override
  AppointmentStatus get status;
  @override
  AppointmentType get type;
  @override
  String? get notes;
  @override
  String? get location;
  @override
  String? get department;
  @override
  int? get duration;
  @override
  String? get symptoms;
  @override
  String? get patientPhoneNumber;
  @override
  String? get doctorSpecialty;
  @override
  bool? get isVirtual;
  @override
  String? get virtualMeetingLink;
  @override
  List<String>? get attachments;
  @override
  DateTime? get checkedInTime;
  @override
  DateTime? get checkedOutTime;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  String? get createdBy;
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of Appointment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentImplCopyWith<_$AppointmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AppointmentSlot _$AppointmentSlotFromJson(Map<String, dynamic> json) {
  return _AppointmentSlot.fromJson(json);
}

/// @nodoc
mixin _$AppointmentSlot {
  String get id => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  bool get isAvailable => throw _privateConstructorUsedError;
  String? get appointmentId => throw _privateConstructorUsedError;
  String? get patientId => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this AppointmentSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AppointmentSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppointmentSlotCopyWith<AppointmentSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppointmentSlotCopyWith<$Res> {
  factory $AppointmentSlotCopyWith(
          AppointmentSlot value, $Res Function(AppointmentSlot) then) =
      _$AppointmentSlotCopyWithImpl<$Res, AppointmentSlot>;
  @useResult
  $Res call(
      {String id,
      String doctorId,
      DateTime date,
      String startTime,
      String endTime,
      bool isAvailable,
      String? appointmentId,
      String? patientId,
      String? notes});
}

/// @nodoc
class _$AppointmentSlotCopyWithImpl<$Res, $Val extends AppointmentSlot>
    implements $AppointmentSlotCopyWith<$Res> {
  _$AppointmentSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppointmentSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? doctorId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? appointmentId = freezed,
    Object? patientId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      appointmentId: freezed == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      patientId: freezed == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppointmentSlotImplCopyWith<$Res>
    implements $AppointmentSlotCopyWith<$Res> {
  factory _$$AppointmentSlotImplCopyWith(_$AppointmentSlotImpl value,
          $Res Function(_$AppointmentSlotImpl) then) =
      __$$AppointmentSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String doctorId,
      DateTime date,
      String startTime,
      String endTime,
      bool isAvailable,
      String? appointmentId,
      String? patientId,
      String? notes});
}

/// @nodoc
class __$$AppointmentSlotImplCopyWithImpl<$Res>
    extends _$AppointmentSlotCopyWithImpl<$Res, _$AppointmentSlotImpl>
    implements _$$AppointmentSlotImplCopyWith<$Res> {
  __$$AppointmentSlotImplCopyWithImpl(
      _$AppointmentSlotImpl _value, $Res Function(_$AppointmentSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppointmentSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? doctorId = null,
    Object? date = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? isAvailable = null,
    Object? appointmentId = freezed,
    Object? patientId = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$AppointmentSlotImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      isAvailable: null == isAvailable
          ? _value.isAvailable
          : isAvailable // ignore: cast_nullable_to_non_nullable
              as bool,
      appointmentId: freezed == appointmentId
          ? _value.appointmentId
          : appointmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      patientId: freezed == patientId
          ? _value.patientId
          : patientId // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AppointmentSlotImpl
    with DiagnosticableTreeMixin
    implements _AppointmentSlot {
  const _$AppointmentSlotImpl(
      {required this.id,
      required this.doctorId,
      required this.date,
      required this.startTime,
      required this.endTime,
      this.isAvailable = true,
      this.appointmentId,
      this.patientId,
      this.notes});

  factory _$AppointmentSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$AppointmentSlotImplFromJson(json);

  @override
  final String id;
  @override
  final String doctorId;
  @override
  final DateTime date;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  @JsonKey()
  final bool isAvailable;
  @override
  final String? appointmentId;
  @override
  final String? patientId;
  @override
  final String? notes;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AppointmentSlot(id: $id, doctorId: $doctorId, date: $date, startTime: $startTime, endTime: $endTime, isAvailable: $isAvailable, appointmentId: $appointmentId, patientId: $patientId, notes: $notes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AppointmentSlot'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('doctorId', doctorId))
      ..add(DiagnosticsProperty('date', date))
      ..add(DiagnosticsProperty('startTime', startTime))
      ..add(DiagnosticsProperty('endTime', endTime))
      ..add(DiagnosticsProperty('isAvailable', isAvailable))
      ..add(DiagnosticsProperty('appointmentId', appointmentId))
      ..add(DiagnosticsProperty('patientId', patientId))
      ..add(DiagnosticsProperty('notes', notes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppointmentSlotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.isAvailable, isAvailable) ||
                other.isAvailable == isAvailable) &&
            (identical(other.appointmentId, appointmentId) ||
                other.appointmentId == appointmentId) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, doctorId, date, startTime,
      endTime, isAvailable, appointmentId, patientId, notes);

  /// Create a copy of AppointmentSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppointmentSlotImplCopyWith<_$AppointmentSlotImpl> get copyWith =>
      __$$AppointmentSlotImplCopyWithImpl<_$AppointmentSlotImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AppointmentSlotImplToJson(
      this,
    );
  }
}

abstract class _AppointmentSlot implements AppointmentSlot {
  const factory _AppointmentSlot(
      {required final String id,
      required final String doctorId,
      required final DateTime date,
      required final String startTime,
      required final String endTime,
      final bool isAvailable,
      final String? appointmentId,
      final String? patientId,
      final String? notes}) = _$AppointmentSlotImpl;

  factory _AppointmentSlot.fromJson(Map<String, dynamic> json) =
      _$AppointmentSlotImpl.fromJson;

  @override
  String get id;
  @override
  String get doctorId;
  @override
  DateTime get date;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  bool get isAvailable;
  @override
  String? get appointmentId;
  @override
  String? get patientId;
  @override
  String? get notes;

  /// Create a copy of AppointmentSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppointmentSlotImplCopyWith<_$AppointmentSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
