// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clinical_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClinicalFile _$ClinicalFileFromJson(Map<String, dynamic> json) {
  return _ClinicalFile.fromJson(json);
}

/// @nodoc
mixin _$ClinicalFile {
  String get id => throw _privateConstructorUsedError;
  String get patientId => throw _privateConstructorUsedError;
  String get patientName => throw _privateConstructorUsedError;
  String? get medicalCondition => throw _privateConstructorUsedError;
  String? get bloodType => throw _privateConstructorUsedError;
  Map<String, dynamic>? get vitals => throw _privateConstructorUsedError;
  List<Diagnostic> get diagnostics => throw _privateConstructorUsedError;
  List<Treatment> get treatments => throw _privateConstructorUsedError;
  List<LabResult> get labResults => throw _privateConstructorUsedError;
  List<MedicalNote> get medicalNotes => throw _privateConstructorUsedError;
  List<Prescription> get prescriptions => throw _privateConstructorUsedError;
  List<Surgery> get surgeries => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClinicalFile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClinicalFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClinicalFileCopyWith<ClinicalFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClinicalFileCopyWith<$Res> {
  factory $ClinicalFileCopyWith(
          ClinicalFile value, $Res Function(ClinicalFile) then) =
      _$ClinicalFileCopyWithImpl<$Res, ClinicalFile>;
  @useResult
  $Res call(
      {String id,
      String patientId,
      String patientName,
      String? medicalCondition,
      String? bloodType,
      Map<String, dynamic>? vitals,
      List<Diagnostic> diagnostics,
      List<Treatment> treatments,
      List<LabResult> labResults,
      List<MedicalNote> medicalNotes,
      List<Prescription> prescriptions,
      List<Surgery> surgeries,
      DateTime? lastUpdated,
      DateTime? createdAt});
}

/// @nodoc
class _$ClinicalFileCopyWithImpl<$Res, $Val extends ClinicalFile>
    implements $ClinicalFileCopyWith<$Res> {
  _$ClinicalFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClinicalFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? medicalCondition = freezed,
    Object? bloodType = freezed,
    Object? vitals = freezed,
    Object? diagnostics = null,
    Object? treatments = null,
    Object? labResults = null,
    Object? medicalNotes = null,
    Object? prescriptions = null,
    Object? surgeries = null,
    Object? lastUpdated = freezed,
    Object? createdAt = freezed,
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
      medicalCondition: freezed == medicalCondition
          ? _value.medicalCondition
          : medicalCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      vitals: freezed == vitals
          ? _value.vitals
          : vitals // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      diagnostics: null == diagnostics
          ? _value.diagnostics
          : diagnostics // ignore: cast_nullable_to_non_nullable
              as List<Diagnostic>,
      treatments: null == treatments
          ? _value.treatments
          : treatments // ignore: cast_nullable_to_non_nullable
              as List<Treatment>,
      labResults: null == labResults
          ? _value.labResults
          : labResults // ignore: cast_nullable_to_non_nullable
              as List<LabResult>,
      medicalNotes: null == medicalNotes
          ? _value.medicalNotes
          : medicalNotes // ignore: cast_nullable_to_non_nullable
              as List<MedicalNote>,
      prescriptions: null == prescriptions
          ? _value.prescriptions
          : prescriptions // ignore: cast_nullable_to_non_nullable
              as List<Prescription>,
      surgeries: null == surgeries
          ? _value.surgeries
          : surgeries // ignore: cast_nullable_to_non_nullable
              as List<Surgery>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClinicalFileImplCopyWith<$Res>
    implements $ClinicalFileCopyWith<$Res> {
  factory _$$ClinicalFileImplCopyWith(
          _$ClinicalFileImpl value, $Res Function(_$ClinicalFileImpl) then) =
      __$$ClinicalFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String patientId,
      String patientName,
      String? medicalCondition,
      String? bloodType,
      Map<String, dynamic>? vitals,
      List<Diagnostic> diagnostics,
      List<Treatment> treatments,
      List<LabResult> labResults,
      List<MedicalNote> medicalNotes,
      List<Prescription> prescriptions,
      List<Surgery> surgeries,
      DateTime? lastUpdated,
      DateTime? createdAt});
}

/// @nodoc
class __$$ClinicalFileImplCopyWithImpl<$Res>
    extends _$ClinicalFileCopyWithImpl<$Res, _$ClinicalFileImpl>
    implements _$$ClinicalFileImplCopyWith<$Res> {
  __$$ClinicalFileImplCopyWithImpl(
      _$ClinicalFileImpl _value, $Res Function(_$ClinicalFileImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClinicalFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientId = null,
    Object? patientName = null,
    Object? medicalCondition = freezed,
    Object? bloodType = freezed,
    Object? vitals = freezed,
    Object? diagnostics = null,
    Object? treatments = null,
    Object? labResults = null,
    Object? medicalNotes = null,
    Object? prescriptions = null,
    Object? surgeries = null,
    Object? lastUpdated = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ClinicalFileImpl(
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
      medicalCondition: freezed == medicalCondition
          ? _value.medicalCondition
          : medicalCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      bloodType: freezed == bloodType
          ? _value.bloodType
          : bloodType // ignore: cast_nullable_to_non_nullable
              as String?,
      vitals: freezed == vitals
          ? _value._vitals
          : vitals // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      diagnostics: null == diagnostics
          ? _value._diagnostics
          : diagnostics // ignore: cast_nullable_to_non_nullable
              as List<Diagnostic>,
      treatments: null == treatments
          ? _value._treatments
          : treatments // ignore: cast_nullable_to_non_nullable
              as List<Treatment>,
      labResults: null == labResults
          ? _value._labResults
          : labResults // ignore: cast_nullable_to_non_nullable
              as List<LabResult>,
      medicalNotes: null == medicalNotes
          ? _value._medicalNotes
          : medicalNotes // ignore: cast_nullable_to_non_nullable
              as List<MedicalNote>,
      prescriptions: null == prescriptions
          ? _value._prescriptions
          : prescriptions // ignore: cast_nullable_to_non_nullable
              as List<Prescription>,
      surgeries: null == surgeries
          ? _value._surgeries
          : surgeries // ignore: cast_nullable_to_non_nullable
              as List<Surgery>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClinicalFileImpl implements _ClinicalFile {
  const _$ClinicalFileImpl(
      {required this.id,
      required this.patientId,
      required this.patientName,
      this.medicalCondition,
      this.bloodType,
      final Map<String, dynamic>? vitals,
      final List<Diagnostic> diagnostics = const [],
      final List<Treatment> treatments = const [],
      final List<LabResult> labResults = const [],
      final List<MedicalNote> medicalNotes = const [],
      final List<Prescription> prescriptions = const [],
      final List<Surgery> surgeries = const [],
      this.lastUpdated,
      this.createdAt})
      : _vitals = vitals,
        _diagnostics = diagnostics,
        _treatments = treatments,
        _labResults = labResults,
        _medicalNotes = medicalNotes,
        _prescriptions = prescriptions,
        _surgeries = surgeries;

  factory _$ClinicalFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClinicalFileImplFromJson(json);

  @override
  final String id;
  @override
  final String patientId;
  @override
  final String patientName;
  @override
  final String? medicalCondition;
  @override
  final String? bloodType;
  final Map<String, dynamic>? _vitals;
  @override
  Map<String, dynamic>? get vitals {
    final value = _vitals;
    if (value == null) return null;
    if (_vitals is EqualUnmodifiableMapView) return _vitals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Diagnostic> _diagnostics;
  @override
  @JsonKey()
  List<Diagnostic> get diagnostics {
    if (_diagnostics is EqualUnmodifiableListView) return _diagnostics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diagnostics);
  }

  final List<Treatment> _treatments;
  @override
  @JsonKey()
  List<Treatment> get treatments {
    if (_treatments is EqualUnmodifiableListView) return _treatments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_treatments);
  }

  final List<LabResult> _labResults;
  @override
  @JsonKey()
  List<LabResult> get labResults {
    if (_labResults is EqualUnmodifiableListView) return _labResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labResults);
  }

  final List<MedicalNote> _medicalNotes;
  @override
  @JsonKey()
  List<MedicalNote> get medicalNotes {
    if (_medicalNotes is EqualUnmodifiableListView) return _medicalNotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_medicalNotes);
  }

  final List<Prescription> _prescriptions;
  @override
  @JsonKey()
  List<Prescription> get prescriptions {
    if (_prescriptions is EqualUnmodifiableListView) return _prescriptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prescriptions);
  }

  final List<Surgery> _surgeries;
  @override
  @JsonKey()
  List<Surgery> get surgeries {
    if (_surgeries is EqualUnmodifiableListView) return _surgeries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_surgeries);
  }

  @override
  final DateTime? lastUpdated;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ClinicalFile(id: $id, patientId: $patientId, patientName: $patientName, medicalCondition: $medicalCondition, bloodType: $bloodType, vitals: $vitals, diagnostics: $diagnostics, treatments: $treatments, labResults: $labResults, medicalNotes: $medicalNotes, prescriptions: $prescriptions, surgeries: $surgeries, lastUpdated: $lastUpdated, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClinicalFileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientId, patientId) ||
                other.patientId == patientId) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.medicalCondition, medicalCondition) ||
                other.medicalCondition == medicalCondition) &&
            (identical(other.bloodType, bloodType) ||
                other.bloodType == bloodType) &&
            const DeepCollectionEquality().equals(other._vitals, _vitals) &&
            const DeepCollectionEquality()
                .equals(other._diagnostics, _diagnostics) &&
            const DeepCollectionEquality()
                .equals(other._treatments, _treatments) &&
            const DeepCollectionEquality()
                .equals(other._labResults, _labResults) &&
            const DeepCollectionEquality()
                .equals(other._medicalNotes, _medicalNotes) &&
            const DeepCollectionEquality()
                .equals(other._prescriptions, _prescriptions) &&
            const DeepCollectionEquality()
                .equals(other._surgeries, _surgeries) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      patientId,
      patientName,
      medicalCondition,
      bloodType,
      const DeepCollectionEquality().hash(_vitals),
      const DeepCollectionEquality().hash(_diagnostics),
      const DeepCollectionEquality().hash(_treatments),
      const DeepCollectionEquality().hash(_labResults),
      const DeepCollectionEquality().hash(_medicalNotes),
      const DeepCollectionEquality().hash(_prescriptions),
      const DeepCollectionEquality().hash(_surgeries),
      lastUpdated,
      createdAt);

  /// Create a copy of ClinicalFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClinicalFileImplCopyWith<_$ClinicalFileImpl> get copyWith =>
      __$$ClinicalFileImplCopyWithImpl<_$ClinicalFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClinicalFileImplToJson(
      this,
    );
  }
}

abstract class _ClinicalFile implements ClinicalFile {
  const factory _ClinicalFile(
      {required final String id,
      required final String patientId,
      required final String patientName,
      final String? medicalCondition,
      final String? bloodType,
      final Map<String, dynamic>? vitals,
      final List<Diagnostic> diagnostics,
      final List<Treatment> treatments,
      final List<LabResult> labResults,
      final List<MedicalNote> medicalNotes,
      final List<Prescription> prescriptions,
      final List<Surgery> surgeries,
      final DateTime? lastUpdated,
      final DateTime? createdAt}) = _$ClinicalFileImpl;

  factory _ClinicalFile.fromJson(Map<String, dynamic> json) =
      _$ClinicalFileImpl.fromJson;

  @override
  String get id;
  @override
  String get patientId;
  @override
  String get patientName;
  @override
  String? get medicalCondition;
  @override
  String? get bloodType;
  @override
  Map<String, dynamic>? get vitals;
  @override
  List<Diagnostic> get diagnostics;
  @override
  List<Treatment> get treatments;
  @override
  List<LabResult> get labResults;
  @override
  List<MedicalNote> get medicalNotes;
  @override
  List<Prescription> get prescriptions;
  @override
  List<Surgery> get surgeries;
  @override
  DateTime? get lastUpdated;
  @override
  DateTime? get createdAt;

  /// Create a copy of ClinicalFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClinicalFileImplCopyWith<_$ClinicalFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Vitals _$VitalsFromJson(Map<String, dynamic> json) {
  return _Vitals.fromJson(json);
}

/// @nodoc
mixin _$Vitals {
  String get heartRate => throw _privateConstructorUsedError;
  String get bloodPressure => throw _privateConstructorUsedError;
  String get temperature => throw _privateConstructorUsedError;
  String get oxygenSaturation => throw _privateConstructorUsedError;
  String? get respiratoryRate => throw _privateConstructorUsedError;
  String? get weight => throw _privateConstructorUsedError;
  String? get height => throw _privateConstructorUsedError;
  String? get bmi => throw _privateConstructorUsedError;
  String? get pain => throw _privateConstructorUsedError;
  DateTime? get lastMeasured => throw _privateConstructorUsedError;

  /// Serializes this Vitals to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Vitals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VitalsCopyWith<Vitals> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VitalsCopyWith<$Res> {
  factory $VitalsCopyWith(Vitals value, $Res Function(Vitals) then) =
      _$VitalsCopyWithImpl<$Res, Vitals>;
  @useResult
  $Res call(
      {String heartRate,
      String bloodPressure,
      String temperature,
      String oxygenSaturation,
      String? respiratoryRate,
      String? weight,
      String? height,
      String? bmi,
      String? pain,
      DateTime? lastMeasured});
}

/// @nodoc
class _$VitalsCopyWithImpl<$Res, $Val extends Vitals>
    implements $VitalsCopyWith<$Res> {
  _$VitalsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Vitals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heartRate = null,
    Object? bloodPressure = null,
    Object? temperature = null,
    Object? oxygenSaturation = null,
    Object? respiratoryRate = freezed,
    Object? weight = freezed,
    Object? height = freezed,
    Object? bmi = freezed,
    Object? pain = freezed,
    Object? lastMeasured = freezed,
  }) {
    return _then(_value.copyWith(
      heartRate: null == heartRate
          ? _value.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as String,
      bloodPressure: null == bloodPressure
          ? _value.bloodPressure
          : bloodPressure // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as String,
      oxygenSaturation: null == oxygenSaturation
          ? _value.oxygenSaturation
          : oxygenSaturation // ignore: cast_nullable_to_non_nullable
              as String,
      respiratoryRate: freezed == respiratoryRate
          ? _value.respiratoryRate
          : respiratoryRate // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as String?,
      bmi: freezed == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as String?,
      pain: freezed == pain
          ? _value.pain
          : pain // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMeasured: freezed == lastMeasured
          ? _value.lastMeasured
          : lastMeasured // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VitalsImplCopyWith<$Res> implements $VitalsCopyWith<$Res> {
  factory _$$VitalsImplCopyWith(
          _$VitalsImpl value, $Res Function(_$VitalsImpl) then) =
      __$$VitalsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String heartRate,
      String bloodPressure,
      String temperature,
      String oxygenSaturation,
      String? respiratoryRate,
      String? weight,
      String? height,
      String? bmi,
      String? pain,
      DateTime? lastMeasured});
}

/// @nodoc
class __$$VitalsImplCopyWithImpl<$Res>
    extends _$VitalsCopyWithImpl<$Res, _$VitalsImpl>
    implements _$$VitalsImplCopyWith<$Res> {
  __$$VitalsImplCopyWithImpl(
      _$VitalsImpl _value, $Res Function(_$VitalsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Vitals
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heartRate = null,
    Object? bloodPressure = null,
    Object? temperature = null,
    Object? oxygenSaturation = null,
    Object? respiratoryRate = freezed,
    Object? weight = freezed,
    Object? height = freezed,
    Object? bmi = freezed,
    Object? pain = freezed,
    Object? lastMeasured = freezed,
  }) {
    return _then(_$VitalsImpl(
      heartRate: null == heartRate
          ? _value.heartRate
          : heartRate // ignore: cast_nullable_to_non_nullable
              as String,
      bloodPressure: null == bloodPressure
          ? _value.bloodPressure
          : bloodPressure // ignore: cast_nullable_to_non_nullable
              as String,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as String,
      oxygenSaturation: null == oxygenSaturation
          ? _value.oxygenSaturation
          : oxygenSaturation // ignore: cast_nullable_to_non_nullable
              as String,
      respiratoryRate: freezed == respiratoryRate
          ? _value.respiratoryRate
          : respiratoryRate // ignore: cast_nullable_to_non_nullable
              as String?,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as String?,
      height: freezed == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as String?,
      bmi: freezed == bmi
          ? _value.bmi
          : bmi // ignore: cast_nullable_to_non_nullable
              as String?,
      pain: freezed == pain
          ? _value.pain
          : pain // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMeasured: freezed == lastMeasured
          ? _value.lastMeasured
          : lastMeasured // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VitalsImpl implements _Vitals {
  const _$VitalsImpl(
      {required this.heartRate,
      required this.bloodPressure,
      required this.temperature,
      required this.oxygenSaturation,
      this.respiratoryRate,
      this.weight,
      this.height,
      this.bmi,
      this.pain,
      this.lastMeasured});

  factory _$VitalsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VitalsImplFromJson(json);

  @override
  final String heartRate;
  @override
  final String bloodPressure;
  @override
  final String temperature;
  @override
  final String oxygenSaturation;
  @override
  final String? respiratoryRate;
  @override
  final String? weight;
  @override
  final String? height;
  @override
  final String? bmi;
  @override
  final String? pain;
  @override
  final DateTime? lastMeasured;

  @override
  String toString() {
    return 'Vitals(heartRate: $heartRate, bloodPressure: $bloodPressure, temperature: $temperature, oxygenSaturation: $oxygenSaturation, respiratoryRate: $respiratoryRate, weight: $weight, height: $height, bmi: $bmi, pain: $pain, lastMeasured: $lastMeasured)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VitalsImpl &&
            (identical(other.heartRate, heartRate) ||
                other.heartRate == heartRate) &&
            (identical(other.bloodPressure, bloodPressure) ||
                other.bloodPressure == bloodPressure) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.oxygenSaturation, oxygenSaturation) ||
                other.oxygenSaturation == oxygenSaturation) &&
            (identical(other.respiratoryRate, respiratoryRate) ||
                other.respiratoryRate == respiratoryRate) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.bmi, bmi) || other.bmi == bmi) &&
            (identical(other.pain, pain) || other.pain == pain) &&
            (identical(other.lastMeasured, lastMeasured) ||
                other.lastMeasured == lastMeasured));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      heartRate,
      bloodPressure,
      temperature,
      oxygenSaturation,
      respiratoryRate,
      weight,
      height,
      bmi,
      pain,
      lastMeasured);

  /// Create a copy of Vitals
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VitalsImplCopyWith<_$VitalsImpl> get copyWith =>
      __$$VitalsImplCopyWithImpl<_$VitalsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VitalsImplToJson(
      this,
    );
  }
}

abstract class _Vitals implements Vitals {
  const factory _Vitals(
      {required final String heartRate,
      required final String bloodPressure,
      required final String temperature,
      required final String oxygenSaturation,
      final String? respiratoryRate,
      final String? weight,
      final String? height,
      final String? bmi,
      final String? pain,
      final DateTime? lastMeasured}) = _$VitalsImpl;

  factory _Vitals.fromJson(Map<String, dynamic> json) = _$VitalsImpl.fromJson;

  @override
  String get heartRate;
  @override
  String get bloodPressure;
  @override
  String get temperature;
  @override
  String get oxygenSaturation;
  @override
  String? get respiratoryRate;
  @override
  String? get weight;
  @override
  String? get height;
  @override
  String? get bmi;
  @override
  String? get pain;
  @override
  DateTime? get lastMeasured;

  /// Create a copy of Vitals
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VitalsImplCopyWith<_$VitalsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Diagnostic _$DiagnosticFromJson(Map<String, dynamic> json) {
  return _Diagnostic.fromJson(json);
}

/// @nodoc
mixin _$Diagnostic {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  String get doctorName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get diagnosisType => throw _privateConstructorUsedError;
  String? get severity => throw _privateConstructorUsedError;
  String? get icdCode => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get symptoms => throw _privateConstructorUsedError;
  List<String>? get testResults => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;

  /// Serializes this Diagnostic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiagnosticCopyWith<Diagnostic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiagnosticCopyWith<$Res> {
  factory $DiagnosticCopyWith(
          Diagnostic value, $Res Function(Diagnostic) then) =
      _$DiagnosticCopyWithImpl<$Res, Diagnostic>;
  @useResult
  $Res call(
      {String id,
      String description,
      String doctorId,
      String doctorName,
      DateTime date,
      String? diagnosisType,
      String? severity,
      String? icdCode,
      String? notes,
      List<String>? symptoms,
      List<String>? testResults,
      List<String>? attachments});
}

/// @nodoc
class _$DiagnosticCopyWithImpl<$Res, $Val extends Diagnostic>
    implements $DiagnosticCopyWith<$Res> {
  _$DiagnosticCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? date = null,
    Object? diagnosisType = freezed,
    Object? severity = freezed,
    Object? icdCode = freezed,
    Object? notes = freezed,
    Object? symptoms = freezed,
    Object? testResults = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diagnosisType: freezed == diagnosisType
          ? _value.diagnosisType
          : diagnosisType // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
      icdCode: freezed == icdCode
          ? _value.icdCode
          : icdCode // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      symptoms: freezed == symptoms
          ? _value.symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      testResults: freezed == testResults
          ? _value.testResults
          : testResults // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiagnosticImplCopyWith<$Res>
    implements $DiagnosticCopyWith<$Res> {
  factory _$$DiagnosticImplCopyWith(
          _$DiagnosticImpl value, $Res Function(_$DiagnosticImpl) then) =
      __$$DiagnosticImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      String doctorId,
      String doctorName,
      DateTime date,
      String? diagnosisType,
      String? severity,
      String? icdCode,
      String? notes,
      List<String>? symptoms,
      List<String>? testResults,
      List<String>? attachments});
}

/// @nodoc
class __$$DiagnosticImplCopyWithImpl<$Res>
    extends _$DiagnosticCopyWithImpl<$Res, _$DiagnosticImpl>
    implements _$$DiagnosticImplCopyWith<$Res> {
  __$$DiagnosticImplCopyWithImpl(
      _$DiagnosticImpl _value, $Res Function(_$DiagnosticImpl) _then)
      : super(_value, _then);

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? date = null,
    Object? diagnosisType = freezed,
    Object? severity = freezed,
    Object? icdCode = freezed,
    Object? notes = freezed,
    Object? symptoms = freezed,
    Object? testResults = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_$DiagnosticImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      diagnosisType: freezed == diagnosisType
          ? _value.diagnosisType
          : diagnosisType // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String?,
      icdCode: freezed == icdCode
          ? _value.icdCode
          : icdCode // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      symptoms: freezed == symptoms
          ? _value._symptoms
          : symptoms // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      testResults: freezed == testResults
          ? _value._testResults
          : testResults // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DiagnosticImpl implements _Diagnostic {
  const _$DiagnosticImpl(
      {required this.id,
      required this.description,
      required this.doctorId,
      required this.doctorName,
      required this.date,
      this.diagnosisType,
      this.severity,
      this.icdCode,
      this.notes,
      final List<String>? symptoms,
      final List<String>? testResults,
      final List<String>? attachments})
      : _symptoms = symptoms,
        _testResults = testResults,
        _attachments = attachments;

  factory _$DiagnosticImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiagnosticImplFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final String doctorId;
  @override
  final String doctorName;
  @override
  final DateTime date;
  @override
  final String? diagnosisType;
  @override
  final String? severity;
  @override
  final String? icdCode;
  @override
  final String? notes;
  final List<String>? _symptoms;
  @override
  List<String>? get symptoms {
    final value = _symptoms;
    if (value == null) return null;
    if (_symptoms is EqualUnmodifiableListView) return _symptoms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _testResults;
  @override
  List<String>? get testResults {
    final value = _testResults;
    if (value == null) return null;
    if (_testResults is EqualUnmodifiableListView) return _testResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  String toString() {
    return 'Diagnostic(id: $id, description: $description, doctorId: $doctorId, doctorName: $doctorName, date: $date, diagnosisType: $diagnosisType, severity: $severity, icdCode: $icdCode, notes: $notes, symptoms: $symptoms, testResults: $testResults, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiagnosticImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.diagnosisType, diagnosisType) ||
                other.diagnosisType == diagnosisType) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.icdCode, icdCode) || other.icdCode == icdCode) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality().equals(other._symptoms, _symptoms) &&
            const DeepCollectionEquality()
                .equals(other._testResults, _testResults) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      doctorId,
      doctorName,
      date,
      diagnosisType,
      severity,
      icdCode,
      notes,
      const DeepCollectionEquality().hash(_symptoms),
      const DeepCollectionEquality().hash(_testResults),
      const DeepCollectionEquality().hash(_attachments));

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiagnosticImplCopyWith<_$DiagnosticImpl> get copyWith =>
      __$$DiagnosticImplCopyWithImpl<_$DiagnosticImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiagnosticImplToJson(
      this,
    );
  }
}

abstract class _Diagnostic implements Diagnostic {
  const factory _Diagnostic(
      {required final String id,
      required final String description,
      required final String doctorId,
      required final String doctorName,
      required final DateTime date,
      final String? diagnosisType,
      final String? severity,
      final String? icdCode,
      final String? notes,
      final List<String>? symptoms,
      final List<String>? testResults,
      final List<String>? attachments}) = _$DiagnosticImpl;

  factory _Diagnostic.fromJson(Map<String, dynamic> json) =
      _$DiagnosticImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  String get doctorId;
  @override
  String get doctorName;
  @override
  DateTime get date;
  @override
  String? get diagnosisType;
  @override
  String? get severity;
  @override
  String? get icdCode;
  @override
  String? get notes;
  @override
  List<String>? get symptoms;
  @override
  List<String>? get testResults;
  @override
  List<String>? get attachments;

  /// Create a copy of Diagnostic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiagnosticImplCopyWith<_$DiagnosticImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Treatment _$TreatmentFromJson(Map<String, dynamic> json) {
  return _Treatment.fromJson(json);
}

/// @nodoc
mixin _$Treatment {
  String get id => throw _privateConstructorUsedError;
  String get medication => throw _privateConstructorUsedError;
  String get dosage => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  String get doctorName => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get treatmentType => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get frequency => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  String? get sideEffects => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool? get isCompleted => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;

  /// Serializes this Treatment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Treatment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TreatmentCopyWith<Treatment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TreatmentCopyWith<$Res> {
  factory $TreatmentCopyWith(Treatment value, $Res Function(Treatment) then) =
      _$TreatmentCopyWithImpl<$Res, Treatment>;
  @useResult
  $Res call(
      {String id,
      String medication,
      String dosage,
      String description,
      String doctorId,
      String doctorName,
      DateTime date,
      String? treatmentType,
      String? duration,
      String? frequency,
      String? instructions,
      String? sideEffects,
      String? notes,
      DateTime? startDate,
      DateTime? endDate,
      bool? isCompleted,
      List<String>? attachments});
}

/// @nodoc
class _$TreatmentCopyWithImpl<$Res, $Val extends Treatment>
    implements $TreatmentCopyWith<$Res> {
  _$TreatmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Treatment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medication = null,
    Object? dosage = null,
    Object? description = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? date = null,
    Object? treatmentType = freezed,
    Object? duration = freezed,
    Object? frequency = freezed,
    Object? instructions = freezed,
    Object? sideEffects = freezed,
    Object? notes = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCompleted = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medication: null == medication
          ? _value.medication
          : medication // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      treatmentType: freezed == treatmentType
          ? _value.treatmentType
          : treatmentType // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      sideEffects: freezed == sideEffects
          ? _value.sideEffects
          : sideEffects // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TreatmentImplCopyWith<$Res>
    implements $TreatmentCopyWith<$Res> {
  factory _$$TreatmentImplCopyWith(
          _$TreatmentImpl value, $Res Function(_$TreatmentImpl) then) =
      __$$TreatmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String medication,
      String dosage,
      String description,
      String doctorId,
      String doctorName,
      DateTime date,
      String? treatmentType,
      String? duration,
      String? frequency,
      String? instructions,
      String? sideEffects,
      String? notes,
      DateTime? startDate,
      DateTime? endDate,
      bool? isCompleted,
      List<String>? attachments});
}

/// @nodoc
class __$$TreatmentImplCopyWithImpl<$Res>
    extends _$TreatmentCopyWithImpl<$Res, _$TreatmentImpl>
    implements _$$TreatmentImplCopyWith<$Res> {
  __$$TreatmentImplCopyWithImpl(
      _$TreatmentImpl _value, $Res Function(_$TreatmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Treatment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medication = null,
    Object? dosage = null,
    Object? description = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? date = null,
    Object? treatmentType = freezed,
    Object? duration = freezed,
    Object? frequency = freezed,
    Object? instructions = freezed,
    Object? sideEffects = freezed,
    Object? notes = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCompleted = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_$TreatmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medication: null == medication
          ? _value.medication
          : medication // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      treatmentType: freezed == treatmentType
          ? _value.treatmentType
          : treatmentType // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      frequency: freezed == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      sideEffects: freezed == sideEffects
          ? _value.sideEffects
          : sideEffects // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCompleted: freezed == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TreatmentImpl implements _Treatment {
  const _$TreatmentImpl(
      {required this.id,
      required this.medication,
      required this.dosage,
      required this.description,
      required this.doctorId,
      required this.doctorName,
      required this.date,
      this.treatmentType,
      this.duration,
      this.frequency,
      this.instructions,
      this.sideEffects,
      this.notes,
      this.startDate,
      this.endDate,
      this.isCompleted,
      final List<String>? attachments})
      : _attachments = attachments;

  factory _$TreatmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$TreatmentImplFromJson(json);

  @override
  final String id;
  @override
  final String medication;
  @override
  final String dosage;
  @override
  final String description;
  @override
  final String doctorId;
  @override
  final String doctorName;
  @override
  final DateTime date;
  @override
  final String? treatmentType;
  @override
  final String? duration;
  @override
  final String? frequency;
  @override
  final String? instructions;
  @override
  final String? sideEffects;
  @override
  final String? notes;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final bool? isCompleted;
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
  String toString() {
    return 'Treatment(id: $id, medication: $medication, dosage: $dosage, description: $description, doctorId: $doctorId, doctorName: $doctorName, date: $date, treatmentType: $treatmentType, duration: $duration, frequency: $frequency, instructions: $instructions, sideEffects: $sideEffects, notes: $notes, startDate: $startDate, endDate: $endDate, isCompleted: $isCompleted, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TreatmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.medication, medication) ||
                other.medication == medication) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.treatmentType, treatmentType) ||
                other.treatmentType == treatmentType) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.sideEffects, sideEffects) ||
                other.sideEffects == sideEffects) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      medication,
      dosage,
      description,
      doctorId,
      doctorName,
      date,
      treatmentType,
      duration,
      frequency,
      instructions,
      sideEffects,
      notes,
      startDate,
      endDate,
      isCompleted,
      const DeepCollectionEquality().hash(_attachments));

  /// Create a copy of Treatment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TreatmentImplCopyWith<_$TreatmentImpl> get copyWith =>
      __$$TreatmentImplCopyWithImpl<_$TreatmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TreatmentImplToJson(
      this,
    );
  }
}

abstract class _Treatment implements Treatment {
  const factory _Treatment(
      {required final String id,
      required final String medication,
      required final String dosage,
      required final String description,
      required final String doctorId,
      required final String doctorName,
      required final DateTime date,
      final String? treatmentType,
      final String? duration,
      final String? frequency,
      final String? instructions,
      final String? sideEffects,
      final String? notes,
      final DateTime? startDate,
      final DateTime? endDate,
      final bool? isCompleted,
      final List<String>? attachments}) = _$TreatmentImpl;

  factory _Treatment.fromJson(Map<String, dynamic> json) =
      _$TreatmentImpl.fromJson;

  @override
  String get id;
  @override
  String get medication;
  @override
  String get dosage;
  @override
  String get description;
  @override
  String get doctorId;
  @override
  String get doctorName;
  @override
  DateTime get date;
  @override
  String? get treatmentType;
  @override
  String? get duration;
  @override
  String? get frequency;
  @override
  String? get instructions;
  @override
  String? get sideEffects;
  @override
  String? get notes;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool? get isCompleted;
  @override
  List<String>? get attachments;

  /// Create a copy of Treatment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TreatmentImplCopyWith<_$TreatmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LabResult _$LabResultFromJson(Map<String, dynamic> json) {
  return _LabResult.fromJson(json);
}

/// @nodoc
mixin _$LabResult {
  String get id => throw _privateConstructorUsedError;
  String get testName => throw _privateConstructorUsedError;
  String get result => throw _privateConstructorUsedError;
  String get performedBy => throw _privateConstructorUsedError;
  DateTime get testDate => throw _privateConstructorUsedError;
  String? get referenceRange => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get interpretation => throw _privateConstructorUsedError;
  String? get labName => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;
  bool? get isAbnormal => throw _privateConstructorUsedError;

  /// Serializes this LabResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LabResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LabResultCopyWith<LabResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LabResultCopyWith<$Res> {
  factory $LabResultCopyWith(LabResult value, $Res Function(LabResult) then) =
      _$LabResultCopyWithImpl<$Res, LabResult>;
  @useResult
  $Res call(
      {String id,
      String testName,
      String result,
      String performedBy,
      DateTime testDate,
      String? referenceRange,
      String? unit,
      String? interpretation,
      String? labName,
      String? notes,
      List<String>? attachments,
      bool? isAbnormal});
}

/// @nodoc
class _$LabResultCopyWithImpl<$Res, $Val extends LabResult>
    implements $LabResultCopyWith<$Res> {
  _$LabResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LabResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? testName = null,
    Object? result = null,
    Object? performedBy = null,
    Object? testDate = null,
    Object? referenceRange = freezed,
    Object? unit = freezed,
    Object? interpretation = freezed,
    Object? labName = freezed,
    Object? notes = freezed,
    Object? attachments = freezed,
    Object? isAbnormal = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      testName: null == testName
          ? _value.testName
          : testName // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      testDate: null == testDate
          ? _value.testDate
          : testDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenceRange: freezed == referenceRange
          ? _value.referenceRange
          : referenceRange // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      interpretation: freezed == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      labName: freezed == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isAbnormal: freezed == isAbnormal
          ? _value.isAbnormal
          : isAbnormal // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LabResultImplCopyWith<$Res>
    implements $LabResultCopyWith<$Res> {
  factory _$$LabResultImplCopyWith(
          _$LabResultImpl value, $Res Function(_$LabResultImpl) then) =
      __$$LabResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String testName,
      String result,
      String performedBy,
      DateTime testDate,
      String? referenceRange,
      String? unit,
      String? interpretation,
      String? labName,
      String? notes,
      List<String>? attachments,
      bool? isAbnormal});
}

/// @nodoc
class __$$LabResultImplCopyWithImpl<$Res>
    extends _$LabResultCopyWithImpl<$Res, _$LabResultImpl>
    implements _$$LabResultImplCopyWith<$Res> {
  __$$LabResultImplCopyWithImpl(
      _$LabResultImpl _value, $Res Function(_$LabResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of LabResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? testName = null,
    Object? result = null,
    Object? performedBy = null,
    Object? testDate = null,
    Object? referenceRange = freezed,
    Object? unit = freezed,
    Object? interpretation = freezed,
    Object? labName = freezed,
    Object? notes = freezed,
    Object? attachments = freezed,
    Object? isAbnormal = freezed,
  }) {
    return _then(_$LabResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      testName: null == testName
          ? _value.testName
          : testName // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as String,
      performedBy: null == performedBy
          ? _value.performedBy
          : performedBy // ignore: cast_nullable_to_non_nullable
              as String,
      testDate: null == testDate
          ? _value.testDate
          : testDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      referenceRange: freezed == referenceRange
          ? _value.referenceRange
          : referenceRange // ignore: cast_nullable_to_non_nullable
              as String?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      interpretation: freezed == interpretation
          ? _value.interpretation
          : interpretation // ignore: cast_nullable_to_non_nullable
              as String?,
      labName: freezed == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isAbnormal: freezed == isAbnormal
          ? _value.isAbnormal
          : isAbnormal // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LabResultImpl implements _LabResult {
  const _$LabResultImpl(
      {required this.id,
      required this.testName,
      required this.result,
      required this.performedBy,
      required this.testDate,
      this.referenceRange,
      this.unit,
      this.interpretation,
      this.labName,
      this.notes,
      final List<String>? attachments,
      this.isAbnormal})
      : _attachments = attachments;

  factory _$LabResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$LabResultImplFromJson(json);

  @override
  final String id;
  @override
  final String testName;
  @override
  final String result;
  @override
  final String performedBy;
  @override
  final DateTime testDate;
  @override
  final String? referenceRange;
  @override
  final String? unit;
  @override
  final String? interpretation;
  @override
  final String? labName;
  @override
  final String? notes;
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
  final bool? isAbnormal;

  @override
  String toString() {
    return 'LabResult(id: $id, testName: $testName, result: $result, performedBy: $performedBy, testDate: $testDate, referenceRange: $referenceRange, unit: $unit, interpretation: $interpretation, labName: $labName, notes: $notes, attachments: $attachments, isAbnormal: $isAbnormal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LabResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.testName, testName) ||
                other.testName == testName) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.performedBy, performedBy) ||
                other.performedBy == performedBy) &&
            (identical(other.testDate, testDate) ||
                other.testDate == testDate) &&
            (identical(other.referenceRange, referenceRange) ||
                other.referenceRange == referenceRange) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.interpretation, interpretation) ||
                other.interpretation == interpretation) &&
            (identical(other.labName, labName) || other.labName == labName) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments) &&
            (identical(other.isAbnormal, isAbnormal) ||
                other.isAbnormal == isAbnormal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      testName,
      result,
      performedBy,
      testDate,
      referenceRange,
      unit,
      interpretation,
      labName,
      notes,
      const DeepCollectionEquality().hash(_attachments),
      isAbnormal);

  /// Create a copy of LabResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LabResultImplCopyWith<_$LabResultImpl> get copyWith =>
      __$$LabResultImplCopyWithImpl<_$LabResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LabResultImplToJson(
      this,
    );
  }
}

abstract class _LabResult implements LabResult {
  const factory _LabResult(
      {required final String id,
      required final String testName,
      required final String result,
      required final String performedBy,
      required final DateTime testDate,
      final String? referenceRange,
      final String? unit,
      final String? interpretation,
      final String? labName,
      final String? notes,
      final List<String>? attachments,
      final bool? isAbnormal}) = _$LabResultImpl;

  factory _LabResult.fromJson(Map<String, dynamic> json) =
      _$LabResultImpl.fromJson;

  @override
  String get id;
  @override
  String get testName;
  @override
  String get result;
  @override
  String get performedBy;
  @override
  DateTime get testDate;
  @override
  String? get referenceRange;
  @override
  String? get unit;
  @override
  String? get interpretation;
  @override
  String? get labName;
  @override
  String? get notes;
  @override
  List<String>? get attachments;
  @override
  bool? get isAbnormal;

  /// Create a copy of LabResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LabResultImplCopyWith<_$LabResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MedicalNote _$MedicalNoteFromJson(Map<String, dynamic> json) {
  return _MedicalNote.fromJson(json);
}

/// @nodoc
mixin _$MedicalNote {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get authorRole => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get noteType => throw _privateConstructorUsedError;
  String? get visibility => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;

  /// Serializes this MedicalNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MedicalNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MedicalNoteCopyWith<MedicalNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MedicalNoteCopyWith<$Res> {
  factory $MedicalNoteCopyWith(
          MedicalNote value, $Res Function(MedicalNote) then) =
      _$MedicalNoteCopyWithImpl<$Res, MedicalNote>;
  @useResult
  $Res call(
      {String id,
      String content,
      String authorId,
      String authorName,
      String authorRole,
      DateTime date,
      String? noteType,
      String? visibility,
      List<String>? tags,
      List<String>? attachments});
}

/// @nodoc
class _$MedicalNoteCopyWithImpl<$Res, $Val extends MedicalNote>
    implements $MedicalNoteCopyWith<$Res> {
  _$MedicalNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MedicalNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorRole = null,
    Object? date = null,
    Object? noteType = freezed,
    Object? visibility = freezed,
    Object? tags = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorRole: null == authorRole
          ? _value.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      noteType: freezed == noteType
          ? _value.noteType
          : noteType // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MedicalNoteImplCopyWith<$Res>
    implements $MedicalNoteCopyWith<$Res> {
  factory _$$MedicalNoteImplCopyWith(
          _$MedicalNoteImpl value, $Res Function(_$MedicalNoteImpl) then) =
      __$$MedicalNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String content,
      String authorId,
      String authorName,
      String authorRole,
      DateTime date,
      String? noteType,
      String? visibility,
      List<String>? tags,
      List<String>? attachments});
}

/// @nodoc
class __$$MedicalNoteImplCopyWithImpl<$Res>
    extends _$MedicalNoteCopyWithImpl<$Res, _$MedicalNoteImpl>
    implements _$$MedicalNoteImplCopyWith<$Res> {
  __$$MedicalNoteImplCopyWithImpl(
      _$MedicalNoteImpl _value, $Res Function(_$MedicalNoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of MedicalNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? authorRole = null,
    Object? date = null,
    Object? noteType = freezed,
    Object? visibility = freezed,
    Object? tags = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_$MedicalNoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorRole: null == authorRole
          ? _value.authorRole
          : authorRole // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      noteType: freezed == noteType
          ? _value.noteType
          : noteType // ignore: cast_nullable_to_non_nullable
              as String?,
      visibility: freezed == visibility
          ? _value.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MedicalNoteImpl implements _MedicalNote {
  const _$MedicalNoteImpl(
      {required this.id,
      required this.content,
      required this.authorId,
      required this.authorName,
      required this.authorRole,
      required this.date,
      this.noteType,
      this.visibility,
      final List<String>? tags,
      final List<String>? attachments})
      : _tags = tags,
        _attachments = attachments;

  factory _$MedicalNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$MedicalNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String content;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String authorRole;
  @override
  final DateTime date;
  @override
  final String? noteType;
  @override
  final String? visibility;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  String toString() {
    return 'MedicalNote(id: $id, content: $content, authorId: $authorId, authorName: $authorName, authorRole: $authorRole, date: $date, noteType: $noteType, visibility: $visibility, tags: $tags, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MedicalNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorRole, authorRole) ||
                other.authorRole == authorRole) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.noteType, noteType) ||
                other.noteType == noteType) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      content,
      authorId,
      authorName,
      authorRole,
      date,
      noteType,
      visibility,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_attachments));

  /// Create a copy of MedicalNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MedicalNoteImplCopyWith<_$MedicalNoteImpl> get copyWith =>
      __$$MedicalNoteImplCopyWithImpl<_$MedicalNoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MedicalNoteImplToJson(
      this,
    );
  }
}

abstract class _MedicalNote implements MedicalNote {
  const factory _MedicalNote(
      {required final String id,
      required final String content,
      required final String authorId,
      required final String authorName,
      required final String authorRole,
      required final DateTime date,
      final String? noteType,
      final String? visibility,
      final List<String>? tags,
      final List<String>? attachments}) = _$MedicalNoteImpl;

  factory _MedicalNote.fromJson(Map<String, dynamic> json) =
      _$MedicalNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get content;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String get authorRole;
  @override
  DateTime get date;
  @override
  String? get noteType;
  @override
  String? get visibility;
  @override
  List<String>? get tags;
  @override
  List<String>? get attachments;

  /// Create a copy of MedicalNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MedicalNoteImplCopyWith<_$MedicalNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Prescription _$PrescriptionFromJson(Map<String, dynamic> json) {
  return _Prescription.fromJson(json);
}

/// @nodoc
mixin _$Prescription {
  String get id => throw _privateConstructorUsedError;
  String get medicationName => throw _privateConstructorUsedError;
  String get dosage => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  String get doctorId => throw _privateConstructorUsedError;
  String get doctorName => throw _privateConstructorUsedError;
  DateTime get prescriptionDate => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get instructions => throw _privateConstructorUsedError;
  String? get quantity => throw _privateConstructorUsedError;
  String? get refills => throw _privateConstructorUsedError;
  bool? get isActive => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;

  /// Serializes this Prescription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrescriptionCopyWith<Prescription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrescriptionCopyWith<$Res> {
  factory $PrescriptionCopyWith(
          Prescription value, $Res Function(Prescription) then) =
      _$PrescriptionCopyWithImpl<$Res, Prescription>;
  @useResult
  $Res call(
      {String id,
      String medicationName,
      String dosage,
      String frequency,
      String doctorId,
      String doctorName,
      DateTime prescriptionDate,
      String? duration,
      String? instructions,
      String? quantity,
      String? refills,
      bool? isActive,
      DateTime? startDate,
      DateTime? endDate,
      List<String>? attachments});
}

/// @nodoc
class _$PrescriptionCopyWithImpl<$Res, $Val extends Prescription>
    implements $PrescriptionCopyWith<$Res> {
  _$PrescriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medicationName = null,
    Object? dosage = null,
    Object? frequency = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? prescriptionDate = null,
    Object? duration = freezed,
    Object? instructions = freezed,
    Object? quantity = freezed,
    Object? refills = freezed,
    Object? isActive = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medicationName: null == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      prescriptionDate: null == prescriptionDate
          ? _value.prescriptionDate
          : prescriptionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      refills: freezed == refills
          ? _value.refills
          : refills // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrescriptionImplCopyWith<$Res>
    implements $PrescriptionCopyWith<$Res> {
  factory _$$PrescriptionImplCopyWith(
          _$PrescriptionImpl value, $Res Function(_$PrescriptionImpl) then) =
      __$$PrescriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String medicationName,
      String dosage,
      String frequency,
      String doctorId,
      String doctorName,
      DateTime prescriptionDate,
      String? duration,
      String? instructions,
      String? quantity,
      String? refills,
      bool? isActive,
      DateTime? startDate,
      DateTime? endDate,
      List<String>? attachments});
}

/// @nodoc
class __$$PrescriptionImplCopyWithImpl<$Res>
    extends _$PrescriptionCopyWithImpl<$Res, _$PrescriptionImpl>
    implements _$$PrescriptionImplCopyWith<$Res> {
  __$$PrescriptionImplCopyWithImpl(
      _$PrescriptionImpl _value, $Res Function(_$PrescriptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? medicationName = null,
    Object? dosage = null,
    Object? frequency = null,
    Object? doctorId = null,
    Object? doctorName = null,
    Object? prescriptionDate = null,
    Object? duration = freezed,
    Object? instructions = freezed,
    Object? quantity = freezed,
    Object? refills = freezed,
    Object? isActive = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_$PrescriptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      medicationName: null == medicationName
          ? _value.medicationName
          : medicationName // ignore: cast_nullable_to_non_nullable
              as String,
      dosage: null == dosage
          ? _value.dosage
          : dosage // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      doctorId: null == doctorId
          ? _value.doctorId
          : doctorId // ignore: cast_nullable_to_non_nullable
              as String,
      doctorName: null == doctorName
          ? _value.doctorName
          : doctorName // ignore: cast_nullable_to_non_nullable
              as String,
      prescriptionDate: null == prescriptionDate
          ? _value.prescriptionDate
          : prescriptionDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as String?,
      refills: freezed == refills
          ? _value.refills
          : refills // ignore: cast_nullable_to_non_nullable
              as String?,
      isActive: freezed == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrescriptionImpl implements _Prescription {
  const _$PrescriptionImpl(
      {required this.id,
      required this.medicationName,
      required this.dosage,
      required this.frequency,
      required this.doctorId,
      required this.doctorName,
      required this.prescriptionDate,
      this.duration,
      this.instructions,
      this.quantity,
      this.refills,
      this.isActive,
      this.startDate,
      this.endDate,
      final List<String>? attachments})
      : _attachments = attachments;

  factory _$PrescriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrescriptionImplFromJson(json);

  @override
  final String id;
  @override
  final String medicationName;
  @override
  final String dosage;
  @override
  final String frequency;
  @override
  final String doctorId;
  @override
  final String doctorName;
  @override
  final DateTime prescriptionDate;
  @override
  final String? duration;
  @override
  final String? instructions;
  @override
  final String? quantity;
  @override
  final String? refills;
  @override
  final bool? isActive;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
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
  String toString() {
    return 'Prescription(id: $id, medicationName: $medicationName, dosage: $dosage, frequency: $frequency, doctorId: $doctorId, doctorName: $doctorName, prescriptionDate: $prescriptionDate, duration: $duration, instructions: $instructions, quantity: $quantity, refills: $refills, isActive: $isActive, startDate: $startDate, endDate: $endDate, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrescriptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.medicationName, medicationName) ||
                other.medicationName == medicationName) &&
            (identical(other.dosage, dosage) || other.dosage == dosage) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.doctorId, doctorId) ||
                other.doctorId == doctorId) &&
            (identical(other.doctorName, doctorName) ||
                other.doctorName == doctorName) &&
            (identical(other.prescriptionDate, prescriptionDate) ||
                other.prescriptionDate == prescriptionDate) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.refills, refills) || other.refills == refills) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      medicationName,
      dosage,
      frequency,
      doctorId,
      doctorName,
      prescriptionDate,
      duration,
      instructions,
      quantity,
      refills,
      isActive,
      startDate,
      endDate,
      const DeepCollectionEquality().hash(_attachments));

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrescriptionImplCopyWith<_$PrescriptionImpl> get copyWith =>
      __$$PrescriptionImplCopyWithImpl<_$PrescriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrescriptionImplToJson(
      this,
    );
  }
}

abstract class _Prescription implements Prescription {
  const factory _Prescription(
      {required final String id,
      required final String medicationName,
      required final String dosage,
      required final String frequency,
      required final String doctorId,
      required final String doctorName,
      required final DateTime prescriptionDate,
      final String? duration,
      final String? instructions,
      final String? quantity,
      final String? refills,
      final bool? isActive,
      final DateTime? startDate,
      final DateTime? endDate,
      final List<String>? attachments}) = _$PrescriptionImpl;

  factory _Prescription.fromJson(Map<String, dynamic> json) =
      _$PrescriptionImpl.fromJson;

  @override
  String get id;
  @override
  String get medicationName;
  @override
  String get dosage;
  @override
  String get frequency;
  @override
  String get doctorId;
  @override
  String get doctorName;
  @override
  DateTime get prescriptionDate;
  @override
  String? get duration;
  @override
  String? get instructions;
  @override
  String? get quantity;
  @override
  String? get refills;
  @override
  bool? get isActive;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  List<String>? get attachments;

  /// Create a copy of Prescription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrescriptionImplCopyWith<_$PrescriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Surgery _$SurgeryFromJson(Map<String, dynamic> json) {
  return _Surgery.fromJson(json);
}

/// @nodoc
mixin _$Surgery {
  String get id => throw _privateConstructorUsedError;
  String get procedureName => throw _privateConstructorUsedError;
  String get surgeonId => throw _privateConstructorUsedError;
  String get surgeonName => throw _privateConstructorUsedError;
  DateTime get surgeryDate => throw _privateConstructorUsedError;
  String? get procedureType => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get duration => throw _privateConstructorUsedError;
  String? get anesthesia => throw _privateConstructorUsedError;
  String? get preOpDiagnosis => throw _privateConstructorUsedError;
  String? get postOpDiagnosis => throw _privateConstructorUsedError;
  String? get complications => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  List<String>? get assistants => throw _privateConstructorUsedError;
  List<String>? get attachments => throw _privateConstructorUsedError;

  /// Serializes this Surgery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Surgery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SurgeryCopyWith<Surgery> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurgeryCopyWith<$Res> {
  factory $SurgeryCopyWith(Surgery value, $Res Function(Surgery) then) =
      _$SurgeryCopyWithImpl<$Res, Surgery>;
  @useResult
  $Res call(
      {String id,
      String procedureName,
      String surgeonId,
      String surgeonName,
      DateTime surgeryDate,
      String? procedureType,
      String? location,
      String? duration,
      String? anesthesia,
      String? preOpDiagnosis,
      String? postOpDiagnosis,
      String? complications,
      String? notes,
      List<String>? assistants,
      List<String>? attachments});
}

/// @nodoc
class _$SurgeryCopyWithImpl<$Res, $Val extends Surgery>
    implements $SurgeryCopyWith<$Res> {
  _$SurgeryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Surgery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? procedureName = null,
    Object? surgeonId = null,
    Object? surgeonName = null,
    Object? surgeryDate = null,
    Object? procedureType = freezed,
    Object? location = freezed,
    Object? duration = freezed,
    Object? anesthesia = freezed,
    Object? preOpDiagnosis = freezed,
    Object? postOpDiagnosis = freezed,
    Object? complications = freezed,
    Object? notes = freezed,
    Object? assistants = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      procedureName: null == procedureName
          ? _value.procedureName
          : procedureName // ignore: cast_nullable_to_non_nullable
              as String,
      surgeonId: null == surgeonId
          ? _value.surgeonId
          : surgeonId // ignore: cast_nullable_to_non_nullable
              as String,
      surgeonName: null == surgeonName
          ? _value.surgeonName
          : surgeonName // ignore: cast_nullable_to_non_nullable
              as String,
      surgeryDate: null == surgeryDate
          ? _value.surgeryDate
          : surgeryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      procedureType: freezed == procedureType
          ? _value.procedureType
          : procedureType // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      anesthesia: freezed == anesthesia
          ? _value.anesthesia
          : anesthesia // ignore: cast_nullable_to_non_nullable
              as String?,
      preOpDiagnosis: freezed == preOpDiagnosis
          ? _value.preOpDiagnosis
          : preOpDiagnosis // ignore: cast_nullable_to_non_nullable
              as String?,
      postOpDiagnosis: freezed == postOpDiagnosis
          ? _value.postOpDiagnosis
          : postOpDiagnosis // ignore: cast_nullable_to_non_nullable
              as String?,
      complications: freezed == complications
          ? _value.complications
          : complications // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      assistants: freezed == assistants
          ? _value.assistants
          : assistants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value.attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SurgeryImplCopyWith<$Res> implements $SurgeryCopyWith<$Res> {
  factory _$$SurgeryImplCopyWith(
          _$SurgeryImpl value, $Res Function(_$SurgeryImpl) then) =
      __$$SurgeryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String procedureName,
      String surgeonId,
      String surgeonName,
      DateTime surgeryDate,
      String? procedureType,
      String? location,
      String? duration,
      String? anesthesia,
      String? preOpDiagnosis,
      String? postOpDiagnosis,
      String? complications,
      String? notes,
      List<String>? assistants,
      List<String>? attachments});
}

/// @nodoc
class __$$SurgeryImplCopyWithImpl<$Res>
    extends _$SurgeryCopyWithImpl<$Res, _$SurgeryImpl>
    implements _$$SurgeryImplCopyWith<$Res> {
  __$$SurgeryImplCopyWithImpl(
      _$SurgeryImpl _value, $Res Function(_$SurgeryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Surgery
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? procedureName = null,
    Object? surgeonId = null,
    Object? surgeonName = null,
    Object? surgeryDate = null,
    Object? procedureType = freezed,
    Object? location = freezed,
    Object? duration = freezed,
    Object? anesthesia = freezed,
    Object? preOpDiagnosis = freezed,
    Object? postOpDiagnosis = freezed,
    Object? complications = freezed,
    Object? notes = freezed,
    Object? assistants = freezed,
    Object? attachments = freezed,
  }) {
    return _then(_$SurgeryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      procedureName: null == procedureName
          ? _value.procedureName
          : procedureName // ignore: cast_nullable_to_non_nullable
              as String,
      surgeonId: null == surgeonId
          ? _value.surgeonId
          : surgeonId // ignore: cast_nullable_to_non_nullable
              as String,
      surgeonName: null == surgeonName
          ? _value.surgeonName
          : surgeonName // ignore: cast_nullable_to_non_nullable
              as String,
      surgeryDate: null == surgeryDate
          ? _value.surgeryDate
          : surgeryDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      procedureType: freezed == procedureType
          ? _value.procedureType
          : procedureType // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as String?,
      anesthesia: freezed == anesthesia
          ? _value.anesthesia
          : anesthesia // ignore: cast_nullable_to_non_nullable
              as String?,
      preOpDiagnosis: freezed == preOpDiagnosis
          ? _value.preOpDiagnosis
          : preOpDiagnosis // ignore: cast_nullable_to_non_nullable
              as String?,
      postOpDiagnosis: freezed == postOpDiagnosis
          ? _value.postOpDiagnosis
          : postOpDiagnosis // ignore: cast_nullable_to_non_nullable
              as String?,
      complications: freezed == complications
          ? _value.complications
          : complications // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      assistants: freezed == assistants
          ? _value._assistants
          : assistants // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attachments: freezed == attachments
          ? _value._attachments
          : attachments // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SurgeryImpl implements _Surgery {
  const _$SurgeryImpl(
      {required this.id,
      required this.procedureName,
      required this.surgeonId,
      required this.surgeonName,
      required this.surgeryDate,
      this.procedureType,
      this.location,
      this.duration,
      this.anesthesia,
      this.preOpDiagnosis,
      this.postOpDiagnosis,
      this.complications,
      this.notes,
      final List<String>? assistants,
      final List<String>? attachments})
      : _assistants = assistants,
        _attachments = attachments;

  factory _$SurgeryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SurgeryImplFromJson(json);

  @override
  final String id;
  @override
  final String procedureName;
  @override
  final String surgeonId;
  @override
  final String surgeonName;
  @override
  final DateTime surgeryDate;
  @override
  final String? procedureType;
  @override
  final String? location;
  @override
  final String? duration;
  @override
  final String? anesthesia;
  @override
  final String? preOpDiagnosis;
  @override
  final String? postOpDiagnosis;
  @override
  final String? complications;
  @override
  final String? notes;
  final List<String>? _assistants;
  @override
  List<String>? get assistants {
    final value = _assistants;
    if (value == null) return null;
    if (_assistants is EqualUnmodifiableListView) return _assistants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  String toString() {
    return 'Surgery(id: $id, procedureName: $procedureName, surgeonId: $surgeonId, surgeonName: $surgeonName, surgeryDate: $surgeryDate, procedureType: $procedureType, location: $location, duration: $duration, anesthesia: $anesthesia, preOpDiagnosis: $preOpDiagnosis, postOpDiagnosis: $postOpDiagnosis, complications: $complications, notes: $notes, assistants: $assistants, attachments: $attachments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurgeryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.procedureName, procedureName) ||
                other.procedureName == procedureName) &&
            (identical(other.surgeonId, surgeonId) ||
                other.surgeonId == surgeonId) &&
            (identical(other.surgeonName, surgeonName) ||
                other.surgeonName == surgeonName) &&
            (identical(other.surgeryDate, surgeryDate) ||
                other.surgeryDate == surgeryDate) &&
            (identical(other.procedureType, procedureType) ||
                other.procedureType == procedureType) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.anesthesia, anesthesia) ||
                other.anesthesia == anesthesia) &&
            (identical(other.preOpDiagnosis, preOpDiagnosis) ||
                other.preOpDiagnosis == preOpDiagnosis) &&
            (identical(other.postOpDiagnosis, postOpDiagnosis) ||
                other.postOpDiagnosis == postOpDiagnosis) &&
            (identical(other.complications, complications) ||
                other.complications == complications) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            const DeepCollectionEquality()
                .equals(other._assistants, _assistants) &&
            const DeepCollectionEquality()
                .equals(other._attachments, _attachments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      procedureName,
      surgeonId,
      surgeonName,
      surgeryDate,
      procedureType,
      location,
      duration,
      anesthesia,
      preOpDiagnosis,
      postOpDiagnosis,
      complications,
      notes,
      const DeepCollectionEquality().hash(_assistants),
      const DeepCollectionEquality().hash(_attachments));

  /// Create a copy of Surgery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurgeryImplCopyWith<_$SurgeryImpl> get copyWith =>
      __$$SurgeryImplCopyWithImpl<_$SurgeryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurgeryImplToJson(
      this,
    );
  }
}

abstract class _Surgery implements Surgery {
  const factory _Surgery(
      {required final String id,
      required final String procedureName,
      required final String surgeonId,
      required final String surgeonName,
      required final DateTime surgeryDate,
      final String? procedureType,
      final String? location,
      final String? duration,
      final String? anesthesia,
      final String? preOpDiagnosis,
      final String? postOpDiagnosis,
      final String? complications,
      final String? notes,
      final List<String>? assistants,
      final List<String>? attachments}) = _$SurgeryImpl;

  factory _Surgery.fromJson(Map<String, dynamic> json) = _$SurgeryImpl.fromJson;

  @override
  String get id;
  @override
  String get procedureName;
  @override
  String get surgeonId;
  @override
  String get surgeonName;
  @override
  DateTime get surgeryDate;
  @override
  String? get procedureType;
  @override
  String? get location;
  @override
  String? get duration;
  @override
  String? get anesthesia;
  @override
  String? get preOpDiagnosis;
  @override
  String? get postOpDiagnosis;
  @override
  String? get complications;
  @override
  String? get notes;
  @override
  List<String>? get assistants;
  @override
  List<String>? get attachments;

  /// Create a copy of Surgery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurgeryImplCopyWith<_$SurgeryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Allergy _$AllergyFromJson(Map<String, dynamic> json) {
  return _Allergy.fromJson(json);
}

/// @nodoc
mixin _$Allergy {
  String get id => throw _privateConstructorUsedError;
  String get allergen => throw _privateConstructorUsedError;
  String get reaction => throw _privateConstructorUsedError;
  String get severity => throw _privateConstructorUsedError;
  DateTime? get diagnosedDate => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this Allergy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Allergy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AllergyCopyWith<Allergy> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AllergyCopyWith<$Res> {
  factory $AllergyCopyWith(Allergy value, $Res Function(Allergy) then) =
      _$AllergyCopyWithImpl<$Res, Allergy>;
  @useResult
  $Res call(
      {String id,
      String allergen,
      String reaction,
      String severity,
      DateTime? diagnosedDate,
      String? notes});
}

/// @nodoc
class _$AllergyCopyWithImpl<$Res, $Val extends Allergy>
    implements $AllergyCopyWith<$Res> {
  _$AllergyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Allergy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? allergen = null,
    Object? reaction = null,
    Object? severity = null,
    Object? diagnosedDate = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      allergen: null == allergen
          ? _value.allergen
          : allergen // ignore: cast_nullable_to_non_nullable
              as String,
      reaction: null == reaction
          ? _value.reaction
          : reaction // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      diagnosedDate: freezed == diagnosedDate
          ? _value.diagnosedDate
          : diagnosedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AllergyImplCopyWith<$Res> implements $AllergyCopyWith<$Res> {
  factory _$$AllergyImplCopyWith(
          _$AllergyImpl value, $Res Function(_$AllergyImpl) then) =
      __$$AllergyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String allergen,
      String reaction,
      String severity,
      DateTime? diagnosedDate,
      String? notes});
}

/// @nodoc
class __$$AllergyImplCopyWithImpl<$Res>
    extends _$AllergyCopyWithImpl<$Res, _$AllergyImpl>
    implements _$$AllergyImplCopyWith<$Res> {
  __$$AllergyImplCopyWithImpl(
      _$AllergyImpl _value, $Res Function(_$AllergyImpl) _then)
      : super(_value, _then);

  /// Create a copy of Allergy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? allergen = null,
    Object? reaction = null,
    Object? severity = null,
    Object? diagnosedDate = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$AllergyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      allergen: null == allergen
          ? _value.allergen
          : allergen // ignore: cast_nullable_to_non_nullable
              as String,
      reaction: null == reaction
          ? _value.reaction
          : reaction // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as String,
      diagnosedDate: freezed == diagnosedDate
          ? _value.diagnosedDate
          : diagnosedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AllergyImpl implements _Allergy {
  const _$AllergyImpl(
      {required this.id,
      required this.allergen,
      required this.reaction,
      required this.severity,
      this.diagnosedDate,
      this.notes});

  factory _$AllergyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AllergyImplFromJson(json);

  @override
  final String id;
  @override
  final String allergen;
  @override
  final String reaction;
  @override
  final String severity;
  @override
  final DateTime? diagnosedDate;
  @override
  final String? notes;

  @override
  String toString() {
    return 'Allergy(id: $id, allergen: $allergen, reaction: $reaction, severity: $severity, diagnosedDate: $diagnosedDate, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AllergyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.allergen, allergen) ||
                other.allergen == allergen) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.diagnosedDate, diagnosedDate) ||
                other.diagnosedDate == diagnosedDate) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, allergen, reaction, severity, diagnosedDate, notes);

  /// Create a copy of Allergy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AllergyImplCopyWith<_$AllergyImpl> get copyWith =>
      __$$AllergyImplCopyWithImpl<_$AllergyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AllergyImplToJson(
      this,
    );
  }
}

abstract class _Allergy implements Allergy {
  const factory _Allergy(
      {required final String id,
      required final String allergen,
      required final String reaction,
      required final String severity,
      final DateTime? diagnosedDate,
      final String? notes}) = _$AllergyImpl;

  factory _Allergy.fromJson(Map<String, dynamic> json) = _$AllergyImpl.fromJson;

  @override
  String get id;
  @override
  String get allergen;
  @override
  String get reaction;
  @override
  String get severity;
  @override
  DateTime? get diagnosedDate;
  @override
  String? get notes;

  /// Create a copy of Allergy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AllergyImplCopyWith<_$AllergyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Immunization _$ImmunizationFromJson(Map<String, dynamic> json) {
  return _Immunization.fromJson(json);
}

/// @nodoc
mixin _$Immunization {
  String get id => throw _privateConstructorUsedError;
  String get vaccineName => throw _privateConstructorUsedError;
  DateTime get administrationDate => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  String? get lotNumber => throw _privateConstructorUsedError;
  String? get administeredBy => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime? get nextDueDate => throw _privateConstructorUsedError;

  /// Serializes this Immunization to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Immunization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImmunizationCopyWith<Immunization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImmunizationCopyWith<$Res> {
  factory $ImmunizationCopyWith(
          Immunization value, $Res Function(Immunization) then) =
      _$ImmunizationCopyWithImpl<$Res, Immunization>;
  @useResult
  $Res call(
      {String id,
      String vaccineName,
      DateTime administrationDate,
      String? manufacturer,
      String? lotNumber,
      String? administeredBy,
      String? location,
      String? notes,
      DateTime? nextDueDate});
}

/// @nodoc
class _$ImmunizationCopyWithImpl<$Res, $Val extends Immunization>
    implements $ImmunizationCopyWith<$Res> {
  _$ImmunizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Immunization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vaccineName = null,
    Object? administrationDate = null,
    Object? manufacturer = freezed,
    Object? lotNumber = freezed,
    Object? administeredBy = freezed,
    Object? location = freezed,
    Object? notes = freezed,
    Object? nextDueDate = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vaccineName: null == vaccineName
          ? _value.vaccineName
          : vaccineName // ignore: cast_nullable_to_non_nullable
              as String,
      administrationDate: null == administrationDate
          ? _value.administrationDate
          : administrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      lotNumber: freezed == lotNumber
          ? _value.lotNumber
          : lotNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      administeredBy: freezed == administeredBy
          ? _value.administeredBy
          : administeredBy // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      nextDueDate: freezed == nextDueDate
          ? _value.nextDueDate
          : nextDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ImmunizationImplCopyWith<$Res>
    implements $ImmunizationCopyWith<$Res> {
  factory _$$ImmunizationImplCopyWith(
          _$ImmunizationImpl value, $Res Function(_$ImmunizationImpl) then) =
      __$$ImmunizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String vaccineName,
      DateTime administrationDate,
      String? manufacturer,
      String? lotNumber,
      String? administeredBy,
      String? location,
      String? notes,
      DateTime? nextDueDate});
}

/// @nodoc
class __$$ImmunizationImplCopyWithImpl<$Res>
    extends _$ImmunizationCopyWithImpl<$Res, _$ImmunizationImpl>
    implements _$$ImmunizationImplCopyWith<$Res> {
  __$$ImmunizationImplCopyWithImpl(
      _$ImmunizationImpl _value, $Res Function(_$ImmunizationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Immunization
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vaccineName = null,
    Object? administrationDate = null,
    Object? manufacturer = freezed,
    Object? lotNumber = freezed,
    Object? administeredBy = freezed,
    Object? location = freezed,
    Object? notes = freezed,
    Object? nextDueDate = freezed,
  }) {
    return _then(_$ImmunizationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      vaccineName: null == vaccineName
          ? _value.vaccineName
          : vaccineName // ignore: cast_nullable_to_non_nullable
              as String,
      administrationDate: null == administrationDate
          ? _value.administrationDate
          : administrationDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      lotNumber: freezed == lotNumber
          ? _value.lotNumber
          : lotNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      administeredBy: freezed == administeredBy
          ? _value.administeredBy
          : administeredBy // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      nextDueDate: freezed == nextDueDate
          ? _value.nextDueDate
          : nextDueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImmunizationImpl implements _Immunization {
  const _$ImmunizationImpl(
      {required this.id,
      required this.vaccineName,
      required this.administrationDate,
      this.manufacturer,
      this.lotNumber,
      this.administeredBy,
      this.location,
      this.notes,
      this.nextDueDate});

  factory _$ImmunizationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImmunizationImplFromJson(json);

  @override
  final String id;
  @override
  final String vaccineName;
  @override
  final DateTime administrationDate;
  @override
  final String? manufacturer;
  @override
  final String? lotNumber;
  @override
  final String? administeredBy;
  @override
  final String? location;
  @override
  final String? notes;
  @override
  final DateTime? nextDueDate;

  @override
  String toString() {
    return 'Immunization(id: $id, vaccineName: $vaccineName, administrationDate: $administrationDate, manufacturer: $manufacturer, lotNumber: $lotNumber, administeredBy: $administeredBy, location: $location, notes: $notes, nextDueDate: $nextDueDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImmunizationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vaccineName, vaccineName) ||
                other.vaccineName == vaccineName) &&
            (identical(other.administrationDate, administrationDate) ||
                other.administrationDate == administrationDate) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.lotNumber, lotNumber) ||
                other.lotNumber == lotNumber) &&
            (identical(other.administeredBy, administeredBy) ||
                other.administeredBy == administeredBy) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.nextDueDate, nextDueDate) ||
                other.nextDueDate == nextDueDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      vaccineName,
      administrationDate,
      manufacturer,
      lotNumber,
      administeredBy,
      location,
      notes,
      nextDueDate);

  /// Create a copy of Immunization
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImmunizationImplCopyWith<_$ImmunizationImpl> get copyWith =>
      __$$ImmunizationImplCopyWithImpl<_$ImmunizationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ImmunizationImplToJson(
      this,
    );
  }
}

abstract class _Immunization implements Immunization {
  const factory _Immunization(
      {required final String id,
      required final String vaccineName,
      required final DateTime administrationDate,
      final String? manufacturer,
      final String? lotNumber,
      final String? administeredBy,
      final String? location,
      final String? notes,
      final DateTime? nextDueDate}) = _$ImmunizationImpl;

  factory _Immunization.fromJson(Map<String, dynamic> json) =
      _$ImmunizationImpl.fromJson;

  @override
  String get id;
  @override
  String get vaccineName;
  @override
  DateTime get administrationDate;
  @override
  String? get manufacturer;
  @override
  String? get lotNumber;
  @override
  String? get administeredBy;
  @override
  String? get location;
  @override
  String? get notes;
  @override
  DateTime? get nextDueDate;

  /// Create a copy of Immunization
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImmunizationImplCopyWith<_$ImmunizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FamilyHistory _$FamilyHistoryFromJson(Map<String, dynamic> json) {
  return _FamilyHistory.fromJson(json);
}

/// @nodoc
mixin _$FamilyHistory {
  String get id => throw _privateConstructorUsedError;
  String get condition => throw _privateConstructorUsedError;
  String get relationship => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String? get onsetAge => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this FamilyHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FamilyHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FamilyHistoryCopyWith<FamilyHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FamilyHistoryCopyWith<$Res> {
  factory $FamilyHistoryCopyWith(
          FamilyHistory value, $Res Function(FamilyHistory) then) =
      _$FamilyHistoryCopyWithImpl<$Res, FamilyHistory>;
  @useResult
  $Res call(
      {String id,
      String condition,
      String relationship,
      String? notes,
      String? onsetAge,
      String? status});
}

/// @nodoc
class _$FamilyHistoryCopyWithImpl<$Res, $Val extends FamilyHistory>
    implements $FamilyHistoryCopyWith<$Res> {
  _$FamilyHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FamilyHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? condition = null,
    Object? relationship = null,
    Object? notes = freezed,
    Object? onsetAge = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      onsetAge: freezed == onsetAge
          ? _value.onsetAge
          : onsetAge // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FamilyHistoryImplCopyWith<$Res>
    implements $FamilyHistoryCopyWith<$Res> {
  factory _$$FamilyHistoryImplCopyWith(
          _$FamilyHistoryImpl value, $Res Function(_$FamilyHistoryImpl) then) =
      __$$FamilyHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String condition,
      String relationship,
      String? notes,
      String? onsetAge,
      String? status});
}

/// @nodoc
class __$$FamilyHistoryImplCopyWithImpl<$Res>
    extends _$FamilyHistoryCopyWithImpl<$Res, _$FamilyHistoryImpl>
    implements _$$FamilyHistoryImplCopyWith<$Res> {
  __$$FamilyHistoryImplCopyWithImpl(
      _$FamilyHistoryImpl _value, $Res Function(_$FamilyHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of FamilyHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? condition = null,
    Object? relationship = null,
    Object? notes = freezed,
    Object? onsetAge = freezed,
    Object? status = freezed,
  }) {
    return _then(_$FamilyHistoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      condition: null == condition
          ? _value.condition
          : condition // ignore: cast_nullable_to_non_nullable
              as String,
      relationship: null == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as String,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      onsetAge: freezed == onsetAge
          ? _value.onsetAge
          : onsetAge // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FamilyHistoryImpl implements _FamilyHistory {
  const _$FamilyHistoryImpl(
      {required this.id,
      required this.condition,
      required this.relationship,
      this.notes,
      this.onsetAge,
      this.status});

  factory _$FamilyHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$FamilyHistoryImplFromJson(json);

  @override
  final String id;
  @override
  final String condition;
  @override
  final String relationship;
  @override
  final String? notes;
  @override
  final String? onsetAge;
  @override
  final String? status;

  @override
  String toString() {
    return 'FamilyHistory(id: $id, condition: $condition, relationship: $relationship, notes: $notes, onsetAge: $onsetAge, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FamilyHistoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.condition, condition) ||
                other.condition == condition) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.onsetAge, onsetAge) ||
                other.onsetAge == onsetAge) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, condition, relationship, notes, onsetAge, status);

  /// Create a copy of FamilyHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FamilyHistoryImplCopyWith<_$FamilyHistoryImpl> get copyWith =>
      __$$FamilyHistoryImplCopyWithImpl<_$FamilyHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FamilyHistoryImplToJson(
      this,
    );
  }
}

abstract class _FamilyHistory implements FamilyHistory {
  const factory _FamilyHistory(
      {required final String id,
      required final String condition,
      required final String relationship,
      final String? notes,
      final String? onsetAge,
      final String? status}) = _$FamilyHistoryImpl;

  factory _FamilyHistory.fromJson(Map<String, dynamic> json) =
      _$FamilyHistoryImpl.fromJson;

  @override
  String get id;
  @override
  String get condition;
  @override
  String get relationship;
  @override
  String? get notes;
  @override
  String? get onsetAge;
  @override
  String? get status;

  /// Create a copy of FamilyHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FamilyHistoryImplCopyWith<_$FamilyHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
