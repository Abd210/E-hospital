import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isEditing = false;
  late TabController _tabController;
  
  // Doctor data
  Doctor? _doctorData;
  List<Map<String, dynamic>> _patientsList = [];
  List<Map<String, dynamic>> _appointmentsList = [];
  List<Map<String, dynamic>> _scheduleList = [];
  
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _specializationController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _experienceController = TextEditingController();
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDoctorData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _specializationController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }
  
  Future<void> _loadDoctorData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get current user ID
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        setState(() {
          _isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not authenticated')),
          );
        }
        return;
      }
      
      // Get doctor data
      final doctor = await FirestoreService.getDoctorById(currentUserId);
      if (doctor != null && mounted) {
        setState(() {
          _doctorData = doctor;
          
          // Populate form controllers with doctor data
          _nameController.text = doctor.name;
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
        });
        
        // Load doctor's patients and appointments
        await Future.wait([
          _loadDoctorPatients(currentUserId),
          _loadDoctorAppointments(currentUserId),
          _loadDoctorSchedule(),
        ]);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Failed to load doctor profile')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading doctor data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
  
  Future<void> _loadDoctorPatients(String doctorId) async {
    try {
      final patients = await FirestoreService.getDoctorPatients(doctorId);
      if (mounted) {
        setState(() {
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
        });
      }
    } catch (e) {
      debugPrint('Error loading doctor patients: $e');
    }
  }
  
  Future<void> _loadDoctorAppointments(String doctorId) async {
    try {
      final appointments = await FirestoreService.getDoctorUpcomingAppointments(doctorId);
      if (mounted) {
        setState(() {
          _appointmentsList = appointments.map((appointment) => {
            'id': appointment.id,
            'Patient': appointment.patientName,
            'Date': appointment.appointmentDate,
            'Time': appointment.time,
            'Type': appointment.type.toString().split('.').last,
            'Status': appointment.status.toString().split('.').last,
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading doctor appointments: $e');
    }
  }
  
  Future<void> _loadDoctorSchedule() async {
    try {
      // Mock schedule data for now
      setState(() {
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
      });
    } catch (e) {
      debugPrint('Error loading doctor schedule: $e');
    }
  }
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final doctorId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (doctorId == null) {
        throw Exception('User not authenticated');
      }
      
      // Prepare doctor data
      final doctorData = {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'profile': {
          'specialization': _specializationController.text,
          'licenseNumber': _licenseNumberController.text,
          'experience': int.tryParse(_experienceController.text) ?? 0,
          'address': _addressController.text,
          'bio': _bioController.text,
          'lastUpdated': Timestamp.now(),
        },
      };
      
      // Update doctor data
      await FirestoreService.updateDoctor(doctorId, doctorData);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        
        // Refresh data
        await _loadDoctorData();
        
        // Exit edit mode
        setState(() {
          _isEditing = false;
        });
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
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
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildMobileLayout(),
        desktop: _buildDesktopLayout(),
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        actions: _buildAppBarActions(),
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentPath: '/medic/profile',
          userRole: 'medicalPersonnel',
          userName: _doctorData?.name ?? '',
          userEmail: _doctorData?.email ?? '',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        AppSidebar(
          currentPath: '/medic/profile',
          userRole: 'medicalPersonnel',
          userName: _doctorData?.name ?? '',
          userEmail: _doctorData?.email ?? '',
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Doctor Profile'),
              actions: _buildAppBarActions(),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
                  ),
          ),
        ),
      ],
    );
  }
  
  List<Widget> _buildAppBarActions() {
    return [
      if (!_isEditing)
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: 'Edit Profile',
          onPressed: () {
            setState(() {
              _isEditing = true;
            });
          },
        )
      else
        IconButton(
          icon: const Icon(Icons.save),
          tooltip: 'Save Profile',
          onPressed: _saveProfile,
        ),
      IconButton(
        icon: const Icon(Icons.refresh),
        tooltip: 'Refresh',
        onPressed: _loadDoctorData,
      ),
    ];
  }
  
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isEditing ? _buildEditForm() : _buildProfileInfo(),
          const SizedBox(height: 24),
          _buildTabSection(),
        ],
      ),
    );
  }
  
  Widget _buildProfileInfo() {
    if (_doctorData == null) {
      return const Center(child: Text('Doctor data not found'));
    }
    
    final profile = _doctorData!.profile as Map<String, dynamic>?;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 24),
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
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(_doctorData!.email),
                        ],
                      ),
                      if (_doctorData!.phone != null && _doctorData!.phone!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(_doctorData!.phone!),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            // Professional details
            if (profile != null) ...[
              const Text(
                'Professional Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.medical_services, 'Specialization', profile['specialization'] ?? 'Not specified'),
              _buildInfoRow(Icons.badge, 'License Number', profile['licenseNumber'] ?? 'Not specified'),
              _buildInfoRow(Icons.work, 'Experience', '${profile['experience'] ?? '0'} years'),
              if (profile['address'] != null && profile['address'].isNotEmpty)
                _buildInfoRow(Icons.location_on, 'Address', profile['address']),
              
              const SizedBox(height: 16),
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(profile['bio'] ?? 'No bio provided'),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildEditForm() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Professional Details',
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
                  prefixIcon: Icon(Icons.medical_services),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your specialization';
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
                    return 'Please enter your license number';
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your years of experience';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
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
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTabSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'My Patients'),
            Tab(text: 'Upcoming Appointments'),
            Tab(text: 'Schedule'),
          ],
        ),
        SizedBox(
          height: 500,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPatientsTab(),
              _buildAppointmentsTab(),
              _buildScheduleTab(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPatientsTab() {
    if (_patientsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No patients assigned',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have no patients assigned to you yet',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Patients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _patientsList.length,
              itemBuilder: (context, index) {
                final patient = _patientsList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondary.withOpacity(0.2),
                      child: const Icon(Icons.person, color: AppColors.secondary),
                    ),
                    title: Text(patient['Name'] as String),
                    subtitle: Text('${patient['Age']} years, ${patient['Gender']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/medic/records',
                          arguments: {'patientId': patient['id']},
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/medic/records',
                        arguments: {'patientId': patient['id']},
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAppointmentsTab() {
    if (_appointmentsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No upcoming appointments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have no scheduled appointments',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Appointments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _appointmentsList.length,
              itemBuilder: (context, index) {
                final appointment = _appointmentsList[index];
                final date = appointment['Date'] as DateTime;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: const Icon(Icons.calendar_today, color: AppColors.primary),
                    ),
                    title: Text(appointment['Patient'] as String),
                    subtitle: Text('${DateFormat('MMM dd, yyyy').format(date)}, ${appointment['Time']}'),
                    trailing: Chip(
                      label: Text(
                        appointment['Status'] as String,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: _getStatusColor(appointment['Status'] as String),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/medic/appointments/view/${appointment['id']}',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScheduleTab() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Implement schedule editing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Schedule editing will be available soon')),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Schedule'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _scheduleList.length,
                itemBuilder: (context, index) {
                  final schedule = _scheduleList[index];
                  return Card(
                    color: _getScheduleColor(schedule['Status'] as String),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(schedule['Day'] as String),
                      subtitle: schedule['Status'] == 'Unavailable'
                          ? const Text('Not Available')
                          : Text('${schedule['StartTime']} - ${schedule['EndTime']}'),
                      trailing: Chip(
                        label: Text(
                          schedule['Status'] as String,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        backgroundColor: _getStatusColor(schedule['Status'] as String),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 120,
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
  
  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SCHEDULED':
      case 'AVAILABLE':
        return Colors.green;
      case 'COMPLETED':
        return Colors.blue;
      case 'CANCELLED':
      case 'UNAVAILABLE':
        return Colors.red;
      case 'PENDING':
      case 'LIMITED':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  Color _getScheduleColor(String status) {
    switch (status.toUpperCase()) {
      case 'AVAILABLE':
        return Colors.green.withOpacity(0.1);
      case 'LIMITED':
        return Colors.orange.withOpacity(0.1);
      case 'UNAVAILABLE':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }
} 