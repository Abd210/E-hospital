import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:e_hospital/models/simplified_clinical_model.dart';

/// A simplified service that handles Firestore operations for clinical files
class SimplifiedFirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final _uuid = Uuid();
  
  // Collection reference
  static final CollectionReference _clinicalFilesCollection = _db.collection('clinical_files');
  
  /// Get a patient's clinical file
  static Future<SimplifiedClinicalFile?> getPatientClinicalFile(String patientId) async {
    try {
      final doc = await _clinicalFilesCollection.doc(patientId).get();
      
      if (!doc.exists) {
        debugPrint('Clinical file not found for patient ID: $patientId');
        // Return empty clinical file
        return SimplifiedClinicalFile(
          id: patientId,
          patientId: patientId,
          patientName: 'Unknown Patient', // This will be updated when saving
          lastUpdated: DateTime.now(),
        );
      }
      
      return SimplifiedClinicalFile.fromFirestore(doc);
    } catch (e) {
      debugPrint('Error getting clinical file: $e');
      return null;
    }
  }
  
  /// Save a clinical file
  static Future<bool> saveClinicalFile(SimplifiedClinicalFile file) async {
    try {
      // Convert to compatible format for storage
      final compatibleData = file.toCompatibleFormat();
      
      await _clinicalFilesCollection.doc(file.patientId).set({
        ...compatibleData,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      
      return true;
    } catch (e) {
      debugPrint('Error saving clinical file: $e');
      return false;
    }
  }
  
  /// Add a medical record to a patient's file
  static Future<bool> addMedicalRecord(String patientId, SimplifiedMedicalRecord record) async {
    try {
      // Get the current file
      final file = await getPatientClinicalFile(patientId);
      if (file == null) return false;
      
      // Create an ID if not provided
      final recordWithId = record.id.isEmpty 
          ? record.copyWith(id: _uuid.v4()) 
          : record;
      
      // Determine which collection to update based on record type
      String collectionField;
      Map<String, dynamic> recordData = recordWithId.additionalInfo ?? {};
      
      // Add common fields to record data
      recordData['id'] = recordWithId.id;
      recordData['date'] = recordWithId.date.toIso8601String();
      
      switch (recordWithId.recordType) {
        case 'Diagnostic':
          collectionField = 'diagnostics';
          recordData['description'] = recordWithId.description;
          recordData['diagnosisType'] = recordWithId.title;
          recordData['doctorId'] = recordWithId.doctorId;
          recordData['doctorName'] = recordWithId.doctorName;
          break;
          
        case 'Note':
          collectionField = 'medicalNotes';
          recordData['content'] = recordWithId.description;
          recordData['noteType'] = recordWithId.title;
          recordData['authorId'] = recordWithId.doctorId;
          recordData['authorName'] = recordWithId.doctorName;
          recordData['authorRole'] = 'medicalPersonnel';
          break;
          
        case 'Prescription':
          collectionField = 'prescriptions';
          recordData['medicationName'] = recordWithId.title;
          recordData['doctorId'] = recordWithId.doctorId;
          recordData['doctorName'] = recordWithId.doctorName;
          recordData['prescriptionDate'] = recordWithId.date.toIso8601String();
          break;
          
        case 'LabResult':
          collectionField = 'labResults';
          recordData['testName'] = recordWithId.title;
          recordData['result'] = recordWithId.description;
          break;
          
        case 'Treatment':
          collectionField = 'treatments';
          recordData['medication'] = recordWithId.title;
          recordData['description'] = recordWithId.description;
          recordData['doctorId'] = recordWithId.doctorId;
          recordData['doctorName'] = recordWithId.doctorName;
          break;
          
        default:
          // Default to medical notes
          collectionField = 'medicalNotes';
          recordData['content'] = recordWithId.description;
          recordData['noteType'] = recordWithId.title;
          recordData['authorId'] = recordWithId.doctorId;
          recordData['authorName'] = recordWithId.doctorName;
          recordData['authorRole'] = 'medicalPersonnel';
      }
      
      // Add attachments if any
      if (recordWithId.attachments.isNotEmpty) {
        recordData['attachments'] = recordWithId.attachments;
      }
      
      // Update the document
      await _clinicalFilesCollection.doc(patientId).update({
        collectionField: FieldValue.arrayUnion([recordData]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error adding medical record: $e');
      return false;
    }
  }
  
  /// Update a medical record
  static Future<bool> updateMedicalRecord(String patientId, SimplifiedMedicalRecord record) async {
    try {
      // Delete the old record
      final deleteSuccess = await deleteMedicalRecord(patientId, record.recordType, record.id);
      if (!deleteSuccess) return false;
      
      // Add the updated record
      return await addMedicalRecord(patientId, record);
    } catch (e) {
      debugPrint('Error updating medical record: $e');
      return false;
    }
  }
  
  /// Delete a medical record
  static Future<bool> deleteMedicalRecord(String patientId, String recordType, String recordId) async {
    try {
      // Get the current file
      final file = await getPatientClinicalFile(patientId);
      if (file == null) return false;
      
      // Determine which collection to update
      String collectionField;
      switch (recordType) {
        case 'Diagnostic':
          collectionField = 'diagnostics';
          break;
        case 'Note':
          collectionField = 'medicalNotes';
          break;
        case 'Prescription':
          collectionField = 'prescriptions';
          break;
        case 'LabResult':
          collectionField = 'labResults';
          break;
        case 'Treatment':
          collectionField = 'treatments';
          break;
        default:
          collectionField = 'medicalNotes';
      }
      
      // Find the record
      final records = file.records.where((r) => r.recordType == recordType && r.id == recordId);
      if (records.isEmpty) return false;
      
      // Get the record data
      final recordData = records.first.additionalInfo;
      if (recordData == null) return false;
      
      // Remove the record
      await _clinicalFilesCollection.doc(patientId).update({
        collectionField: FieldValue.arrayRemove([recordData]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error deleting medical record: $e');
      return false;
    }
  }
  
  /// Update patient vitals
  static Future<bool> updatePatientVitals(String patientId, Map<String, dynamic> vitals) async {
    try {
      await _clinicalFilesCollection.doc(patientId).update({
        'vitals': vitals,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error updating patient vitals: $e');
      return false;
    }
  }

  /// Helper extension for SimplifiedMedicalRecord
  static SimplifiedMedicalRecord _copyWith(SimplifiedMedicalRecord record, {String? id}) {
    if (id == null) return record;
    
    return SimplifiedMedicalRecord(
      id: id,
      patientId: record.patientId,
      patientName: record.patientName,
      doctorId: record.doctorId,
      doctorName: record.doctorName,
      title: record.title,
      description: record.description,
      date: record.date,
      recordType: record.recordType,
      additionalInfo: record.additionalInfo,
      attachments: record.attachments,
    );
  }
}

// Extension to allow copyWith on SimplifiedMedicalRecord
extension SimplifiedMedicalRecordExtension on SimplifiedMedicalRecord {
  SimplifiedMedicalRecord copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? title,
    String? description,
    DateTime? date,
    String? recordType,
    Map<String, dynamic>? additionalInfo,
    List<String>? attachments,
  }) {
    return SimplifiedMedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      recordType: recordType ?? this.recordType,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      attachments: attachments ?? this.attachments,
    );
  }
} 