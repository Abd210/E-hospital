import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _db = FirebaseFirestore.instance;

/// returns the current user role ('hospitalAdmin' | 'medicalPersonnel' | 'patient')
Future<String?> fetchRole() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  final doc = await _db.collection('users').doc(uid).get();
  return doc.data()?['role'] as String?;
}
