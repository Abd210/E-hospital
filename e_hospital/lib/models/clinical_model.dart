import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clinical_model.freezed.dart';
part 'clinical_model.g.dart';

@freezed
class ClinicalFile with _$ClinicalFile {
  const factory ClinicalFile({
    required String id,
    required String patientId,
    required String patientName,
    String? medicalCondition,
    String? bloodType,
    Map<String, dynamic>? vitals,
    @Default([]) List<Diagnostic> diagnostics,
    @Default([]) List<Treatment> treatments,
    @Default([]) List<LabResult> labResults,
    @Default([]) List<MedicalNote> medicalNotes,
    @Default([]) List<Prescription> prescriptions,
    @Default([]) List<Surgery> surgeries,
    DischargeSummary? dischargeSummary,
    VitalsReport? vitalsReport,
    DateTime? lastUpdated,
    DateTime? createdAt,
  }) = _ClinicalFile;

  factory ClinicalFile.fromJson(Map<String, dynamic> json) =>
      _$ClinicalFileFromJson(json);

  factory ClinicalFile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ClinicalFile.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate().toIso8601String()
          : null,
      'lastUpdated': data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate().toIso8601String()
          : null,
      'diagnostics': _parseList(data['diagnostics']),
      'treatments': _parseList(data['treatments']),
      'labResults': _parseList(data['labResults']),
      'medicalNotes': _parseList(data['medicalNotes']),
      'prescriptions': _parseList(data['prescriptions']),
      'surgeries': _parseList(data['surgeries']),
      'dischargeSummary': data['dischargeSummary'] != null
          ? data['dischargeSummary'] as Map<String, dynamic>
          : null,
      'vitalsReport': data['vitalsReport'] != null
          ? data['vitalsReport'] as Map<String, dynamic>
          : null,
    });
  }

  static List<Map<String, dynamic>> _parseList(dynamic list) {
    if (list == null) return [];
    if (list is List) {
      return list.map((item) => item as Map<String, dynamic>).toList();
    }
    return [];
  }
}

@freezed
class Vitals with _$Vitals {
  const factory Vitals({
    required String heartRate,
    required String bloodPressure,
    required String temperature,
    required String oxygenSaturation,
    String? respiratoryRate,
    String? weight,
    String? height,
    String? bmi,
    String? pain,
    DateTime? lastMeasured,
  }) = _Vitals;

  factory Vitals.fromJson(Map<String, dynamic> json) => _$VitalsFromJson(json);
}

@freezed
class Diagnostic with _$Diagnostic {
  const factory Diagnostic({
    required String id,
    required String description,
    required String doctorId,
    required String doctorName,
    required DateTime date,
    String? diagnosisType,
    String? severity,
    String? icdCode,
    String? notes,
    List<String>? symptoms,
    List<String>? testResults,
    List<String>? attachments,
  }) = _Diagnostic;

  factory Diagnostic.fromJson(Map<String, dynamic> json) =>
      _$DiagnosticFromJson(json);
}

@freezed
class Treatment with _$Treatment {
  const factory Treatment({
    required String id,
    required String medication,
    required String dosage,
    required String description,
    required String doctorId,
    required String doctorName,
    required DateTime date,
    String? treatmentType,
    String? duration,
    String? frequency,
    String? instructions,
    String? sideEffects,
    String? notes,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    List<String>? attachments,
  }) = _Treatment;

  factory Treatment.fromJson(Map<String, dynamic> json) =>
      _$TreatmentFromJson(json);
}

@freezed
class LabResult with _$LabResult {
  const factory LabResult({
    required String id,
    required String testName,
    required String result,
    required String performedBy,
    required DateTime testDate,
    String? referenceRange,
    String? unit,
    String? interpretation,
    String? labName,
    String? notes,
    List<String>? attachments,
    bool? isAbnormal,
  }) = _LabResult;

  factory LabResult.fromJson(Map<String, dynamic> json) =>
      _$LabResultFromJson(json);
}

@freezed
class MedicalNote with _$MedicalNote {
  const factory MedicalNote({
    required String id,
    required String content,
    required String authorId,
    required String authorName,
    required String authorRole,
    required DateTime date,
    String? noteType,
    String? visibility,
    List<String>? tags,
    List<String>? attachments,
  }) = _MedicalNote;

  factory MedicalNote.fromJson(Map<String, dynamic> json) =>
      _$MedicalNoteFromJson(json);
}

@freezed
class Prescription with _$Prescription {
  const factory Prescription({
    required String id,
    required String medicationName,
    required String dosage,
    required String frequency,
    required String doctorId,
    required String doctorName,
    required DateTime prescriptionDate,
    String? duration,
    String? instructions,
    String? quantity,
    String? refills,
    bool? isActive,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? attachments,
  }) = _Prescription;

  factory Prescription.fromJson(Map<String, dynamic> json) =>
      _$PrescriptionFromJson(json);
}

@freezed
class Surgery with _$Surgery {
  const factory Surgery({
    required String id,
    required String procedureName,
    required String surgeonId,
    required String surgeonName,
    required DateTime surgeryDate,
    String? procedureType,
    String? location,
    String? duration,
    String? anesthesia,
    String? preOpDiagnosis,
    String? postOpDiagnosis,
    String? complications,
    String? notes,
    List<String>? assistants,
    List<String>? attachments,
  }) = _Surgery;

  factory Surgery.fromJson(Map<String, dynamic> json) =>
      _$SurgeryFromJson(json);
}

@freezed
class Allergy with _$Allergy {
  const factory Allergy({
    required String id,
    required String allergen,
    required String reaction,
    required String severity,
    DateTime? diagnosedDate,
    String? notes,
  }) = _Allergy;

  factory Allergy.fromJson(Map<String, dynamic> json) =>
      _$AllergyFromJson(json);
}

@freezed
class Immunization with _$Immunization {
  const factory Immunization({
    required String id,
    required String vaccineName,
    required DateTime administrationDate,
    String? manufacturer,
    String? lotNumber,
    String? administeredBy,
    String? location,
    String? notes,
    DateTime? nextDueDate,
  }) = _Immunization;

  factory Immunization.fromJson(Map<String, dynamic> json) =>
      _$ImmunizationFromJson(json);
}

@freezed
class FamilyHistory with _$FamilyHistory {
  const factory FamilyHistory({
    required String id,
    required String condition,
    required String relationship,
    String? notes,
    String? onsetAge,
    String? status,
  }) = _FamilyHistory;

  factory FamilyHistory.fromJson(Map<String, dynamic> json) =>
      _$FamilyHistoryFromJson(json);
}

/// A class representing a discharge summary
class DischargeSummary {
  final String id;
  final String summary;
  final DateTime dischargeDate;
  final String finalDiagnosis;
  final String followUpInstructions;
  final String? generatedSummary; // Computed from other fields
  final String? patientInstructions;

  DischargeSummary({
    required this.id,
    required this.summary,
    required this.dischargeDate,
    required this.finalDiagnosis,
    required this.followUpInstructions,
    this.generatedSummary,
    this.patientInstructions,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'summary': summary,
      'dischargeDate': dischargeDate.toIso8601String(),
      'finalDiagnosis': finalDiagnosis,
      'followUpInstructions': followUpInstructions,
      'generatedSummary': generatedSummary,
      'patientInstructions': patientInstructions,
    };
  }

  /// Create from JSON
  factory DischargeSummary.fromJson(Map<String, dynamic> json) {
    return DischargeSummary(
      id: json['id'] as String,
      summary: json['summary'] as String,
      dischargeDate: DateTime.parse(json['dischargeDate'] as String),
      finalDiagnosis: json['finalDiagnosis'] as String,
      followUpInstructions: json['followUpInstructions'] as String,
      generatedSummary: json['generatedSummary'] as String?,
      patientInstructions: json['patientInstructions'] as String?,
    );
  }

  /// Create a copy with some fields replaced
  DischargeSummary copyWith({
    String? id,
    String? summary,
    DateTime? dischargeDate,
    String? finalDiagnosis,
    String? followUpInstructions,
    String? generatedSummary,
    String? patientInstructions,
  }) {
    return DischargeSummary(
      id: id ?? this.id,
      summary: summary ?? this.summary,
      dischargeDate: dischargeDate ?? this.dischargeDate,
      finalDiagnosis: finalDiagnosis ?? this.finalDiagnosis,
      followUpInstructions: followUpInstructions ?? this.followUpInstructions,
      generatedSummary: generatedSummary ?? this.generatedSummary,
      patientInstructions: patientInstructions ?? this.patientInstructions,
    );
  }
}

/// A class representing vitals report data
class VitalsReport {
  final String id;
  final double temperature;
  final String bloodPressure;
  final int heartRate;
  final int respiratoryRate;
  final DateTime recordTime;
  final bool isAbnormal;

  VitalsReport({
    required this.id,
    required this.temperature,
    required this.bloodPressure,
    required this.heartRate,
    required this.respiratoryRate,
    required this.recordTime,
    this.isAbnormal = false,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temperature': temperature,
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'respiratoryRate': respiratoryRate,
      'recordTime': recordTime.toIso8601String(),
      'isAbnormal': isAbnormal,
    };
  }

  /// Create from JSON
  factory VitalsReport.fromJson(Map<String, dynamic> json) {
    return VitalsReport(
      id: json['id'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      bloodPressure: json['bloodPressure'] as String,
      heartRate: json['heartRate'] as int,
      respiratoryRate: json['respiratoryRate'] as int,
      recordTime: DateTime.parse(json['recordTime'] as String),
      isAbnormal: json['isAbnormal'] as bool? ?? false,
    );
  }

  /// Create a copy with some fields replaced
  VitalsReport copyWith({
    String? id,
    double? temperature,
    String? bloodPressure,
    int? heartRate,
    int? respiratoryRate,
    DateTime? recordTime,
    bool? isAbnormal,
  }) {
    return VitalsReport(
      id: id ?? this.id,
      temperature: temperature ?? this.temperature,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      heartRate: heartRate ?? this.heartRate,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      recordTime: recordTime ?? this.recordTime,
      isAbnormal: isAbnormal ?? this.isAbnormal,
    );
  }
}

/// A class representing an alert notification
class AlertNotification {
  final String id;
  final String alertType;
  final DateTime date;
  final String status;
  final String details;
  final String? respondedBy;

  AlertNotification({
    required this.id,
    required this.alertType,
    required this.date,
    required this.status,
    required this.details,
    this.respondedBy,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alertType': alertType,
      'date': date.toIso8601String(),
      'status': status,
      'details': details,
      'respondedBy': respondedBy,
    };
  }

  /// Create from JSON
  factory AlertNotification.fromJson(Map<String, dynamic> json) {
    return AlertNotification(
      id: json['id'] as String,
      alertType: json['alertType'] as String,
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
      details: json['details'] as String,
      respondedBy: json['respondedBy'] as String?,
    );
  }

  /// Create a copy with some fields replaced
  AlertNotification copyWith({
    String? id,
    String? alertType,
    DateTime? date,
    String? status,
    String? details,
    String? respondedBy,
  }) {
    return AlertNotification(
      id: id ?? this.id,
      alertType: alertType ?? this.alertType,
      date: date ?? this.date,
      status: status ?? this.status,
      details: details ?? this.details,
      respondedBy: respondedBy ?? this.respondedBy,
    );
  }

  /// Trigger the alert
  void triggerAlert() {
    // Implementation
  }

  /// Respond to the alert
  void respondToAlert() {
    // Implementation
  }
} 