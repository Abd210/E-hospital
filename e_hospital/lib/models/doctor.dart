import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_hospital/models/user_model.dart';

/// Doctor model - a convenience wrapper around the User model
/// that represents a medical personnel (doctor)
class Doctor {
  final User user;
  
  Doctor(this.user) {
    assert(user.role == UserRole.medicalPersonnel, 'User must be a medical personnel');
  }

  /// Create a Doctor from a User object
  factory Doctor.fromUser(User user) {
    return Doctor(user);
  }
  
  /// Create a Doctor from Firestore document
  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final user = User.fromFirestore(doc);
    return Doctor.fromUser(user);
  }
  
  // Forward User properties
  String get id => user.id;
  String get email => user.email;
  String get name => user.name;
  String? get photoUrl => user.photoUrl;
  String? get phone => user.phone;
  Map<String, dynamic>? get profile => user.profile;
  bool get isActive => user.isActive;
  DateTime? get lastLogin => user.lastLogin;
  DateTime? get createdAt => user.createdAt;
  DateTime? get updatedAt => user.updatedAt;
  Map<String, dynamic>? get metadata => user.metadata;
  
  /// Get doctor's specialization
  String get specialization => profile?['specialization'] as String? ?? 'General';
  
  /// Get doctor's license number
  String get licenseNumber => profile?['licenseNumber'] as String? ?? '';
  
  /// Get doctor's experience
  String get experience => profile?['experience'] as String? ?? '';
  
  /// Get doctor's department
  String get department => profile?['department'] as String? ?? '';
  
  /// Get doctor's biography
  String get bio => profile?['bio'] as String? ?? '';
  
  /// Get doctor's qualifications
  List<String> get qualifications => 
      (profile?['qualifications'] as List<dynamic>?)?.cast<String>() ?? [];
  
  /// Get doctor's certifications
  List<String> get certifications =>
      (profile?['certifications'] as List<dynamic>?)?.cast<String>() ?? [];
  
  /// Get doctor's assigned patients - get it from either the top-level 'assignedPatientIds' field
  /// or the 'profile.assignedPatientIds' field for backward compatibility
  List<String> get assignedPatientIds {
    // Try to get from user.metadata first (top-level field)
    if (user.metadata != null && user.metadata!.containsKey('assignedPatientIds')) {
      return (user.metadata!['assignedPatientIds'] as List<dynamic>?)?.cast<String>() ?? [];
    }
    
    // No direct data field in User model at this time
    // Try to get from profile
    return (profile?['assignedPatientIds'] as List<dynamic>?)?.cast<String>() ?? [];
  }
  
  /// Convert to user model for updates
  User toUser() => user;
} 