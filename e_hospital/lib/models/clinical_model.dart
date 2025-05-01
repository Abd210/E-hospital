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