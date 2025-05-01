// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppointmentImpl _$$AppointmentImplFromJson(Map<String, dynamic> json) =>
    _$AppointmentImpl(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate'] as String),
      time: json['time'] as String,
      purpose: json['purpose'] as String,
      status: $enumDecodeNullable(_$AppointmentStatusEnumMap, json['status']) ??
          AppointmentStatus.scheduled,
      type: $enumDecodeNullable(_$AppointmentTypeEnumMap, json['type']) ??
          AppointmentType.checkup,
      notes: json['notes'] as String?,
      location: json['location'] as String?,
      department: json['department'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      symptoms: json['symptoms'] as String?,
      patientPhoneNumber: json['patientPhoneNumber'] as String?,
      doctorSpecialty: json['doctorSpecialty'] as String?,
      isVirtual: json['isVirtual'] as bool?,
      virtualMeetingLink: json['virtualMeetingLink'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      checkedInTime: json['checkedInTime'] == null
          ? null
          : DateTime.parse(json['checkedInTime'] as String),
      checkedOutTime: json['checkedOutTime'] == null
          ? null
          : DateTime.parse(json['checkedOutTime'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AppointmentImplToJson(_$AppointmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientId': instance.patientId,
      'patientName': instance.patientName,
      'doctorId': instance.doctorId,
      'doctorName': instance.doctorName,
      'appointmentDate': instance.appointmentDate.toIso8601String(),
      'time': instance.time,
      'purpose': instance.purpose,
      'status': _$AppointmentStatusEnumMap[instance.status]!,
      'type': _$AppointmentTypeEnumMap[instance.type]!,
      'notes': instance.notes,
      'location': instance.location,
      'department': instance.department,
      'duration': instance.duration,
      'symptoms': instance.symptoms,
      'patientPhoneNumber': instance.patientPhoneNumber,
      'doctorSpecialty': instance.doctorSpecialty,
      'isVirtual': instance.isVirtual,
      'virtualMeetingLink': instance.virtualMeetingLink,
      'attachments': instance.attachments,
      'checkedInTime': instance.checkedInTime?.toIso8601String(),
      'checkedOutTime': instance.checkedOutTime?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'metadata': instance.metadata,
    };

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.scheduled: 'scheduled',
  AppointmentStatus.confirmed: 'confirmed',
  AppointmentStatus.inProgress: 'inProgress',
  AppointmentStatus.completed: 'completed',
  AppointmentStatus.cancelled: 'cancelled',
  AppointmentStatus.noShow: 'noShow',
  AppointmentStatus.rescheduled: 'rescheduled',
};

const _$AppointmentTypeEnumMap = {
  AppointmentType.checkup: 'checkup',
  AppointmentType.followUp: 'followUp',
  AppointmentType.consultation: 'consultation',
  AppointmentType.emergency: 'emergency',
  AppointmentType.procedure: 'procedure',
  AppointmentType.surgery: 'surgery',
  AppointmentType.vaccination: 'vaccination',
  AppointmentType.test: 'test',
  AppointmentType.therapy: 'therapy',
};

_$AppointmentSlotImpl _$$AppointmentSlotImplFromJson(
        Map<String, dynamic> json) =>
    _$AppointmentSlotImpl(
      id: json['id'] as String,
      doctorId: json['doctorId'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      appointmentId: json['appointmentId'] as String?,
      patientId: json['patientId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$AppointmentSlotImplToJson(
        _$AppointmentSlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorId': instance.doctorId,
      'date': instance.date.toIso8601String(),
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isAvailable': instance.isAvailable,
      'appointmentId': instance.appointmentId,
      'patientId': instance.patientId,
      'notes': instance.notes,
    };
