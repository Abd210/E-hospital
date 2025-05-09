import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/appointment_model.dart';
import 'package:e_hospital/theme/app_theme.dart';

class DoctorAppointmentListScreen extends StatefulWidget {
  const DoctorAppointmentListScreen({Key? key}) : super(key: key);

  @override
  State<DoctorAppointmentListScreen> createState() => _DoctorAppointmentListScreenState();
}

class _DoctorAppointmentListScreenState extends State<DoctorAppointmentListScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  final _dateFormat = DateFormat('MMM d, yyyy');
  
  // Current user data
  String _doctorId = '';
  String _doctorName = '';
  
  // Appointment data
  List<Appointment> _allAppointments = [];
  List<Appointment> _upcomingAppointments = [];
  List<Appointment> _pastAppointments = [];
  
  // Filter options
  String _filterStatus = 'All';
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;
  String _filterPatientName = '';
  
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
      // Get current user
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }
      
      // Get doctor data
      _doctorId = currentUser.uid;
      final doctorData = await FirestoreService.getUserById(_doctorId);
      if (doctorData != null) {
        _doctorName = doctorData.name;
      }
      
      // Get all appointments for this doctor
      final appointments = await FirestoreService.getDoctorAppointments(_doctorId);
      
      // Now split into upcoming and past
      final now = DateTime.now();
      
      setState(() {
        _allAppointments = appointments;
        _upcomingAppointments = appointments
            .where((appointment) => appointment.appointmentDate.isAfter(now))
            .toList()
          ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
        
        _pastAppointments = appointments
            .where((appointment) => appointment.appointmentDate.isBefore(now))
            .toList()
          ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate)); // Sort descending
        
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading doctor appointments: $e');
      
      // Show error and set as not loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading appointments: $e')),
        );
        
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempFilterStatus = _filterStatus;
        DateTime? tempStartDate = _filterStartDate;
        DateTime? tempEndDate = _filterEndDate;
        String tempPatientName = _filterPatientName;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filter Appointments'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status filter
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      value: tempFilterStatus,
                      items: [
                        'All',
                        ...AppointmentStatus.values.map((status) => 
                          status.toString().split('.').last
                        ).toList(),
                      ].map((String status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() {
                            tempFilterStatus = value;
                          });
                        }
                      },
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Date range picker
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'From Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                              text: tempStartDate != null 
                                  ? _dateFormat.format(tempStartDate!)
                                  : '',
                            ),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: tempStartDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              
                              if (pickedDate != null) {
                                setState(() {
                                  tempStartDate = pickedDate;
                                });
                              }
                            },
                          ),
                        ),
                        
                        const SizedBox(width: 8),
                        
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'To Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                              text: tempEndDate != null 
                                  ? _dateFormat.format(tempEndDate!)
                                  : '',
                            ),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: tempEndDate ?? DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                              );
                              
                              if (pickedDate != null) {
                                setState(() {
                                  tempEndDate = pickedDate;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Patient name filter
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Patient Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      initialValue: tempPatientName,
                      onChanged: (value) {
                        tempPatientName = value;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Clear Filters'),
                  onPressed: () {
                    setState(() {
                      tempFilterStatus = 'All';
                      tempStartDate = null;
                      tempEndDate = null;
                      tempPatientName = '';
                    });
                  },
                ),
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FilledButton(
                  child: const Text('Apply'),
                  onPressed: () {
                    this.setState(() {
                      _filterStatus = tempFilterStatus;
                      _filterStartDate = tempStartDate;
                      _filterEndDate = tempEndDate;
                      _filterPatientName = tempPatientName;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  List<Appointment> _getFilteredAppointments(List<Appointment> appointments) {
    return appointments.where((appointment) {
      // Filter by status
      if (_filterStatus != 'All') {
        final statusString = appointment.status.toString().split('.').last;
        if (statusString != _filterStatus) {
          return false;
        }
      }
      
      // Filter by date range
      if (_filterStartDate != null && appointment.appointmentDate.isBefore(_filterStartDate!)) {
        return false;
      }
      if (_filterEndDate != null) {
        // Add one day to include the end date fully
        final endDatePlusOne = _filterEndDate!.add(const Duration(days: 1));
        if (appointment.appointmentDate.isAfter(endDatePlusOne)) {
          return false;
        }
      }
      
      // Filter by patient name
      if (_filterPatientName.isNotEmpty) {
        return appointment.patientName.toLowerCase().contains(_filterPatientName.toLowerCase());
      }
      
      return true;
    }).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'Filter Appointments',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Upcoming appointments tab
                _buildAppointmentsList(_getFilteredAppointments(_upcomingAppointments)),
                
                // Past appointments tab
                _buildAppointmentsList(_getFilteredAppointments(_pastAppointments)),
              ],
            ),
    );
  }
  
  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No appointments found',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _tabController.index == 0
                  ? 'You have no upcoming appointments'
                  : 'You have no past appointments',
              textAlign: TextAlign.center,
            ),
            if (_filterStatus != 'All' || 
                _filterStartDate != null || 
                _filterEndDate != null || 
                _filterPatientName.isNotEmpty) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.filter_alt_off),
                label: const Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    _filterStatus = 'All';
                    _filterStartDate = null;
                    _filterEndDate = null;
                    _filterPatientName = '';
                  });
                },
              ),
            ],
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                appointment.patientName.substring(0, 1).toUpperCase(),
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            title: Text(
              appointment.patientName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Date: ${_dateFormat.format(appointment.appointmentDate)}'),
                Text('Time: ${appointment.time}'),
                Text('Type: ${appointment.type.toString().split('.').last}'),
                if (appointment.purpose.isNotEmpty)
                  Text('Purpose: ${appointment.purpose}'),
              ],
            ),
            trailing: _buildStatusChip(appointment.status),
            onTap: () => _viewAppointmentDetails(appointment),
          ),
        );
      },
    );
  }
  
  Widget _buildStatusChip(AppointmentStatus status) {
    Color chipColor;
    String statusText = status.toString().split('.').last;
    
    switch (status) {
      case AppointmentStatus.scheduled:
        chipColor = Colors.blue;
        break;
      case AppointmentStatus.confirmed:
        chipColor = Colors.green;
        break;
      case AppointmentStatus.inProgress:
        chipColor = Colors.orange;
        break;
      case AppointmentStatus.completed:
        chipColor = Colors.purple;
        break;
      case AppointmentStatus.cancelled:
        chipColor = Colors.red;
        break;
      case AppointmentStatus.noShow:
        chipColor = Colors.grey;
        break;
      case AppointmentStatus.rescheduled:
        chipColor = Colors.amber;
        break;
    }
    
    // Convert camelCase to title case with spaces
    statusText = statusText.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => ' ${match.group(0)}',
    ).trim().capitalize();
    
    return Chip(
      label: Text(
        statusText,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
  
  void _viewAppointmentDetails(Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${appointment.type.toString().split('.').last.capitalize()} Appointment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('Patient', appointment.patientName),
                _buildInfoRow('Date', _dateFormat.format(appointment.appointmentDate)),
                _buildInfoRow('Time', appointment.time),
                _buildInfoRow('Status', appointment.status.toString().split('.').last.capitalize()),
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
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // Add more actions like update status, etc.
          ],
        );
      },
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
} 