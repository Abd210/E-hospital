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
      // First get the doctor to access their assigned patients
      final doctorDoc = await _usersCollection.doc(doctorId).get();
      if (!doctorDoc.exists) return [];
      
      final doctor = Doctor.fromFirestore(doctorDoc as DocumentSnapshot<Map<String, dynamic>>);
      final assignedPatientIds = doctor.assignedPatientIds;
      
      if (assignedPatientIds.isEmpty) return [];
      
      // Get all assigned patients
      final patients = <Patient>[];
      for (final patientId in assignedPatientIds) {
        final patientDoc = await _usersCollection.doc(patientId).get();
        if (patientDoc.exists) {
          final user = User.fromFirestore(patientDoc as DocumentSnapshot<Map<String, dynamic>>);
          if (user.role == UserRole.patient) {
            patients.add(Patient.fromUser(user));
          }
        }
      }
      return patients;
    } catch (e) {
      debugPrint('Error getting doctor patients: $e');
      return [];
    }
  }
  
  /// Assign patient to doctor
  static Future<bool> assignPatientToDoctor(String patientId, String doctorId) async {
    try {
      await _usersCollection.doc(doctorId).update({
        'assignedPatientIds': FieldValue.arrayUnion([patientId]),
      });
      
      return true;
    } catch (e) {
      debugPrint('Error assigning patient to doctor: $e');
      return false;
    }
  }
  
  /// Remove patient from doctor
  static Future<bool> removePatientFromDoctor(String patientId, String doctorId) async {
    try {
      await _usersCollection.doc(doctorId).update({
        'assignedPatientIds': FieldValue.arrayRemove([patientId]),
      });
      
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
      final querySnapshot = await _appointmentsCollection
          .where('patientId', isEqualTo: patientId)
          .orderBy('appointmentDate', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting patient appointments: $e');
      return [];
    }
  }
  
  /// Get appointments for a doctor
  static Future<List<Appointment>> getDoctorAppointments(String doctorId) async {
    try {
      final querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .orderBy('appointmentDate', descending: true)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      debugPrint('Error getting doctor appointments: $e');
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
      final now = DateTime.now();
      final querySnapshot = await _appointmentsCollection
          .where('doctorId', isEqualTo: doctorId)
          .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .orderBy('appointmentDate')
          .limit(10)
          .get();
      
      return querySnapshot.docs
          .map((doc) => Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
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
      final appointmentWithId = appointment.id.isEmpty
          ? appointment.copyWith(id: _uuid.v4())
          : appointment;
      
      final docRef = _appointmentsCollection.doc(appointmentWithId.id);
      
      await docRef.set(appointmentWithId.toFirestore()..addAll({
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }));
      
      final doc = await docRef.get();
      return Appointment.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      debugPrint('Error creating appointment: $e');
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
  static Future<ClinicalFile?> getClinicalFileByPatientId(String patientId) async {
    try {
      final doc = await _clinicalFilesCollection.doc(patientId).get();
      if (!doc.exists) return null;
      
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
      
      await _clinicalFilesCollection.doc(patientId).update({
        'diagnostics': FieldValue.arrayUnion([diagnosticWithId.toJson()]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
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
      
      await _clinicalFilesCollection.doc(patientId).update({
        'treatments': FieldValue.arrayUnion([treatmentWithId.toJson()]),
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      
      return true;
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
      
      final assignedPatientIds = List<String>.from(doctorData['assignedPatientIds'] ?? []);
      
      // Get upcoming appointments
      final now = DateTime.now();
      
      // Use null-safe approach
      try {
        final appointmentsSnapshot = await _appointmentsCollection
            .where('doctorId', isEqualTo: doctorId)
            .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
            .orderBy('appointmentDate')
            .limit(10)
            .get();
        
        final upcomingAppointments = appointmentsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...(doc.data() as Map<String, dynamic>),
                })
            .toList();
        
        // Get today's appointments
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(Duration(days: 1));
        
        final todayAppointmentsSnapshot = await _appointmentsCollection
            .where('doctorId', isEqualTo: doctorId)
            .where('appointmentDate', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
            .where('appointmentDate', isLessThan: Timestamp.fromDate(tomorrow))
            .get();
        
        final todayAppointments = todayAppointmentsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...(doc.data() as Map<String, dynamic>),
                })
            .toList();
        
        // Get appointment count safely
        final countResult = await _appointmentsCollection
            .where('doctorId', isEqualTo: doctorId)
            .count()
            .get();
        
        final appointmentCount = countResult.count ?? 0;
        
        // Return dashboard data
        return {
          'patientCount': assignedPatientIds.length,
          'todayAppointments': todayAppointments,
          'upcomingAppointments': upcomingAppointments,
          'appointmentCount': appointmentCount,
        };
      } catch (e) {
        debugPrint('Error getting appointments data: $e');
        // Fallback in case of query error
        return {
          'patientCount': assignedPatientIds.length,
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
}
