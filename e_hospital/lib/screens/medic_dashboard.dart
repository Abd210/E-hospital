import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/core/widgets/dashboard_card.dart';
import 'package:e_hospital/core/widgets/chart_card.dart';
import 'package:e_hospital/core/widgets/data_table_widget.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class MedicDashboard extends StatefulWidget {
  final String? selectedPatientId;
  final String? initialTab;
  
  const MedicDashboard({
    Key? key,
    this.selectedPatientId,
    this.initialTab,
  }) : super(key: key);

  @override
  State<MedicDashboard> createState() => _MedicDashboardState();
}

class _MedicDashboardState extends State<MedicDashboard> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  Map<String, dynamic> _dashboardData = {};
  List<Map<String, dynamic>> _myPatients = [];
  List<Map<String, dynamic>> _upcomingAppointments = [];
  List<Map<String, dynamic>> _recentMedicalRecords = [];
  String _doctorName = '';
  String _doctorEmail = '';
  String _doctorSpecialty = '';
  late String _currentTab;
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab ?? '';
    _tabController = TabController(length: 3, vsync: this);
    
    // Set the correct tab index based on initialTab
    if (_currentTab.isNotEmpty) {
      int tabIndex = 0;
      switch (_currentTab) {
        case 'patients':
          tabIndex = 1;
          break;
        case 'appointments':
          tabIndex = 2;
          break;
        case 'records':
        case 'profile':
          // These tabs are handled differently - navigating to separate screens
          tabIndex = 0;
          break;
        default:
          tabIndex = 0;
      }
      _tabController.animateTo(tabIndex);
    }
    
    // Listen to tab changes to update _currentTab
    _tabController.addListener(_handleTabChange);
    
    _loadDashboardData();
    
    // If a patient ID is selected, switch to patients tab
    if (widget.selectedPatientId != null) {
      _currentTab = 'patients';
      _tabController.animateTo(1); // Patients tab index
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _currentTab = '';
            break;
          case 1:
            _currentTab = 'patients';
            break;
          case 2:
            _currentTab = 'appointments';
            break;
        }
      });
    }
  }
  
  @override
  void didUpdateWidget(MedicDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle initialTab changes from navigation
    if (widget.initialTab != oldWidget.initialTab && widget.initialTab != null) {
      setState(() {
        _currentTab = widget.initialTab!;
        
        // Update tab controller to match the new tab
        int tabIndex = 0;
        switch (_currentTab) {
          case 'patients':
            tabIndex = 1;
            break;
          case 'appointments':
            tabIndex = 2;
            break;
          default:
            tabIndex = 0;
        }
        _tabController.animateTo(tabIndex);
      });
    }
    
    // Handle patient selection changes
    if (widget.selectedPatientId != oldWidget.selectedPatientId && 
        widget.selectedPatientId != null) {
      setState(() {
        _currentTab = 'patients';
        _tabController.animateTo(1); // Patients tab index
      });
    }
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        debugPrint("Current user ID is null");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User ID not found. Please try logging in again.')),
        );
        return;
      }

      // Get doctor data
      final doctor = await FirestoreService.getUserById(currentUserId);
      if (doctor != null) {
        setState(() {
          _doctorName = doctor.name;
          _doctorEmail = doctor.email;
          _doctorSpecialty = (doctor.profile as Map<String, dynamic>?)?['specialization'] ?? 'General';
        });
        
        debugPrint("Loaded doctor basic info: $_doctorName");

        // Get dashboard data (with error handling)
        try {
          _dashboardData = await FirestoreService.getDoctorDashboardData(currentUserId);
          debugPrint("Loaded dashboard data: $_dashboardData");
        } catch (e) {
          debugPrint("Error loading dashboard data: $e");
          _dashboardData = {};
        }

        // Get my patients (with error handling)
        try {
          final patients = await FirestoreService.getDoctorPatients(currentUserId);
          debugPrint("Loaded ${patients.length} patients");
          
          if (patients.isEmpty) {
            _myPatients = [];
          } else {
            _myPatients = patients.map((patient) {
              return {
                'id': patient.id,
                'Name': patient.name,
                'Age': patient.age.toString(),
                'Gender': patient.gender,
                'Condition': patient.medicalCondition,
                'Last Checkup': patient.lastCheckup?.toString() ?? 'Not Available',
              };
            }).toList();
          }
        } catch (e) {
          debugPrint("Error loading patients: $e");
          _myPatients = [];
        }

        // Get upcoming appointments (with error handling)
        try {
          final appointments = await FirestoreService.getDoctorUpcomingAppointments(currentUserId);
          debugPrint("Loaded ${appointments.length} upcoming appointments");
          
          if (appointments.isEmpty) {
            _upcomingAppointments = [];
          } else {
            _upcomingAppointments = appointments.map((appointment) => {
              'id': appointment.id,
              'Patient': appointment.patientName,
              'Date': appointment.appointmentDate,
              'Time': appointment.time,
              'Type': appointment.type.toString().split('.').last,
              'Status': appointment.status.toString().split('.').last,
            }).toList();
          }
        } catch (e) {
          debugPrint("Error loading upcoming appointments: $e");
          _upcomingAppointments = [];
        }
      } else {
        debugPrint("Failed to load doctor profile");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading doctor profile. Please try again.')),
        );
      }
    } catch (e) {
      debugPrint("Error in _loadDashboardData: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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

  Widget _buildContentPage() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading dashboard data...'),
          ],
        ),
      );
    }

    // Determine if we should display an error message
    final hasData = _dashboardData.isNotEmpty || _myPatients.isNotEmpty || _upcomingAppointments.isNotEmpty;
    if (!hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'No data available',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unable to load your dashboard data. Please try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Welcome back, Dr. $_doctorName',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Here\'s an overview of your activities',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          // Stats
          _buildStatsSection(),
          const SizedBox(height: 32),
          
          // Upcoming appointments section
          Text(
            'Upcoming Appointments',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _upcomingAppointments.isEmpty
              ? _buildEmptyStateCard(
                  icon: Icons.calendar_today_outlined,
                  title: 'No upcoming appointments',
                  subtitle: 'You have no scheduled appointments with your patients',
                )
              : _buildAppointmentsSection(),
          const SizedBox(height: 32),
          
          // Patients section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Patients',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => _tabController.animateTo(1),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _myPatients.isEmpty
              ? _buildEmptyStateCard(
                  icon: Icons.people_outline,
                  title: 'No patients assigned',
                  subtitle: 'You have no patients assigned to you',
                )
              : _buildPatientsSection(),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMobileLayout() {
    // Create a proper current path based on the active tab
    final currentPath = '/medic${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentPath: currentPath,
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
      ),
      body: _buildContent(),
    );
  }
  
  Widget _buildDesktopLayout() {
    // Create a proper current path based on the active tab
    final currentPath = '/medic${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
    return Row(
      children: [
        AppSidebar(
          currentPath: currentPath,
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: Text(_getAppBarTitle()),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: _loadDashboardData,
                ),
                const SizedBox(width: 16),
              ],
            ),
            body: _buildContent(),
          ),
        ),
      ],
    );
  }
  
  Widget _buildContent() {
    // Special handling for tabs that should navigate to different screens
    if (_currentTab == 'records') {
      // Navigate to MedicalRecordsScreen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/medic/records');
        }
      });
      return const Center(child: CircularProgressIndicator());
    } else if (_currentTab == 'profile') {
      // For now, just show profile in the existing dashboard
      return _buildProfileContent();
    }
    
    // Normal tab handling
    if (_currentTab.isEmpty) {
      return _buildContentPage();
    }
    
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'My Patients'),
            Tab(text: 'Appointments'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildContentPage(),
              _buildPatientsTab(),
              _buildAppointmentsTab(),
            ],
          ),
        ),
      ],
    );
  }
  
  String _getAppBarTitle() {
    switch (_currentTab) {
      case 'patients':
        return widget.selectedPatientId != null ? 'Patient Details' : 'My Patients';
      case 'appointments':
        return 'Appointments';
      case 'records':
        return 'Medical Records';
      case 'prescriptions':
        return 'Prescriptions';
      case 'lab-results':
        return 'Laboratory Results';
      case 'profile':
        return 'My Profile';
      default:
        return 'Doctor Dashboard';
    }
  }
  
  Widget _buildPatientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Patients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        DataTableWidget(
          columns: ['Name', 'Age', 'Gender', 'Condition', 'Last Checkup'],
          rows: _myPatients,
          onRowTap: (row) {
            // View patient details
            Navigator.pushNamed(context, '/medic/patients/${row['id']}');
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
        const Text(
          'All Appointments',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        DataTableWidget(
          columns: ['Patient', 'Date', 'Time', 'Type', 'Status'],
          rows: _upcomingAppointments,
          onRowTap: (row) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected appointment: ${row['Patient']}'))
            );
          },
          maxHeight: 600,
        ),
      ],
    );
  }
  
  Widget _buildPatientsTab() {
    if (_myPatients.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No patients assigned to you',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Patients need to be assigned to you by an administrator',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadDashboardData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Patients',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/medic/patients'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: DataTableWidget(
            columns: ['Name', 'Age', 'Gender', 'Condition'],
            rows: _myPatients,
            onRowTap: (row) {
              _showPatientOptions(row);
            },
          ),
        ),
      ],
    );
  }

  // Add a method to show patient options
  void _showPatientOptions(Map<String, dynamic> patient) {
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
                  Navigator.pushNamed(context, '/medic/patients/${patient['id']}');
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
                leading: const Icon(Icons.medical_services),
                title: const Text('Add Medical Record'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context, 
                    '/medic/records/add',
                    arguments: {'patientId': patient['id']},
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.medication),
                title: const Text('Add Prescription'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context, 
                    '/medic/prescriptions/add',
                    arguments: {'patientId': patient['id']},
                  );
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

  // Add a method to navigate to patient appointments
  void _navigateToPatientAppointments(Map<String, dynamic> patient) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      
      // Get patient's appointments with this doctor
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      debugPrint('Current doctor ID: $currentUserId');
      debugPrint('Looking for appointments with patient ID: ${patient['id']}');
      
      if (currentUserId == null) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not authenticated')),
          );
        }
        return;
      }
      
      // First check if there are any appointments for this patient regardless of doctor
      final allPatientAppointments = await FirestoreService.getPatientAppointments(patient['id']);
      debugPrint('Patient has ${allPatientAppointments.length} total appointments in the system');
      
      // Get appointments for this patient with this doctor
      final appointments = await FirestoreService.getPatientAppointmentsWithDoctor(
        patient['id'], 
        currentUserId
      );
      
      debugPrint('Found ${appointments.length} appointments for this patient with this doctor');
      
      // Print each appointment for debugging
      for (var appointment in appointments) {
        debugPrint('Appointment ID: ${appointment.id}, Date: ${appointment.appointmentDate}, Doctor: ${appointment.doctorName}, Patient: ${appointment.patientName}');
      }
      
      if (context.mounted) {
        // Hide loading indicator
        Navigator.pop(context);
        
        // Show appointments
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointments with ${patient['Name']}'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: appointments.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No appointments found with this patient'),
                        if (allPatientAppointments.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Patient has ${allPatientAppointments.length} appointments with other doctors')
                        ]
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
                              '/medic/appointments/view/${appointment.id}',
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
                    '/medic/appointments/add',
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
      debugPrint('Exception details: ${e.toString()}');
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

  Widget _buildAppointmentsTab() {
    if (_upcomingAppointments.isEmpty) {
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
              'You have no scheduled appointments with your patients',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _loadDashboardData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/medic/appointments/add');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Create Appointment'),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Appointments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/medic/appointments'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: DataTableWidget(
            columns: ['Patient', 'Date', 'Time', 'Type', 'Status'],
            rows: _upcomingAppointments,
            onRowTap: (row) {
              // Navigate to appointment details
              _navigateToAppointmentDetails(row);
            },
            onEdit: (row) {
              // Navigate to edit appointment
              Navigator.pushNamed(
                context, 
                '/medic/appointments/edit/${row['id']}',
              );
            },
          ),
        ),
      ],
    );
  }

  // Add new method to handle appointment navigation
  void _navigateToAppointmentDetails(Map<String, dynamic> appointment) {
    // Navigate to appointment details
    Navigator.pushNamed(
      context, 
      '/medic/appointments/view/${appointment['id']}',
    );
  }

  Widget _buildStatsSection() {
    final patientCount = _dashboardData['patientCount'] ?? 0;
    final appointmentCount = _dashboardData['appointmentCount'] ?? 0;
    final todayAppointments = (_dashboardData['todayAppointments'] as List?)?.length ?? 0;

    return GridView.count(
      crossAxisCount: ResponsiveLayout.isDesktop(context) ? 3 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardCard(
          title: 'My Patients',
          value: patientCount.toString(),
          icon: Icons.people_outline,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          subtitle: '+2 new this month',
          showIncreaseIcon: true,
          onTap: () => Navigator.pushNamed(context, '/medic/patients'),
        ),
        DashboardCard(
          title: 'Appointments',
          value: appointmentCount.toString(),
          icon: Icons.calendar_today_outlined,
          iconColor: AppColors.secondary,
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          subtitle: '$todayAppointments today',
          onTap: () => Navigator.pushNamed(context, '/medic/appointments'),
        ),
        DashboardCard(
          title: 'Medical Records',
          value: '48',
          icon: Icons.folder_outlined,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.1),
          subtitle: '3 new this week',
          showIncreaseIcon: true,
          onTap: () => Navigator.pushNamed(context, '/medic/records'),
        ),
      ],
    );
  }

  // New profile content section
  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    'Dr. $_doctorName',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Specialty
                  Text(
                    _doctorSpecialty,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Info sections
                  _buildProfileInfoItem(Icons.email, 'Email', _doctorEmail),
                  _buildProfileInfoItem(Icons.people, 'Patients', '${_myPatients.length}'),
                  _buildProfileInfoItem(Icons.calendar_today, 'Appointments', '${_upcomingAppointments.length}'),
                  _buildProfileInfoItem(Icons.medical_services, 'Specialty', _doctorSpecialty),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProfileInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 16),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
