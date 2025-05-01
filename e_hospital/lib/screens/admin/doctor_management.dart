import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/doctor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorManagement extends StatefulWidget {
  final String? doctorId;
  final String action; // 'view', 'add', 'edit'
  
  const DoctorManagement({
    Key? key, 
    this.doctorId,
    required this.action,
  }) : super(key: key);

  @override
  State<DoctorManagement> createState() => _DoctorManagementState();
}

class _DoctorManagementState extends State<DoctorManagement> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Doctor data
  Doctor? _doctorData;
  List<Map<String, dynamic>> _patientsList = [];
  List<Map<String, dynamic>> _appointmentsList = [];
  List<Map<String, dynamic>> _scheduleList = [];
  
  @override
  void initState() {
    super.initState();
    if (widget.action != 'add' && widget.doctorId != null) {
      _loadDoctorData();
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  Future<void> _loadDoctorData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get doctor data
      final doctor = await FirestoreService.getDoctorById(widget.doctorId!);
      if (doctor != null) {
        setState(() {
          _doctorData = doctor;
          
          // Populate form controllers with doctor data
          _nameController.text = doctor.name;
          _emailController.text = doctor.email;
          _phoneController.text = doctor.phone ?? '';
          
          // Profile data
          final profile = doctor.profile as Map<String, dynamic>?;
          if (profile != null) {
            _specializationController.text = profile['specialization'] ?? '';
            _licenseNumberController.text = profile['licenseNumber'] ?? '';
            _experienceController.text = (profile['experience'] ?? '').toString();
            _addressController.text = profile['address'] ?? '';
            _bioController.text = profile['bio'] ?? '';
          }
          
          // Load doctor's patients
          _loadDoctorPatients();
          
          // Load doctor's appointments
          _loadDoctorAppointments();
          
          // Load doctor's schedule
          _loadDoctorSchedule();
        });
      }
    } catch (e) {
      debugPrint('Error loading doctor data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading doctor data: $e')),
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
  
  Future<void> _loadDoctorPatients() async {
    try {
      final patients = await FirestoreService.getDoctorPatients(widget.doctorId!);
      _patientsList = patients.map((patient) {
        return {
          'id': patient.id,
          'Name': patient.name,
          'Email': patient.email,
          'Phone': patient.phone ?? 'N/A',
          'Age': patient.age.toString(),
          'Gender': patient.gender,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading doctor patients: $e');
    }
  }
  
  Future<void> _loadDoctorAppointments() async {
    try {
      final appointments = await FirestoreService.getDoctorUpcomingAppointments(widget.doctorId!);
      _appointmentsList = appointments.map((appointment) => {
        'id': appointment.id,
        'Patient': appointment.patientName,
        'Date': appointment.appointmentDate,
        'Time': appointment.time,
        'Type': appointment.type.toString().split('.').last,
        'Status': appointment.status.toString().split('.').last,
      }).toList();
    } catch (e) {
      debugPrint('Error loading doctor appointments: $e');
    }
  }
  
  Future<void> _loadDoctorSchedule() async {
    try {
      // Mock schedule data
      _scheduleList = [
        {
          'Day': 'Monday',
          'StartTime': '09:00 AM',
          'EndTime': '05:00 PM',
          'Status': 'Available',
        },
        {
          'Day': 'Tuesday',
          'StartTime': '09:00 AM',
          'EndTime': '05:00 PM',
          'Status': 'Available',
        },
        {
          'Day': 'Wednesday',
          'StartTime': '10:00 AM',
          'EndTime': '06:00 PM',
          'Status': 'Available',
        },
        {
          'Day': 'Thursday',
          'StartTime': '09:00 AM',
          'EndTime': '05:00 PM',
          'Status': 'Available',
        },
        {
          'Day': 'Friday',
          'StartTime': '09:00 AM',
          'EndTime': '03:00 PM',
          'Status': 'Available',
        },
        {
          'Day': 'Saturday',
          'StartTime': '10:00 AM',
          'EndTime': '02:00 PM',
          'Status': 'Limited',
        },
        {
          'Day': 'Sunday',
          'StartTime': 'N/A',
          'EndTime': 'N/A',
          'Status': 'Unavailable',
        },
      ];
    } catch (e) {
      debugPrint('Error loading doctor schedule: $e');
    }
  }
  
  Future<void> _saveDoctor() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Prepare doctor data
      final doctorData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role': 'medicalPersonnel',
        'profile': {
          'specialization': _specializationController.text,
          'licenseNumber': _licenseNumberController.text,
          'experience': int.tryParse(_experienceController.text) ?? 0,
          'address': _addressController.text,
          'bio': _bioController.text,
          'patientCount': _doctorData?.profile?['patientCount'] ?? 0,
          'lastUpdated': Timestamp.now(),
        },
        'assignedPatientIds': _doctorData?.assignedPatientIds ?? [],
      };
      
      if (widget.action == 'add') {
        // Create new doctor with authentication
        final password = _passwordController.text;
        final result = await FirestoreService.createDoctorWithAuth(doctorData, password);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          
          if (result['success']) {
            Navigator.pushReplacementNamed(context, '/admin/doctors');
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else if (widget.action == 'edit') {
        // Update existing doctor - no need to update authentication
        await FirestoreService.updateDoctor(widget.doctorId!, doctorData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Doctor updated successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving doctor: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _deleteDoctor() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Doctor'),
          content: Text('Are you sure you want to delete ${_doctorData?.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirestoreService.deleteDoctor(widget.doctorId!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Doctor deleted successfully')),
                    );
                    Navigator.pushReplacementNamed(context, '/admin/doctors');
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting doctor: $e')),
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
  
  // Add this method to handle patient assignment
  Future<void> _assignPatient() async {
    // List of available patients
    List<Map<String, dynamic>> allPatients = [];
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get all patients
      final patients = await FirestoreService.getAllPatients();
      allPatients = patients.map((patient) => {
        'id': patient.id,
        'name': patient.name,
        'email': patient.email,
      }).toList();
      
      // Filter out patients already assigned to this doctor
      allPatients = allPatients.where((patient) => 
        !_patientsList.any((assigned) => assigned['id'] == patient['id'])
      ).toList();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        if (allPatients.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No more patients available to assign')),
          );
          return;
        }
        
        // Show dialog with patient selection
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Assign Patient'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: allPatients.length,
                itemBuilder: (context, index) {
                  final patient = allPatients[index];
                  return ListTile(
                    title: Text(patient['name']),
                    subtitle: Text(patient['email']),
                    onTap: () async {
                      Navigator.of(context).pop();
                      await _confirmAssignPatient(patient);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error loading patients: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patients: $e')),
        );
      }
    }
  }
  
  // Method to confirm and execute patient assignment
  Future<void> _confirmAssignPatient(Map<String, dynamic> patient) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // Assign patient to doctor
      await FirestoreService.assignPatientToDoctor(patient['id'], widget.doctorId!);
      
      // Reload doctor's patients
      await _loadDoctorPatients();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ${patient['name']} assigned successfully')),
        );
      }
    } catch (e) {
      debugPrint('Error assigning patient: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error assigning patient: $e')),
        );
      }
    }
  }
  
  // Add a method to handle patient removal
  Future<void> _removePatientAssignment(Map<String, dynamic> patient) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // Remove patient from doctor
      await FirestoreService.removePatientFromDoctor(patient['id'], widget.doctorId!);
      
      // Reload doctor's patients
      await _loadDoctorPatients();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Patient ${patient['Name']} removed successfully')),
        );
      }
    } catch (e) {
      debugPrint('Error removing patient: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing patient: $e')),
        );
      }
    }
  }
  
  // Add a new method for schedule editing
  Future<void> _editSchedule() async {
    // Show a dialog with schedule editing form
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Create temporary schedule data that can be modified
        List<Map<String, dynamic>> tempSchedule = List.from(_scheduleList);
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Doctor Schedule'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: ListView.builder(
                  itemCount: tempSchedule.length,
                  itemBuilder: (context, index) {
                    final schedule = tempSchedule[index];
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule['Day'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      labelText: 'Status',
                                      border: OutlineInputBorder(),
                                    ),
                                    value: schedule['Status'],
                                    items: ['Available', 'Limited', 'Unavailable']
                                        .map((status) => DropdownMenuItem(
                                              value: status,
                                              child: Text(status),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        schedule['Status'] = value;
                                        
                                        // Update time fields based on status
                                        if (value == 'Unavailable') {
                                          schedule['StartTime'] = 'N/A';
                                          schedule['EndTime'] = 'N/A';
                                        } else if (value == 'Available' && schedule['StartTime'] == 'N/A') {
                                          schedule['StartTime'] = '09:00 AM';
                                          schedule['EndTime'] = '05:00 PM';
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (schedule['Status'] != 'Unavailable')
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Start Time',
                                        border: OutlineInputBorder(),
                                      ),
                                      initialValue: schedule['StartTime'],
                                      onChanged: (value) {
                                        setState(() {
                                          schedule['StartTime'] = value;
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'End Time',
                                        border: OutlineInputBorder(),
                                      ),
                                      initialValue: schedule['EndTime'],
                                      onChanged: (value) {
                                        setState(() {
                                          schedule['EndTime'] = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Save the updated schedule
                    setState(() {
                      _scheduleList = tempSchedule;
                    });
                    Navigator.of(context).pop();
                    
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Schedule updated successfully')),
                      );
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  
  // Add a new function to show assigned patients in a dialog
  void _viewAssignedPatients() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assigned Patients'),
          content: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: _patientsList.isEmpty
                ? const Center(child: Text('No patients assigned to this doctor'))
                : SingleChildScrollView(
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Age')),
                        DataColumn(label: Text('Gender')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _patientsList.map((patient) {
                        return DataRow(
                          cells: [
                            DataCell(Text(patient['Name'])),
                            DataCell(Text(patient['Email'])),
                            DataCell(Text(patient['Phone'])),
                            DataCell(Text(patient['Age'])),
                            DataCell(Text(patient['Gender'])),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_red_eye),
                                    tooltip: 'View Patient',
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                      Navigator.pushNamed(
                                        context, 
                                        '/admin/patients/view/${patient['id']}',
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.person_remove),
                                    tooltip: 'Remove Assignment',
                                    onPressed: () {
                                      Navigator.pop(context); // Close the dialog
                                      _removePatientAssignment(patient);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _assignPatient();
              },
              child: const Text('Assign New Patient'),
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
                mobile: _buildMobileContent(),
                desktop: _buildDesktopContent(),
              ),
            ),
    );
  }
  
  String _getTitle() {
    switch (widget.action) {
      case 'add':
        return 'Add New Doctor';
      case 'edit':
        return 'Edit Doctor';
      case 'view':
        return 'Doctor Details';
      default:
        return 'Doctor Management';
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
              '/admin/doctors/edit/${widget.doctorId}',
            );
          },
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deleteDoctor,
        ),
      );
    } else if (widget.action == 'edit' || widget.action == 'add') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveDoctor,
        ),
      );
    }
    
    return actions;
  }
  
  Widget _buildMobileContent() {
    if (widget.action == 'view') {
      return _buildViewContent();
    } else {
      return _buildForm();
    }
  }
  
  Widget _buildDesktopContent() {
    if (widget.action == 'view') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: _buildViewContent(),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: _buildSidebarContent(),
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _buildForm(),
          ),
        ],
      );
    }
  }
  
  Widget _buildViewContent() {
    if (_doctorData == null) {
      return const Center(child: Text('Doctor data not found'));
    }
    
    final profile = _doctorData!.profile as Map<String, dynamic>?;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dr. ${_doctorData!.name}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile?['specialization'] ?? 'General Practitioner',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'License: ${profile?['licenseNumber'] ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Experience: ${profile?['experience'] ?? '0'} years',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.email, 'Email', _doctorData!.email),
                _buildInfoRow(Icons.phone, 'Phone', _doctorData!.phone ?? 'Not provided'),
                _buildInfoRow(Icons.location_on, 'Address', profile?['address'] ?? 'Not provided'),
                const SizedBox(height: 16),
                const Text(
                  'Bio',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  profile?['bio'] ?? 'No bio provided',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Doctor Schedule',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildScheduleTable(),
      ],
    );
  }
  
  Widget _buildSidebarContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Doctor Statistics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildStatItem('Total Patients', '${_patientsList.length}'),
                _buildStatItem('Appointments (This Month)', '${_appointmentsList.length}'),
                _buildStatItem('Rating', '4.8/5'),
                _buildStatItem('Success Rate', '95%'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Doctor'),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context, 
                      '/admin/doctors/edit/${widget.doctorId}',
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete Doctor'),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                  onTap: _deleteDoctor,
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Edit Schedule'),
                  onTap: _editSchedule,
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('View Assigned Patients'),
                  onTap: _viewAssignedPatients,
                ),
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Assign Patient'),
                  onTap: _assignPatient,
                ),
                ListTile(
                  leading: const Icon(Icons.add_circle),
                  title: const Text('Create Test Appointments'),
                  textColor: Colors.orange,
                  iconColor: Colors.orange,
                  onTap: () async {
                    // Show a dialog to select a patient for the appointments
                    final patients = await FirestoreService.getAllPatients();
                    if (patients.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No patients found')),
                      );
                      return;
                    }
                    
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Select a Patient for Test Appointments'),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: 300,
                            child: ListView.builder(
                              itemCount: patients.length,
                              itemBuilder: (context, index) {
                                final patient = patients[index];
                                return ListTile(
                                  title: Text(patient.name),
                                  subtitle: Text(patient.email),
                                  onTap: () async {
                                    Navigator.pop(context);
                                    
                                    // Show loading indicator
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(child: CircularProgressIndicator()),
                                    );
                                    
                                    try {
                                      // Create sample appointments
                                      await FirestoreService.createSampleAppointments(widget.doctorId!, patient.id);
                                      
                                      if (context.mounted) {
                                        // Hide loading indicator
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Sample appointments created with ${patient.name}')),
                                        );
                                        
                                        // Reload doctor data
                                        _loadDoctorData();
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        // Hide loading indicator
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error creating appointments: $e')),
                                        );
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildScheduleTable() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Table(
          border: TableBorder.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Day',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Start Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'End Time',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ..._scheduleList.map((schedule) {
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(schedule['Day']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(schedule['StartTime']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(schedule['EndTime']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      schedule['Status'],
                      style: TextStyle(
                        color: schedule['Status'] == 'Available'
                            ? Colors.green
                            : schedule['Status'] == 'Limited'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Basic Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter doctor name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.action == 'add') 
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Professional Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specializationController,
                    decoration: const InputDecoration(
                      labelText: 'Specialization',
                      prefixIcon: Icon(Icons.local_hospital),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter specialization';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _licenseNumberController,
                    decoration: const InputDecoration(
                      labelText: 'License Number',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter license number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Years of Experience',
                      prefixIcon: Icon(Icons.work),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Professional Bio',
                      prefixIcon: Icon(Icons.description),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _saveDoctor,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: Text(
              widget.action == 'add' ? 'Create Doctor' : 'Update Doctor',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(
              label,
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
  
  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 