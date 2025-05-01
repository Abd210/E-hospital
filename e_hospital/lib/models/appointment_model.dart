import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

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
    try {
      debugPrint('Parsing appointment from Firestore doc ID: ${doc.id}');
      final data = doc.data() as Map<String, dynamic>? ?? {};
      debugPrint('Raw appointment data: $data');
      
      // Parse dates from Firestore Timestamps
      DateTime appointmentDate;
      try {
        if (data['appointmentDate'] is Timestamp) {
          appointmentDate = (data['appointmentDate'] as Timestamp).toDate();
          debugPrint('Parsed appointmentDate: $appointmentDate');
        } else {
          debugPrint('appointmentDate is not a Timestamp: ${data['appointmentDate']}');
          appointmentDate = DateTime.now();
        }
      } catch (e) {
        debugPrint('Error parsing appointment date: $e');
        appointmentDate = DateTime.now();
      }
      
      DateTime? checkedInTime;
      try {
        if (data['checkedInTime'] is Timestamp) {
          checkedInTime = (data['checkedInTime'] as Timestamp).toDate();
        }
      } catch (e) {
        debugPrint('Error parsing checkedInTime: $e');
      }
      
      DateTime? checkedOutTime;
      try {
        if (data['checkedOutTime'] is Timestamp) {
          checkedOutTime = (data['checkedOutTime'] as Timestamp).toDate();
        }
      } catch (e) {
        debugPrint('Error parsing checkedOutTime: $e');
      }
      
      DateTime? createdAt;
      try {
        if (data['createdAt'] is Timestamp) {
          createdAt = (data['createdAt'] as Timestamp).toDate();
        }
      } catch (e) {
        debugPrint('Error parsing createdAt: $e');
      }
      
      DateTime? updatedAt;
      try {
        if (data['updatedAt'] is Timestamp) {
          updatedAt = (data['updatedAt'] as Timestamp).toDate();
        }
      } catch (e) {
        debugPrint('Error parsing updatedAt: $e');
      }
      
      // Parse enum values
      AppointmentStatus status = AppointmentStatus.scheduled;
      if (data['status'] != null) {
        try {
          status = AppointmentStatus.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == data['status'].toString().toLowerCase(),
            orElse: () => AppointmentStatus.scheduled,
          );
          debugPrint('Parsed status: $status');
        } catch (e) {
          debugPrint('Error parsing status: $e');
        }
      }
      
      AppointmentType type = AppointmentType.checkup;
      if (data['type'] != null) {
        try {
          type = AppointmentType.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == data['type'].toString().toLowerCase(),
            orElse: () => AppointmentType.checkup,
          );
          debugPrint('Parsed type: $type');
        } catch (e) {
          debugPrint('Error parsing type: $e');
        }
      }

      final appointment = Appointment(
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
      
      debugPrint('Successfully parsed appointment: ${appointment.id}');
      return appointment;
    } catch (e, stackTrace) {
      debugPrint('Error in Appointment.fromFirestore: $e');
      debugPrint('Stack trace: $stackTrace');
      
      // Return a minimal valid appointment to avoid crashes
      return Appointment(
        id: doc.id,
        patientId: '',
        patientName: 'Error parsing data',
        doctorId: '',
        doctorName: 'Error parsing data',
        appointmentDate: DateTime.now(),
        time: '',
        purpose: 'Error: $e',
      );
    }
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