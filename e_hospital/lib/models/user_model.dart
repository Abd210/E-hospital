import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  hospitalAdmin,
  medicalPersonnel,
  patient,
  nurse,
  receptionist,
  pharmacist,
  labTechnician
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    required UserRole role,
    String? photoUrl,
    String? phone,
    String? address,
    @Default(false) bool isActive,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? metadata,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return User.fromJson({
      'id': doc.id,
      ...data,
      'role': _parseRole(data['role']),
      'createdAt': data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate().toIso8601String()
          : null,
      'updatedAt': data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
          : null,
      'lastLogin': data['lastLogin'] != null
          ? (data['lastLogin'] as Timestamp).toDate().toIso8601String()
          : null,
    });
  }

  static String _parseRole(dynamic role) {
    if (role is String) {
      return role;
    }
    return 'patient'; // Default role
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    
    // Convert DateTime to Timestamp for Firestore
    if (createdAt != null) {
      json['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    if (updatedAt != null) {
      json['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    if (lastLogin != null) {
      json['lastLogin'] = Timestamp.fromDate(lastLogin!);
    }
    
    return json;
  }

  bool get isAdmin => role == UserRole.hospitalAdmin;
  bool get isDoctor => role == UserRole.medicalPersonnel;
  bool get isPatient => role == UserRole.patient;
  bool get isNurse => role == UserRole.nurse;
  bool get isReceptionist => role == UserRole.receptionist;
  bool get isPharmacist => role == UserRole.pharmacist;
  bool get isLabTechnician => role == UserRole.labTechnician;
  bool get isMedicalStaff => isDoctor || isNurse || isPharmacist || isLabTechnician;
}

@freezed
class AdminProfile with _$AdminProfile {
  const factory AdminProfile({
    required String userId,
    required String department,
    String? position,
    String? employeeId,
    String? officeLocation,
    List<String>? managedDepartments,
    List<String>? responsibilities,
    DateTime? hireDate,
  }) = _AdminProfile;

  factory AdminProfile.fromJson(Map<String, dynamic> json) =>
      _$AdminProfileFromJson(json);
}

@freezed
class MedicalPersonnelProfile with _$MedicalPersonnelProfile {
  const factory MedicalPersonnelProfile({
    required String userId,
    required String specialization,
    required String licenseNumber,
    required String experience,
    List<String>? assignedPatientIds,
    List<String>? qualifications,
    List<String>? certifications,
    String? biography,
    String? officeHours,
    String? department,
    Map<String, dynamic>? schedule,
    @Default(0) int patientCount,
    @Default(0) int appointmentCount,
    @Default(0) double rating,
    @Default(0) int reviewCount,
  }) = _MedicalPersonnelProfile;

  factory MedicalPersonnelProfile.fromJson(Map<String, dynamic> json) =>
      _$MedicalPersonnelProfileFromJson(json);
}

@freezed
class PatientProfile with _$PatientProfile {
  const factory PatientProfile({
    required String userId,
    required int age,
    required String gender,
    String? medicalCondition,
    String? bloodType,
    String? emergencyContact,
    String? insuranceProvider,
    String? insuranceNumber,
    String? allergies,
    String? chronicDiseases,
    String? currentMedication,
    Map<String, dynamic>? vitals,
    List<Map<String, dynamic>>? medicalHistory,
    List<Map<String, dynamic>>? treatments,
    List<Map<String, dynamic>>? diagnostics,
    List<String>? assignedDoctorIds,
    DateTime? lastCheckup,
  }) = _PatientProfile;

  factory PatientProfile.fromJson(Map<String, dynamic> json) =>
      _$PatientProfileFromJson(json);
}

@freezed
class NurseProfile with _$NurseProfile {
  const factory NurseProfile({
    required String userId,
    required String nurseType,
    required String licenseNumber,
    String? department,
    List<String>? assignedPatientIds,
    String? specialization,
    String? experience,
    List<String>? qualifications,
    Map<String, dynamic>? schedule,
  }) = _NurseProfile;

  factory NurseProfile.fromJson(Map<String, dynamic> json) =>
      _$NurseProfileFromJson(json);
}

@freezed
class ReceptionistProfile with _$ReceptionistProfile {
  const factory ReceptionistProfile({
    required String userId,
    required String employeeId,
    String? department,
    String? shiftHours,
    String? responsibilities,
    DateTime? hireDate,
  }) = _ReceptionistProfile;

  factory ReceptionistProfile.fromJson(Map<String, dynamic> json) =>
      _$ReceptionistProfileFromJson(json);
}

@freezed
class PharmacistProfile with _$PharmacistProfile {
  const factory PharmacistProfile({
    required String userId,
    required String licenseNumber,
    String? experience,
    String? department,
    String? specialization,
    List<String>? certifications,
    DateTime? hireDate,
  }) = _PharmacistProfile;

  factory PharmacistProfile.fromJson(Map<String, dynamic> json) =>
      _$PharmacistProfileFromJson(json);
}

@freezed
class LabTechnicianProfile with _$LabTechnicianProfile {
  const factory LabTechnicianProfile({
    required String userId,
    required String licenseNumber,
    String? experience,
    String? department,
    List<String>? specializations,
    List<String>? certifications,
    DateTime? hireDate,
  }) = _LabTechnicianProfile;

  factory LabTechnicianProfile.fromJson(Map<String, dynamic> json) =>
      _$LabTechnicianProfileFromJson(json);
} 