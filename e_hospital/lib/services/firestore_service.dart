import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _db = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

/// returns the current user role ('hospitalAdmin' | 'medicalPersonnel' | 'patient')
Future<String?> fetchRole() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  
  try {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  } catch (e) {
    debugPrint('Error fetching role: $e');
    // Return null when there's a permission error, let UI handle this case
    return null;
  }
}

/// Populates the database with sample users and data
Future<void> populateSampleData() async {
  try {
    // Check if current user is authenticated and has admin rights
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint('Error: User must be authenticated to populate sample data');
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Authentication required to populate sample data',
      );
    }
    
    // Check if the current user has admin rights
    final userDoc = await _db.collection('users').doc(currentUser.uid).get();
    final isAdmin = userDoc.data()?['role'] == 'hospitalAdmin';
    
    if (!isAdmin) {
      debugPrint('Error: Only admin users can populate sample data');
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Admin privileges required to populate sample data',
      );
    }
    
    // First, ensure Firestore security rules are set to allow operations
    try {
      // Test write access to the _config collection (which should be allowed for authenticated users)
      await _db.collection('_config').doc('test').set({
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      // If successful, delete the test document
      await _db.collection('_config').doc('test').delete();
      
      debugPrint('Firebase security rules allow write access, proceeding...');
    } catch (e) {
      debugPrint('Error: Firebase security rules do not allow write access: $e');
      throw FirebaseException(
        plugin: 'firestore',
        message: 'Security rules prevent database operations. Please check your Firestore rules.',
      );
    }
    
    // 1. Create sample users if they don't exist
    final sampleUsers = [
      {'email': 'admin@hospital.com', 'password': 'admin123', 'role': 'hospitalAdmin', 'name': 'Admin User'},
      {'email': 'doctor1@hospital.com', 'password': 'doctor123', 'role': 'medicalPersonnel', 'name': 'Dr. Smith'},
      {'email': 'doctor2@hospital.com', 'password': 'doctor123', 'role': 'medicalPersonnel', 'name': 'Dr. Johnson'},
      {'email': 'patient1@example.com', 'password': 'patient123', 'role': 'patient', 'name': 'John Patient'},
      {'email': 'patient2@example.com', 'password': 'patient123', 'role': 'patient', 'name': 'Sarah Patient'},
    ];

    final userIds = <String, String>{};
    
    for (final userData in sampleUsers) {
      final email = userData['email'] as String;
      final password = userData['password'] as String;
      final role = userData['role'] as String;
      final name = userData['name'] as String;
      
      try {
        // Check if user exists
        final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
        
        UserCredential? userCredential;
        String? userId;
        
        if (signInMethods.isEmpty) {
          // Create new user
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          userId = userCredential.user?.uid;
        } else {
          // User exists, try to get their ID
          try {
            // Save the current user so we can sign back in afterward
            final adminUser = _auth.currentUser;
            
            // Sign in as the user to get their ID
            await _auth.signInWithEmailAndPassword(email: email, password: password);
            userId = _auth.currentUser?.uid;
            
            // Sign back in as the admin
            if (adminUser != null && adminUser.email != email) {
              await _auth.signInWithEmailAndPassword(
                email: adminUser.email!,
                password: 'admin123', // Note: This assumes the admin password, which is not secure
              );
            }
          } catch (e) {
            debugPrint('Error signing in as existing user: $e');
            continue;
          }
        }
        
        if (userId != null) {
          userIds[email] = userId;
          
          // Create or update user document
          await _db.collection('users').doc(userId).set({
            'email': email,
            'name': name,
            'role': role,
            'assignedPatientIds': [],
            'createdAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          
          debugPrint('Created/updated user: $email with role: $role');
        }
      } catch (e) {
        debugPrint('Error creating/updating user $email: $e');
      }
    }
    
    // 2. Set up sample patient data
    if (userIds.containsKey('patient1@example.com')) {
      final patientId = userIds['patient1@example.com']!;
      try {
        await _db.collection('users').doc(patientId).update({
          'medicalCondition': 'Hypertension',
          'bloodType': 'A+',
          'vitals': {
            'heartRate': '82 bpm',
            'bloodPressure': '135/90 mmHg',
            'temperature': '36.7 °C',
            'oxygenSaturation': '98%',
            'lastMeasured': DateTime.now().toString(),
          },
          'lastCheckup': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          'lastUpdated': DateTime.now().toString(),
        });
      } catch (e) {
        debugPrint('Error updating patient1 data: $e');
      }
    }
    
    if (userIds.containsKey('patient2@example.com')) {
      final patientId = userIds['patient2@example.com']!;
      try {
        await _db.collection('users').doc(patientId).update({
          'medicalCondition': 'Diabetes Type 2',
          'bloodType': 'O-',
          'vitals': {
            'heartRate': '76 bpm',
            'bloodPressure': '128/84 mmHg',
            'temperature': '36.5 °C',
            'oxygenSaturation': '97%',
            'lastMeasured': DateTime.now().toString(),
          },
          'lastCheckup': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
          'lastUpdated': DateTime.now().toString(),
        });
      } catch (e) {
        debugPrint('Error updating patient2 data: $e');
      }
    }
    
    // 3. Assign patients to doctors
    if (userIds.containsKey('doctor1@hospital.com') && userIds.containsKey('patient1@example.com')) {
      try {
        await _db.collection('users').doc(userIds['doctor1@hospital.com']).update({
          'assignedPatientIds': FieldValue.arrayUnion([userIds['patient1@example.com']]),
        });
      } catch (e) {
        debugPrint('Error assigning patient1 to doctor1: $e');
      }
      
      // Add sample diagnostic and treatment
      if (userIds.containsKey('patient1@example.com')) {
        try {
          await _db.collection('users').doc(userIds['patient1@example.com']).update({
            'diagnostics': [
              {
                'description': 'Primary hypertension, moderate to severe',
                'date': DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
                'doctorId': userIds['doctor1@hospital.com'],
                'doctorName': 'Dr. Smith',
              }
            ],
            'treatments': [
              {
                'medication': 'Amlodipine',
                'dosage': '5mg once daily',
                'description': 'Take in the morning with food. Monitor blood pressure daily.',
                'date': DateTime.now().subtract(const Duration(days: 14)).toIso8601String(),
                'doctorId': userIds['doctor1@hospital.com'],
                'doctorName': 'Dr. Smith',
              }
            ],
          });
        } catch (e) {
          debugPrint('Error adding diagnostics/treatments for patient1: $e');
        }
      }
    }
    
    if (userIds.containsKey('doctor2@hospital.com') && userIds.containsKey('patient2@example.com')) {
      try {
        await _db.collection('users').doc(userIds['doctor2@hospital.com']).update({
          'assignedPatientIds': FieldValue.arrayUnion([userIds['patient2@example.com']]),
        });
      } catch (e) {
        debugPrint('Error assigning patient2 to doctor2: $e');
      }
      
      // Add sample diagnostic and treatment
      if (userIds.containsKey('patient2@example.com')) {
        try {
          await _db.collection('users').doc(userIds['patient2@example.com']).update({
            'diagnostics': [
              {
                'description': 'Type 2 Diabetes Mellitus with hyperglycemia',
                'date': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
                'doctorId': userIds['doctor2@hospital.com'],
                'doctorName': 'Dr. Johnson',
              }
            ],
            'treatments': [
              {
                'medication': 'Metformin',
                'dosage': '500mg twice daily',
                'description': 'Take with meals to reduce gastrointestinal side effects. Monitor blood glucose levels.',
                'date': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
                'doctorId': userIds['doctor2@hospital.com'],
                'doctorName': 'Dr. Johnson',
              }
            ],
          });
        } catch (e) {
          debugPrint('Error adding diagnostics/treatments for patient2: $e');
        }
      }
    }
    
    debugPrint('Sample data population completed successfully');
  } catch (e) {
    debugPrint('Error populating sample data: $e');
    rethrow; // Rethrow to allow UI to handle the error
  } finally {
    // Ensure we're signed out after creating sample data
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }
}
