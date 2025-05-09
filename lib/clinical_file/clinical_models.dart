import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for patient diagnosis
class Diagnosis {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String type;
  final String description;
  final DateTime date;
  final String? notes;
  
  const Diagnosis({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.type,
    required this.description,
    required this.date,
    this.notes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'type': type,
      'description': description,
      'date': date.toIso8601String(),
      'notes': notes,
    };
  }
  
  factory Diagnosis.fromJson(Map<String, dynamic> json) {
    return Diagnosis(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      date: json['date'] is Timestamp 
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
    );
  }
  
  /// Create a copy of this diagnosis with some fields replaced
  Diagnosis copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? type,
    String? description,
    DateTime? date,
    String? notes,
  }) {
    return Diagnosis(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      type: type ?? this.type,
      description: description ?? this.description,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}

/// Model for patient prescription
class Prescription {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String medicationName;
  final String dosage;
  final String frequency;
  final DateTime date;
  final int? duration;
  final String? instructions;
  
  const Prescription({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.date,
    this.duration,
    this.instructions,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'date': date.toIso8601String(),
      'duration': duration,
      'instructions': instructions,
    };
  }
  
  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      medicationName: json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      date: json['date'] is Timestamp 
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date'] as String),
      duration: json['duration'] as int?,
      instructions: json['instructions'] as String?,
    );
  }
  
  /// Create a copy of this prescription with some fields replaced
  Prescription copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? medicationName,
    String? dosage,
    String? frequency,
    DateTime? date,
    int? duration,
    String? instructions,
  }) {
    return Prescription(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      date: date ?? this.date,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }
}

/// Model for laboratory test
class LaboratoryTest {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String testName;
  final String testType;
  final DateTime date;
  final DateTime? resultDate;
  final String? results;
  final String status; // "ordered", "completed", "cancelled"
  final String? notes;
  
  const LaboratoryTest({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.testName,
    required this.testType,
    required this.date,
    this.resultDate,
    this.results,
    required this.status,
    this.notes,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'testName': testName,
      'testType': testType,
      'date': date.toIso8601String(),
      'resultDate': resultDate?.toIso8601String(),
      'results': results,
      'status': status,
      'notes': notes,
    };
  }
  
  factory LaboratoryTest.fromJson(Map<String, dynamic> json) {
    return LaboratoryTest(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      testName: json['testName'] as String,
      testType: json['testType'] as String,
      date: json['date'] is Timestamp 
          ? (json['date'] as Timestamp).toDate()
          : DateTime.parse(json['date'] as String),
      resultDate: json['resultDate'] == null 
          ? null 
          : (json['resultDate'] is Timestamp 
              ? (json['resultDate'] as Timestamp).toDate() 
              : DateTime.parse(json['resultDate'] as String)),
      results: json['results'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
    );
  }
  
  /// Create a copy of this laboratory test with some fields replaced
  LaboratoryTest copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? testName,
    String? testType,
    DateTime? date,
    DateTime? resultDate,
    String? results,
    String? status,
    String? notes,
  }) {
    return LaboratoryTest(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      testName: testName ?? this.testName,
      testType: testType ?? this.testType,
      date: date ?? this.date,
      resultDate: resultDate ?? this.resultDate,
      results: results ?? this.results,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
} 
 