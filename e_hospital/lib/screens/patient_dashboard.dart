import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/core/widgets/dashboard_card.dart';
import 'package:e_hospital/core/widgets/data_table_widget.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:e_hospital/services/firestore_service.dart';

class PatientDashboard extends StatefulWidget {
  final String? initialTab;
  
  const PatientDashboard({Key? key, this.initialTab}) : super(key: key);

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String _patientName = '';
  String _patientEmail = '';
  Map<String, dynamic> _patientData = {};
  late TabController _tabController;
  late String _currentTab;
  
  List<Map<String, dynamic>> _myAppointments = [];
  List<Map<String, dynamic>> _myDoctors = [];
  List<Map<String, dynamic>> _myPrescriptions = [];

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab ?? '';
    _tabController = TabController(length: 3, vsync: this);
    _loadPatientData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user data
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await FirestoreService.getUserById(currentUser.uid);
        if (userData != null) {
          _patientName = userData.name;
          _patientEmail = userData.email;
          _patientData = userData.profile as Map<String, dynamic>? ?? {};
          
          // Load assigned doctors
          _myDoctors = [];
          final assignedDoctors = await FirestoreService.getPatientDoctors(currentUser.uid);
          for (final doctor in assignedDoctors) {
            _myDoctors.add({
              'id': doctor.id,
              'Name': doctor.name,
              'Specialization': doctor.profile != null && doctor.profile!.containsKey('specialization') 
                  ? doctor.profile!['specialization'] 
                  : 'General',
              'Hospital': doctor.profile != null && doctor.profile!.containsKey('hospital') 
                  ? doctor.profile!['hospital'] 
                  : 'Main Hospital',
              'Contact': doctor.phone ?? 'N/A',
            });
          }
          
          // Load appointments
          _myAppointments = [];
          final appointments = await FirestoreService.getPatientUpcomingAppointments(currentUser.uid);
          for (final appointment in appointments) {
            _myAppointments.add({
              'id': appointment.id,
              'Doctor': appointment.doctorName,
              'Date': appointment.appointmentDate,
              'Time': appointment.time,
              'Type': appointment.type.toString().split('.').last,
              'Status': appointment.status.toString().split('.').last,
            });
          }
          
          // If no real data yet, keep the mock data for demo purposes
          if (_myDoctors.isEmpty) {
            _myDoctors = [
              {
                'id': '1',
                'Name': 'Dr. John Smith',
                'Specialization': 'Cardiology',
                'Hospital': 'Central Hospital',
                'Contact': '+1 234-567-8900',
              },
              {
                'id': '2',
                'Name': 'Dr. Sarah Johnson',
                'Specialization': 'Neurology',
                'Hospital': 'City Medical Center',
                'Contact': '+1 234-567-8901',
              },
            ];
          }
          
          if (_myAppointments.isEmpty) {
            _myAppointments = [
              {
                'id': '1',
                'Doctor': 'Dr. Smith',
                'Date': DateTime.now().add(const Duration(days: 2)),
                'Time': '10:30 AM',
                'Type': 'Checkup',
                'Status': 'Scheduled',
              },
              {
                'id': '2',
                'Doctor': 'Dr. Johnson',
                'Date': DateTime.now().add(const Duration(days: 7)),
                'Time': '2:15 PM',
                'Type': 'Follow-up',
                'Status': 'Scheduled',
              },
            ];
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading patient data: $e');
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
    final currentPath = '/patient${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
    return Row(
      children: [
        AppSidebar(
          currentPath: currentPath,
          userRole: 'patient',
          userName: _patientName,
          userEmail: _patientEmail,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Patient Dashboard'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(),
                        const SizedBox(height: 24),
                        _buildStatsSection(),
                        const SizedBox(height: 24),
                        _buildTabSection(),
                      ],
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final currentPath = '/patient${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
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
          userRole: 'patient',
          userName: _patientName,
          userEmail: _patientEmail,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 16),
                  _buildStatsSection(),
                  const SizedBox(height: 16),
                  _buildTabSection(),
                ],
              ),
            ),
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
                  Text(
                    'Welcome, $_patientName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your next appointment is in ${_myAppointments.isNotEmpty ? '2 days' : 'not scheduled'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/patient/appointments'),
                    child: const Text('Book Appointment'),
                  ),
                ],
              ),
            ),
            if (ResponsiveLayout.isDesktop(context)) ...[
              const SizedBox(width: 40),
              Icon(
                Icons.personal_injury_rounded,
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
    return GridView.count(
      crossAxisCount: ResponsiveLayout.isDesktop(context) ? 3 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardCard(
          title: 'Appointments',
          value: _myAppointments.length.toString(),
          icon: Icons.calendar_today_outlined,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          subtitle: 'Upcoming',
          onTap: () => Navigator.pushNamed(context, '/patient/appointments'),
        ),
        DashboardCard(
          title: 'My Doctors',
          value: _myDoctors.length.toString(),
          icon: Icons.medical_services_outlined,
          iconColor: AppColors.secondary,
          backgroundColor: AppColors.secondary.withOpacity(0.1),
          subtitle: 'Active care providers',
          onTap: () => Navigator.pushNamed(context, '/patient/doctors'),
        ),
        DashboardCard(
          title: 'Clinical File',
          value: '1',
          icon: Icons.folder_outlined,
          iconColor: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.1),
          subtitle: 'Patient records',
          onTap: () => Navigator.pushNamed(context, '/patient/records'),
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming Appointments'),
            Tab(text: 'My Doctors'),
            Tab(text: 'Clinical File'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.neutral,
          indicatorColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentsTab(),
              _buildDoctorsTab(),
              _buildClinicalFilesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Appointments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/patient/appointments'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _myAppointments.isEmpty
              ? const Center(
                  child: Text(
                    'No upcoming appointments. Book one now!',
                    style: TextStyle(color: AppColors.neutral),
                  ),
                )
              : DataTableWidget(
                  columns: ['Doctor', 'Date', 'Time', 'Type', 'Status'],
                  rows: _myAppointments,
                  onRowTap: (row) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected appointment with: ${row['Doctor']}'))
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDoctorsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Doctors',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/patient/doctors'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _myDoctors.isEmpty
              ? const Center(
                  child: Text(
                    'No assigned doctors yet.',
                    style: TextStyle(color: AppColors.neutral),
                  ),
                )
              : DataTableWidget(
                  columns: ['Name', 'Specialization', 'Hospital', 'Contact'],
                  rows: _myDoctors,
                  onRowTap: (row) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected doctor: ${row['Name']}'))
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildClinicalFilesTab() {
    // Clinical files related data with only diagnostics and treatments
    List<Map<String, dynamic>> clinicalFiles = [
      {
        'id': '1',
        'Type': 'Diagnostic',
        'Date': DateTime.now().subtract(const Duration(days: 3)),
        'Doctor': 'Dr. Smith',
        'Description': 'Initial diagnosis',
      },
      {
        'id': '2',
        'Type': 'Treatment',
        'Date': DateTime.now().subtract(const Duration(days: 2)),
        'Doctor': 'Dr. Johnson',
        'Description': 'Follow-up treatment plan',
      }
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Clinical File',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/patient/records'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: clinicalFiles.isEmpty
              ? const Center(
                  child: Text(
                    'No clinical file available.',
                    style: TextStyle(color: AppColors.neutral),
                  ),
                )
              : DataTableWidget(
                  columns: ['Type', 'Date', 'Doctor', 'Description'],
                  rows: clinicalFiles,
                  onRowTap: (row) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected clinical file entry: ${row['Type']} - ${row['Description']}'))
                    );
                  },
                ),
        ),
      ],
    );
  }
}
