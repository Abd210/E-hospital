import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _db = FirebaseFirestore.instance;

/// returns the current user role ('hospitalAdmin' | 'medicalPersonnel' | 'patient')
Future<String?> fetchRole() async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return null;
  
  try {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.data()?['role'] as String?;
  } catch (e) {
    debugPrint('Error fetching role: $e');
    // Return a default role when there's a permission error
    return 'patient';
  }
}
