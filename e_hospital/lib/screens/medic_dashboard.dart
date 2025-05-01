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
    _loadDashboardData();
    
    // If a patient ID is selected, switch to patients tab
    if (widget.selectedPatientId != null) {
      _currentTab = 'patients';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) {
        return;
      }

      // Get doctor data
      final doctor = await FirestoreService.getUserById(currentUserId);
      if (doctor != null) {
        _doctorName = doctor.name;
        _doctorEmail = doctor.email;
        _doctorSpecialty = (doctor.profile as Map<String, dynamic>?)?['specialization'] ?? 'General';

        // Get dashboard data
        _dashboardData = await FirestoreService.getDoctorDashboardData(currentUserId);

        // Get my patients
        final patients = await FirestoreService.getDoctorPatients(currentUserId);
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

        // Get upcoming appointments
        final appointments = await FirestoreService.getDoctorUpcomingAppointments(currentUserId);
        _upcomingAppointments = appointments.map((appointment) => {
          'id': appointment.id,
          'Patient': appointment.patientName,
          'Date': appointment.appointmentDate,
          'Time': appointment.time,
          'Type': appointment.type.toString().split('.').last,
          'Status': appointment.status.toString().split('.').last,
        }).toList();

        // Mock recent medical records data
        _recentMedicalRecords = [
          {
            'id': '1',
            'Patient': 'John Patient',
            'Date': DateTime.now().subtract(const Duration(days: 3)),
            'Type': 'Diagnostic',
            'Description': 'Hypertension Assessment',
          },
          {
            'id': '2',
            'Patient': 'Sarah Patient',
            'Date': DateTime.now().subtract(const Duration(days: 5)),
            'Type': 'Treatment',
            'Description': 'Diabetes Medication Adjustment',
          },
          {
            'id': '3',
            'Patient': 'Michael Smith',
            'Date': DateTime.now().subtract(const Duration(days: 7)),
            'Type': 'Lab Result',
            'Description': 'Blood Test Analysis',
          },
        ];
      }
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
    final currentPath = '/medic${_currentTab.isNotEmpty ? '/$_currentTab' : ''}';
    
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
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
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
  
  Widget _buildContent() {
    switch (_currentTab) {
      case 'patients':
        return widget.selectedPatientId != null 
            ? _buildPatientDetails() 
            : _buildPatientsSection();
      case 'appointments':
        return _buildAppointmentsSection();
      case 'records':
        return _buildMedicalRecordsSection();
      case 'prescriptions':
        return Center(child: Text('Prescriptions page coming soon'));
      case 'lab-results':
        return Center(child: Text('Lab Results page coming soon'));
      case 'profile':
        return _buildDoctorProfile();
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 24),
            _buildStatsSection(),
            const SizedBox(height: 24),
            _buildTabSection(),
          ],
        );
    }
  }
  
  Widget _buildPatientDetails() {
    // Show details of the selected patient
    final patient = _myPatients.firstWhere(
      (p) => p['id'] == widget.selectedPatientId,
      orElse: () => {'Name': 'Unknown Patient', 'Condition': 'N/A'},
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Patient: ${patient['Name']}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text('Age: ${patient['Age']}'),
                Text('Gender: ${patient['Gender']}'),
                Text('Medical Condition: ${patient['Condition']}'),
                Text('Last Checkup: ${patient['Last Checkup']}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/medic/patients');
                  },
                  child: const Text('Back to All Patients'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Patient Medical History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        const Text(
          'No medical history records available for this patient.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
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
  
  Widget _buildMedicalRecordsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Medical Records',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        DataTableWidget(
          columns: ['Patient', 'Date', 'Type', 'Description'],
          rows: _recentMedicalRecords,
          onRowTap: (row) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected record: ${row['Description']}'))
            );
          },
          maxHeight: 600,
        ),
      ],
    );
  }
  
  Widget _buildDoctorProfile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Dr. $_doctorName',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                _doctorSpecialty,
                style: TextStyle(fontSize: 18, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 16),
            _buildProfileRow('Email', _doctorEmail),
            _buildProfileRow('Phone', '+1 555-123-4567'),
            _buildProfileRow('Experience', '7 years'),
            _buildProfileRow('Patients', '${_myPatients.length}'),
            _buildProfileRow('License Number', 'MD-123456'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
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
                    'Welcome, Dr. $_doctorName',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Specialty: $_doctorSpecialty',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have ${_upcomingAppointments.length} upcoming appointments today.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.neutral,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/medic/appointments'),
                    child: const Text('View Appointments'),
                  ),
                ],
              ),
            ),
            if (ResponsiveLayout.isDesktop(context)) ...[
              const SizedBox(width: 40),
              Icon(
                Icons.medical_services_rounded,
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

  Widget _buildTabSection() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming Appointments'),
            Tab(text: 'My Patients'),
            Tab(text: 'Recent Medical Records'),
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
              _buildPatientsTab(),
              _buildMedicalRecordsTab(),
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
              // Handle appointment tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected appointment for: ${row['Patient']}'))
              );
            },
            onEdit: (row) {
              // Handle edit
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Edit appointment for: ${row['Patient']}'))
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPatientsTab() {
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
            columns: ['Name', 'Age', 'Gender', 'Condition', 'Last Checkup'],
            rows: _myPatients,
            onRowTap: (row) {
              // Handle patient tap
              Navigator.pushNamed(context, '/medic/patients/${row['id']}');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicalRecordsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Medical Records',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/medic/records'),
              icon: const Icon(Icons.arrow_forward),
              label: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: DataTableWidget(
            columns: ['Patient', 'Date', 'Type', 'Description'],
            rows: _recentMedicalRecords,
            onRowTap: (row) {
              // Handle record tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selected medical record: ${row['Type']} for ${row['Patient']}'))
              );
            },
          ),
        ),
      ],
    );
  }
}
