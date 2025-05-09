import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:e_hospital/models/user_model.dart';
import 'package:e_hospital/models/clinical_model.dart';
import 'package:e_hospital/models/appointment_model.dart';
import 'package:e_hospital/models/doctor.dart';
import 'package:e_hospital/models/patient.dart';

/// A comprehensive service that handles all Firestore operations
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  static final _uuid = Uuid();
  
  // Collection references
  static final CollectionReference _usersCollection = _db.collection('users');
  static final CollectionReference _appointmentsCollection = _db.collection('appointments');
  static final CollectionReference _clinicalFilesCollection = _db.collection('clinical_files');
  static final CollectionReference _appointmentSlotsCollection = _db.collection('appointment_slots');
  static final CollectionReference _departmentsCollection = _db.collection('departments');
  static final CollectionReference _medicationsCollection = _db.collection('medications');
  static final CollectionReference _notificationsCollection = _db.collection('notifications');
  
  // CURRENT USER OPERATIONS
  
  /// Get the current user's role
  static Future<String?> getCurrentUserRole() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    try {
      final doc = await _usersCollection.doc(user.uid).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>?;
      return data?['role'] as String?;
    } catch (e) {
      debugPrint('Error getting user role: $e');
      return null;
    }
  }
  
  /// Get the current authenticated user from Firestore
  static Future<User?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    
    try {
      final doc = await _usersCollection.doc(user.uid).get();
      if (!doc.exists) return null;
      
      // Update last login
      await _usersCollection.doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
      
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error getting current user: $e');
      return null;
    }
  }
  
  // USER OPERATIONS
  
  /// Get a user by ID
  static Future<User?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (!doc.exists) return null;
      
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error getting user by ID: $e');
      return null;
    }
  }
  
  /// Get all users
  static Future<List<User>> getAllUsers() async {
    try {
      final querySnapshot = await _usersCollection.get();
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting all users: $e');
      return [];
    }
  }
  
  /// Get users by role
  static Future<List<User>> getUsersByRole(UserRole role) async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: role.toString().split('.').last)
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting users by role: $e');
      return [];
    }
  }
  
  /// Create a new user
  static Future<User?> createUser(User user) async {
    try {
      final docRef = _usersCollection.doc(user.id);
      
      await docRef.set(user.toFirestore()..addAll({
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }));
      
      final doc = await docRef.get();
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error creating user: $e');
      return null;
    }
  }
  
  /// Update an existing user
  static Future<User?> updateUser(User user) async {
    try {
      final docRef = _usersCollection.doc(user.id);
      
      await docRef.update(user.toFirestore()..addAll({
        'updatedAt': FieldValue.serverTimestamp(),
      }));
      
      final doc = await docRef.get();
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error updating user: $e');
      return null;
    }
  }
  
  /// Delete a user
  static Future<bool> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting user: $e');
      return false;
    }
  }
  
  // DOCTOR OPERATIONS
  
  /// Get all doctors
  static Future<List<User>> getAllDoctors() async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: 'medicalPersonnel')
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting all doctors: $e');
      return [];
    }
  }
  
  /// Get doctors by specialization
  static Future<List<User>> getDoctorsBySpecialization(String specialization) async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: 'medicalPersonnel')
          .where('specialization', isEqualTo: specialization)
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting doctors by specialization: $e');
      return [];
    }
  }
  
  /// Get doctors by department
  static Future<List<User>> getDoctorsByDepartment(String department) async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: 'medicalPersonnel')
          .where('department', isEqualTo: department)
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting doctors by department: $e');
      return [];
    }
  }
  
  /// Get a doctor by ID
  static Future<Doctor?> getDoctorById(String doctorId) async {
    try {
      final doc = await _usersCollection.doc(doctorId).get();
      if (!doc.exists) return null;
      
      final user = User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      if (user.role != UserRole.medicalPersonnel) {
        return null; // Not a doctor
      }
      
      return Doctor.fromUser(user);
    } catch (e) {
      debugPrint('Error getting doctor by ID: $e');
      return null;
    }
  }
  
  /// Get patients assigned to a doctor
  static Future<List<Patient>> getDoctorPatients(String doctorId) async {
    try {
      debugPrint('Getting patients for doctor with ID: $doctorId');
      
      // First get the doctor document
      final doctorDoc = await _usersCollection.doc(doctorId).get();
      if (!doctorDoc.exists) {
        debugPrint('Doctor document does not exist');
        return [];
      }
      
      // Get the doctor data and extract assignedPatientIds directly
      final doctorData = doctorDoc.data() as Map<String, dynamic>?;
      if (doctorData == null) {
        debugPrint('Doctor data is null');
        return [];
      }
      
      // Get assigned patient IDs with fallbacks
      List<dynamic> rawIds = [];
      
      // Check if assignedPatientIds exists directly in the document
      if (doctorData.containsKey('assignedPatientIds')) {
        rawIds = doctorData['assignedPatientIds'] ?? [];
      } 
      // If not, check in profile
      else if (doctorData.containsKey('profile') && 
               doctorData['profile'] is Map<String, dynamic>) {
        final profile = doctorData['profile'] as Map<String, dynamic>;
        if (profile.containsKey('assignedPatientIds')) {
          rawIds = profile['assignedPatientIds'] ?? [];
        }
      }
      
      // Convert to List<String> and filter out any non-string values
      final assignedPatientIds = <String>[];
      for (final id in rawIds) {
        if (id is String) {
          assignedPatientIds.add(id);
        }
      }
      
      debugPrint('Found ${assignedPatientIds.length} assigned patient IDs');
      
      if (assignedPatientIds.isEmpty) {
        return [];
      }
      
      // Get all assigned patients in one batch for efficiency
      final patients = <Patient>[];
      
      // Process in smaller batches if there are many patients
      for (int i = 0; i < assignedPatientIds.length; i += 10) {
        // Get current batch
        final endIndex = (i + 10 < assignedPatientIds.length) 
            ? i + 10 
            : assignedPatientIds.length;
        final batch = assignedPatientIds.sublist(i, endIndex);
        
        // Query for this batch of patients
        try {
          // Use in query for efficiency
          final querySnapshot = await _usersCollection
              .where(FieldPath.documentId, whereIn: batch)
              .where('role', isEqualTo: 'patient')
              .get();
          
          // Convert to Patient objects
          for (final doc in querySnapshot.docs) {
            try {
              final user = User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
              patients.add(Patient.fromUser(user));
              debugPrint('Added patient: ${user.name}');
            } catch (e) {
              debugPrint('Error converting patient doc ${doc.id}: $e');
            }
          }
        } catch (e) {
          debugPrint('Error querying batch of patients: $e');
        }
      }
      
      debugPrint('Returning ${patients.length} patients for doctor');
      return patients;
    } catch (e) {
      debugPrint('Error getting doctor patients: $e');
      return [];
    }
  }
  
  /// Assign patient to doctor
  static Future<bool> assignPatientToDoctor(String patientId, String doctorId) async {
    try {
      // Get current doctor data to check where assignedPatientIds are stored
      final doctorDoc = await _usersCollection.doc(doctorId).get();
      final doctorData = doctorDoc.data() as Map<String, dynamic>?;
      
      if (doctorData == null || !doctorDoc.exists) {
        debugPrint('Doctor not found when assigning patient');
        return false;
      }
      
      // Update the top-level assignedPatientIds field
      await _usersCollection.doc(doctorId).update({
        'assignedPatientIds': FieldValue.arrayUnion([patientId]),
      });
      
      // Also update the patient count in doctor profile for quick reference in UI
      // Count patients in assignedPatientIds array
      final updatedDoc = await _usersCollection.doc(doctorId).get();
      final updatedData = updatedDoc.data() as Map<String, dynamic>?;
      
      if (updatedData != null && updatedData.containsKey('assignedPatientIds')) {
        final assignedIds = updatedData['assignedPatientIds'] as List<dynamic>?;
        final patientCount = assignedIds?.length ?? 0;
        
        // Update the profile.patientCount field
        await _usersCollection.doc(doctorId).update({
          'profile.patientCount': patientCount,
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('Error assigning patient to doctor: $e');
      return false;
    }
  }
  
  /// Remove patient from doctor
  static Future<bool> removePatientFromDoctor(String patientId, String doctorId) async {
    try {
      // Update the top-level assignedPatientIds field
      await _usersCollection.doc(doctorId).update({
        'assignedPatientIds': FieldValue.arrayRemove([patientId]),
      });
      
      // Also update the patient count in doctor profile
      // Count patients in assignedPatientIds array after removal
      final updatedDoc = await _usersCollection.doc(doctorId).get();
      final updatedData = updatedDoc.data() as Map<String, dynamic>?;
      
      if (updatedData != null && updatedData.containsKey('assignedPatientIds')) {
        final assignedIds = updatedData['assignedPatientIds'] as List<dynamic>?;
        final patientCount = assignedIds?.length ?? 0;
        
        // Update the profile.patientCount field
        await _usersCollection.doc(doctorId).update({
          'profile.patientCount': patientCount,
        });
      }
      
      return true;
    } catch (e) {
      debugPrint('Error removing patient from doctor: $e');
      return false;
    }
  }
  
  // PATIENT OPERATIONS
  
  /// Get all patients
  static Future<List<User>> getAllPatients() async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: 'patient')
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting all patients: $e');
      return [];
    }
  }
  
  /// Get patient by ID
  static Future<User?> getPatientById(String patientId) async {
    try {
      final doc = await _usersCollection.doc(patientId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || data['role'] != 'patient') return null;
      
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error getting patient by ID: $e');
      return null;
    }
  }
  
  /// Get doctors assigned to a patient
  static Future<List<User>> getPatientDoctors(String patientId) async {
    try {
      final querySnapshot = await _usersCollection
          .where('role', isEqualTo: 'medicalPersonnel')
          .where('assignedPatientIds', arrayContains: patientId)
          .get();
      
      return querySnapshot.docs
          .map((doc) => User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting patient doctors: $e');
      return [];
    }
  }
  
  // APPOINTMENT OPERATIONS
  
  /// Get all appointments
  static Future<List<Appointment>> getAllAppointments() async {
    try {
      final querySnapshot = await _appointmentsCollection
          .orderBy('appointmentDate', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting all appointments: $e');
      return [];
    }
  }
  
  /// Get appointment by ID
  static Future<Appointment?> getAppointmentById(String appointmentId) async {
    try {
      final doc = await _appointmentsCollection.doc(appointmentId).get();
      if (!doc.exists) return null;
      
      return Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error getting appointment by ID: $e');
      return null;
    }
  }
  
  /// Get appointments for a patient
  static Future<List<Appointment>> getPatientAppointments(String patientId) async {
    try {
      debugPrint('Getting appointments for patient with ID: $patientId');
      
      // Use a more explicit query with no limit to ensure we're getting all appointments
      final querySnapshot = await _appointmentsCollection
          .where('patientId', isEqualTo: patientId)
          .get();
      
      debugPrint('Found ${querySnapshot.docs.length} appointment documents in Firestore');
      
      // Convert snapshots to appointment models with explicit error handling
      final appointments = <Appointment>[];
      for (final doc in querySnapshot.docs) {
        try {
          final appointment = Appointment.fromFirestore(doc);
          appointments.add(appointment);
          debugPrint('Successfully parsed appointment ${appointment.id}');
        } catch (e) {
          debugPrint('Error parsing appointment doc ${doc.id}: $e');
          // Try a more robust approach to parse the document
          try {
            final data = doc.data() as Map<String, dynamic>;
            // Create a minimal valid appointment to avoid losing data
            final fallbackAppointment = Appointment(
              id: doc.id,
              patientId: data['patientId'] ?? patientId,
              patientName: data['patientName'] ?? 'Unknown',
              doctorId: data['doctorId'] ?? '',
              doctorName: data['doctorName'] ?? 'Unknown Doctor',
              appointmentDate: data['appointmentDate'] is Timestamp 
                  ? (data['appointmentDate'] as Timestamp).toDate() 
                  : DateTime.now(),
              time: data['time'] ?? 'Unknown',
              purpose: data['purpose'] ?? 'Unknown',
              status: AppointmentStatus.scheduled,
              type: AppointmentType.checkup,
            );
            appointments.add(fallbackAppointment);
            debugPrint('Added fallback appointment for ${doc.id}');
          } catch (innerError) {
            debugPrint('Failed to create fallback appointment: $innerError');
          }
        }
      }
      
      debugPrint('Successfully retrieved ${appointments.length} appointments for patient');
      return appointments;
    } catch (e) {
      debugPrint('Error getting patient appointments: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return [];
    }
  }
  
  /// Get appointments for a doctor
  static Future<List<Appointment>> getDoctorAppointments(String doctorId) async {
    try {
      debugPrint('Getting appointments for doctor with ID: $doctorId');
      
      // Use a more explicit query to ensure we're getting all appointments
      final querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .get();
      
      debugPrint('Found ${querySnapshot.docs.length} appointment documents in Firestore');
      
      // Convert snapshots to appointment models with explicit error handling
      final appointments = <Appointment>[];
      for (final doc in querySnapshot.docs) {
        try {
          final appointment = Appointment.fromFirestore(doc);
          appointments.add(appointment);
        } catch (e) {
          debugPrint('Error parsing appointment doc ${doc.id}: $e');
        }
      }
      
      debugPrint('Successfully parsed ${appointments.length} appointments');
      return appointments;
    } catch (e) {
      debugPrint('Error getting doctor appointments: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return [];
    }
  }
  
  /// Get upcoming appointments for a patient
  static Future<List<Appointment>> getPatientUpcomingAppointments(String patientId) async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _appointmentsCollection
          .where('patientId', isEqualTo: patientId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('appointmentDate')
          .get();
      
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting patient upcoming appointments: $e');
      return [];
    }
  }
  
  /// Get upcoming appointments for a doctor
  static Future<List<Appointment>> getDoctorUpcomingAppointments(String doctorId) async {
    try {
      // Use a simpler query without requiring composite index
      final querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .get();
      
      final now = DateTime.now();
      // Filter locally instead of in the query
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .where((appointment) => appointment.appointmentDate.isAfter(now))
          .toList()
          ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
    } catch (e) {
      debugPrint('Error getting doctor upcoming appointments: $e');
      return [];
    }
  }
  
  /// Get appointments by date range
  static Future<List<Appointment>> getAppointmentsByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final querySnapshot = await _appointmentsCollection
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('appointmentDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('appointmentDate')
          .get();
      
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting appointments by date range: $e');
      return [];
    }
  }
  
  /// Create a new appointment
  static Future<Appointment?> createAppointment(Appointment appointment) async {
    try {
      debugPrint('Creating appointment: ${appointment.id} for patient ${appointment.patientName} with doctor ${appointment.doctorName}');
      
      final appointmentWithId = appointment.id.isEmpty
          ? appointment.copyWith(id: _uuid.v4())
          : appointment;
      
      final docRef = _appointmentsCollection.doc(appointmentWithId.id);
      
      // Create the Firestore data
      final firestoreData = appointmentWithId.toFirestore();
      debugPrint('Appointment data to be saved: $firestoreData');
      
      await docRef.set(firestoreData..addAll({
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }));
      
      // Verify if the appointment was created
      final doc = await docRef.get();
      if (!doc.exists) {
        debugPrint('Error: Appointment was not saved properly');
        return null;
      }
      
      debugPrint('Appointment created successfully');
      return Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error creating appointment: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return null;
    }
  }
  
  /// Update an existing appointment
  static Future<Appointment?> updateAppointment(Appointment appointment) async {
    try {
      final docRef = _appointmentsCollection.doc(appointment.id);
      
      await docRef.update(appointment.toFirestore()..addAll({
        'updatedAt': FieldValue.serverTimestamp(),
      }));
      
      final doc = await docRef.get();
      return Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error updating appointment: $e');
      return null;
    }
  }
  
  /// Delete an appointment
  static Future<bool> deleteAppointment(String appointmentId) async {
    try {
      await _appointmentsCollection.doc(appointmentId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting appointment: $e');
      return false;
    }
  }
  
  // CLINICAL FILE OPERATIONS
  
  /// Get clinical file by patient ID
  static Future<ClinicalFile?> getClinicalFileByPatientId(String? patientId) async {
    if (patientId == null) {
      debugPrint('Error getting clinical file: patientId is null');
      return null;
    }
    
    try {
      final doc = await _clinicalFilesCollection.doc(patientId).get();
      if (!doc.exists) {
        debugPrint('Clinical file not found for patient ID: $patientId');
        // Create a default clinical file and return it
        return ClinicalFile(
          id: patientId,
          patientId: patientId,
          patientName: 'Unknown Patient', // This will be updated when saving
          lastUpdated: DateTime.now(),
        );
      }
      
      return ClinicalFile.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error getting clinical file by patient ID: $e');
      return null;
    }
  }
  
  /// Get all clinical files
  static Future<List<ClinicalFile>> getAllClinicalFiles() async {
    try {
      final querySnapshot = await _clinicalFilesCollection.get();
      
      return querySnapshot.docs
          .map((doc) => ClinicalFile.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting all clinical files: $e');
      return [];
    }
  }
  
  /// Create or update a clinical file
  static Future<ClinicalFile?> updateClinicalFile(ClinicalFile clinicalFile) async {
    try {
      final docRef = _clinicalFilesCollection.doc(clinicalFile.patientId);
      
      await docRef.set(
        {
          'patientId': clinicalFile.patientId,
          'patientName': clinicalFile.patientName,
          'medicalCondition': clinicalFile.medicalCondition,
          'bloodType': clinicalFile.bloodType,
          'vitals': clinicalFile.vitals,
          'diagnostics': clinicalFile.diagnostics.map((d) => d.toJson()).toList(),
          'treatments': clinicalFile.treatments.map((t) => t.toJson()).toList(),
          'labResults': clinicalFile.labResults.map((l) => l.toJson()).toList(),
          'medicalNotes': clinicalFile.medicalNotes.map((m) => m.toJson()).toList(),
          'prescriptions': clinicalFile.prescriptions.map((p) => p.toJson()).toList(),
          'surgeries': clinicalFile.surgeries.map((s) => s.toJson()).toList(),
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
      
      final doc = await docRef.get();
      return ClinicalFile.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error updating clinical file: $e');
      return null;
    }
  }
  
  /// Add a diagnostic to a patient's clinical file
  static Future<bool> addDiagnostic(String patientId, Diagnostic diagnostic) async {
    try {
      final diagnosticWithId = diagnostic.id.isEmpty
          ? diagnostic.copyWith(id: _uuid.v4())
          : diagnostic;
      
      // Check if clinical file exists
      final docSnapshot = await _clinicalFilesCollection.doc(patientId).get();
      
      if (!docSnapshot.exists) {
        // Get patient name
        final patientDoc = await _usersCollection.doc(patientId).get();
        String patientName = 'Patient';
        if (patientDoc.exists) {
          final patientData = patientDoc.data() as Map<String, dynamic>?;
          patientName = patientData?['name'] ?? 'Patient';
        }
        
        // Create clinical file first
        await _clinicalFilesCollection.doc(patientId).set({
          'patientId': patientId,
          'patientName': patientName,
          'diagnostics': [diagnosticWithId.toJson()],
          'treatments': [],
          'labResults': [],
          'medicalNotes': [],
          'prescriptions': [],
          'surgeries': [],
          'lastUpdated': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return true;
      } else {
        // Document exists, update it
        await _clinicalFilesCollection.doc(patientId).update({
          'diagnostics': FieldValue.arrayUnion([diagnosticWithId.toJson()]),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        
        return true;
      }
    } catch (e) {
      debugPrint('Error adding diagnostic: $e');
      return false;
    }
  }
  
  /// Add a treatment to a patient's clinical file
  static Future<bool> addTreatment(String patientId, Treatment treatment) async {
    try {
      final treatmentWithId = treatment.id.isEmpty
          ? treatment.copyWith(id: _uuid.v4())
          : treatment;
      
      // Check if clinical file exists
      final docSnapshot = await _clinicalFilesCollection.doc(patientId).get();
      
      if (!docSnapshot.exists) {
        // Get patient name
        final patientDoc = await _usersCollection.doc(patientId).get();
        String patientName = 'Patient';
        if (patientDoc.exists) {
          final patientData = patientDoc.data() as Map<String, dynamic>?;
          patientName = patientData?['name'] ?? 'Patient';
        }
        
        // Create clinical file first
        await _clinicalFilesCollection.doc(patientId).set({
          'patientId': patientId,
          'patientName': patientName,
          'diagnostics': [],
          'treatments': [treatmentWithId.toJson()],
          'labResults': [],
          'medicalNotes': [],
          'prescriptions': [],
          'surgeries': [],
          'lastUpdated': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return true;
      } else {
        // Document exists, update it
        await _clinicalFilesCollection.doc(patientId).update({
          'treatments': FieldValue.arrayUnion([treatmentWithId.toJson()]),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        
        return true;
      }
    } catch (e) {
      debugPrint('Error adding treatment: $e');
      return false;
    }
  }
  
  /// Add a lab result to a patient's clinical file
  static Future<bool> addLabResult(String patientId, LabResult labResult) async {
    try {
      final labResultWithId = labResult.id.isEmpty
          ? labResult.copyWith(id: _uuid.v4())
          : labResult;
      
      await _clinicalFilesCollection.doc(patientId).update({
        'labResults': FieldValue.arrayUnion([labResultWithId.toJson()]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error adding lab result: $e');
      return false;
    }
  }
  
  /// Add a medical note to a patient's clinical file
  static Future<bool> addMedicalNote(String patientId, MedicalNote medicalNote) async {
    try {
      final noteWithId = medicalNote.id.isEmpty
          ? medicalNote.copyWith(id: _uuid.v4())
          : medicalNote;
      
      await _clinicalFilesCollection.doc(patientId).update({
        'medicalNotes': FieldValue.arrayUnion([noteWithId.toJson()]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error adding medical note: $e');
      return false;
    }
  }
  
  /// Add a prescription to a patient's clinical file
  static Future<bool> addPrescription(String patientId, Prescription prescription) async {
    try {
      final prescriptionWithId = prescription.id.isEmpty
          ? prescription.copyWith(id: _uuid.v4())
          : prescription;
      
      await _clinicalFilesCollection.doc(patientId).update({
        'prescriptions': FieldValue.arrayUnion([prescriptionWithId.toJson()]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error adding prescription: $e');
      return false;
    }
  }
  
  /// Add a surgery to a patient's clinical file
  static Future<bool> addSurgery(String patientId, Surgery surgery) async {
    try {
      final surgeryWithId = surgery.id.isEmpty
          ? surgery.copyWith(id: _uuid.v4())
          : surgery;
      
      await _clinicalFilesCollection.doc(patientId).update({
        'surgeries': FieldValue.arrayUnion([surgeryWithId.toJson()]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error adding surgery: $e');
      return false;
    }
  }
  
  /// Add or update a discharge summary to a patient's clinical file
  static Future<bool> updateDischargeSummary(String patientId, DischargeSummary dischargeSummary) async {
    try {
      final summaryWithId = dischargeSummary.id.isEmpty
          ? dischargeSummary.copyWith(id: _uuid.v4())
          : dischargeSummary;
      
      // Check if clinical file exists
      final docSnapshot = await _clinicalFilesCollection.doc(patientId).get();
      
      if (!docSnapshot.exists) {
        // Get patient name
        final patientDoc = await _usersCollection.doc(patientId).get();
        String patientName = 'Patient';
        if (patientDoc.exists) {
          final patientData = patientDoc.data() as Map<String, dynamic>?;
          patientName = patientData?['name'] ?? 'Patient';
        }
        
        // Create clinical file first
        await _clinicalFilesCollection.doc(patientId).set({
          'patientId': patientId,
          'patientName': patientName,
          'diagnostics': [],
          'treatments': [],
          'labResults': [],
          'medicalNotes': [],
          'prescriptions': [],
          'surgeries': [],
          'dischargeSummary': summaryWithId.toJson(),
          'lastUpdated': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return true;
      } else {
        // Document exists, update it
        await _clinicalFilesCollection.doc(patientId).update({
          'dischargeSummary': summaryWithId.toJson(),
          'lastUpdated': FieldValue.serverTimestamp(),
        });
        
        return true;
      }
    } catch (e) {
      debugPrint('Error updating discharge summary: $e');
      return false;
    }
  }
  
  /// Delete a discharge summary from a patient's clinical file
  static Future<bool> deleteDischargeSummary(String patientId) async {
    try {
      await _clinicalFilesCollection.doc(patientId).update({
        'dischargeSummary': FieldValue.delete(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error deleting discharge summary: $e');
      return false;
    }
  }
  
  /// Add or update a vitals report to a patient's clinical file
  static Future<bool> updateVitalsReport(String patientId, VitalsReport vitalsReport) async {
    try {
      final reportWithId = vitalsReport.id.isEmpty
          ? vitalsReport.copyWith(id: _uuid.v4())
          : vitalsReport;
      
      await _clinicalFilesCollection.doc(patientId).update({
        'vitalsReport': reportWithId.toJson(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      // If there's an abnormal vitals report, create an alert notification
      if (vitalsReport.isAbnormal) {
        final alertNotification = {
          'id': _uuid.v4(),
          'userId': patientId,
          'type': 'abnormal_vitals',
          'message': 'Patient has abnormal vital signs. Please check immediately.',
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        };
        
        await _notificationsCollection.add(alertNotification);
      }
      
      return true;
    } catch (e) {
      debugPrint('Error updating vitals report: $e');
      return false;
    }
  }
  
  /// Delete a vitals report from a patient's clinical file
  static Future<bool> deleteVitalsReport(String patientId) async {
    try {
      await _clinicalFilesCollection.doc(patientId).update({
        'vitalsReport': FieldValue.delete(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error deleting vitals report: $e');
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
  
  // DEPARTMENT OPERATIONS
  
  /// Get all departments
  static Future<List<Map<String, dynamic>>> getAllDepartments() async {
    try {
      final querySnapshot = await _departmentsCollection.get();
      
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList();
    } catch (e) {
      debugPrint('Error getting all departments: $e');
      return [];
    }
  }
  
  // MEDICATION OPERATIONS
  
  /// Get all medications
  static Future<List<Map<String, dynamic>>> getAllMedications() async {
    try {
      final querySnapshot = await _medicationsCollection.get();
      
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList();
    } catch (e) {
      debugPrint('Error getting all medications: $e');
      return [];
    }
  }
  
  // NOTIFICATION OPERATIONS
  
  /// Get notifications for a user
  static Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final querySnapshot = await _notificationsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList();
    } catch (e) {
      debugPrint('Error getting user notifications: $e');
      return [];
    }
  }
  
  /// Add a notification for a user
  static Future<bool> addNotification(Map<String, dynamic> notification) async {
    try {
      await _notificationsCollection.add({
        ...notification,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });
      
      return true;
    } catch (e) {
      debugPrint('Error adding notification: $e');
      return false;
    }
  }
  
  /// Mark a notification as read
  static Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).update({
        'read': true,
      });
      
      return true;
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      return false;
    }
  }
  
  /// Delete a notification
  static Future<bool> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
      return true;
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      return false;
    }
  }
  
  // DASHBOARD DATA OPERATIONS
  
  /// Get dashboard data for admin
  static Future<Map<String, dynamic>> getAdminDashboardData() async {
    try {
      // Get counts for different user types
      final usersSnapshot = await _usersCollection.get();
      final users = usersSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      
      int doctorCount = 0;
      int patientCount = 0;
      int nurseCount = 0;
      int staffCount = 0;
      
      for (final user in users) {
        final role = user['role'] as String?;
        if (role == 'medicalPersonnel') {
          doctorCount++;
        } else if (role == 'patient') {
          patientCount++;
        } else if (role == 'nurse') {
          nurseCount++;
        } else if (role != 'hospitalAdmin') {
          staffCount++;
        }
      }
      
      // Get appointment statistics
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(Duration(days: 1));
      
      final appointmentsSnapshot = await _appointmentsCollection.get();
      final appointments = appointmentsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      
      int todayAppointments = 0;
      int pendingAppointments = 0;
      int completedAppointments = 0;
      int cancelledAppointments = 0;
      
      for (final appointment in appointments) {
        // Handle null timestamps safely
        final Timestamp? appointmentTimestamp = appointment['appointmentDate'] as Timestamp?;
        final status = appointment['status'] as String?;
        
        if (appointmentTimestamp != null) {
          final date = appointmentTimestamp.toDate();
          if (date.isAfter(today) && date.isBefore(tomorrow)) {
            todayAppointments++;
          }
        }
        
        if (status == 'scheduled' || status == 'confirmed') {
          pendingAppointments++;
        } else if (status == 'completed') {
          completedAppointments++;
        } else if (status == 'cancelled' || status == 'noShow') {
          cancelledAppointments++;
        }
      }
      
      // Return dashboard data
      return {
        'doctorCount': doctorCount,
        'patientCount': patientCount,
        'nurseCount': nurseCount,
        'staffCount': staffCount,
        'totalUsers': users.length,
        'todayAppointments': todayAppointments,
        'pendingAppointments': pendingAppointments,
        'completedAppointments': completedAppointments,
        'cancelledAppointments': cancelledAppointments,
        'totalAppointments': appointments.length,
      };
    } catch (e) {
      debugPrint('Error getting admin dashboard data: $e');
      return {};
    }
  }
  
  /// Get dashboard data for doctor
  static Future<Map<String, dynamic>> getDoctorDashboardData(String doctorId) async {
    try {
      // Get assigned patients
      final doctorDoc = await _usersCollection.doc(doctorId).get();
      final doctorData = doctorDoc.data() as Map<String, dynamic>?;
      
      if (doctorData == null || !doctorDoc.exists) {
        return {};
      }
      
      // Look for assigned patients in both possible locations
      List<dynamic> rawIds = [];
      
      // Check if assignedPatientIds exists directly in the document
      if (doctorData.containsKey('assignedPatientIds')) {
        rawIds = doctorData['assignedPatientIds'] ?? [];
      } 
      // If not, check in profile
      else if (doctorData.containsKey('profile') && 
               doctorData['profile'] is Map<String, dynamic>) {
        final profile = doctorData['profile'] as Map<String, dynamic>;
        if (profile.containsKey('assignedPatientIds')) {
          rawIds = profile['assignedPatientIds'] ?? [];
        }
      }
      
      // Convert to List<String> and filter out any non-string values
      final assignedPatientIds = <String>[];
      for (final id in rawIds) {
        if (id is String) {
          assignedPatientIds.add(id);
        }
      }
      
      debugPrint('Found ${assignedPatientIds.length} assigned patient IDs for doctor $doctorId');
      
      // Get patient details for the dashboard
      List<Map<String, dynamic>> patientList = [];
      if (assignedPatientIds.isNotEmpty) {
        try {
          // Process patients in batches to avoid large queries
          for (int i = 0; i < assignedPatientIds.length; i += 10) {
            final endIndex = (i + 10 < assignedPatientIds.length) 
                ? i + 10 
                : assignedPatientIds.length;
            final batchIds = assignedPatientIds.sublist(i, endIndex);
            
            final patientsSnapshot = await _usersCollection
                .where(FieldPath.documentId, whereIn: batchIds)
                .where('role', isEqualTo: 'patient')
                .get();
                
            for (final doc in patientsSnapshot.docs) {
              final data = doc.data() as Map<String, dynamic>;
              patientList.add({
                'id': doc.id,
                'name': data['name'] ?? 'Unknown',
                'age': data['age'] ?? (data['profile'] != null ? data['profile']['age'] : 0),
                'gender': data['gender'] ?? (data['profile'] != null ? data['profile']['gender'] : 'Unknown'),
                'medicalCondition': data['medicalCondition'] ?? 
                  (data['profile'] != null ? data['profile']['medicalCondition'] ?? 'N/A' : 'N/A'),
              });
            }
          }
        } catch (e) {
          debugPrint('Error loading patient details: $e');
        }
      }
      
      // Get appointments with a simpler query
      try {
        final appointmentsSnapshot = await _appointmentsCollection
            .where('doctorId', isEqualTo: doctorId)
            .get();
        
        final allAppointments = appointmentsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...(doc.data() as Map<String, dynamic>),
                })
            .toList();
        
        // Filter upcoming appointments in memory
        final now = DateTime.now();
        final upcomingAppointments = allAppointments
            .where((appointment) {
              final appointmentDate = (appointment['appointmentDate'] as Timestamp?)?.toDate();
              return appointmentDate != null && appointmentDate.isAfter(now);
            })
            .toList()
            ..sort((a, b) {
              final dateA = (a['appointmentDate'] as Timestamp).toDate();
              final dateB = (b['appointmentDate'] as Timestamp).toDate();
              return dateA.compareTo(dateB);
            });
        
        // Take only first 10 appointments after sorting
        final limitedUpcomingAppointments = upcomingAppointments.take(10).toList();
        
        // Get today's appointments by filtering in memory
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(Duration(days: 1));
        
        final todayAppointments = allAppointments
            .where((appointment) {
              final appointmentDate = (appointment['appointmentDate'] as Timestamp?)?.toDate();
              return appointmentDate != null && 
                     appointmentDate.isAfter(today) && 
                     appointmentDate.isBefore(tomorrow);
            })
            .toList();
        
        // Return dashboard data
        return {
          'patientCount': assignedPatientIds.length,
          'patientList': patientList,
          'todayAppointments': todayAppointments,
          'upcomingAppointments': limitedUpcomingAppointments,
          'appointmentCount': allAppointments.length,
        };
      } catch (e) {
        debugPrint('Error getting appointments data: $e');
        // Fallback in case of query error
        return {
          'patientCount': assignedPatientIds.length,
          'patientList': patientList,
          'todayAppointments': [],
          'upcomingAppointments': [],
          'appointmentCount': 0,
        };
      }
    } catch (e) {
      debugPrint('Error getting doctor dashboard data: $e');
      return {};
    }
  }
  
  /// Get dashboard data for patient
  static Future<Map<String, dynamic>> getPatientDashboardData(String patientId) async {
    try {
      // Get clinical file
      final clinicalFileDoc = await _clinicalFilesCollection.doc(patientId).get();
      final clinicalFileData = clinicalFileDoc.exists 
          ? clinicalFileDoc.data() as Map<String, dynamic>? 
          : null;
      
      // Get upcoming appointments - use try-catch for query issues
      List<Map<String, dynamic>> upcomingAppointments = [];
      try {
        final now = DateTime.now();
        final appointmentsSnapshot = await _appointmentsCollection
            .where('patientId', isEqualTo: patientId)
            .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .orderBy('appointmentDate')
            .limit(5)
            .get();
        
        upcomingAppointments = appointmentsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...(doc.data() as Map<String, dynamic>),
                })
            .toList();
      } catch (e) {
        debugPrint('Error getting patient appointments: $e');
        // Keep as empty list on error
      }
      
      // Get assigned doctors
      final doctorsSnapshot = await _usersCollection
          .where('role', isEqualTo: 'medicalPersonnel')
          .where('assignedPatientIds', arrayContains: patientId)
          .get();
      
      final assignedDoctors = doctorsSnapshot.docs
          .map((doc) => {
                'id': doc.id,
                ...(doc.data() as Map<String, dynamic>),
              })
          .toList();
      
      // Get appointment count safely
      int appointmentCount = 0;
      try {
        final countResult = await _appointmentsCollection
            .where('patientId', isEqualTo: patientId)
            .count()
            .get();
        
        appointmentCount = countResult.count ?? 0;
      } catch (e) {
        debugPrint('Error getting patient appointment count: $e');
        // Keep as 0 on error
      }
      
      // Return dashboard data
      return {
        'clinicalFile': clinicalFileData,
        'upcomingAppointments': upcomingAppointments,
        'assignedDoctors': assignedDoctors,
        'appointmentCount': appointmentCount,
      };
    } catch (e) {
      debugPrint('Error getting patient dashboard data: $e');
      return {};
    }
  }
  
  /// Get appointments for a specific patient with a specific doctor
  static Future<List<Appointment>> getPatientAppointmentsWithDoctor(String patientId, String doctorId) async {
    try {
      debugPrint('Querying appointments for patient $patientId with doctor $doctorId');
      final querySnapshot = await _appointmentsCollection
          .where('patientId', isEqualTo: patientId)
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('appointmentDate', descending: true)
          .get();
      
      debugPrint('Found ${querySnapshot.docs.length} appointment documents for patient with doctor');
      
      // Print raw data for debugging
      for (var doc in querySnapshot.docs) {
        debugPrint('Appointment document ID: ${doc.id}');
        final data = doc.data() as Map<String, dynamic>;
        debugPrint('Raw data: ${data.toString()}');
      }
      
      return querySnapshot.docs
          .map((doc) {
            try {
              return Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
            } catch (e) {
              debugPrint('Error parsing appointment document ${doc.id}: $e');
              // Return a placeholder appointment to avoid null issues
              return Appointment(
                id: doc.id,
                patientId: patientId,
                patientName: 'Error loading patient',
                doctorId: doctorId,
                doctorName: 'Error loading doctor',
                appointmentDate: DateTime.now(),
                time: 'Unknown',
                purpose: 'Unknown',
              );
            }
          })
          .toList();
    } catch (e) {
      debugPrint('Error getting patient appointments with doctor: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return [];
    }
  }
  
  // HELPER METHODS
  
  /// Fetch the current user's role (used by the router)
  static Future<String?> fetchRole() async {
    return getCurrentUserRole();
  }
  
  /// Create a doctor (a user with medicalPersonnel role)
  static Future<User?> createDoctor(Map<String, dynamic> doctorData) async {
    try {
      // Ensure the role is set to medicalPersonnel
      doctorData['role'] = 'medicalPersonnel';
      
      // Generate a new ID if not provided
      final String id = doctorData['id'] as String? ?? _uuid.v4();
      doctorData['id'] = id;
      
      final docRef = _usersCollection.doc(id);
      
      await docRef.set({
        ...doctorData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final doc = await docRef.get();
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error creating doctor: $e');
      return null;
    }
  }
  
  /// Update a doctor (a user with medicalPersonnel role)
  static Future<User?> updateDoctor(String doctorId, Map<String, dynamic> doctorData) async {
    try {
      // Ensure the role is set to medicalPersonnel
      doctorData['role'] = 'medicalPersonnel';
      
      // Remove ID from data if present to avoid overwriting
      doctorData.remove('id');
      
      final docRef = _usersCollection.doc(doctorId);
      
      await docRef.update({
        ...doctorData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final doc = await docRef.get();
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error updating doctor: $e');
      return null;
    }
  }
  
  /// Delete a doctor
  static Future<bool> deleteDoctor(String doctorId) async {
    try {
      // Check if the user is a doctor
      final doc = await _usersCollection.doc(doctorId).get();
      if (!doc.exists) return false;
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || data['role'] != 'medicalPersonnel') {
        return false; // Not a doctor
      }
      
      // Delete the user document
      await _usersCollection.doc(doctorId).delete();
      
      // Delete related appointments
      final appointmentsSnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .get();
          
      for (final doc in appointmentsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting doctor: $e');
      return false;
    }
  }
  
  /// Create a patient (a user with patient role)
  static Future<User?> createPatient(Map<String, dynamic> patientData) async {
    try {
      // Ensure the role is set to patient
      patientData['role'] = 'patient';
      
      // Generate a new ID if not provided
      final String id = patientData['id'] as String? ?? _uuid.v4();
      patientData['id'] = id;
      
      final docRef = _usersCollection.doc(id);
      
      await docRef.set({
        ...patientData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final doc = await docRef.get();
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error creating patient: $e');
      return null;
    }
  }
  
  /// Update a patient (a user with patient role)
  static Future<User?> updatePatient(String patientId, Map<String, dynamic> patientData) async {
    try {
      // Ensure the role is set to patient
      patientData['role'] = 'patient';
      
      // Remove ID from data if present to avoid overwriting
      patientData.remove('id');
      
      final docRef = _usersCollection.doc(patientId);
      
      await docRef.update({
        ...patientData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      final doc = await docRef.get();
      return User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error updating patient: $e');
      return null;
    }
  }
  
  /// Delete a patient
  static Future<bool> deletePatient(String patientId) async {
    try {
      // Check if the user is a patient
      final doc = await _usersCollection.doc(patientId).get();
      if (!doc.exists) return false;
      
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null || data['role'] != 'patient') {
        return false; // Not a patient
      }
      
      // Delete the user document
      await _usersCollection.doc(patientId).delete();
      
      // Delete related appointments
      final appointmentsSnapshot = await _appointmentsCollection
          .where('patientId', isEqualTo: patientId)
          .get();
          
      for (final doc in appointmentsSnapshot.docs) {
        await doc.reference.delete();
      }
      
      // Delete clinical file if exists
      final clinicalFileDoc = await _clinicalFilesCollection.doc(patientId).get();
      if (clinicalFileDoc.exists) {
        await _clinicalFilesCollection.doc(patientId).delete();
      }
      
      return true;
    } catch (e) {
      debugPrint('Error deleting patient: $e');
      return false;
    }
  }
  
  /// Create sample appointments for testing
  static Future<bool> createSampleAppointments(String doctorId, String patientId) async {
    try {
      debugPrint('Creating sample appointments for testing: doctor $doctorId, patient $patientId');
      
      // Get doctor and patient names
      String doctorName = 'Doctor';
      String patientName = 'Patient';
      String doctorSpecialty = 'General';
      
      try {
        final doctorDoc = await _usersCollection.doc(doctorId).get();
        if (doctorDoc.exists) {
          final doctorData = doctorDoc.data() as Map<String, dynamic>?;
          doctorName = doctorData?['name'] ?? 'Doctor';
          doctorSpecialty = (doctorData?['profile'] as Map<String, dynamic>?)?['specialization'] ?? 'General';
        }
        
        final patientDoc = await _usersCollection.doc(patientId).get();
        if (patientDoc.exists) {
          final patientData = patientDoc.data() as Map<String, dynamic>?;
          patientName = patientData?['name'] ?? 'Patient';
        }
      } catch (e) {
        debugPrint('Error getting doctor/patient details: $e');
      }
      
      // Create a few sample appointments
      final now = DateTime.now();
      
      // Past appointment
      final pastAppointment = Appointment(
        id: _uuid.v4(),
        patientId: patientId,
        patientName: patientName,
        doctorId: doctorId,
        doctorName: 'Dr. $doctorName',
        doctorSpecialty: doctorSpecialty,
        appointmentDate: DateTime(now.year, now.month, now.day - 7),
        time: '10:00 AM',
        purpose: 'Regular checkup',
        status: AppointmentStatus.completed,
        type: AppointmentType.checkup,
        notes: 'Patient reported feeling better',
      );
      
      // Today's appointment
      final todayAppointment = Appointment(
        id: _uuid.v4(),
        patientId: patientId,
        patientName: patientName,
        doctorId: doctorId,
        doctorName: 'Dr. $doctorName',
        doctorSpecialty: doctorSpecialty,
        appointmentDate: DateTime(now.year, now.month, now.day),
        time: '2:30 PM',
        purpose: 'Follow-up consultation',
        status: AppointmentStatus.scheduled,
        type: AppointmentType.followUp,
      );
      
      // Future appointment
      final futureAppointment = Appointment(
        id: _uuid.v4(),
        patientId: patientId,
        patientName: patientName,
        doctorId: doctorId,
        doctorName: 'Dr. $doctorName',
        doctorSpecialty: doctorSpecialty,
        appointmentDate: DateTime(now.year, now.month, now.day + 14),
        time: '11:15 AM',
        purpose: 'Vaccination',
        status: AppointmentStatus.scheduled,
        type: AppointmentType.vaccination,
      );
      
      // Save appointments to Firestore
      await createAppointment(pastAppointment);
      await createAppointment(todayAppointment);
      await createAppointment(futureAppointment);
      
      debugPrint('Successfully created 3 sample appointments');
      return true;
    } catch (e) {
      debugPrint('Error creating sample appointments: $e');
      return false;
    }
  }
  
  /// Add a test appointment directly (bypassing the model)
  static Future<bool> addDirectTestAppointment(String doctorId, String patientId) async {
    try {
      debugPrint('Creating a direct test appointment with doctor: $doctorId and patient: $patientId');
      
      // Get names
      String doctorName = 'Doctor';
      String patientName = 'Patient';
      
      try {
        final doctorDoc = await _usersCollection.doc(doctorId).get();
        if (doctorDoc.exists) {
          doctorName = (doctorDoc.data() as Map<String, dynamic>)['name'] ?? 'Doctor';
        }
        
        final patientDoc = await _usersCollection.doc(patientId).get();
        if (patientDoc.exists) {
          patientName = (patientDoc.data() as Map<String, dynamic>)['name'] ?? 'Patient';
        }
      } catch (e) {
        debugPrint('Error getting names: $e');
      }
      
      // Create appointment document ID
      final appointmentId = _uuid.v4();
      debugPrint('Using appointment ID: $appointmentId');
      
      // Get reference
      final appointmentRef = _appointmentsCollection.doc(appointmentId);
      
      // Create data directly as a Map
      final now = DateTime.now();
      final appointmentData = {
        'id': appointmentId,
        'patientId': patientId,
        'patientName': patientName,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'appointmentDate': Timestamp.fromDate(now.add(Duration(days: 1))),
        'time': '10:00 AM',
        'purpose': 'Test appointment',
        'status': 'scheduled',
        'type': 'checkup',
        'notes': 'This is a test appointment created directly',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      // Save to Firestore
      await appointmentRef.set(appointmentData);
      
      // Verify it was created
      final doc = await appointmentRef.get();
      if (doc.exists) {
        debugPrint('Direct test appointment created successfully: ${doc.data()}');
        return true;
      } else {
        debugPrint('Failed to verify appointment creation');
        return false;
      }
    } catch (e) {
      debugPrint('Error creating direct test appointment: $e');
      debugPrint('Stack trace: ${StackTrace.current}');
      return false;
    }
  }
  
  /// Create a patient with authentication (email and password)
  static Future<Map<String, dynamic>> createPatientWithAuth(Map<String, dynamic> patientData, String password) async {
    try {
      debugPrint('Creating patient with authentication');
      final email = patientData['email'] as String;
      
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final uid = userCredential.user!.uid;
      debugPrint('Created auth user with ID: $uid');
      
      // Use the Firebase Auth UID as the Firestore document ID
      patientData['id'] = uid;
      patientData['role'] = 'patient';
      
      // Create Firestore document
      final docRef = _usersCollection.doc(uid);
      await docRef.set({
        ...patientData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Return success with user data
      return {
        'success': true,
        'userId': uid,
        'message': 'Patient created successfully'
      };
    } catch (e) {
      debugPrint('Error creating patient with auth: $e');
      return {
        'success': false,
        'message': 'Error creating patient: $e'
      };
    }
  }
  
  /// Create a doctor with authentication (email and password)
  static Future<Map<String, dynamic>> createDoctorWithAuth(Map<String, dynamic> doctorData, String password) async {
    try {
      debugPrint('Creating doctor with authentication');
      final email = doctorData['email'] as String;
      
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final uid = userCredential.user!.uid;
      debugPrint('Created auth user with ID: $uid');
      
      // Use the Firebase Auth UID as the Firestore document ID
      doctorData['id'] = uid;
      doctorData['role'] = 'medicalPersonnel';
      
      // Create Firestore document
      final docRef = _usersCollection.doc(uid);
      await docRef.set({
        ...doctorData,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Return success with user data
      return {
        'success': true,
        'userId': uid,
        'message': 'Doctor created successfully'
      };
    } catch (e) {
      debugPrint('Error creating doctor with auth: $e');
      return {
        'success': false,
        'message': 'Error creating doctor: $e'
      };
    }
  }
  
  /// Update a diagnostic in a patient's clinical file
  static Future<bool> updateDiagnostic(String patientId, Diagnostic diagnostic) async {
    try {
      // Get the clinical file
      final clinicalFile = await getClinicalFileByPatientId(patientId);
      if (clinicalFile == null) return false;
      
      // Find the index of the diagnostic to update
      final index = clinicalFile.diagnostics.indexWhere((d) => d.id == diagnostic.id);
      if (index == -1) return false;
      
      // Create a new list with the updated diagnostic
      final updatedDiagnostics = List<Diagnostic>.from(clinicalFile.diagnostics);
      updatedDiagnostics[index] = diagnostic;
      
      // Update the clinical file
      await _clinicalFilesCollection.doc(patientId).update({
        'diagnostics': updatedDiagnostics.map((d) => d.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error updating diagnostic: $e');
      return false;
    }
  }
  
  /// Delete a diagnostic from a patient's clinical file
  static Future<bool> deleteDiagnostic(String patientId, String diagnosticId) async {
    try {
      // Get the clinical file
      final clinicalFile = await getClinicalFileByPatientId(patientId);
      if (clinicalFile == null) return false;
      
      // Find the diagnostic to delete
      final index = clinicalFile.diagnostics.indexWhere((d) => d.id == diagnosticId);
      if (index == -1) return false;
      
      // Create a new list without the diagnostic
      final updatedDiagnostics = List<Diagnostic>.from(clinicalFile.diagnostics);
      updatedDiagnostics.removeAt(index);
      
      // Update the clinical file
      await _clinicalFilesCollection.doc(patientId).update({
        'diagnostics': updatedDiagnostics.map((d) => d.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error deleting diagnostic: $e');
      return false;
    }
  }
  
  /// Update a medical note in a patient's clinical file
  static Future<bool> updateMedicalNote(String patientId, MedicalNote note) async {
    try {
      // Get the clinical file
      final clinicalFile = await getClinicalFileByPatientId(patientId);
      if (clinicalFile == null) return false;
      
      // Find the index of the note to update
      final index = clinicalFile.medicalNotes.indexWhere((n) => n.id == note.id);
      if (index == -1) return false;
      
      // Create a new list with the updated note
      final updatedNotes = List<MedicalNote>.from(clinicalFile.medicalNotes);
      updatedNotes[index] = note;
      
      // Update the clinical file
      await _clinicalFilesCollection.doc(patientId).update({
        'medicalNotes': updatedNotes.map((n) => n.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error updating medical note: $e');
      return false;
    }
  }
  
  /// Delete a medical note from a patient's clinical file
  static Future<bool> deleteMedicalNote(String patientId, String noteId) async {
    try {
      // Get the clinical file
      final clinicalFile = await getClinicalFileByPatientId(patientId);
      if (clinicalFile == null) return false;
      
      // Find the note to delete
      final index = clinicalFile.medicalNotes.indexWhere((n) => n.id == noteId);
      if (index == -1) return false;
      
      // Create a new list without the note
      final updatedNotes = List<MedicalNote>.from(clinicalFile.medicalNotes);
      updatedNotes.removeAt(index);
      
      // Update the clinical file
      await _clinicalFilesCollection.doc(patientId).update({
        'medicalNotes': updatedNotes.map((n) => n.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error deleting medical note: $e');
      return false;
    }
  }
  
  /// Update a treatment in a patient's clinical file
  static Future<bool> updateTreatment(String patientId, Treatment treatment) async {
    try {
      // Get the clinical file
      final clinicalFile = await getClinicalFileByPatientId(patientId);
      if (clinicalFile == null) return false;
      
      // Find the index of the treatment to update
      final index = clinicalFile.treatments.indexWhere((t) => t.id == treatment.id);
      if (index == -1) return false;
      
      // Create a new list with the updated treatment
      final updatedTreatments = List<Treatment>.from(clinicalFile.treatments);
      updatedTreatments[index] = treatment;
      
      // Update the clinical file
      await _clinicalFilesCollection.doc(patientId).update({
        'treatments': updatedTreatments.map((t) => t.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error updating treatment: $e');
      return false;
    }
  }
  
  /// Delete a treatment from a patient's clinical file
  static Future<bool> deleteTreatment(String patientId, String treatmentId) async {
    try {
      // Get the clinical file
      final clinicalFile = await getClinicalFileByPatientId(patientId);
      if (clinicalFile == null) return false;
      
      // Find the treatment to delete
      final index = clinicalFile.treatments.indexWhere((t) => t.id == treatmentId);
      if (index == -1) return false;
      
      // Create a new list without the treatment
      final updatedTreatments = List<Treatment>.from(clinicalFile.treatments);
      updatedTreatments.removeAt(index);
      
      // Update the clinical file
      await _clinicalFilesCollection.doc(patientId).update({
        'treatments': updatedTreatments.map((t) => t.toJson()).toList(),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error deleting treatment: $e');
      return false;
    }
  }
  
  /// Check if doctor is available at the specified date and time
  static Future<bool> isDoctorAvailable(String doctorId, DateTime date, String time) async {
    try {
      // First check doctor schedule
      final doctor = await getDoctorById(doctorId);
      if (doctor == null) {
        debugPrint('Doctor not found with ID: $doctorId');
        return false;
      }
      
      // Check if the doctor works at this time according to their schedule
      final isInSchedule = doctor.isAvailableAt(date, time);
      if (!isInSchedule) {
        debugPrint('Requested time is outside doctor\'s working hours');
        return false;
      }
      
      // Now check for existing appointments to avoid double booking
      debugPrint('Checking for conflicting appointments on ${date.toString().split(' ')[0]} at $time');
      
      // Query for appointments on the same date and time
      final querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isEqualTo: Timestamp.fromDate(
              DateTime(date.year, date.month, date.day)))
          .get();
      
      for (final doc in querySnapshot.docs) {
        final appointmentData = doc.data() as Map<String, dynamic>;
        final appointmentTime = appointmentData['time'] as String?;
        
        // If there's an appointment at the same time, the doctor is not available
        if (appointmentTime == time) {
          debugPrint('Doctor already has an appointment at this time');
          return false;
        }
      }
      
      debugPrint('Doctor is available at the requested time');
      return true;
    } catch (e) {
      debugPrint('Error checking doctor availability: $e');
      return false;
    }
  }
  
  /// Get all existing appointments for a doctor on a specific date
  static Future<List<String>> getDoctorAppointmentTimes(String doctorId, DateTime date) async {
    try {
      final querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isEqualTo: Timestamp.fromDate(
              DateTime(date.year, date.month, date.day)))
          .get();
      
      final times = <String>[];
      for (final doc in querySnapshot.docs) {
        final appointmentData = doc.data() as Map<String, dynamic>;
        final time = appointmentData['time'] as String?;
        if (time != null && time.isNotEmpty) {
          times.add(time);
        }
      }
      
      return times;
    } catch (e) {
      debugPrint('Error getting doctor appointment times: $e');
      return [];
    }
  }
}
