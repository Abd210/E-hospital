// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinical_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClinicalFileImpl _$$ClinicalFileImplFromJson(Map<String, dynamic> json) =>
    _$ClinicalFileImpl(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      medicalCondition: json['medicalCondition'] as String?,
      bloodType: json['bloodType'] as String?,
      vitals: json['vitals'] as Map<String, dynamic>?,
      diagnostics: (json['diagnostics'] as List<dynamic>?)
              ?.map((e) => Diagnostic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      treatments: (json['treatments'] as List<dynamic>?)
              ?.map((e) => Treatment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      labResults: (json['labResults'] as List<dynamic>?)
              ?.map((e) => LabResult.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      medicalNotes: (json['medicalNotes'] as List<dynamic>?)
              ?.map((e) => MedicalNote.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      prescriptions: (json['prescriptions'] as List<dynamic>?)
              ?.map((e) => Prescription.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      surgeries: (json['surgeries'] as List<dynamic>?)
              ?.map((e) => Surgery.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClinicalFileImplToJson(_$ClinicalFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'medicalCondition': instance.medicalCondition,
      'bloodType': instance.bloodType,
      'vitals': instance.vitals,
      'diagnostics': instance.diagnostics,
      'treatments': instance.treatments,
      'labResults': instance.labResults,
      'medicalNotes': instance.medicalNotes,
      'prescriptions': instance.prescriptions,
      'surgeries': instance.surgeries,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };

_$VitalsImpl _$$VitalsImplFromJson(Map<String, dynamic> json) => _$VitalsImpl(
      heartRate: json['heartRate'] as String,
      bloodPressure: json['bloodPressure'] as String,
      temperature: json['temperature'] as String,
      oxygenSaturation: json['oxygenSaturation'] as String,
      respiratoryRate: json['respiratoryRate'] as String?,
      weight: json['weight'] as String?,
      height: json['height'] as String?,
      bmi: json['bmi'] as String?,
      pain: json['pain'] as String?,
      lastMeasured: json['lastMeasured'] == null
          ? null
          : DateTime.parse(json['lastMeasured'] as String),
    );

Map<String, dynamic> _$$VitalsImplToJson(_$VitalsImpl instance) =>
    <String, dynamic>{
      'heartRate': instance.heartRate,
      'bloodPressure': instance.bloodPressure,
      'temperature': instance.temperature,
      'oxygenSaturation': instance.oxygenSaturation,
      'respiratoryRate': instance.respiratoryRate,
      'weight': instance.weight,
      'height': instance.height,
      'bmi': instance.bmi,
      'pain': instance.pain,
      'lastMeasured': instance.lastMeasured?.toIso8601String(),
    };

_$DiagnosticImpl _$$DiagnosticImplFromJson(Map<String, dynamic> json) =>
    _$DiagnosticImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      date: DateTime.parse(json['date'] as String),
      diagnosisType: json['diagnosisType'] as String?,
      severity: json['severity'] as String?,
      icdCode: json['icdCode'] as String?,
      notes: json['notes'] as String?,
      symptoms: (json['symptoms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      testResults: (json['testResults'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$DiagnosticImplToJson(_$DiagnosticImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'date': instance.date.toIso8601String(),
      'diagnosisType': instance.diagnosisType,
      'severity': instance.severity,
      'icdCode': instance.icdCode,
      'notes': instance.notes,
      'symptoms': instance.symptoms,
      'testResults': instance.testResults,
      'attachments': instance.attachments,
    };

_$TreatmentImpl _$$TreatmentImplFromJson(Map<String, dynamic> json) =>
    _$TreatmentImpl(
      id: json['id'] as String,
      medication: json['medication'] as String,
      dosage: json['dosage'] as String,
      description: json['description'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      date: DateTime.parse(json['date'] as String),
      treatmentType: json['treatmentType'] as String?,
      duration: json['duration'] as String?,
      frequency: json['frequency'] as String?,
      instructions: json['instructions'] as String?,
      sideEffects: json['sideEffects'] as String?,
      notes: json['notes'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isCompleted: json['isCompleted'] as bool?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TreatmentImplToJson(_$TreatmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medication': instance.medication,
      'dosage': instance.dosage,
      'description': instance.description,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'date': instance.date.toIso8601String(),
      'treatmentType': instance.treatmentType,
      'duration': instance.duration,
      'frequency': instance.frequency,
      'instructions': instance.instructions,
      'sideEffects': instance.sideEffects,
      'notes': instance.notes,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'attachments': instance.attachments,
    };

_$LabResultImpl _$$LabResultImplFromJson(Map<String, dynamic> json) =>
    _$LabResultImpl(
      id: json['id'] as String,
      testName: json['testName'] as String,
      result: json['result'] as String,
      performedBy: json['performedBy'] as String,
      testDate: DateTime.parse(json['testDate'] as String),
      referenceRange: json['referenceRange'] as String?,
      unit: json['unit'] as String?,
      interpretation: json['interpretation'] as String?,
      labName: json['labName'] as String?,
      notes: json['notes'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isAbnormal: json['isAbnormal'] as bool?,
    );

Map<String, dynamic> _$$LabResultImplToJson(_$LabResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testName': instance.testName,
      'result': instance.result,
      'performedBy': instance.performedBy,
      'testDate': instance.testDate.toIso8601String(),
      'referenceRange': instance.referenceRange,
      'unit': instance.unit,
      'interpretation': instance.interpretation,
      'labName': instance.labName,
      'notes': instance.notes,
      'attachments': instance.attachments,
      'isAbnormal': instance.isAbnormal,
    };

_$MedicalNoteImpl _$$MedicalNoteImplFromJson(Map<String, dynamic> json) =>
    _$MedicalNoteImpl(
      id: json['id'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String,
      date: DateTime.parse(json['date'] as String),
      noteType: json['noteType'] as String?,
      visibility: json['visibility'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$MedicalNoteImplToJson(_$MedicalNoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorRole': instance.authorRole,
      'date': instance.date.toIso8601String(),
      'noteType': instance.noteType,
      'visibility': instance.visibility,
      'tags': instance.tags,
      'attachments': instance.attachments,
    };

_$PrescriptionImpl _$$PrescriptionImplFromJson(Map<String, dynamic> json) =>
    _$PrescriptionImpl(
      id: json['id'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      prescriptionDate: DateTime.parse(json['prescriptionDate'] as String),
      duration: json['duration'] as String?,
      instructions: json['instructions'] as String?,
      quantity: json['quantity'] as String?,
      refills: json['refills'] as String?,
      isActive: json['isActive'] as bool?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$PrescriptionImplToJson(_$PrescriptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'medicationName': instance.medicationName,
      'dosage': instance.dosage,
      'frequency': instance.frequency,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'prescriptionDate': instance.prescriptionDate.toIso8601String(),
      'duration': instance.duration,
      'instructions': instance.instructions,
      'quantity': instance.quantity,
      'refills': instance.refills,
      'isActive': instance.isActive,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'attachments': instance.attachments,
    };

_$SurgeryImpl _$$SurgeryImplFromJson(Map<String, dynamic> json) =>
    _$SurgeryImpl(
      id: json['id'] as String,
      procedureName: json['procedureName'] as String,
      surgeonId: json['surgeonId'] as String,
      surgeonName: json['surgeonName'] as String,
      surgeryDate: DateTime.parse(json['surgeryDate'] as String),
      procedureType: json['procedureType'] as String?,
      location: json['location'] as String?,
      duration: json['duration'] as String?,
      anesthesia: json['anesthesia'] as String?,
      preOpDiagnosis: json['preOpDiagnosis'] as String?,
      postOpDiagnosis: json['postOpDiagnosis'] as String?,
      complications: json['complications'] as String?,
      notes: json['notes'] as String?,
      assistants: (json['assistants'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SurgeryImplToJson(_$SurgeryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'procedureName': instance.procedureName,
      'surgeonId': instance.surgeonId,
      'surgeonName': instance.surgeonName,
      'surgeryDate': instance.surgeryDate.toIso8601String(),
      'procedureType': instance.procedureType,
      'location': instance.location,
      'duration': instance.duration,
      'anesthesia': instance.anesthesia,
      'preOpDiagnosis': instance.preOpDiagnosis,
      'postOpDiagnosis': instance.postOpDiagnosis,
      'complications': instance.complications,
      'notes': instance.notes,
      'assistants': instance.assistants,
      'attachments': instance.attachments,
    };

_$AllergyImpl _$$AllergyImplFromJson(Map<String, dynamic> json) =>
    _$AllergyImpl(
      id: json['id'] as String,
      allergen: json['allergen'] as String,
      reaction: json['reaction'] as String,
      severity: json['severity'] as String,
      diagnosedDate: json['diagnosedDate'] == null
          ? null
          : DateTime.parse(json['diagnosedDate'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AllergyImplToJson(_$AllergyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'allergen': instance.allergen,
      'reaction': instance.reaction,
      'severity': instance.severity,
      'diagnosedDate': instance.diagnosedDate?.toIso8601String(),
      'notes': instance.notes,
    };

_$ImmunizationImpl _$$ImmunizationImplFromJson(Map<String, dynamic> json) =>
    _$ImmunizationImpl(
      id: json['id'] as String,
      vaccineName: json['vaccineName'] as String,
      administrationDate: DateTime.parse(json['administrationDate'] as String),
      manufacturer: json['manufacturer'] as String?,
      lotNumber: json['lotNumber'] as String?,
      administeredBy: json['administeredBy'] as String?,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      nextDueDate: json['nextDueDate'] == null
          ? null
          : DateTime.parse(json['nextDueDate'] as String),
    );

Map<String, dynamic> _$$ImmunizationImplToJson(_$ImmunizationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vaccineName': instance.vaccineName,
      'administrationDate': instance.administrationDate.toIso8601String(),
      'manufacturer': instance.manufacturer,
      'lotNumber': instance.lotNumber,
      'administeredBy': instance.administeredBy,
      'location': instance.location,
      'notes': instance.notes,
      'nextDueDate': instance.nextDueDate?.toIso8601String(),
    };

_$FamilyHistoryImpl _$$FamilyHistoryImplFromJson(Map<String, dynamic> json) =>
    _$FamilyHistoryImpl(
      id: json['id'] as String,
      condition: json['condition'] as String,
      relationship: json['relationship'] as String,
      notes: json['notes'] as String?,
      onsetAge: json['onsetAge'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$FamilyHistoryImplToJson(_$FamilyHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'condition': instance.condition,
      'relationship': instance.relationship,
      'notes': instance.notes,
      'onsetAge': instance.onsetAge,
      'status': instance.status,
    };
