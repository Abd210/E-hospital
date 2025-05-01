import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/core/widgets/dashboard_card.dart';
import 'package:e_hospital/core/widgets/data_table_widget.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  final String? initialTab;
  
  const AdminDashboard({Key? key, this.initialTab}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isLoading = true;
  Map<String, dynamic> _dashboardData = {};
  List<Map<String, dynamic>> _recentAppointments = [];
  List<Map<String, dynamic>> _doctorsList = [];
  List<Map<String, dynamic>> _patientsList = [];
  late String _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab ?? '';
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get dashboard data
      _dashboardData = await FirestoreService.getAdminDashboardData();

      // Get recent appointments
      final appointments = await FirestoreService.getAllAppointments();
      _recentAppointments = appointments
          .take(5)
          .map((appointment) => {
                'id': appointment.id,
                'Patient': appointment.patientName,
                'Doctor': appointment.doctorName,
                'Date': appointment.appointmentDate,
                'Time': appointment.time,
                'Status': appointment.status.toString().split('.').last,
                'Type': appointment.type.toString().split('.').last,
              })
          .toList();

      // Get doctors
      final doctors = await FirestoreService.getAllDoctors();
      _doctorsList = doctors.map((doctor) {
        final profile = doctor.profile as Map<String, dynamic>?;
        return {
          'id': doctor.id,
          'Name': doctor.name,
          'Email': doctor.email,
          'Specialization': profile?['specialization'] ?? 'General',
          'Patients': profile?['patientCount'] ?? 0,
        };
      }).toList();

      // Get patients
      final patients = await FirestoreService.getAllPatients();
      _patientsList = patients
          .take(5)
          .map((patient) => {
                'id': patient.id,
                'Name': patient.name,
                'Email': patient.email,
                'Phone': patient.phone ?? 'N/A',
                'Condition': (patient.profile as Map<String, dynamic>?)?['medicalCondition'] ?? 'Healthy',
              })
          .toList();
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
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

  Widget _buildDesktopLayout() {
    // Use the current route for the sidebar
    final currentPath = '/admin${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
    return Row(
      children: [
        AppSidebar(
          currentPath: currentPath,
          userRole: 'hospitalAdmin',
          userName: 'Admin User',
          userEmail: 'admin@hospital.com',
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Text(_getPageTitle()),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notifications coming soon'))
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search coming soon'))
                    );
                  },
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildContent(),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final currentPath = '/admin${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getPageTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon'))
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentPath: currentPath,
          userRole: 'hospitalAdmin',
          userName: 'Admin User',
          userEmail: 'admin@hospital.com',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildContent(),
            ),
    );
  }

  String _getPageTitle() {
    switch (_currentTab) {
      case 'doctors':
        return 'Doctors Management';
      case 'patients':
        return 'Patients Management';
      case 'appointments':
        return 'Appointments Management';
      case 'settings':
        return 'Settings';
      default:
        return 'Admin Dashboard';
    }
  }

  Widget _buildContent() {
    switch (_currentTab) {
      case 'doctors':
        return _buildDoctorsSection();
      case 'patients':
        return _buildPatientsSection();
      case 'appointments':
        return _buildAppointmentsSection();
      case 'settings':
        return Center(child: Text('Settings page coming soon'));
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildTablesSection(),
          ],
        );
    }
  }

  Widget _buildDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Manage Doctors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Doctor'),
              onPressed: () {
                Navigator.pushNamed(context, '/admin/doctors/add');
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        DataTableWidget(
          columns: ['Name', 'Email', 'Specialization', 'Patients'],
          rows: _doctorsList,
          onRowTap: (row) {
            _showDoctorOptions(context, row);
          },
          onEdit: (row) {
            Navigator.pushNamed(context, '/admin/doctors/edit/${row['id']}');
          },
          onDelete: (row) {
            _showDeleteConfirmation(context, 'doctor', row['id'], row['Name']);
          },
          maxHeight: 600,
        ),
      ],
    );
  }

  Widget _buildPatientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Manage Patients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Patient'),
              onPressed: () {
                Navigator.pushNamed(context, '/admin/patients/add');
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        DataTableWidget(
          columns: ['Name', 'Email', 'Phone', 'Condition'],
          rows: _patientsList,
          onRowTap: (row) {
            _showPatientOptions(context, row);
          },
          onEdit: (row) {
            Navigator.pushNamed(context, '/admin/patients/edit/${row['id']}');
          },
          onDelete: (row) {
            _showDeleteConfirmation(context, 'patient', row['id'], row['Name']);
          },
          maxHeight: 600,
        ),
      ],
    );
  }

  Widget _buildAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Manage Appointments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Appointment'),
              onPressed: () {
                Navigator.pushNamed(context, '/admin/appointments/add');
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        DataTableWidget(
          columns: ['Patient', 'Doctor', 'Date', 'Time', 'Status', 'Type'],
          rows: _recentAppointments,
          onRowTap: (row) {
            Navigator.pushNamed(context, '/admin/appointments/view/${row['id']}');
          },
          onEdit: (row) {
            Navigator.pushNamed(context, '/admin/appointments/edit/${row['id']}');
          },
          onDelete: (row) {
            _showDeleteConfirmation(context, 'appointment', row['id'], '${row['Patient']} with ${row['Doctor']}');
          },
          maxHeight: 600,
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, String itemType, String id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $itemType'),
          content: Text('Are you sure you want to delete $itemType: $name?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  // Implement the deletion logic based on itemType
                  switch (itemType) {
                    case 'doctor':
                      await FirestoreService.deleteDoctor(id);
                      break;
                    case 'patient':
                      await FirestoreService.deletePatient(id);
                      break;
                    case 'appointment':
                      await FirestoreService.deleteAppointment(id);
                      break;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$itemType deleted successfully')),
                  );
                  _loadDashboardData(); // Refresh data
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting $itemType: $e')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to E-Hospital Admin Dashboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage your hospital data, doctors, patients, and appointments all in one place.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin/doctors');
                        },
                        child: const Text('Manage Doctors'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/admin/patients');
                        },
                        child: const Text('Manage Patients'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (ResponsiveLayout.isDesktop(context)) ...[
              const SizedBox(width: 40),
              Icon(
                Icons.local_hospital_rounded,
                size: 150,
                color: AppColors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final doctorCount = _dashboardData['doctorCount'] ?? 0;
    final patientCount = _dashboardData['patientCount'] ?? 0;
    final appointmentCount = _dashboardData['totalAppointments'] ?? 0;

    return GridView.count(
      crossAxisCount: ResponsiveLayout.isDesktop(context) ? 3 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardCard(
          title: 'Doctors',
          value: doctorCount.toString(),
          icon: Icons.medical_services_outlined,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          subtitle: '+3 new this month',
          showIncreaseIcon: true,
          onTap: () => Navigator.pushNamed(context, '/admin/doctors'),
        ),
        DashboardCard(
          title: 'Patients',
          value: patientCount.toString(),
          icon: Icons.people_outline,
          iconColor: AppColors.secondary,
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          subtitle: '+12 new this month',
          showIncreaseIcon: true,
          onTap: () => Navigator.pushNamed(context, '/admin/patients'),
        ),
        DashboardCard(
          title: 'Appointments',
          value: appointmentCount.toString(),
          icon: Icons.calendar_today_outlined,
          iconColor: Colors.purple,
          backgroundColor: Colors.purple.withOpacity(0.1),
          subtitle: '${_dashboardData['todayAppointments'] ?? 0} today',
          onTap: () => Navigator.pushNamed(context, '/admin/appointments'),
        ),
      ],
    );
  }

  Widget _buildTablesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Appointments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/admin/appointments'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DataTableWidget(
          columns: ['Patient', 'Doctor', 'Date', 'Time', 'Status', 'Type'],
          rows: _recentAppointments,
          onRowTap: (row) {
            Navigator.pushNamed(context, '/admin/appointments/view/${row['id']}');
          },
          maxHeight: 300,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Doctors',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/admin/doctors'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DataTableWidget(
          columns: ['Name', 'Email', 'Specialization', 'Patients'],
          rows: _doctorsList,
          onRowTap: (row) {
            _showDoctorOptions(context, row);
          },
          maxHeight: 300,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Patients',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/admin/patients'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DataTableWidget(
          columns: ['Name', 'Email', 'Phone', 'Condition'],
          rows: _patientsList,
          onRowTap: (row) {
            _showPatientOptions(context, row);
          },
          maxHeight: 300,
        ),
      ],
    );
  }

  void _showDoctorOptions(BuildContext context, Map<String, dynamic> doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doctor: ${doctor['Name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Doctor Details'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/doctors/view/${doctor['id']}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('View Appointments'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToDoctorAppointments(doctor);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Doctor'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/doctors/edit/${doctor['id']}');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showPatientOptions(BuildContext context, Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Patient: ${patient['Name']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('View Patient Details'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/patients/view/${patient['id']}');
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('View Appointments'),
                onTap: () {
                  Navigator.pop(context);
                  _navigateToPatientAppointments(patient);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Patient'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin/patients/edit/${patient['id']}');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToDoctorAppointments(Map<String, dynamic> doctor) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      
      // Get doctor's appointments with debug logging
      debugPrint('\n');
      debugPrint('======== DEBUGGING DOCTOR APPOINTMENTS ========');
      debugPrint('Doctor ID: ${doctor['id']}');
      debugPrint('Doctor Name: ${doctor['Name']}');
      
      // First check if there are any appointments in the collection at all
      try {
        final allAppointments = await FirebaseFirestore.instance.collection('appointments').get();
        debugPrint('Total appointments in Firestore: ${allAppointments.docs.length}');
        
        // Print raw data for each appointment
        for (final doc in allAppointments.docs) {
          debugPrint('Found appointment: ${doc.id}');
          final data = doc.data();
          debugPrint('Data: $data');
          
          // Check if this appointment is for our doctor
          if (data['doctorId'] == doctor['id']) {
            debugPrint('THIS APPOINTMENT MATCHES OUR DOCTOR!');
          }
        }
      } catch (e) {
        debugPrint('Error checking all appointments: $e');
      }
      
      // Now try the query that should be finding appointments for this doctor
      debugPrint('\nTrying specific doctor query:');
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('appointments')
            .where('doctorId', isEqualTo: doctor['id'])
            .get();
        
        debugPrint('Doctor-specific query returned ${querySnapshot.docs.length} appointments');
        for (final doc in querySnapshot.docs) {
          debugPrint('Appointment ID: ${doc.id}, Data: ${doc.data()}');
        }
      } catch (e) {
        debugPrint('Error with doctor-specific query: $e');
      }
      
      // Original query
      debugPrint('\nUsing original service method:');
      final appointments = await FirestoreService.getDoctorAppointments(doctor['id']);
      debugPrint('Retrieved ${appointments.length} appointments for doctor ${doctor['Name']}');
      
      // For debugging, print details about each appointment
      for (var appointment in appointments) {
        debugPrint('Appointment ID: ${appointment.id}, Patient: ${appointment.patientName}, ' +
                  'Date: ${appointment.appointmentDate}, Status: ${appointment.status}');
      }
      debugPrint('======== END DEBUG ========\n');
      
      if (context.mounted) {
        // Hide loading indicator
        Navigator.pop(context);
        
        // Show appointments
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointments for Dr. ${doctor['Name']}'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: appointments.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No appointments found for this doctor.'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(child: CircularProgressIndicator()),
                            );
                            
                            try {
                              // Get all patients to select one for test appointment
                              final patients = await FirestoreService.getAllPatients();
                              
                              if (patients.isEmpty) {
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('No patients found')),
                                  );
                                }
                                return;
                              }
                              
                              // Use the first patient for a direct test
                              final patientId = patients.first.id;
                              
                              if (context.mounted) {
                                Navigator.pop(context);
                                
                                // Create direct test appointment
                                await FirestoreService.addDirectTestAppointment(doctor['id'], patientId);
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Created test appointment')),
                                );
                                
                                // Try viewing appointments again
                                _navigateToDoctorAppointments(doctor);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                          child: const Text('Create Test Appointment'),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        // Format date properly
                        final formattedDate = appointment.appointmentDate != null
                            ? '${appointment.appointmentDate.year}-${appointment.appointmentDate.month}-${appointment.appointmentDate.day}'
                            : 'No date';
                        return ListTile(
                          title: Text(appointment.patientName),
                          subtitle: Text('$formattedDate, ${appointment.time}'),
                          trailing: Chip(
                            label: Text(
                              appointment.status.toString().split('.').last,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: _getAppointmentStatusColor(appointment.status.toString()),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context, 
                              '/admin/appointments/view/${appointment.id}',
                            );
                          },
                        );
                      },
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
                  // Navigate to add appointment form with doctor pre-selected
                  Navigator.pushNamed(
                    context, 
                    '/admin/appointments/add',
                    arguments: {'doctorId': doctor['id']},
                  );
                },
                child: const Text('Add Appointment'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting doctor appointments: $e');
      if (context.mounted) {
        Navigator.pop(context); // Hide loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting appointments: $e')),
        );
      }
    }
  }

  void _navigateToPatientAppointments(Map<String, dynamic> patient) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      
      // Get patient's appointments with debug logging
      debugPrint('Fetching appointments for patient with ID: ${patient['id']}');
      final appointments = await FirestoreService.getPatientAppointments(patient['id']);
      debugPrint('Retrieved ${appointments.length} appointments for patient ${patient['Name']}');
      
      // For debugging, print details about each appointment
      for (var appointment in appointments) {
        debugPrint('Appointment ID: ${appointment.id}, Doctor: ${appointment.doctorName}, Date: ${appointment.appointmentDate}, Status: ${appointment.status}');
      }
      
      if (context.mounted) {
        // Hide loading indicator
        Navigator.pop(context);
        
        // Show appointments
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointments for ${patient['Name']}'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: appointments.isEmpty
                  ? const Center(child: Text('No appointments found'))
                  : ListView.builder(
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        // Format date properly
                        final formattedDate = appointment.appointmentDate != null
                            ? '${appointment.appointmentDate.year}-${appointment.appointmentDate.month}-${appointment.appointmentDate.day}'
                            : 'No date';
                        return ListTile(
                          title: Text('Dr. ${appointment.doctorName}'),
                          subtitle: Text('$formattedDate, ${appointment.time}'),
                          trailing: Chip(
                            label: Text(
                              appointment.status.toString().split('.').last,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: _getAppointmentStatusColor(appointment.status.toString()),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(
                              context, 
                              '/admin/appointments/view/${appointment.id}',
                            );
                          },
                        );
                      },
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
                  // Navigate to add appointment form with patient pre-selected
                  Navigator.pushNamed(
                    context, 
                    '/admin/appointments/add',
                    arguments: {'patientId': patient['id']},
                  );
                },
                child: const Text('Add Appointment'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting patient appointments: $e');
      if (context.mounted) {
        Navigator.pop(context); // Hide loading indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting appointments: $e')),
        );
      }
    }
  }

  Color _getAppointmentStatusColor(String status) {
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
