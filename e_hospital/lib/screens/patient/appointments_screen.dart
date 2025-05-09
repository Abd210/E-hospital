import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/appointment_model.dart';
import 'package:e_hospital/models/user_model.dart';
import 'package:e_hospital/theme/app_theme.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({Key? key}) : super(key: key);

  @override
  State<PatientAppointmentsScreen> createState() => _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  final _dateFormat = DateFormat('MMM d, yyyy');
  
  // Current user data
  String _patientId = '';
  String _patientName = '';
  
  // Appointment data
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];
  
  // Doctor data
  List<User> _assignedDoctors = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get current user ID
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      
      _patientId = currentUser.uid;
      
      // Get patient info
      final user = await FirestoreService.getUserById(_patientId);
      if (user != null) {
        _patientName = user.name;
      }
      
      // Get assigned doctors
      _assignedDoctors = await FirestoreService.getPatientDoctors(_patientId);
      
      // Get all appointments
      final appointments = await FirestoreService.getPatientAppointments(_patientId);
      
      // Split into upcoming and past
      final now = DateTime.now();
      
      _upcomingAppointments = appointments
          .where((appointment) => appointment.appointmentDate.isAfter(now))
          .toList()
        ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
      
      _pastAppointments = appointments
          .where((appointment) => appointment.appointmentDate.isBefore(now))
          .toList()
        ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
      
    } catch (e) {
      debugPrint('Error loading appointments data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _bookAppointment() async {
    // If no assigned doctors, show error
    if (_assignedDoctors.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have no assigned doctors to book appointments with')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) => _AppointmentDialog(
        patientId: _patientId,
        patientName: _patientName,
        assignedDoctors: _assignedDoctors,
        onAppointmentAdded: () {
          // Reload data after appointment added
          _loadData();
        },
      ),
    );
  }
  
  Future<void> _cancelAppointment(Appointment appointment) async {
    // Only allow cancellation if not within 24 hours
    final now = DateTime.now();
    final difference = appointment.appointmentDate.difference(now).inHours;
    
    if (difference < 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot cancel appointments within 24 hours')),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: const Text('Are you sure you want to cancel this appointment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                setState(() {
                  _isLoading = true;
                });
                
                try {
                  final updatedAppointment = appointment.copyWith(
                    status: AppointmentStatus.cancelled,
                  );
                  
                  await FirestoreService.updateAppointment(updatedAppointment);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment cancelled successfully')),
                  );
                  
                  // Reload data
                  _loadData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error cancelling appointment: $e')),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              },
              child: const Text('Yes', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  Future<void> _viewAppointmentDetails(Appointment appointment) async {
    // Get doctor details
    final doctor = await FirestoreService.getUserById(appointment.doctorId);
    
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${appointment.type.toString().split('.').last} Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('Doctor', appointment.doctorName),
                if (doctor != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            doctor.name.substring(0, 1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                doctor.profile != null 
                                    ? doctor.profile!['specialization'] ?? 'General' 
                                    : 'General',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                ),
                              ),
                              if (doctor.profile != null &&
                                  doctor.profile!['phoneNumber'] != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Phone: ${doctor.profile!['phoneNumber']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                _buildInfoRow('Date', _dateFormat.format(appointment.appointmentDate)),
                _buildInfoRow('Time', appointment.time),
                _buildInfoRow('Status', appointment.status.toString().split('.').last),
                _buildInfoRow('Purpose', appointment.purpose),
                if (appointment.notes != null && appointment.notes!.isNotEmpty)
                  _buildInfoRow('Notes', appointment.notes!),
                if (appointment.location != null && appointment.location!.isNotEmpty)
                  _buildInfoRow('Location', appointment.location!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            if (appointment.status == AppointmentStatus.scheduled ||
                appointment.status == AppointmentStatus.confirmed)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cancelAppointment(appointment);
                },
                child: const Text('Cancel Appointment', style: TextStyle(color: Colors.red)),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildContent(isMobile: true),
      tablet: _buildContent(isMobile: false),
      desktop: Row(
        children: [
          AppSidebar(
            currentPath: '/patient/appointments',
            userRole: 'patient',
            userName: _patientName,
          ),
          Expanded(
            child: _buildContent(isMobile: false),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent({required bool isMobile}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      drawer: isMobile ? Drawer(
        child: AppSidebar(
          currentPath: '/patient/appointments',
          userRole: 'patient',
          userName: _patientName,
        ),
      ) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: _bookAppointment,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentsList(_upcomingAppointments),
                _buildAppointmentsList(_pastAppointments),
              ],
            ),
    );
  }
  
  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text('No appointments found'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              'Dr. ${appointment.doctorName.split(' ').last}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 8),
                    Text(_dateFormat.format(appointment.appointmentDate)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 8),
                    Text(appointment.time),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, size: 16),
                    const SizedBox(width: 8),
                    Text('${appointment.type.toString().split('.').last} - ${appointment.purpose}'),
                  ],
                ),
                const SizedBox(height: 8),
                Chip(
                  label: Text(
                    appointment.status.toString().split('.').last,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  backgroundColor: _getStatusColor(appointment.status),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => _viewAppointmentDetails(appointment),
            ),
            onTap: () => _viewAppointmentDetails(appointment),
          ),
        );
      },
    );
  }
  
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.inProgress:
        return Colors.orange;
      case AppointmentStatus.completed:
        return Colors.teal;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return Colors.deepPurple;
      case AppointmentStatus.rescheduled:
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}

class _AppointmentDialog extends StatefulWidget {
  final String patientId;
  final String patientName;
  final List<User> assignedDoctors;
  final VoidCallback onAppointmentAdded;
  
  const _AppointmentDialog({
    Key? key,
    required this.patientId,
    required this.patientName,
    required this.assignedDoctors,
    required this.onAppointmentAdded,
  }) : super(key: key);

  @override
  State<_AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends State<_AppointmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _purposeController = TextEditingController();
  final _notesController = TextEditingController();
  
  User? _selectedDoctor;
  AppointmentType _appointmentType = AppointmentType.checkup;
  late DateTime _selectedDate;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    
    // Default to first doctor if available
    if (widget.assignedDoctors.isNotEmpty) {
      _selectedDoctor = widget.assignedDoctors.first;
    }
  }
  
  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
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
  
  Future<void> _saveAppointment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedDoctor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a doctor')),
      );
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Check if the doctor is available at the selected date and time
      final isDoctorAvailable = await FirestoreService.isDoctorAvailable(
        _selectedDoctor!.id,
        _selectedDate,
        _timeController.text,
      );
      
      if (!isDoctorAvailable) {
        if (mounted) {
          setState(() => _isLoading = false);
          
          // Get all existing appointment times for this doctor on the selected date
          final bookedTimes = await FirestoreService.getDoctorAppointmentTimes(
            _selectedDoctor!.id,
            _selectedDate,
          );
          
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Schedule Conflict'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. ${_selectedDoctor!.name} is not available at this time.'),
                  const SizedBox(height: 8),
                  if (bookedTimes.isNotEmpty) ...[
                    const Text('Already booked times on this date:'),
                    const SizedBox(height: 4),
                    ...bookedTimes.map((time) => Text('• $time')).take(5),
                    if (bookedTimes.length > 5) 
                      Text('... and ${bookedTimes.length - 5} more'),
                  ],
                  const SizedBox(height: 8),
                  const Text('Please select another date or time.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }
      
      // Create appointment
      final appointment = Appointment(
        id: '',
        patientId: widget.patientId,
        patientName: widget.patientName,
        doctorId: _selectedDoctor!.id,
        doctorName: _selectedDoctor!.name,
        doctorSpecialty: _selectedDoctor!.profile != null 
            ? _selectedDoctor!.profile!['specialization'] 
            : null,
        appointmentDate: _selectedDate,
        time: _timeController.text,
        purpose: _purposeController.text,
        type: _appointmentType,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );
      
      await FirestoreService.createAppointment(appointment);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment booked successfully')),
        );
        
        Navigator.of(context).pop();
        widget.onAppointmentAdded();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error booking appointment: $e')),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Book Appointment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Doctor dropdown
              DropdownButtonFormField<User>(
                decoration: const InputDecoration(
                  labelText: 'Select Doctor',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDoctor,
                items: widget.assignedDoctors.map((doctor) {
                  final specialization = doctor.profile != null 
                      ? doctor.profile!['specialization'] ?? 'General' 
                      : 'General';
                  
                  return DropdownMenuItem<User>(
                    value: doctor,
                    child: Text('Dr. ${doctor.name} ($specialization)'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a doctor';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Appointment type
              DropdownButtonFormField<AppointmentType>(
                decoration: const InputDecoration(
                  labelText: 'Appointment Type',
                  border: OutlineInputBorder(),
                ),
                value: _appointmentType,
                items: AppointmentType.values.map((type) {
                  // Create a more user-friendly display name
                  final String displayName = _getAppointmentTypeDisplayName(type);
                  return DropdownMenuItem<AppointmentType>(
                    value: type,
                    child: Text(displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _appointmentType = value;
                    });
                  }
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select an appointment type';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Date field
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Time field
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Purpose field
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the purpose of your appointment';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Notes field
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: _saveAppointment,
                child: const Text('Book Appointment'),
              ),
      ],
    );
  }

  String _getAppointmentTypeDisplayName(AppointmentType type) {
    switch (type) {
      case AppointmentType.checkup:
        return 'Checkup';
      case AppointmentType.followUp:
        return 'Follow-Up';
      case AppointmentType.consultation:
        return 'Consultation';
      case AppointmentType.emergency:
        return 'Emergency';
      case AppointmentType.procedure:
        return 'Procedure';
      case AppointmentType.surgery:
        return 'Surgery';
      case AppointmentType.vaccination:
        return 'Vaccination';
      case AppointmentType.test:
        return 'Test';
      case AppointmentType.therapy:
        return 'Therapy';
      default:
        return type.toString().split('.').last;
    }
  }
} 