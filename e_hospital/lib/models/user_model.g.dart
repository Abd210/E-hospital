// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      photoUrl: json['photoUrl'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      profile: json['profile'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'photoUrl': instance.photoUrl,
      'phone': instance.phone,
      'address': instance.address,
      'isActive': instance.isActive,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'profile': instance.profile,
      'metadata': instance.metadata,
    };

const _$UserRoleEnumMap = {
  UserRole.hospitalAdmin: 'hospitalAdmin',
  UserRole.medicalPersonnel: 'medicalPersonnel',
  UserRole.patient: 'patient',
  UserRole.nurse: 'nurse',
  UserRole.receptionist: 'receptionist',
  UserRole.pharmacist: 'pharmacist',
  UserRole.labTechnician: 'labTechnician',
};

_$AdminProfileImpl _$$AdminProfileImplFromJson(Map<String, dynamic> json) =>
    _$AdminProfileImpl(
      userId: json['userId'] as String,
      department: json['department'] as String,
      position: json['position'] as String?,
      employeeId: json['employeeId'] as String?,
      officeLocation: json['officeLocation'] as String?,
      managedDepartments: (json['managedDepartments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      responsibilities: (json['responsibilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
    );

Map<String, dynamic> _$$AdminProfileImplToJson(_$AdminProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'department': instance.department,
      'position': instance.position,
      'employeeId': instance.employeeId,
      'officeLocation': instance.officeLocation,
      'managedDepartments': instance.managedDepartments,
      'responsibilities': instance.responsibilities,
      'hireDate': instance.hireDate?.toIso8601String(),
    };

_$MedicalPersonnelProfileImpl _$$MedicalPersonnelProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$MedicalPersonnelProfileImpl(
      userId: json['userId'] as String,
      specialization: json['specialization'] as String,
      licenseNumber: json['licenseNumber'] as String,
      experience: json['experience'] as String,
      assignedPatientIds: (json['assignedPatientIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      qualifications: (json['qualifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      biography: json['biography'] as String?,
      officeHours: json['officeHours'] as String?,
      department: json['department'] as String?,
      schedule: json['schedule'] as Map<String, dynamic>?,
      patientCount: (json['patientCount'] as num?)?.toInt() ?? 0,
      appointmentCount: (json['appointmentCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$MedicalPersonnelProfileImplToJson(
        _$MedicalPersonnelProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'specialization': instance.specialization,
      'licenseNumber': instance.licenseNumber,
      'experience': instance.experience,
      'assignedPatientIds': instance.assignedPatientIds,
      'qualifications': instance.qualifications,
      'certifications': instance.certifications,
      'biography': instance.biography,
      'officeHours': instance.officeHours,
      'department': instance.department,
      'schedule': instance.schedule,
      'patientCount': instance.patientCount,
      'appointmentCount': instance.appointmentCount,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
    };

_$PatientProfileImpl _$$PatientProfileImplFromJson(Map<String, dynamic> json) =>
    _$PatientProfileImpl(
      userId: json['userId'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
      medicalCondition: json['medicalCondition'] as String?,
      bloodType: json['bloodType'] as String?,
      emergencyContact: json['emergencyContact'] as String?,
      insuranceProvider: json['insuranceProvider'] as String?,
      insuranceNumber: json['insuranceNumber'] as String?,
      allergies: json['allergies'] as String?,
      chronicDiseases: json['chronicDiseases'] as String?,
      currentMedication: json['currentMedication'] as String?,
      vitals: json['vitals'] as Map<String, dynamic>?,
      medicalHistory: (json['medicalHistory'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      treatments: (json['treatments'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      diagnostics: (json['diagnostics'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      assignedDoctorIds: (json['assignedDoctorIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastCheckup: json['lastCheckup'] == null
          ? null
          : DateTime.parse(json['lastCheckup'] as String),
    );

Map<String, dynamic> _$$PatientProfileImplToJson(
        _$PatientProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'age': instance.age,
      'gender': instance.gender,
      'medicalCondition': instance.medicalCondition,
      'bloodType': instance.bloodType,
      'emergencyContact': instance.emergencyContact,
      'insuranceProvider': instance.insuranceProvider,
      'insuranceNumber': instance.insuranceNumber,
      'allergies': instance.allergies,
      'chronicDiseases': instance.chronicDiseases,
      'currentMedication': instance.currentMedication,
      'vitals': instance.vitals,
      'medicalHistory': instance.medicalHistory,
      'treatments': instance.treatments,
      'diagnostics': instance.diagnostics,
      'assignedDoctorIds': instance.assignedDoctorIds,
      'lastCheckup': instance.lastCheckup?.toIso8601String(),
    };

_$NurseProfileImpl _$$NurseProfileImplFromJson(Map<String, dynamic> json) =>
    _$NurseProfileImpl(
      userId: json['userId'] as String,
      nurseType: json['nurseType'] as String,
      licenseNumber: json['licenseNumber'] as String,
      department: json['department'] as String?,
      assignedPatientIds: (json['assignedPatientIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialization: json['specialization'] as String?,
      experience: json['experience'] as String?,
      qualifications: (json['qualifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      schedule: json['schedule'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$NurseProfileImplToJson(_$NurseProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nurseType': instance.nurseType,
      'licenseNumber': instance.licenseNumber,
      'department': instance.department,
      'assignedPatientIds': instance.assignedPatientIds,
      'specialization': instance.specialization,
      'experience': instance.experience,
      'qualifications': instance.qualifications,
      'schedule': instance.schedule,
    };

_$ReceptionistProfileImpl _$$ReceptionistProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$ReceptionistProfileImpl(
      userId: json['userId'] as String,
      employeeId: json['employeeId'] as String,
      department: json['department'] as String?,
      shiftHours: json['shiftHours'] as String?,
      responsibilities: json['responsibilities'] as String?,
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
    );

Map<String, dynamic> _$$ReceptionistProfileImplToJson(
        _$ReceptionistProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'employeeId': instance.employeeId,
      'department': instance.department,
      'shiftHours': instance.shiftHours,
      'responsibilities': instance.responsibilities,
      'hireDate': instance.hireDate?.toIso8601String(),
    };

_$PharmacistProfileImpl _$$PharmacistProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$PharmacistProfileImpl(
      userId: json['userId'] as String,
      licenseNumber: json['licenseNumber'] as String,
      experience: json['experience'] as String?,
      department: json['department'] as String?,
      specialization: json['specialization'] as String?,
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
    );

Map<String, dynamic> _$$PharmacistProfileImplToJson(
        _$PharmacistProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'licenseNumber': instance.licenseNumber,
      'experience': instance.experience,
      'department': instance.department,
      'specialization': instance.specialization,
      'certifications': instance.certifications,
      'hireDate': instance.hireDate?.toIso8601String(),
    };

_$LabTechnicianProfileImpl _$$LabTechnicianProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$LabTechnicianProfileImpl(
      userId: json['userId'] as String,
      licenseNumber: json['licenseNumber'] as String,
      experience: json['experience'] as String?,
      department: json['department'] as String?,
      specializations: (json['specializations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hireDate: json['hireDate'] == null
          ? null
          : DateTime.parse(json['hireDate'] as String),
    );

Map<String, dynamic> _$$LabTechnicianProfileImplToJson(
        _$LabTechnicianProfileImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'licenseNumber': instance.licenseNumber,
      'experience': instance.experience,
      'department': instance.department,
      'specializations': instance.specializations,
      'certifications': instance.certifications,
      'hireDate': instance.hireDate?.toIso8601String(),
    };
