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
      '/medic/records/${patient['id']}',
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
    return Row(
      children: [
        AppSidebar(
          currentPath: '/medic/my-patients',
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('My Patients'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: () {
                    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
                    if (currentUserId != null) {
                      _loadPatientData(currentUserId);
                    }
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _addNewPatient,
              child: const Icon(Icons.add),
              tooltip: 'Add Patient',
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

  Widget _buildMobileLayout() {
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
          ),
        ],
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentPath: '/medic/my-patients',
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewPatient,
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    if (_patientsList.isEmpty) {
      return const Center(
        child: Text('You have no patients assigned. Please ask an admin to assign patients to you.'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patients Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total Patients: ${_patientsList.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _patientsList.length,
            itemBuilder: (context, index) {
              final patient = _patientsList[index];
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
                            Text('${patient['age']} years, ${patient['gender']}'),
                            if (patient['medicalCondition'] != null && patient['medicalCondition'].isNotEmpty)
                              Text('Condition: ${patient['medicalCondition']}'),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.visibility),
                                  label: const Text('View Details'),
                                  onPressed: () => _viewPatientDetails(patient),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.folder_open, color: Colors.orange),
                                  label: const Text('Medical Records', style: TextStyle(color: Colors.orange)),
                                  onPressed: () => _viewPatientRecords(patient),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.orange),
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
    );
  }
} 