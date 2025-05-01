import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_hospital/models/user_model.dart';

/// Patient model - a convenience wrapper around the User model
/// that represents a patient
class Patient {
  final User user;
  
  Patient(this.user) {
    assert(user.role == UserRole.patient, 'User must be a patient');
  }

  /// Create a Patient from a User object
  factory Patient.fromUser(User user) {
    return Patient(user);
  }
  
  /// Create a Patient from Firestore document
  factory Patient.fromFirestore(DocumentSnapshot doc) {
    final user = User.fromFirestore(doc);
    return Patient.fromUser(user);
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
  
  /// Get patient's age
  int get age => (profile?['age'] as int?) ?? 0;
  
  /// Get patient's gender
  String get gender => profile?['gender'] as String? ?? '';
  
  /// Get patient's medical condition
  String get medicalCondition => profile?['medicalCondition'] as String? ?? 'Healthy';
  
  /// Get patient's blood type
  String get bloodType => profile?['bloodType'] as String? ?? 'Unknown';
  
  /// Get patient's emergency contact
  String get emergencyContact => profile?['emergencyContact'] as String? ?? '';
  
  /// Get patient's insurance provider
  String get insuranceProvider => profile?['insuranceProvider'] as String? ?? '';
  
  /// Get patient's insurance number
  String get insuranceNumber => profile?['insuranceNumber'] as String? ?? '';
  
  /// Get patient's allergies
  String get allergies => profile?['allergies'] as String? ?? '';
  
  /// Get patient's chronic diseases
  String get chronicDiseases => profile?['chronicDiseases'] as String? ?? '';
  
  /// Get patient's current medication
  String get currentMedication => profile?['currentMedication'] as String? ?? '';
  
  /// Get patient's vitals
  Map<String, dynamic> get vitals => profile?['vitals'] as Map<String, dynamic>? ?? {};
  
  /// Get patient's medical history
  List<Map<String, dynamic>> get medicalHistory => 
      (profile?['medicalHistory'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  
  /// Get patient's treatments
  List<Map<String, dynamic>> get treatments =>
      (profile?['treatments'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  
  /// Get patient's diagnostics
  List<Map<String, dynamic>> get diagnostics =>
      (profile?['diagnostics'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  
  /// Get patient's assigned doctors
  List<String> get assignedDoctorIds =>
      (profile?['assignedDoctorIds'] as List<dynamic>?)?.cast<String>() ?? [];
  
  /// Get patient's last checkup date
  DateTime? get lastCheckup {
    final timestamp = profile?['lastCheckup'] as Timestamp?;
    return timestamp?.toDate();
  }
  
  /// Convert to user model for updates
  User toUser() => user;
} 