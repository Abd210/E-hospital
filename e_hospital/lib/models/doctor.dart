import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_hospital/models/user_model.dart';
import 'package:flutter/material.dart';

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
  
  /// Get doctor's schedule - returns a map of day name to working hours
  Map<String, Map<String, dynamic>> get schedule {
    // Try to get from metadata first
    if (user.metadata != null && user.metadata!.containsKey('schedule')) {
      return (user.metadata!['schedule'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as Map<String, dynamic>)
      ) ?? getDefaultSchedule();
    }
    
    // Try to get from profile
    if (profile != null && profile!.containsKey('schedule')) {
      return (profile!['schedule'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as Map<String, dynamic>)
      ) ?? getDefaultSchedule();
    }
    
    // Return default schedule
    return getDefaultSchedule();
  }
  
  /// Get default schedule for doctor
  Map<String, Map<String, dynamic>> getDefaultSchedule() {
    return {
      'Monday': {'startTime': '09:00', 'endTime': '17:00', 'isAvailable': true},
      'Tuesday': {'startTime': '09:00', 'endTime': '17:00', 'isAvailable': true},
      'Wednesday': {'startTime': '10:00', 'endTime': '18:00', 'isAvailable': true},
      'Thursday': {'startTime': '09:00', 'endTime': '17:00', 'isAvailable': true},
      'Friday': {'startTime': '09:00', 'endTime': '15:00', 'isAvailable': true},
      'Saturday': {'startTime': '10:00', 'endTime': '14:00', 'isAvailable': true},
      'Sunday': {'startTime': '00:00', 'endTime': '00:00', 'isAvailable': false},
    };
  }
  
  /// Check if a doctor is available at a specific date and time
  bool isAvailableAt(DateTime dateTime, String timeString) {
    debugPrint('Checking availability for $name on ${_getDayOfWeek(dateTime)} at $timeString');
    
    // Get the day of the week
    final day = _getDayOfWeek(dateTime);
    
    // Get the schedule for this day
    final daySchedule = schedule[day];
    if (daySchedule == null) {
      debugPrint('No schedule defined for $day');
      return false;
    }
    
    // Check if the doctor works on this day
    final isAvailable = daySchedule['isAvailable'] ?? false;
    if (!isAvailable) {
      debugPrint('Doctor is not available on $day');
      return false;
    }
    
    // Parse the requested time
    final requestedTime = _parseTimeString(timeString);
    if (requestedTime == null) {
      debugPrint('Invalid time format: $timeString');
      return false;
    }
    
    // Parse working hours
    final startTime = _parseTimeString(daySchedule['startTime'] ?? '');
    final endTime = _parseTimeString(daySchedule['endTime'] ?? '');
    
    if (startTime == null || endTime == null) {
      debugPrint('Invalid schedule time format: ${daySchedule['startTime']} - ${daySchedule['endTime']}');
      return false;
    }
    
    // Check if the requested time is within working hours
    final isInWorkingHours = 
        requestedTime.isAfter(startTime) && 
        requestedTime.isBefore(endTime);
    
    debugPrint('Requested time $timeString is ${isInWorkingHours ? "within" : "outside"} working hours (${daySchedule['startTime']} - ${daySchedule['endTime']})');
    
    return isInWorkingHours;
  }
  
  /// Helper method to parse a time string (HH:MM) to a DateTime object
  DateTime? _parseTimeString(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length != 2) return null;
      
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      
      if (hour == null || minute == null) return null;
      
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      debugPrint('Error parsing time string: $e');
      return null;
    }
  }
  
  /// Helper method to get day of week string
  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday: return 'Monday';
      case DateTime.tuesday: return 'Tuesday';
      case DateTime.wednesday: return 'Wednesday';
      case DateTime.thursday: return 'Thursday';
      case DateTime.friday: return 'Friday';
      case DateTime.saturday: return 'Saturday';
      case DateTime.sunday: return 'Sunday';
      default: return '';
    }
  }
  
  /// Convert to user model for updates
  User toUser() => user;
} 