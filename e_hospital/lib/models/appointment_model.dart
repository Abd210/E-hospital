import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'appointment_model.freezed.dart';
part 'appointment_model.g.dart';

enum AppointmentStatus {
  scheduled,
  confirmed,
  inProgress,
  completed,
  cancelled,
  noShow,
  rescheduled
}

enum AppointmentType {
  checkup,
  followUp,
  consultation,
  emergency,
  procedure,
  surgery,
  vaccination,
  test,
  therapy
}

@freezed
class Appointment with _$Appointment {
  const factory Appointment({
    required String id,
    required String patientId,
    required String patientName,
    required String doctorId,
    required String doctorName,
    required DateTime appointmentDate,
    required String time,
    required String purpose,
    @Default(AppointmentStatus.scheduled) AppointmentStatus status,
    @Default(AppointmentType.checkup) AppointmentType type,
    String? notes,
    String? location,
    String? department,
    int? duration,
    String? symptoms,
    String? patientPhoneNumber,
    String? doctorSpecialty,
    bool? isVirtual,
    String? virtualMeetingLink,
    List<String>? attachments,
    DateTime? checkedInTime,
    DateTime? checkedOutTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    Map<String, dynamic>? metadata,
  }) = _Appointment;

  factory Appointment.fromJson(Map<String, dynamic> json) =>
      _$AppointmentFromJson(json);

  factory Appointment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    
    // Parse dates from Firestore Timestamps
    final appointmentDate = data['appointmentDate'] != null
        ? (data['appointmentDate'] as Timestamp).toDate()
        : DateTime.now();
    
    final checkedInTime = data['checkedInTime'] != null
        ? (data['checkedInTime'] as Timestamp).toDate()
        : null;
    
    final checkedOutTime = data['checkedOutTime'] != null
        ? (data['checkedOutTime'] as Timestamp).toDate()
        : null;
    
    final createdAt = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : null;
    
    final updatedAt = data['updatedAt'] != null
        ? (data['updatedAt'] as Timestamp).toDate()
        : null;
    
    // Parse enum values
    AppointmentStatus status = AppointmentStatus.scheduled;
    if (data['status'] != null) {
      try {
        status = AppointmentStatus.values.firstWhere(
          (e) => e.toString().split('.').last == data['status'],
          orElse: () => AppointmentStatus.scheduled,
        );
      } catch (_) {}
    }
    
    AppointmentType type = AppointmentType.checkup;
    if (data['type'] != null) {
      try {
        type = AppointmentType.values.firstWhere(
          (e) => e.toString().split('.').last == data['type'],
          orElse: () => AppointmentType.checkup,
        );
      } catch (_) {}
    }

    return Appointment(
      id: doc.id,
      patientId: data['patientId'] ?? '',
      patientName: data['patientName'] ?? '',
      doctorId: data['doctorId'] ?? '',
      doctorName: data['doctorName'] ?? '',
      appointmentDate: appointmentDate,
      time: data['time'] ?? '',
      purpose: data['purpose'] ?? '',
      status: status,
      type: type,
      notes: data['notes'],
      location: data['location'],
      department: data['department'],
      duration: data['duration'],
      symptoms: data['symptoms'],
      patientPhoneNumber: data['patientPhoneNumber'],
      doctorSpecialty: data['doctorSpecialty'],
      isVirtual: data['isVirtual'],
      virtualMeetingLink: data['virtualMeetingLink'],
      attachments: data['attachments'] != null 
          ? List<String>.from(data['attachments'])
          : null,
      checkedInTime: checkedInTime,
      checkedOutTime: checkedOutTime,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: data['createdBy'],
      metadata: data['metadata'],
    );
  }
  
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    
    // Convert DateTime to Timestamp for Firestore
    if (json['appointmentDate'] != null) {
      json['appointmentDate'] = Timestamp.fromDate(appointmentDate);
    }
    
    if (json['checkedInTime'] != null) {
      json['checkedInTime'] = Timestamp.fromDate(checkedInTime!);
    }
    
    if (json['checkedOutTime'] != null) {
      json['checkedOutTime'] = Timestamp.fromDate(checkedOutTime!);
    }
    
    if (json['createdAt'] != null) {
      json['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    
    if (json['updatedAt'] != null) {
      json['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    
    // Convert enum to string
    json['status'] = status.toString().split('.').last;
    json['type'] = type.toString().split('.').last;
    
    return json;
  }
}

@freezed
class AppointmentSlot with _$AppointmentSlot {
  const factory AppointmentSlot({
    required String id,
    required String doctorId,
    required DateTime date,
    required String startTime,
    required String endTime,
    @Default(true) bool isAvailable,
    String? appointmentId,
    String? patientId,
    String? notes,
  }) = _AppointmentSlot;

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotFromJson(json);
} 