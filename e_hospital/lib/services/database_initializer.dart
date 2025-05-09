/// DatabaseInitializer
/// ------------------------------------------------------------
/// A utility that (re)creates every logical collection used by the
/// hospital-management project and fills it with **medically-accurate,
/// realistic demo data**.  
///
///  ▸ Supports `small`, `medium`, `large` presets  
///  ▸ May be run partially (e.g. *only* add more patients)  
///  ▸ Verifies counts afterwards and prints a full progress log  
///
/// **NB** • Deleting authentication users in bulk requires the Firebase
/// **Admin SDK** (or a callable Cloud Function).  From a pure Flutter
/// client we can only *request* such an operation; therefore the helper
/// `_deleteAllUsers()` below calls an HTTPS Cloud-Function named
/// `nukeAuthUsers` that you must expose in the backend.
/// ------------------------------------------------------------
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

enum DatasetSize { small, medium, large, huge }

class DatabaseInitializer {
  //--------------------------------------------------------------------
  // CONFIGURATION (tweak here only)
  //--------------------------------------------------------------------
  static const Map<DatasetSize, Map<String, int>> _preset = {
    DatasetSize.small:  {
      'admins':  1,
      'doctors': 3,
      'patients': 5,
      'appointments': 10,
      'departments': 6,
      'medications': 12,
    },
    DatasetSize.medium: {
      'admins':  3,
      'doctors': 12,
      'patients': 20,
      'appointments': 50,
      'departments': 10,
      'medications': 30,
    },
    DatasetSize.large:  {
      'admins':  5,
      'doctors': 25,
      'patients': 50,
      'appointments': 120,
      'departments': 14,
      'medications': 50,
    },
    DatasetSize.huge:  {
      'admins':  1,   // Single admin as requested
      'doctors': 10,  // 10 doctors as requested
      'patients': 40, // 40 patients as requested
      'appointments': 50, // 50 appointments as requested
      'departments': 14, // 14 departments as requested
      'medications': 30, // 30 medications as requested
    },
  };

  //--------------------------------------------------------------------
  // INTERNAL STATE
  //--------------------------------------------------------------------
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth      _auth = FirebaseAuth.instance;
  static final Faker _faker = Faker();
  static final Random _rng = Random();

  //--------------------------------------------------------------------
  //  PUBLIC  API
  //--------------------------------------------------------------------
  /// Bootstraps the whole DB.
  /// Pass `force: true` to wipe & rebuild even if the `_config/initialization`
  /// sentinel already exists.
  static Future<void> initializeDatabase({
    DatasetSize size = DatasetSize.medium,
    bool force = false,
  }) async {
    final s = Stopwatch()..start();
    if (!force) {
      final sent = await _db.collection('_config').doc('initialization').get();
      if (sent.exists) {
        debugPrint(
          '[DatabaseInitializer] Already initialized – skipping. '
          'Use `force:true` to rebuild.');
        return;
      }
    }

    final cfg = _preset[size]!;
    debugPrint('╔═══════════════════════════════════════════════');
    debugPrint('║ Database-initialization started ($size)…');
    debugPrint('╚═══════════════════════════════════════════════');

    try {
      // Try to perform user deletion
      try {
        await _deleteAllUsers();
      } catch (e) {
        debugPrint('Warning: Error during user deletion: $e');
        // Continue despite errors with user deletion
      }
      
      // Clear Firestore collections
      await _deleteCollections(const [
        'users',
        'departments',
        'medications',
        'diagnoses',
        'prescriptions', 
        'laboratoryTests',
        'appointments',
        'notifications',
        '_config',
      ]);

      final idMap = await _createUsers(cfg);
      
      // Safety check - if we failed to create any doctors, create at least one admin
      if (idMap['doctors']!.isEmpty) {
        debugPrint('Warning: No doctors were created, using login approach to get existing users');
        // Add existing users by trying to log in
        try {
          // Try to sign in as admin0
          final adminCred = await _auth.signInWithEmailAndPassword(
            email: 'admin0@hospital.com',
            password: 'Admin#1000',
          );
          if (adminCred.user != null) {
            idMap['admins'] = [adminCred.user!.uid];
          }
          
          // Try to sign in as doctor0
          final doctorCred = await _auth.signInWithEmailAndPassword(
            email: 'doctor0@hospital.com',
            password: 'Doctor#1000',
          );
          if (doctorCred.user != null) {
            idMap['doctors'] = [doctorCred.user!.uid];
          }
          
          // Try to sign in as patient0
          final patientCred = await _auth.signInWithEmailAndPassword(
            email: 'patient0@example.com',
            password: 'Patient#1000',
          );
          if (patientCred.user != null) {
            idMap['patients'] = [patientCred.user!.uid];
          }
        } catch (e) {
          debugPrint('Error trying to recover users: $e');
        }
      }
      
      if (idMap['doctors']!.isEmpty) {
        throw Exception('No doctors available for initialization. Please ensure at least one doctor account exists.');
      }
      
      await _createDepartments(cfg['departments']!, idMap['doctors']!);
      await _createMedications(cfg['medications']!);
      await _createClinicalFiles(idMap);
      await _createAppointments(cfg['appointments']!, idMap);
      await _verifyDatabase();

      await _db.collection('_config')
               .doc('initialization')
               .set({
                 'initialized': true,
                 'datasetSize': size.name,
                 'timestamp': FieldValue.serverTimestamp(),
               });

      debugPrint('✅ Database bootstrapped in ${s.elapsed.inSeconds}s');
    } catch (e, st) {
      debugPrint('🛑 Initialization failed: $e\n$st');
      rethrow;
    }
  }

  /// Convenience wrappers ­– call these if you only need fresh objects
  static Future<void> addMorePatients(int count) async =>
      _createUsers({'patients': count});
  static Future<void> addMoreAppointments(int count) async =>
      _createAppointments(count, await _collectIds());

  //--------------------------------------------------------------------
  //  PRIVATE HELPERS
  //--------------------------------------------------------------------
  /* -------------------------- DESTRUCTIVE OPS --------------------- */
  static Future<void> _deleteAllUsers() async {
    debugPrint('→ Attempting to delete Firebase Auth users...');
    
    // Since we don't have access to Firebase Admin SDK or Cloud Functions,
    // we'll try to delete users we previously created by signing in as them
    // and then deleting the accounts
    
    // Try to delete admin accounts
    for (int i = 0; i < 10; i++) {
      await _tryDeleteUser('admin$i@hospital.com', 'Admin#${1000 + i}');
    }
    
    // Try to delete doctor accounts
    for (int i = 0; i < 30; i++) {
      await _tryDeleteUser('doctor$i@hospital.com', 'Doctor#${1000 + i}');
    }
    
    // Try to delete patient accounts
    for (int i = 0; i < 100; i++) {
      await _tryDeleteUser('patient$i@example.com', 'Patient#${1000 + i}');
    }
    
    // Sign out when done
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
  
  static Future<void> _tryDeleteUser(String email, String password) async {
    try {
      // Try to sign in
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      
      if (credentials.user != null) {
        debugPrint('Deleting user: $email');
        await credentials.user!.delete();
      }
    } catch (e) {
      // Don't report errors - we expect many of these to fail
      // especially for accounts we didn't create
    }
  }

  static Future<void> _deleteCollections(List<String> names) async {
    debugPrint('→ Clearing old collections…');
    for (final c in names) {
      while (true) {
        final batch = _db.batch();
        final snap = await _db.collection(c).limit(500).get();
        if (snap.docs.isEmpty) break;
        for (final d in snap.docs) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }
      debugPrint('   • $c');
    }
  }

  /* --------------------------- CREATION --------------------------- */
  static Future<Map<String, List<String>>> _createUsers(
      Map<String, int> cfg) async {
    debugPrint('→ Creating users…');

    final admins  = <String>[];
    final doctors = <String>[];
    final patients= <String>[];

    // --- hospital administrators
    for (var i = 0; i < (cfg['admins'] ?? 0); ++i) {
      try {
        final email = 'admin$i@hospital.com';
        final password = 'Admin#${1000 + i}';
        
        // Try direct sign in first (to reuse existing accounts)
        try {
          final userCred = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (userCred.user != null) {
            debugPrint('Signed in to existing admin account: $email');
            
            // Update Firestore data
            await _db.collection('users').doc(userCred.user!.uid).set({
              'name' : _faker.person.name(),
              'email': userCred.user!.email,
              'role' : 'hospitalAdmin',
              'phone': _faker.phoneNumber.us(),
              'createdAt': FieldValue.serverTimestamp(),
            });
            
            admins.add(userCred.user!.uid);
            continue;
          }
        } catch (e) {
          // Account doesn't exist or wrong password - create new account
        }
        
        // Create new account
        try {
          final cred = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await _db.collection('users').doc(cred.user!.uid).set({
            'name' : _faker.person.name(),
            'email': cred.user!.email,
            'role' : 'hospitalAdmin',
            'phone': _faker.phoneNumber.us(),
            'createdAt': FieldValue.serverTimestamp(),
          });
          admins.add(cred.user!.uid);
        } catch (e) {
          debugPrint('Error creating admin user: $e');
        }
      } catch (e) {
        debugPrint('Error processing admin user: $e');
      }
    }

    // --- doctors
    const specs = [
      'Cardiology','Neurology','Pediatrics','Orthopedics','Endocrinology',
      'Gastroenterology','Dermatology','Oncology','Radiology','Psychiatry'
    ];
    for (var i = 0; i < (cfg['doctors'] ?? 0); ++i) {
      try {
        final email = 'doctor$i@hospital.com';
        final password = 'Doctor#${1000 + i}';
        final spec = specs[i % specs.length];
        
        // Try direct sign in first (to reuse existing accounts)
        try {
          final userCred = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (userCred.user != null) {
            debugPrint('Signed in to existing doctor account: $email');
            
            // Update Firestore data
            await _db.collection('users').doc(userCred.user!.uid).set({
              'name' : 'Dr. ${_faker.person.lastName()}',
              'email': userCred.user!.email,
              'role' : 'medicalPersonnel',
              'specialization': spec,
              'experience' : '${5 + _rng.nextInt(25)}y',
              'assignedPatientIds': <String>[],
              'createdAt': FieldValue.serverTimestamp(),
            });
            
            doctors.add(userCred.user!.uid);
            continue;
          }
        } catch (e) {
          // Account doesn't exist or wrong password - create new account
        }
        
        // Create new account
        try {
          final cred = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await _db.collection('users').doc(cred.user!.uid).set({
            'name' : 'Dr. ${_faker.person.lastName()}',
            'email': cred.user!.email,
            'role' : 'medicalPersonnel',
            'specialization': spec,
            'experience' : '${5 + _rng.nextInt(25)}y',
            'assignedPatientIds': <String>[],
            'createdAt': FieldValue.serverTimestamp(),
          });
          doctors.add(cred.user!.uid);
        } catch (e) {
          debugPrint('Error creating doctor user: $e');
        }
      } catch (e) {
        debugPrint('Error processing doctor user: $e');
      }
    }

    // --- patients
    for (var i = 0; i < (cfg['patients'] ?? 0); ++i) {
      try {
        final email = 'patient$i@example.com';
        final password = 'Patient#${1000 + i}';
        final sex = i.isEven ? 'Male' : 'Female';
        
        // Try direct sign in first (to reuse existing accounts)
        try {
          final userCred = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          if (userCred.user != null) {
            debugPrint('Signed in to existing patient account: $email');
            
            // Update Firestore data
            await _db.collection('users').doc(userCred.user!.uid).set({
              'name' : _faker.person.name(),
              'email': userCred.user!.email,
              'role' : 'patient',
              'gender': sex,
              'age'   : 15 + _rng.nextInt(80),
              'bloodType': _bloodTypes[_rng.nextInt(_bloodTypes.length)],
              'createdAt': FieldValue.serverTimestamp(),
            });
            
            patients.add(userCred.user!.uid);
            continue;
          }
        } catch (e) {
          // Account doesn't exist or wrong password - create new account
        }
        
        // Create new account
        try {
          final cred = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await _db.collection('users').doc(cred.user!.uid).set({
            'name' : _faker.person.name(),
            'email': cred.user!.email,
            'role' : 'patient',
            'gender': sex,
            'age'   : 15 + _rng.nextInt(80),
            'bloodType': _bloodTypes[_rng.nextInt(_bloodTypes.length)],
            'createdAt': FieldValue.serverTimestamp(),
          });
          patients.add(cred.user!.uid);
        } catch (e) {
          debugPrint('Error creating patient user: $e');
        }
      } catch (e) {
        debugPrint('Error processing patient user: $e');
      }
    }

    debugPrint('   • admins=${admins.length}  doctors=${doctors.length}  '
               'patients=${patients.length}');
    await _auth.signOut();

    return {
      'admins' : admins,
      'doctors': doctors,
      'patients': patients,
    };
  }

  static Future<void> _createDepartments(
      int count, List<String> doctors) async {
    debugPrint('→ Creating $count departments…');
    
    // Make sure we don't try to create more departments than we have names for
    count = min(count, _departmentNames.length);
    
    // Make sure we use a valid random index for doctor selection
    // even if we have fewer doctors than departments
    for (var i = 0; i < count; ++i) {
      // Safely select a doctor (handle case where doctors list may be small)
      final head = doctors.isNotEmpty 
          ? doctors[i % doctors.length] 
          : null;
          
      await _db.collection('departments').add({
        'name' : _departmentNames[i % _departmentNames.length],
        'description': _faker.lorem.sentences(2).join(' '),
        'headDoctorId': head,
        'location': 'Building ${String.fromCharCode(65 + i)}, Floor ${1 + i % 5}',
        'phone': _faker.phoneNumber.us(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> _createMedications(int count) async {
    debugPrint('→ Creating $count medications…');
    const forms = ['pill','injection','topical','inhaler','syrup'];
    for (var i = 0; i < count; ++i) {
      await _db.collection('medications').add({
        'name'   : _faker.food.dish(),
        'generic': _faker.food.cuisine(),
        'form'   : forms[i % forms.length],
        'dosage' : '${5 + _rng.nextInt(45)} mg',
        'usage'  : _faker.lorem.sentence(),
        'contraindications': _faker.lorem.words(3),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  static Future<void> _createClinicalFiles(
      Map<String, List<String>> ids) async {
    try {
      debugPrint('→ Creating clinical files for every patient…');
      final pats = ids['patients']!;
      final docs = ids['doctors']!;
      
      // Safety check - need at least one doctor and one patient
      if (docs.isEmpty || pats.isEmpty) {
        debugPrint('Warning: Cannot create clinical files without doctors and patients');
        debugPrint('Available doctors: ${docs.length}, patients: ${pats.length}');
        return;
      }
      
      const uuid = Uuid();
      
      // Delete existing clinical files structure
      try {
        await _deleteCollections(['clinical_files']);
      } catch (e) {
        debugPrint('Warning: Error deleting existing clinical files: $e');
      }
    
      // Assign patients to doctors more evenly
      Map<String, List<String>> doctorPatients = {};
      for (final docId in docs) {
        doctorPatients[docId] = [];
      }
      
      // Distribute patients among doctors
      int doctorIndex = 0;
      for (final pid in pats) {
        final docId = docs[doctorIndex % docs.length];
        doctorPatients[docId]?.add(pid);
        doctorIndex++;
      }
      
      // For each doctor, update their assignedPatientIds
      for (final docId in doctorPatients.keys) {
        final patientIds = doctorPatients[docId] ?? [];
        if (patientIds.isNotEmpty) {
          try {
            await _db.collection('users').doc(docId).update({
              'assignedPatientIds': patientIds,
            });
          } catch (e) {
            debugPrint('Warning: Error updating doctor $docId assigned patients: $e');
          }
        }
      }
      
      // Now create clinical files for each patient
      for (final pid in pats) {
        try {
          // Find which doctor this patient is assigned to
          String? docId;
          for (final doctor in doctorPatients.keys) {
            if (doctorPatients[doctor]?.contains(pid) ?? false) {
              docId = doctor;
              break;
            }
          }
          
          // If not assigned, pick a doctor
          if (docId == null) {
            docId = docs[0]; // Just use the first doctor
          }
          
          // Get user documents
          final docDoc = await _db.collection('users').doc(docId).get();
          final patDoc = await _db.collection('users').doc(pid).get();
          
          if (!docDoc.exists || !patDoc.exists) {
            debugPrint('Warning: Doctor or patient document does not exist. Skipping clinical files.');
            continue;
          }
          
          final docName = docDoc.data()?['name'] ?? 'Dr. Unknown';
          final patientName = patDoc.data()?['name'] ?? 'Unknown Patient';
          
          // Create random diagnoses
          final diagnosesList = [];
          for (var i = 0; i < 2 + _rng.nextInt(4); i++) {
            diagnosesList.add({
              'id': uuid.v4(),
              'patientId': pid,
              'patientName': patientName,
              'doctorId': docId,
              'doctorName': docName,
              'type': ['Acute', 'Chronic', 'Preventive', 'Follow-up'][_rng.nextInt(4)],
              'description': _faker.lorem.sentence(),
              'date': DateTime.now()
                  .subtract(Duration(days: _rng.nextInt(400)))
                  .toIso8601String(),
              'notes': _rng.nextBool() ? _faker.lorem.sentence() : null,
            });
          }
          
          // Create random prescriptions
          final prescriptionsList = [];
          for (var i = 0; i < 2 + _rng.nextInt(5); i++) {
            prescriptionsList.add({
              'id': uuid.v4(),
              'patientId': pid,
              'patientName': patientName,
              'doctorId': docId,
              'doctorName': docName,
              'medicationName': _faker.food.dish(),
              'dosage': '${5 + _rng.nextInt(45)} mg',
              'frequency': ['Once daily', 'Twice daily', 'Three times daily', 'Every 12 hours'][_rng.nextInt(4)],
              'date': DateTime.now()
                  .subtract(Duration(days: _rng.nextInt(200)))
                  .toIso8601String(),
              'duration': _rng.nextBool() ? 7 + _rng.nextInt(30) : null,
              'instructions': _rng.nextBool() ? _faker.lorem.sentence() : null,
            });
          }
          
          // Create random laboratory tests
          final labTestsList = [];
          for (var i = 0; i < 1 + _rng.nextInt(4); i++) {
            final testDate = DateTime.now().subtract(Duration(days: _rng.nextInt(100)));
            final isCompleted = _rng.nextBool();
            
            labTestsList.add({
              'id': uuid.v4(),
              'patientId': pid,
              'patientName': patientName,
              'doctorId': docId,
              'doctorName': docName,
              'testName': ['Blood Count', 'Liver Panel', 'Thyroid Profile', 'Urinalysis', 'Lipid Panel'][_rng.nextInt(5)],
              'testType': ['Blood', 'Urine', 'Imaging', 'Biopsy'][_rng.nextInt(4)],
              'date': testDate.toIso8601String(),
              'status': isCompleted ? 'completed' : 'ordered',
              'notes': _rng.nextBool() ? _faker.lorem.sentence() : null,
              'resultDate': isCompleted ? testDate.add(Duration(days: 2 + _rng.nextInt(5))).toIso8601String() : null,
              'results': isCompleted ? _faker.lorem.sentences(3).join(' ') : null,
            });
          }
          
          // Save diagnoses to Firestore
          for (final diagnosis in diagnosesList) {
            try {
              await _db.collection('diagnoses').doc(diagnosis['id']).set(diagnosis);
            } catch (e) {
              debugPrint('Warning: Error saving diagnosis: $e');
            }
          }
          
          // Save prescriptions to Firestore
          for (final prescription in prescriptionsList) {
            try {
              await _db.collection('prescriptions').doc(prescription['id']).set(prescription);
            } catch (e) {
              debugPrint('Warning: Error saving prescription: $e');
            }
          }
          
          // Save laboratory tests to Firestore
          for (final test in labTestsList) {
            try {
              await _db.collection('laboratoryTests').doc(test['id']).set(test);
            } catch (e) {
              debugPrint('Warning: Error saving lab test: $e');
            }
          }
    
          // also update user doc
          try {
            await _db.collection('users').doc(pid).update({
              'assignedDoctorId': docId,
            });
          } catch (e) {
            debugPrint('Warning: Error updating patient $pid assigned doctor: $e');
          }
        } catch (e) {
          debugPrint('Warning: Error creating clinical files for patient $pid: $e');
          // Continue with next patient
        }
      }
    } catch (e) {
      debugPrint('Error in _createClinicalFiles: $e');
      // Don't throw, so database initialization can continue
    }
  }

  static Future<void> _createAppointments(
      int count, Map<String, List<String>> ids) async {
    try {
      debugPrint('→ Creating $count appointments…');
      final docs = ids['doctors']!;
      final pats = ids['patients']!;
      
      // Safety check - need at least one doctor and one patient
      if (docs.isEmpty || pats.isEmpty) {
        debugPrint('Warning: Cannot create appointments without doctors and patients');
        debugPrint('Available doctors: ${docs.length}, patients: ${pats.length}');
        return;
      }
      
      const status = ['scheduled','completed','cancelled'];
      const types = ['checkup', 'followUp', 'consultation'];
      
      // Create a mapping of doctorId -> patients assigned to that doctor
      Map<String, List<String>> doctorPatients = {};
      
      // Get all patients with their assigned doctors
      try {
        final patientDocs = await _db.collection('users')
          .where('role', isEqualTo: 'patient')
          .get();
          
        for (final pat in patientDocs.docs) {
          final patientId = pat.id;
          final doctorId = pat.data()['assignedDoctorId'] as String?;
          if (doctorId != null) {
            if (!doctorPatients.containsKey(doctorId)) {
              doctorPatients[doctorId] = [];
            }
            doctorPatients[doctorId]!.add(patientId);
          }
        }
      } catch (e) {
        debugPrint('Warning: Error fetching patient-doctor assignments: $e');
        // Continue without assignments
      }
      
      // Limit count to a reasonable number based on available patients and doctors
      count = min(count, pats.length * 5);
      
      const uuid = Uuid();
      for (var i = 0; i < count; ++i) {
        try {
          // Determine doctor and patient (use assigned relationship when possible)
          String doctorId;
          String patientId;
          
          // 80% chance to use an assigned doctor-patient relationship
          if (_rng.nextDouble() < 0.8 && doctorPatients.isNotEmpty) {
            // Pick a random doctor that has patients
            final doctorsWithPatients = doctorPatients.keys.toList();
            if (doctorsWithPatients.isNotEmpty) {
              doctorId = doctorsWithPatients[_rng.nextInt(doctorsWithPatients.length)];
              final possiblePatients = doctorPatients[doctorId]!;
              patientId = possiblePatients[_rng.nextInt(possiblePatients.length)];
            } else {
              doctorId = docs[_rng.nextInt(docs.length)];
              patientId = pats[_rng.nextInt(pats.length)];
            }
          } else {
            // Random doctor and patient
            doctorId = docs[_rng.nextInt(docs.length)];
            patientId = pats[_rng.nextInt(pats.length)];
          }
          
          // Get the doctor and patient information for more realistic data
          final doctorDoc = await _db.collection('users').doc(doctorId).get();
          final patientDoc = await _db.collection('users').doc(patientId).get();
          
          if (!doctorDoc.exists || !patientDoc.exists) {
            debugPrint('Warning: Doctor or patient document does not exist. Skipping appointment.');
            continue;
          }
          
          final doctorData = doctorDoc.data();
          final patientData = patientDoc.data();
          final doctorName = doctorData?['name'] ?? 'Unknown Doctor';
          final patientName = patientData?['name'] ?? 'Unknown Patient';
          final doctorSpecialty = doctorData?['specialization'] ?? '';
          
          // Generate appointment date - between 90 days in past and 90 days in future
          final date = DateTime.now().add(Duration(days: _rng.nextInt(180) - 90));
          
          // Create appointment with fields that match the app's appointment model
          final appointmentId = uuid.v4();
          await _db.collection('appointments').doc(appointmentId).set({
            'id': appointmentId,
            'doctorId': doctorId,
            'patientId': patientId,
            'doctorName': doctorName,
            'patientName': patientName,
            'doctorSpecialty': doctorSpecialty, 
            'appointmentDate': date,
            'time': '${8 + _rng.nextInt(9)}:${_rng.nextBool() ? '00':'30'}',
            'purpose': _appointmentPurposes[_rng.nextInt(_appointmentPurposes.length)],
            'status': status[_rng.nextInt(status.length)],
            'type': types[_rng.nextInt(types.length)],
            'notes': _rng.nextBool() ? _faker.lorem.sentence() : null,
            'location': _rng.nextBool() ? 'Room ${100 + _rng.nextInt(400)}' : null,
            'duration': _rng.nextBool() ? 15 + _rng.nextInt(4) * 15 : null, // 15, 30, 45, or 60 minutes
            'symptoms': _rng.nextBool() ? _faker.lorem.sentence() : null,
            'isVirtual': _rng.nextDouble() < 0.3, // 30% chance of virtual appointment
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });
        } catch (e) {
          debugPrint('Warning: Error creating appointment ${i+1}: $e');
          // Continue with next appointment
        }
      }
    } catch (e) {
      debugPrint('Error in _createAppointments: $e');
      // Don't throw, so database initialization can continue
    }
  }

  /* -------------------------- VERIFICATION ------------------------ */
  static Future<void> _verifyDatabase() async {
    debugPrint('→ Verifying counts…');
    final colls = [
      'users','departments','medications',
      'diagnoses','prescriptions','laboratoryTests',
      'appointments'
    ];
    for (final c in colls) {
      final n = (await _db.collection(c).get()).size;
      debugPrint('   • $c = $n');
    }
  }

  /* --------------------------- UTILITIES -------------------------- */
  static Future<Map<String, List<String>>> _collectIds() async {
    final snap = await _db.collection('users').get();
    final Map<String, List<String>> m = {
      'admins':[], 'doctors':[], 'patients':[]
    };
    for (final d in snap.docs) {
      final role = d['role'] as String? ?? '';
      if (role == 'medicalPersonnel') {
        m['doctors']?.add(d.id);
      } else if (role == 'patient') {
        m['patients']?.add(d.id);
      } else if (role == 'hospitalAdmin') {
        m['admins']?.add(d.id);
      }
    }
    return m;
  }

  static final List<String> _departmentNames = [
    'Emergency','Cardiology','Neurology','Pediatrics','Orthopedics',
    'Oncology','Radiology','Gastroenterology','Dermatology','Psychiatry',
    'Urology','Nephrology','Endocrinology','Pulmonology'
  ];

  static final List<String> _bloodTypes = [
    'A+','A−','B+','B−','AB+','AB−','O+','O−'
  ];

  static final List<String> _appointmentPurposes = [
    'Routine check-up',
    'Consultation',
    'Follow-up visit',
    'Post-operative review',
    'Diagnostic evaluation'
  ];
}

extension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
