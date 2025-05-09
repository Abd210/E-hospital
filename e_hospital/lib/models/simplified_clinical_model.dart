import 'package:cloud_firestore/cloud_firestore.dart';

/// A simplified medical record class that combines different types of medical information
class SimplifiedMedicalRecord {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String title;       // Diagnostic type, note title, medication name, etc.
  final String description; // Main content of the record
  final DateTime date;
  final String recordType;  // "Diagnostic", "Note", "Prescription", "LabResult", etc.
  final Map<String, dynamic>? additionalInfo; // For any extra data specific to the record type
  final List<String> attachments;

  SimplifiedMedicalRecord({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.title,
    required this.description,
    required this.date,
    required this.recordType,
    this.additionalInfo,
    this.attachments = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'recordType': recordType,
      'additionalInfo': additionalInfo,
      'attachments': attachments,
    };
  }

  factory SimplifiedMedicalRecord.fromJson(Map<String, dynamic> json) {
    return SimplifiedMedicalRecord(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      recordType: json['recordType'] as String,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
      attachments: (json['attachments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  /// Convert from Firestore document
  factory SimplifiedMedicalRecord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return SimplifiedMedicalRecord.fromJson({
      'id': doc.id,
      ...data,
      'date': data['date'] != null
          ? (data['date'] is Timestamp
              ? (data['date'] as Timestamp).toDate().toIso8601String()
              : data['date'])
          : DateTime.now().toIso8601String(),
    });
  }
}

/// A simplified clinical file that contains basic patient info and a list of medical records
class SimplifiedClinicalFile {
  final String id;
  final String patientId;
  final String patientName;
  final String? medicalCondition;
  final String? bloodType;
  final Map<String, dynamic>? vitals;
  final List<SimplifiedMedicalRecord> records;
  final DateTime? lastUpdated;

  SimplifiedClinicalFile({
    required this.id,
    required this.patientId,
    required this.patientName,
    this.medicalCondition,
    this.bloodType,
    this.vitals,
    this.records = const [],
    this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'medicalCondition': medicalCondition,
      'bloodType': bloodType,
      'vitals': vitals,
      'records': records.map((r) => r.toJson()).toList(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory SimplifiedClinicalFile.fromJson(Map<String, dynamic> json) {
    return SimplifiedClinicalFile(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      medicalCondition: json['medicalCondition'] as String?,
      bloodType: json['bloodType'] as String?,
      vitals: json['vitals'] as Map<String, dynamic>?,
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => SimplifiedMedicalRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  /// Convert from Firestore document
  factory SimplifiedClinicalFile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Extract records from various collections
    List<SimplifiedMedicalRecord> records = [];
    
    // Process diagnostics
    if (data['diagnostics'] != null && data['diagnostics'] is List) {
      records.addAll(_processRecords(
        data['diagnostics'] as List<dynamic>,
        'Diagnostic',
        data['patientId'] as String,
        data['patientName'] as String,
      ));
    }
    
    // Process medical notes
    if (data['medicalNotes'] != null && data['medicalNotes'] is List) {
      records.addAll(_processRecords(
        data['medicalNotes'] as List<dynamic>,
        'Note',
        data['patientId'] as String,
        data['patientName'] as String,
      ));
    }
    
    // Process prescriptions
    if (data['prescriptions'] != null && data['prescriptions'] is List) {
      records.addAll(_processRecords(
        data['prescriptions'] as List<dynamic>,
        'Prescription',
        data['patientId'] as String,
        data['patientName'] as String,
      ));
    }
    
    // Process lab results
    if (data['labResults'] != null && data['labResults'] is List) {
      records.addAll(_processRecords(
        data['labResults'] as List<dynamic>,
        'LabResult',
        data['patientId'] as String,
        data['patientName'] as String,
      ));
    }
    
    // Process treatments
    if (data['treatments'] != null && data['treatments'] is List) {
      records.addAll(_processRecords(
        data['treatments'] as List<dynamic>,
        'Treatment',
        data['patientId'] as String,
        data['patientName'] as String,
      ));
    }
    
    return SimplifiedClinicalFile(
      id: doc.id,
      patientId: data['patientId'] as String,
      patientName: data['patientName'] as String,
      medicalCondition: data['medicalCondition'] as String?,
      bloodType: data['bloodType'] as String?,
      vitals: data['vitals'] as Map<String, dynamic>?,
      records: records,
      lastUpdated: data['lastUpdated'] != null
          ? (data['lastUpdated'] as Timestamp).toDate()
          : null,
    );
  }
  
  /// Helper to process records of different types
  static List<SimplifiedMedicalRecord> _processRecords(
    List<dynamic> records,
    String recordType,
    String patientId,
    String patientName,
  ) {
    return records.map((record) {
      final Map<String, dynamic> r = record as Map<String, dynamic>;
      
      String title = '';
      String description = '';
      
      // Extract the appropriate fields based on record type
      switch (recordType) {
        case 'Diagnostic':
          title = r['diagnosisType'] ?? 'Diagnosis';
          description = r['description'] ?? '';
          break;
        case 'Note':
          title = r['noteType'] ?? 'Medical Note';
          description = r['content'] ?? '';
          break;
        case 'Prescription':
          title = r['medicationName'] ?? 'Medication';
          description = 'Dosage: ${r['dosage'] ?? 'N/A'}, Frequency: ${r['frequency'] ?? 'N/A'}';
          break;
        case 'LabResult':
          title = r['testName'] ?? 'Lab Test';
          description = 'Result: ${r['result'] ?? 'N/A'}';
          break;
        case 'Treatment':
          title = r['medication'] ?? 'Treatment';
          description = r['description'] ?? '';
          break;
      }
      
      return SimplifiedMedicalRecord(
        id: r['id'] as String,
        patientId: patientId,
        patientName: patientName,
        doctorId: r['doctorId'] as String? ?? '',
        doctorName: r['doctorName'] as String? ?? r['authorName'] as String? ?? 'Unknown Doctor',
        title: title,
        description: description,
        date: r['date'] != null
            ? (r['date'] is String 
                ? DateTime.parse(r['date'] as String) 
                : (r['date'] as Timestamp).toDate())
            : DateTime.now(),
        recordType: recordType,
        additionalInfo: r,
        attachments: (r['attachments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      );
    }).toList();
  }
  
  /// Compatibility method to convert to old ClinicalFile format if needed
  Map<String, dynamic> toCompatibleFormat() {
    // Group records by type
    final diagnostics = records
        .where((r) => r.recordType == 'Diagnostic')
        .map((r) => r.additionalInfo ?? {})
        .toList();
    
    final medicalNotes = records
        .where((r) => r.recordType == 'Note')
        .map((r) => r.additionalInfo ?? {})
        .toList();
    
    final prescriptions = records
        .where((r) => r.recordType == 'Prescription')
        .map((r) => r.additionalInfo ?? {})
        .toList();
    
    final labResults = records
        .where((r) => r.recordType == 'LabResult')
        .map((r) => r.additionalInfo ?? {})
        .toList();
    
    final treatments = records
        .where((r) => r.recordType == 'Treatment')
        .map((r) => r.additionalInfo ?? {})
        .toList();
    
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'medicalCondition': medicalCondition,
      'bloodType': bloodType,
      'vitals': vitals,
      'diagnostics': diagnostics,
      'medicalNotes': medicalNotes,
      'prescriptions': prescriptions,
      'labResults': labResults, 
      'treatments': treatments,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }
} 
 