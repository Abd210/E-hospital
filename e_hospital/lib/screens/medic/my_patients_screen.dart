import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class MyPatientsScreen extends StatefulWidget {
  const MyPatientsScreen({Key? key}) : super(key: key);

  @override
  State<MyPatientsScreen> createState() => _MyPatientsScreenState();
}

class _MyPatientsScreenState extends State<MyPatientsScreen> {
  bool _isLoading = true;
  String _doctorName = '';
  String _doctorEmail = '';
  List<Map<String, dynamic>> _patientsList = [];
  String? _selectedPatientId;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
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
      final doctor = await FirestoreService.getUserById(currentUserId);
      if (doctor != null && mounted) {
        setState(() {
          _doctorName = doctor.name;
          _doctorEmail = doctor.email;
        });

        // Get doctor's patients
        await _loadPatientData(currentUserId);
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

  Future<void> _loadPatientData(String doctorId) async {
    try {
      final patients = await FirestoreService.getDoctorPatients(doctorId);
      if (mounted) {
        setState(() {
          _patientsList = patients.map((patient) {
            return {
              'id': patient.id,
              'name': patient.name,
              'age': patient.age ?? 0,
              'gender': patient.gender ?? 'Unknown',
              'email': patient.email,
              'phone': patient.phone ?? 'N/A',
              'medicalCondition': patient.medicalCondition ?? 'Healthy',
              'allergies': patient.allergies ?? 'None',
              'bloodGroup': patient.profile?['bloodGroup'] ?? 'Unknown',
            };
          }).toList();
        });
      }
    } catch (e) {
      debugPrint('Error loading patients: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patients: $e')),
        );
      }
    }
  }

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
              _buildDetailRow('Email', patient['email'] ?? 'N/A'),
              _buildDetailRow('Phone', patient['phone'] ?? 'N/A'),
              _buildDetailRow('Blood Group', patient['bloodGroup'] ?? 'Unknown'),
              _buildDetailRow('Medical Condition', patient['medicalCondition'] ?? 'None'),
              _buildDetailRow('Allergies', patient['allergies'] ?? 'None'),
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
    Navigator.pushNamed(
      context,
      '/doctor/patient-records/${patient['id']}',
      arguments: {
        'patientName': patient['name'],
      },
    ).then((_) {
      // Refresh when returning
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId != null) {
        _loadPatientData(currentUserId);
      }
    });
  }

  void _deletePatient(Map<String, dynamic> patient) {
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
                  final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
                  if (currentUserId != null) {
                    _loadPatientData(currentUserId);
                  }
                }
              } catch (e) {
                // Close loading indicator if still showing
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                
                // Show error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
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
            currentPath: '/medic/my-patients',
            userRole: 'medicalPersonnel',
            userName: _doctorName,
            userEmail: _doctorEmail,
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
        title: const Text('My Patients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
              if (currentUserId != null) {
                _loadPatientData(currentUserId);
              }
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: isMobile ? Drawer(
        child: AppSidebar(
          currentPath: '/medic/my-patients',
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
      ) : null,
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPatient,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patientsList.isEmpty
              ? _buildEmptyState()
              : _buildPatientList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No patients assigned to you yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When patients are assigned to you,\nthey will appear here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Request New Patient'),
            onPressed: _addNewPatient,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have ${_patientsList.length} patient${_patientsList.length != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _patientsList.length,
            itemBuilder: (context, index) {
              final patient = _patientsList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    child: Text(
                      (patient['name'] as String? ?? 'P')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(patient['name'] ?? 'Unknown Patient'),
                  subtitle: Text(
                    '${patient['age'] ?? 'N/A'} years • ${patient['gender'] ?? 'N/A'} • ${patient['bloodGroup'] ?? 'Unknown'}'
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.folder_open),
                        tooltip: 'View Medical Records',
                        onPressed: () => _viewPatientRecords(patient),
                      ),
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        tooltip: 'Patient Details',
                        onPressed: () => _viewPatientDetails(patient),
                      ),
                    ],
                  ),
                  onTap: () => _viewPatientDetails(patient),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}