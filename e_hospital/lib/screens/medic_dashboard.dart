import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/doctor.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class MedicDashboard extends StatefulWidget {
  final String initialTab;
  
  const MedicDashboard({
    Key? key, 
    this.initialTab = '',
  }) : super(key: key);

  @override
  State<MedicDashboard> createState() => _MedicDashboardState();
}

class _MedicDashboardState extends State<MedicDashboard> {
  bool _isLoading = true;
  late String _currentTab;
  
  // Doctor data
  String _doctorName = '';
  String _doctorEmail = '';
  Map<String, dynamic>? _dashboardData;
  
  // Patient and appointment data
  int _patientCount = 0;
  List<Map<String, dynamic>> _todayAppointments = [];
  List<Map<String, dynamic>> _upcomingAppointments = [];
  
  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab.isEmpty ? 'dashboard' : widget.initialTab;
    _loadDashboardData();
  }
  
  @override
  void didUpdateWidget(MedicDashboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab && widget.initialTab.isNotEmpty) {
      setState(() {
        _currentTab = widget.initialTab;
      });
    }
  }
  
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final userId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Get doctor details
      final doctor = await FirestoreService.getDoctorById(userId);
      if (doctor == null) {
        throw Exception('Doctor not found');
      }
      
      // Get dashboard data (patients, appointments, etc.)
      final dashboardData = await FirestoreService.getDoctorDashboardData(userId);
      
      if (mounted) {
        setState(() {
          _doctorName = doctor.name;
          _doctorEmail = doctor.email;
          _dashboardData = dashboardData;
          
          // Extract specific data
          _patientCount = dashboardData['patientCount'] as int? ?? 0;
          
          // Process today's appointments
          final todayAppointments = dashboardData['todayAppointments'] as List<dynamic>? ?? [];
          _todayAppointments = todayAppointments.map((appointment) {
            return {
              'id': appointment['id'],
              'Patient': appointment['patientName'] ?? 'Unknown Patient',
              'Time': appointment['time'] ?? 'N/A',
              'Purpose': appointment['purpose'] ?? 'Consultation',
              'Status': appointment['status'] ?? 'scheduled',
            };
          }).toList();
          
          // Process upcoming appointments
          final upcomingAppointments = dashboardData['upcomingAppointments'] as List<dynamic>? ?? [];
          _upcomingAppointments = upcomingAppointments.map((appointment) {
            final date = (appointment['appointmentDate'] as dynamic)?.toDate();
            return {
              'id': appointment['id'],
              'Patient': appointment['patientName'] ?? 'Unknown Patient',
              'Date': date != null ? DateFormat('MMM dd, yyyy').format(date) : 'N/A',
              'Time': appointment['time'] ?? 'N/A',
              'Purpose': appointment['purpose'] ?? 'Consultation',
              'Status': appointment['status'] ?? 'scheduled',
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
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
  
  void _switchTab(String tab) {
    setState(() {
      _currentTab = tab;
    });
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
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentPath: _getCurrentPath(),
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCurrentTabContent(),
    );
  }
  
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        AppSidebar(
          currentPath: _getCurrentPath(),
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
              ],
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: _buildCurrentTabContent(),
                  ),
          ),
        ),
      ],
    );
  }
  
  String _getCurrentPath() {
    switch (_currentTab) {
      case 'dashboard':
        return '/medic';
      case 'patients':
        return '/medic/my-patients';
      case 'appointments':
        return '/medic/appointments';
      case 'profile':
        return '/medic/profile';
      default:
        return '/medic';
    }
  }
  
  String _getAppBarTitle() {
    switch (_currentTab) {
      case 'dashboard':
        return 'Doctor Dashboard';
      case 'patients':
        return 'My Patients';
      case 'appointments':
        return 'Appointments';
      case 'profile':
        return 'My Profile';
      default:
        return 'Doctor Dashboard';
    }
  }
  
  Widget _buildCurrentTabContent() {
    switch (_currentTab) {
      case 'dashboard':
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _buildDashboardContent(),
        );
      case 'patients':
        return _buildPatientsContent();
      case 'appointments':
        return _buildAppointmentsContent();
      case 'consultations':
        return _buildConsultationsContent();
      case 'clinical_records':
        return _buildClinicalRecordsContent();
      case 'settings':
        return _buildSettingsContent();
      default:
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _buildDashboardContent(),
        );
    }
  }
  
  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome, Dr. $_doctorName',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 24),
        
        // Stats cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.people,
                title: '$_patientCount',
                subtitle: 'Assigned Patients',
                color: AppColors.primary,
                onTap: () => _switchTab('patients'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.today,
                title: '${_todayAppointments.length}',
                subtitle: 'Today\'s Appointments',
                color: AppColors.accent,
                onTap: () => _switchTab('appointments'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.schedule,
                title: '${_dashboardData?['appointmentCount'] ?? 0}',
                subtitle: 'Total Appointments',
                color: AppColors.success,
                onTap: () => _switchTab('appointments'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Today's appointments
        const Text(
          'Today\'s Appointments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _todayAppointments.isEmpty
            ? _buildEmptyState('No appointments scheduled for today')
            : Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _todayAppointments.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final appointment = _todayAppointments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          appointment['Patient'].toString().substring(0, 1),
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(appointment['Patient']),
                      subtitle: Text('${appointment['Time']} - ${appointment['Purpose']}'),
                      trailing: _buildStatusChip(appointment['Status']),
                      onTap: () {
                        // Navigate to appointment details
                        Navigator.pushNamed(
                          context, 
                          '/doctor/appointments/view/${appointment['id']}',
                        );
                      },
                    );
                  },
                ),
              ),
        const SizedBox(height: 32),
        
        // Upcoming appointments
        const Text(
          'Upcoming Appointments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _upcomingAppointments.isEmpty
            ? _buildEmptyState('No upcoming appointments scheduled')
            : Card(
                elevation: 2,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _upcomingAppointments.length > 5 ? 5 : _upcomingAppointments.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final appointment = _upcomingAppointments[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          appointment['Patient'].toString().substring(0, 1),
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                      title: Text(appointment['Patient']),
                      subtitle: Text('${appointment['Date']} at ${appointment['Time']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusChip(appointment['Status']),
                          const SizedBox(width: 8),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                      onTap: () {
                        // Navigate to appointment details
                        Navigator.pushNamed(
                          context, 
                          '/doctor/appointments/view/${appointment['id']}',
                        );
                      },
                    );
                  },
                ),
              ),
        if (_upcomingAppointments.length > 5) ...[
          const SizedBox(height: 16),
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('View All Appointments'),
              onPressed: () => Navigator.pushNamed(context, '/doctor/appointments'),
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'scheduled':
        chipColor = Colors.blue;
        break;
      case 'confirmed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      case 'completed':
        chipColor = Colors.teal;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: chipColor),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: chipColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildAppointmentsContent() {
    return SingleChildScrollView(
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
                    'All Appointments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to the appointment creation screen
                          Navigator.pushNamed(context, '/doctor/appointments/add').then((_) {
                            // Refresh appointments list after returning
                            _loadDashboardData();
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('New Appointment'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Navigate to appointments list screen with filter
                          Navigator.pushNamed(context, '/doctor/appointments');
                        },
                        icon: const Icon(Icons.filter_list),
                        label: const Text('View All & Filter'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today\'s Appointments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _todayAppointments.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No appointments scheduled for today',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildTodayAppointmentsList(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
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
                  _upcomingAppointments.isEmpty
                      ? Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.event_busy,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No upcoming appointments',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : _buildUpcomingAppointmentsList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPatientsContent() {
    // Get the patient list from the dashboard data
    final patientList = _dashboardData != null && _dashboardData!.containsKey('patientList') 
        ? (_dashboardData!['patientList'] as List<dynamic>? ?? []) 
        : <dynamic>[];
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Patients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Patient'),
                        onPressed: _addNewPatient,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total Patients: $_patientCount',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: patientList.isEmpty
              ? const Center(
                  child: Text(
                    'No patients assigned to you yet. Please contact an administrator.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: patientList.length,
                  itemBuilder: (context, index) {
                    final patient = patientList[index] as Map<String, dynamic>;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColors.secondary.withOpacity(0.2),
                              child: const Icon(Icons.person, size: 30, color: AppColors.secondary),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient['name'] ?? 'Unknown Patient',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (patient.containsKey('age') && patient.containsKey('gender'))
                                    Text('${patient['age']} years, ${patient['gender']}'),
                                  if (patient.containsKey('medicalCondition') && patient['medicalCondition'] != null)
                                    Text('Condition: ${patient['medicalCondition']}'),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      ElevatedButton.icon(
                                        icon: const Icon(Icons.visibility),
                                        label: const Text('View Details'),
                                        onPressed: () {
                                          // Navigate to patient details screen
                                          Navigator.pushNamed(
                                            context,
                                            '/doctor/patients/${patient['id']}',
                                          ).then((_) {
                                            // Refresh when returning
                                            _loadDashboardData();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deletePatient(patient),
                                        tooltip: 'Delete Patient',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Dr. $_doctorName',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateTime.now().hour < 12
                            ? 'Good morning! Have a great day ahead.'
                            : DateTime.now().hour < 17
                                ? 'Good afternoon! Hope your day is going well.'
                                : 'Good evening! Time to wrap up for the day.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(
                  icon: Icons.person_search,
                  label: 'View Patients',
                  onPressed: () {
                    _switchTab('patients');
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.calendar_today,
                  label: 'Appointments',
                  onPressed: () {
                    _switchTab('appointments');
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.medical_services,
                  label: 'Medical Records',
                  onPressed: () {
                    Navigator.pushNamed(context, '/medic/records');
                  },
                ),
                _buildQuickActionButton(
                  icon: Icons.person,
                  label: 'My Profile',
                  onPressed: () {
                    Navigator.pushNamed(context, '/medic/profile');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatisticsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  icon: Icons.people,
                  title: _patientCount.toString(),
                  subtitle: 'My Patients',
                  color: Colors.blue,
                  onTap: () => _switchTab('patients'),
                ),
                _buildStatCard(
                  icon: Icons.today,
                  title: _todayAppointments.length.toString(),
                  subtitle: 'Today\'s Appointments',
                  color: Colors.orange,
                  onTap: () => _switchTab('appointments'),
                ),
                _buildStatCard(
                  icon: Icons.calendar_month,
                  title: _upcomingAppointments.length.toString(),
                  subtitle: 'Upcoming Appointments',
                  color: Colors.green,
                  onTap: () => _switchTab('appointments'),
                ),
                _buildStatCard(
                  icon: Icons.check_circle,
                  title: _todayAppointments
                    .where((a) => a['Status']?.toString().toLowerCase() == 'completed')
                    .length
                    .toString(),
                  subtitle: 'Completed Today',
                  color: Colors.purple,
                  onTap: () => _switchTab('appointments'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 28),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTodayAppointmentsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Today\'s Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/doctor/appointments');
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _todayAppointments.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No appointments scheduled for today',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildTodayAppointmentsList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTodayAppointmentsList() {
    return Column(
      children: _todayAppointments.map((appointment) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: AppColors.background,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(appointment['Status'] as String).withOpacity(0.2),
              child: Icon(
                Icons.person,
                color: _getStatusColor(appointment['Status'] as String),
              ),
            ),
            title: Text(
              appointment['Patient'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Time: ${appointment['Time']}'),
                Text('Purpose: ${appointment['Purpose']}'),
              ],
            ),
            trailing: Chip(
              label: Text(
                _getStatusDisplayText(appointment['Status'] as String),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
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
      }).toList(),
    );
  }
  
  Widget _buildUpcomingAppointmentsSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/doctor/appointments');
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _upcomingAppointments.isEmpty
                ? Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No upcoming appointments',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildUpcomingAppointmentsList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildUpcomingAppointmentsList() {
    return Column(
      children: _upcomingAppointments.take(5).map((appointment) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          color: AppColors.background,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(appointment['Status'] as String).withOpacity(0.2),
              child: Icon(
                Icons.person,
                color: _getStatusColor(appointment['Status'] as String),
              ),
            ),
            title: Text(
              appointment['Patient'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Date: ${appointment['Date']}'),
                Text('Time: ${appointment['Time']}'),
                Text('Purpose: ${appointment['Purpose']}'),
              ],
            ),
            trailing: Chip(
              label: Text(
                _getStatusDisplayText(appointment['Status'] as String),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
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
      }).toList(),
    );
  }
  
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  String _getStatusDisplayText(String status) {
    // Capitalize first letter
    if (status.isEmpty) return '';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }
  
  // Add new methods for patient CRUD operations
  void _addNewPatient() {
    // Show dialog to add a new patient
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: const Text('Please contact an administrator to add a new patient.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _viewPatientDetails(Map<String, dynamic> patient) {
    if (patient.containsKey('id')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(patient['name'] ?? 'Patient Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('ID', patient['id']),
                _buildDetailRow('Name', patient['name']),
                _buildDetailRow('Age', patient['age']?.toString() ?? 'N/A'),
                _buildDetailRow('Gender', patient['gender'] ?? 'N/A'),
                _buildDetailRow('Medical Condition', patient['medicalCondition'] ?? 'None'),
                const Divider(),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder_open),
                  label: const Text('View Medical Records'),
                  onPressed: () {
                    Navigator.pop(context);  // Close dialog
                    _viewPatientRecords(patient);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
  
  void _viewPatientRecords(Map<String, dynamic> patient) {
    if (patient.containsKey('id')) {
      Navigator.pushNamed(
        context,
        '/medic/patients/${patient['id']}',
      ).then((_) {
        // Refresh when returning
        _loadDashboardData();
      });
    }
  }
  
  void _deletePatient(Map<String, dynamic> patient) {
    if (patient.containsKey('id')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Patient'),
          content: Text('Are you sure you want to remove ${patient['name']} from your patient list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                try {
                  // In a real app, this would call a service to remove the patient
                  // For now, just show a success message and refresh
                  await Future.delayed(const Duration(seconds: 1));
                  
                  if (mounted) {
                    // Close loading indicator
                    Navigator.pop(context);
                    
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Operation not permitted. Contact an administrator.')),
                    );
                    
                    // Refresh data
                    _loadDashboardData();
                  }
                } catch (e) {
                  if (mounted) {
                    // Close loading indicator
                    Navigator.pop(context);
                    
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }
  }
  
  // Add missing tab building methods
  Widget _buildConsultationsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Consultations feature coming soon',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
  
  Widget _buildClinicalRecordsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.folder_open, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Clinical Records feature coming soon',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Settings feature coming soon',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
