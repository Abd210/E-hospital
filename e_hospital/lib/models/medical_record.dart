import 'package:flutter/material.dart';

class MedicalRecord {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final String title;
  final String description;
  final String recordType;
  final List<String> attachments;
  
  const MedicalRecord({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.title,
    required this.description,
    required this.recordType,
    required this.attachments,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': date.toIso8601String(),
      'title': title,
      'description': description,
      'recordType': recordType,
      'attachments': attachments,
    };
  }
  
  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'] as String,
      patientId: json['patientId'] as String,
      doctorId: json['doctorId'] as String,
      doctorName: json['doctorName'] as String,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      description: json['description'] as String,
      recordType: json['recordType'] as String,
      attachments: (json['attachments'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }
} 