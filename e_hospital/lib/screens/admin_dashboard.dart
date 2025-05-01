import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/core/widgets/dashboard_card.dart';
import 'package:e_hospital/core/widgets/data_table_widget.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';

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
            Navigator.pushNamed(context, '/admin/doctors/view/${row['id']}');
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
            Navigator.pushNamed(context, '/admin/patients/view/${row['id']}');
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
            Navigator.pushNamed(context, '/admin/doctors/view/${row['id']}');
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
            Navigator.pushNamed(context, '/admin/patients/view/${row['id']}');
          },
          maxHeight: 300,
        ),
      ],
    );
  }
}
