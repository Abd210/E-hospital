import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:e_hospital/clinical_file/clinical_models.dart';

/// Service that handles Firestore operations related to diagnoses and prescriptions
class ClinicalService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final _uuid = Uuid();
  
  // Collection references
  static final CollectionReference _diagnosesCollection = _db.collection('diagnoses');
  static final CollectionReference _prescriptionsCollection = _db.collection('prescriptions');
  static final CollectionReference _laboratoryTestsCollection = _db.collection('laboratoryTests');
  
  // Diagnoses methods
  
  /// Get all diagnoses for a patient
  static Future<List<Diagnosis>> getPatientDiagnoses(String patientId) async {
    try {
      final snapshot = await _diagnosesCollection.where('patientId', isEqualTo: patientId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Diagnosis.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error getting patient diagnoses: $e');
      return [];
    }
  }
  
  /// Get a diagnosis by ID
  static Future<Diagnosis?> getDiagnosisById(String diagnosisId) async {
    try {
      final doc = await _diagnosesCollection.doc(diagnosisId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return Diagnosis.fromJson({...data, 'id': doc.id});
    } catch (e) {
      debugPrint('Error getting diagnosis: $e');
      return null;
    }
  }
  
  /// Add a new diagnosis
  static Future<String?> addDiagnosis(Diagnosis diagnosis) async {
    try {
      final id = diagnosis.id.isEmpty ? _uuid.v4() : diagnosis.id;
      final diagnosisWithId = diagnosis.copyWith(id: id);
      
      await _diagnosesCollection.doc(id).set(diagnosisWithId.toJson());
      return id;
    } catch (e) {
      debugPrint('Error adding diagnosis: $e');
      return null;
    }
  }
  
  /// Update an existing diagnosis
  static Future<bool> updateDiagnosis(Diagnosis diagnosis) async {
    try {
      await _diagnosesCollection.doc(diagnosis.id).update(diagnosis.toJson());
      return true;
    } catch (e) {
      debugPrint('Error updating diagnosis: $e');
      return false;
    }
  }
  
  /// Delete a diagnosis
  static Future<bool> deleteDiagnosis(String diagnosisId) async {
    try {
      await _diagnosesCollection.doc(diagnosisId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting diagnosis: $e');
      return false;
    }
  }
  
  /// Get all diagnoses for a doctor
  static Future<List<Diagnosis>> getDoctorDiagnoses(String doctorId) async {
    try {
      final snapshot = await _diagnosesCollection.where('doctorId', isEqualTo: doctorId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Diagnosis.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error getting doctor diagnoses: $e');
      return [];
    }
  }
  
  // Prescriptions methods
  
  /// Get all prescriptions for a patient
  static Future<List<Prescription>> getPatientPrescriptions(String patientId) async {
    try {
      final snapshot = await _prescriptionsCollection.where('patientId', isEqualTo: patientId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Prescription.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error getting patient prescriptions: $e');
      return [];
    }
  }
  
  /// Get a prescription by ID
  static Future<Prescription?> getPrescriptionById(String prescriptionId) async {
    try {
      final doc = await _prescriptionsCollection.doc(prescriptionId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return Prescription.fromJson({...data, 'id': doc.id});
    } catch (e) {
      debugPrint('Error getting prescription: $e');
      return null;
    }
  }
  
  /// Add a new prescription
  static Future<String?> addPrescription(Prescription prescription) async {
    try {
      final id = prescription.id.isEmpty ? _uuid.v4() : prescription.id;
      final prescriptionWithId = prescription.copyWith(id: id);
      
      await _prescriptionsCollection.doc(id).set(prescriptionWithId.toJson());
      return id;
    } catch (e) {
      debugPrint('Error adding prescription: $e');
      return null;
    }
  }
  
  /// Update an existing prescription
  static Future<bool> updatePrescription(Prescription prescription) async {
    try {
      await _prescriptionsCollection.doc(prescription.id).update(prescription.toJson());
      return true;
    } catch (e) {
      debugPrint('Error updating prescription: $e');
      return false;
    }
  }
  
  /// Delete a prescription
  static Future<bool> deletePrescription(String prescriptionId) async {
    try {
      await _prescriptionsCollection.doc(prescriptionId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting prescription: $e');
      return false;
    }
  }
  
  /// Get all prescriptions for a doctor
  static Future<List<Prescription>> getDoctorPrescriptions(String doctorId) async {
    try {
      final snapshot = await _prescriptionsCollection.where('doctorId', isEqualTo: doctorId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Prescription.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error getting doctor prescriptions: $e');
      return [];
    }
  }
  
  // Laboratory Tests methods
  
  /// Get all laboratory tests for a patient
  static Future<List<LaboratoryTest>> getPatientLaboratoryTests(String patientId) async {
    try {
      final snapshot = await _laboratoryTestsCollection.where('patientId', isEqualTo: patientId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return LaboratoryTest.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error getting patient laboratory tests: $e');
      return [];
    }
  }
  
  /// Get a laboratory test by ID
  static Future<LaboratoryTest?> getLaboratoryTestById(String testId) async {
    try {
      final doc = await _laboratoryTestsCollection.doc(testId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      return LaboratoryTest.fromJson({...data, 'id': doc.id});
    } catch (e) {
      debugPrint('Error getting laboratory test: $e');
      return null;
    }
  }
  
  /// Add a new laboratory test
  static Future<String?> addLaboratoryTest(LaboratoryTest test) async {
    try {
      final id = test.id.isEmpty ? _uuid.v4() : test.id;
      final testWithId = test.copyWith(id: id);
      
      await _laboratoryTestsCollection.doc(id).set(testWithId.toJson());
      return id;
    } catch (e) {
      debugPrint('Error adding laboratory test: $e');
      return null;
    }
  }
  
  /// Update an existing laboratory test
  static Future<bool> updateLaboratoryTest(LaboratoryTest test) async {
    try {
      await _laboratoryTestsCollection.doc(test.id).update(test.toJson());
      return true;
    } catch (e) {
      debugPrint('Error updating laboratory test: $e');
      return false;
    }
  }
  
  /// Delete a laboratory test
  static Future<bool> deleteLaboratoryTest(String testId) async {
    try {
      await _laboratoryTestsCollection.doc(testId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting laboratory test: $e');
      return false;
    }
  }
  
  /// Get all laboratory tests for a doctor
  static Future<List<LaboratoryTest>> getDoctorLaboratoryTests(String doctorId) async {
    try {
      final snapshot = await _laboratoryTestsCollection.where('doctorId', isEqualTo: doctorId).get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return LaboratoryTest.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      debugPrint('Error getting doctor laboratory tests: $e');
      return [];
    }
  }
  
  /// Update test results
  static Future<bool> updateTestResults(
    String testId, 
    String results, 
    {String? notes}
  ) async {
    try {
      final test = await getLaboratoryTestById(testId);
      if (test == null) return false;
      
      final updatedTest = test.copyWith(
        results: results,
        resultDate: DateTime.now(),
        status: 'completed',
        notes: notes ?? test.notes,
      );
      
      return await updateLaboratoryTest(updatedTest);
    } catch (e) {
      debugPrint('Error updating test results: $e');
      return false;
    }
  }
} 