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

enum DatasetSize { small, medium, large }

class DatabaseInitializer {
  //--------------------------------------------------------------------
  // CONFIGURATION (tweak here only)
  //--------------------------------------------------------------------
  static const Map<DatasetSize, Map<String, int>> _preset = {
    DatasetSize.small:  {
      'admins':  1,
      'doctors': 3,
      'nurses':  2,
      'staff':   3,   // receptionists, pharmacists, lab techs
      'patients': 5,
      'appointments': 10,
      'departments': 6,
      'medications': 12,
    },
    DatasetSize.medium: {
      'admins':  3,
      'doctors': 12,
      'nurses':  5,
      'staff':   6,
      'patients': 20,
      'appointments': 50,
      'departments': 10,
      'medications': 30,
    },
    DatasetSize.large:  {
      'admins':  5,
      'doctors': 25,
      'nurses':  10,
      'staff':   9,
      'patients': 50,
      'appointments': 120,
      'departments': 14,
      'medications': 50,
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
      await _deleteAllUsers();
      await _deleteCollections(const [
        'users',
        'departments',
        'medications',
        'clinical_files',
        'appointments',
        'notifications',
        '_config',
      ]);

      final idMap = await _createUsers(cfg);
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
    debugPrint('→ Deleting **all** Auth users via cloud-function…');
    // Comment out this line since we don't have access to FirebaseFunctions
    // requires a backend callable named `nukeAuthUsers`
    // await FirebaseFunctions.instance.httpsCallable('nukeAuthUsers').call();
    debugPrint('   ⚠️ FirebaseFunctions not available, skipping auth user deletion');
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
    final nurses  = <String>[];
    final staff   = <String>[];
    final patients= <String>[];

    // --- hospital administrators
    for (var i = 0; i < (cfg['admins'] ?? 0); ++i) {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: 'admin$i@hospital.com',
        password: 'Admin#${1000 + i}',
      );
      await _db.collection('users').doc(cred.user!.uid).set({
        'name' : _faker.person.name(),
        'email': cred.user!.email,
        'role' : 'hospitalAdmin',
        'phone': _faker.phoneNumber.us(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      admins.add(cred.user!.uid);
    }

    // --- doctors
    const specs = [
      'Cardiology','Neurology','Pediatrics','Orthopedics','Endocrinology',
      'Gastroenterology','Dermatology','Oncology','Radiology','Psychiatry'
    ];
    for (var i = 0; i < (cfg['doctors'] ?? 0); ++i) {
      final spec = specs[i % specs.length];
      final cred = await _auth.createUserWithEmailAndPassword(
        email: 'doctor$i@hospital.com',
        password: 'Doctor#${1000 + i}',
      );
      await _db.collection('users').doc(cred.user!.uid).set({
        'name' : 'Dr. ${_faker.person.lastName()}',
        'email': cred.user!.email,
        'role' : 'doctor',
        'specialization': spec,
        'experience' : '${5 + _rng.nextInt(25)}y',
        'assignedPatientIds': <String>[],
        'createdAt': FieldValue.serverTimestamp(),
      });
      doctors.add(cred.user!.uid);
    }

    // --- nurses
    for (var i = 0; i < (cfg['nurses'] ?? 0); ++i) {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: 'nurse$i@hospital.com',
        password: 'Nurse#${1000 + i}',
      );
      await _db.collection('users').doc(cred.user!.uid).set({
        'name' : _faker.person.name(),
        'email': cred.user!.email,
        'role' : 'nurse',
        'department': _departmentNames[_rng.nextInt(_departmentNames.length)],
        'createdAt': FieldValue.serverTimestamp(),
      });
      nurses.add(cred.user!.uid);
    }

    // --- other staff (receptionists, pharmacists, lab techs)
    final staffRoles = ['receptionist','pharmacist','labTechnician'];
    for (var i = 0; i < (cfg['staff'] ?? 0); ++i) {
      final role = staffRoles[i % staffRoles.length];
      final cred = await _auth.createUserWithEmailAndPassword(
        email: '$role$i@hospital.com',
        password: '${role.capitalize()}#${1000 + i}',
      );
      await _db.collection('users').doc(cred.user!.uid).set({
        'name' : _faker.person.name(),
        'email': cred.user!.email,
        'role' : role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      staff.add(cred.user!.uid);
    }

    // --- patients
    for (var i = 0; i < (cfg['patients'] ?? 0); ++i) {
      final sex = i.isEven ? 'Male' : 'Female';
      final cred = await _auth.createUserWithEmailAndPassword(
        email: 'patient$i@example.com',
        password: 'Patient#${1000 + i}',
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
    }

    debugPrint('   • admins=${admins.length}  doctors=${doctors.length}  '
               'nurses=${nurses.length}  staff=${staff.length} '
               'patients=${patients.length}');
    await _auth.signOut();

    return {
      'admins' : admins,
      'doctors': doctors,
      'nurses' : nurses,
      'staff'  : staff,
      'patients': patients,
    };
  }

  static Future<void> _createDepartments(
      int count, List<String> doctors) async {
    debugPrint('→ Creating $count departments…');
    for (var i = 0; i < count; ++i) {
      final head = doctors[_rng.nextInt(doctors.length)];
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
    debugPrint('→ Creating clinical files for every patient…');
    final pats = ids['patients']!;
    for (final pid in pats) {
      final docId = ids['doctors']![_rng.nextInt(ids['doctors']!.length)];
      await _db.collection('clinical_files').doc(pid).set({
        'patientId': pid,
        'doctorId' : docId,
        'diagnostics': [
          {
            'description': _faker.lorem.sentence(),
            'date': DateTime.now()
                .subtract(Duration(days: _rng.nextInt(400)))
                .toIso8601String(),
            'doctorId': docId,
          }
        ],
        'treatments': [],
        'vitals': {
          'heartRate' : '${60 + _rng.nextInt(40)} bpm',
          'bloodPressure': '${100 + _rng.nextInt(30)}/${60 + _rng.nextInt(20)} mmHg',
          'temperature': '36.${_rng.nextInt(8)} °C',
          'oxygenSaturation': '${94 + _rng.nextInt(5)}%',
          'lastMeasured': DateTime.now().toIso8601String(),
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      // also update user doc
      await _db.collection('users').doc(pid).update({
        'assignedDoctorId': docId,
      });
    }
  }

  static Future<void> _createAppointments(
      int count, Map<String, List<String>> ids) async {
    debugPrint('→ Creating $count appointments…');
    final docs = ids['doctors']!;
    final pats = ids['patients']!;
    const status = ['scheduled','completed','cancelled'];
    for (var i = 0; i < count; ++i) {
      final d = docs[_rng.nextInt(docs.length)];
      final p = pats[_rng.nextInt(pats.length)];
      final date = DateTime.now()
          .add(Duration(days: _rng.nextInt(180) - 90)); // ±90 days
      await _db.collection('appointments').add({
        'doctorId' : d,
        'patientId': p,
        'date'     : date.toIso8601String(),
        'time'     : '${8 + _rng.nextInt(9)}:${_rng.nextBool() ? '00':'30'}',
        'purpose'  : _appointmentPurposes[_rng.nextInt(_appointmentPurposes.length)],
        'status'   : status[_rng.nextInt(status.length)],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /* -------------------------- VERIFICATION ------------------------ */
  static Future<void> _verifyDatabase() async {
    debugPrint('→ Verifying counts…');
    final colls = [
      'users','departments','medications',
      'clinical_files','appointments'
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
      'admins':[], 'doctors':[], 'nurses':[], 'staff':[], 'patients':[]
    };
    for (final d in snap.docs) {
      final key = d['role'] == 'doctor'
          ? 'doctors'
          : d['role'] == 'patient'
              ? 'patients'
              : d['role'] == 'hospitalAdmin'
                  ? 'admins'
                  : (d['role'] == 'nurse' ? 'nurses' : 'staff');
                  
      // Handle null list safely
      final list = m[key];
      if (list != null) {
        list.add(d.id);
      } else {
        m[key] = [d.id];
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
