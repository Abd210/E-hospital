import 'package:flutter/material.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:e_hospital/models/user_model.dart';
import 'package:e_hospital/models/patient.dart';
import 'package:e_hospital/models/appointment_model.dart';
import 'package:e_hospital/theme/app_theme.dart';

class DoctorAppointmentForm extends StatefulWidget {
  const DoctorAppointmentForm({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentForm> createState() => _DoctorAppointmentFormState();
}

class _DoctorAppointmentFormState extends State<DoctorAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _purposeController = TextEditingController();
  final _notesController = TextEditingController();
  
  bool _isLoading = true;
  bool _isSaving = false;
  String _errorMessage = '';
  
  // Doctor info
  String _doctorId = '';
  String _doctorName = '';
  String _doctorSpecialty = '';
  
  // Patient selection
  Patient? _selectedPatient;
  List<Patient> _patientsList = [];
  
  // Appointment details
  AppointmentType _appointmentType = AppointmentType.checkup;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _loadData();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Get current user (doctor)
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      _doctorId = currentUser.uid;
      final doctorData = await FirestoreService.getUserById(_doctorId);
      if (doctorData != null) {
        _doctorName = doctorData.name;
        
        // Get specialty if available
        if (doctorData.profile != null && doctorData.profile!.containsKey('specialization')) {
          _doctorSpecialty = doctorData.profile!['specialization'] as String? ?? '';
        }
      }
      
      // Get doctor's patients
      final patients = await FirestoreService.getDoctorPatients(_doctorId);
      
      setState(() {
        _patientsList = patients;
        if (patients.isNotEmpty) {
          _selectedPatient = patients.first;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }
  
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    
    if (picked != null) {
      setState(() {
        _timeController.text = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _createAppointment() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = '';
    });

    try {
      // Check if doctor is available at this time (avoid double-booking)
      final isDoctorAvailable = await FirestoreService.isDoctorAvailable(
        _doctorId,
        _selectedDate,
        _timeController.text,
      );
      
      if (!isDoctorAvailable) {
        // Show error about time slot not being available
        setState(() {
          _isSaving = false;
          _errorMessage = 'This time slot is already booked. Please select another time.';
        });
        
        // Get already booked times to help user
        final bookedTimes = await FirestoreService.getDoctorAppointmentTimes(
          _doctorId,
          _selectedDate,
        );
        
        if (bookedTimes.isNotEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Already booked times: ${bookedTimes.join(", ")}'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
        
        return;
      }
      
      // Create the appointment
      final appointment = Appointment(
        id: '',  // Will be generated by Firestore
        doctorId: _doctorId,
        doctorName: 'Dr. $_doctorName',
        doctorSpecialty: _doctorSpecialty,
        patientId: _selectedPatient!.id,
        patientName: _selectedPatient!.name,
        appointmentDate: _selectedDate,
        time: _timeController.text,
        purpose: _purposeController.text,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        type: _appointmentType,
        status: AppointmentStatus.scheduled,
      );

      await FirestoreService.createAppointment(appointment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment created successfully')),
        );
        Navigator.pop(context, true);  // Return true to indicate success
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create appointment: $e';
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Appointment'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_errorMessage.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.red.shade50,
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Appointment Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Patient dropdown
                            if (_patientsList.isEmpty) ...[
                              const Text(
                                'No patients assigned to you. Please contact an administrator.',
                                style: TextStyle(color: Colors.red),
                              ),
                            ] else ...[
                              DropdownButtonFormField<Patient>(
                                decoration: const InputDecoration(
                                  labelText: 'Select Patient',
                                  border: OutlineInputBorder(),
                                ),
                                value: _selectedPatient,
                                items: _patientsList.map((patient) {
                                  return DropdownMenuItem<Patient>(
                                    value: patient,
                                    child: Text(patient.name),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPatient = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select a patient';
                                  }
                                  return null;
                                },
                              ),
                            ],
                            
                            const SizedBox(height: 16),
                            
                            // Appointment type
                            DropdownButtonFormField<AppointmentType>(
                              decoration: const InputDecoration(
                                labelText: 'Appointment Type',
                                border: OutlineInputBorder(),
                              ),
                              value: _appointmentType,
                              items: AppointmentType.values.map((type) {
                                return DropdownMenuItem<AppointmentType>(
                                  value: type,
                                  child: Text(type.toString().split('.').last),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _appointmentType = value;
                                  });
                                }
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Date
                            TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Date',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Time
                            TextFormField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText: 'Time',
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.access_time),
                              ),
                              readOnly: true,
                              onTap: () => _selectTime(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Purpose
                            TextFormField(
                              controller: _purposeController,
                              decoration: const InputDecoration(
                                labelText: 'Purpose',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the purpose of this appointment';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Notes
                            TextFormField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Notes (Optional)',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    SizedBox(
                      width: double.infinity,
                      child: _isSaving
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _patientsList.isEmpty ? null : _createAppointment,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Create Appointment'),
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 