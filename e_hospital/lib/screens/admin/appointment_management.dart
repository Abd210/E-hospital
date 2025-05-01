import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/appointment.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentManagement extends StatefulWidget {
  final String? appointmentId;
  final String action; // 'view', 'add', 'edit'
  final Map<String, dynamic>? initialData;
  
  const AppointmentManagement({
    Key? key, 
    this.appointmentId,
    required this.action,
    this.initialData,
  }) : super(key: key);

  @override
  State<AppointmentManagement> createState() => _AppointmentManagementState();
}

class _AppointmentManagementState extends State<AppointmentManagement> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  String _selectedType = 'ROUTINE';
  String _selectedStatus = 'SCHEDULED';
  String? _selectedDoctorId;
  String? _selectedPatientId;
  final _notesController = TextEditingController();
  
  // Data
  late DateTime _selectedDate;
  Appointment? _appointmentData;
  List<Map<String, dynamic>> _doctorsList = [];
  List<Map<String, dynamic>> _patientsList = [];
  
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadInitialData();
  }
  
  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load doctors list
      final doctors = await FirestoreService.getAllDoctors();
      _doctorsList = doctors.map((doctor) {
        final profile = doctor.profile as Map<String, dynamic>?;
        return {
          'id': doctor.id,
          'name': doctor.name,
          'specialization': profile?['specialization'] ?? 'General',
        };
      }).toList();
      
      // Load patients list
      final patients = await FirestoreService.getAllPatients();
      _patientsList = patients.map((patient) {
        return {
          'id': patient.id,
          'name': patient.name,
        };
      }).toList();
      
      // If editing or viewing existing appointment, load it
      if (widget.action != 'add' && widget.appointmentId != null) {
        await _loadAppointmentData();
      } else if (widget.action == 'add' && widget.initialData != null) {
        // Set initial data for new appointment
        if (widget.initialData!.containsKey('patientId')) {
          _selectedPatientId = widget.initialData!['patientId'];
        }
        if (widget.initialData!.containsKey('doctorId')) {
          _selectedDoctorId = widget.initialData!['doctorId'];
        }
      }
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadAppointmentData() async {
    try {
      final appointment = await FirestoreService.getAppointmentById(widget.appointmentId!);
      if (appointment != null && mounted) {
        setState(() {
          _appointmentData = appointment;
          
          // Set form data
          _selectedDoctorId = appointment.doctorId;
          _selectedPatientId = appointment.patientId;
          _selectedDate = appointment.appointmentDate;
          _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
          _timeController.text = appointment.time;
          _selectedType = appointment.type.toString().split('.').last;
          _selectedStatus = appointment.status.toString().split('.').last;
          _notesController.text = appointment.notes ?? '';
        });
      }
    } catch (e) {
      debugPrint('Error loading appointment data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading appointment data: $e')),
        );
      }
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
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
        _timeController.text = '${picked.hour}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }
  
  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a doctor')),
      );
      return;
    }
    
    if (_selectedPatientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a patient')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get names for doctor and patient
      String doctorName = '';
      String patientName = '';
      
      for (var doctor in _doctorsList) {
        if (doctor['id'] == _selectedDoctorId) {
          doctorName = doctor['name'];
          break;
        }
      }
      
      for (var patient in _patientsList) {
        if (patient['id'] == _selectedPatientId) {
          patientName = patient['name'];
          break;
        }
      }
      
      // Prepare appointment data - used for display purposes
      final appointmentData = {
        'doctorId': _selectedDoctorId,
        'doctorName': doctorName,
        'patientId': _selectedPatientId,
        'patientName': patientName,
        'appointmentDate': _selectedDate,
        'time': _timeController.text,
        'type': _selectedType.toLowerCase(),
        'status': _selectedStatus.toLowerCase(),
        'notes': _notesController.text,
        'purpose': 'General appointment',
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      };
      
      if (widget.action == 'add') {
        // Create new appointment
        await FirestoreService.createAppointment(Appointment.fromJson({
          'id': '',
          'doctorId': _selectedDoctorId!,
          'doctorName': doctorName,
          'patientId': _selectedPatientId!,
          'patientName': patientName,
          'appointmentDate': _selectedDate.toIso8601String(),
          'time': _timeController.text,
          'purpose': 'General appointment',
          'type': _selectedType.toLowerCase(),
          'status': _selectedStatus.toLowerCase(),
          'notes': _notesController.text
        }));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment created successfully')),
          );
          Navigator.pushReplacementNamed(context, '/admin/appointments');
        }
      } else if (widget.action == 'edit') {
        // Create an Appointment object with the appointment ID
        final appointmentToUpdate = Appointment(
          id: widget.appointmentId!,
          doctorId: _selectedDoctorId!,
          doctorName: doctorName,
          patientId: _selectedPatientId!,
          patientName: patientName,
          appointmentDate: _selectedDate,
          time: _timeController.text,
          purpose: 'General appointment',
          type: AppointmentType.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == _selectedType.toLowerCase(),
            orElse: () => AppointmentType.checkup,
          ),
          status: AppointmentStatus.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() == _selectedStatus.toLowerCase(),
            orElse: () => AppointmentStatus.scheduled,
          ),
          notes: _notesController.text,
        );
        
        // Update existing appointment
        await FirestoreService.updateAppointment(appointmentToUpdate);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Appointment updated successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Error saving appointment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving appointment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _deleteAppointment() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Appointment'),
          content: const Text('Are you sure you want to delete this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirestoreService.deleteAppointment(widget.appointmentId!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appointment deleted successfully')),
                    );
                    Navigator.pushReplacementNamed(context, '/admin/appointments');
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting appointment: $e')),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: _buildAppBarActions(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ResponsiveLayout(
                mobile: _buildContent(),
                desktop: _buildContent(maxWidth: 800),
              ),
            ),
    );
  }
  
  String _getTitle() {
    switch (widget.action) {
      case 'add':
        return 'Create New Appointment';
      case 'edit':
        return 'Edit Appointment';
      case 'view':
        return 'Appointment Details';
      default:
        return 'Appointment Management';
    }
  }
  
  List<Widget> _buildAppBarActions() {
    List<Widget> actions = [];
    
    if (widget.action == 'view') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context, 
              '/admin/appointments/edit/${widget.appointmentId}',
            );
          },
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteAppointment,
        ),
      );
    } else if (widget.action == 'edit' || widget.action == 'add') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveAppointment,
        ),
      );
    }
    
    return actions;
  }
  
  Widget _buildContent({double? maxWidth}) {
    if (widget.action == 'view') {
      return _buildViewContent(maxWidth: maxWidth);
    } else {
      return _buildForm(maxWidth: maxWidth);
    }
  }
  
  Widget _buildViewContent({double? maxWidth}) {
    if (_appointmentData == null) {
      return const Center(child: Text('Appointment data not found'));
    }
    
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_appointmentData!.type.toString().split('.').last} Appointment',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('EEEE, MMMM d, yyyy').format(_appointmentData!.appointmentDate),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Time: ${_appointmentData!.time}',
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Chip(
                            label: Text(
                              _appointmentData!.status.toString().split('.').last,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: _getStatusColor(_appointmentData!.status.toString().split('.').last),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                _buildDetailRow('Doctor', _appointmentData!.doctorName),
                _buildDetailRow('Patient', _appointmentData!.patientName),
                if (_appointmentData!.notes != null && _appointmentData!.notes!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Notes:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_appointmentData!.notes!),
                ],
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text('View Patient'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context, 
                          '/admin/patients/view/${_appointmentData!.patientId}',
                        );
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.medical_services),
                      label: const Text('View Doctor'),
                      onPressed: () {
                        Navigator.pushNamed(
                          context, 
                          '/admin/doctors/view/${_appointmentData!.doctorId}',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildForm({double? maxWidth}) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Appointment Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDropdownField(
                        label: 'Doctor',
                        value: _selectedDoctorId,
                        items: _doctorsList.map((doctor) {
                          return DropdownMenuItem(
                            value: doctor['id'],
                            child: Text('Dr. ${doctor['name']} (${doctor['specialization']})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDoctorId = value as String?;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownField(
                        label: 'Patient',
                        value: _selectedPatientId,
                        items: _patientsList.map((patient) {
                          return DropdownMenuItem(
                            value: patient['id'],
                            child: Text(patient['name']),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPatientId = value as String?;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: InputDecoration(
                                labelText: 'Date',
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_month),
                                  onPressed: () => _selectDate(context),
                                ),
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
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _timeController,
                              decoration: InputDecoration(
                                labelText: 'Time',
                                prefixIcon: const Icon(Icons.access_time),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.schedule),
                                  onPressed: () => _selectTime(context),
                                ),
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Appointment Type',
                              value: _selectedType,
                              items: ['ROUTINE', 'FOLLOW_UP', 'URGENT', 'CONSULTATION'].map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type.replaceAll('_', ' ')),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedType = value as String;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownField(
                              label: 'Status',
                              value: _selectedStatus,
                              items: ['SCHEDULED', 'COMPLETED', 'CANCELLED', 'PENDING'].map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Text(status),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value as String;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          prefixIcon: Icon(Icons.note),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(widget.action == 'add' ? 'Create Appointment' : 'Update Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                onPressed: _saveAppointment,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDropdownField({
    required String label,
    required dynamic value,
    required List<DropdownMenuItem<dynamic>> items,
    required Function(dynamic) onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: value,
          isExpanded: true,
          hint: Text('Select $label'),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
        return Colors.blue;
      case 'COMPLETED':
        return Colors.green;
      case 'CANCELLED':
        return Colors.red;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 