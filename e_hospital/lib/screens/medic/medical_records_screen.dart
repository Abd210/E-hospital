import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/core/widgets/data_table_widget.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({Key? key}) : super(key: key);

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  bool _isLoading = true;
  String _doctorName = '';
  String _doctorEmail = '';
  List<Map<String, dynamic>> _recordsList = [];
  List<Map<String, dynamic>> _patientsList = [];
  String? _selectedPatientId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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
      if (doctor != null && mounted) {
        setState(() {
          _doctorName = doctor.name;
          _doctorEmail = doctor.email;
        });

        // Get doctor's patients
        final patients = await FirestoreService.getDoctorPatients(currentUserId);
        if (mounted) {
          _patientsList = patients.map((patient) {
            return {
              'id': patient.id,
              'Name': patient.name,
              'Age': patient.age.toString(),
              'Gender': patient.gender,
            };
          }).toList();
        }

        // If we have patients, load medical records
        if (_patientsList.isNotEmpty) {
          await _loadMedicalRecords();
        }
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMedicalRecords() async {
    try {
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null) return;

      final recordsList = <Map<String, dynamic>>[];

      // For each patient, get their clinical file
      for (final patient in _patientsList) {
        final patientId = patient['id'] as String;
        final patientName = patient['Name'] as String;

        final clinicalFile = await FirestoreService.getClinicalFileByPatientId(patientId);
        if (clinicalFile != null) {
          // Add diagnostics
          for (final diagnostic in clinicalFile.diagnostics) {
            if (diagnostic.doctorId == currentUserId) {
              recordsList.add({
                'id': diagnostic.id,
                'Patient': patientName,
                'PatientId': patientId,
                'Date': diagnostic.date,
                'Type': 'Diagnostic',
                'Description': diagnostic.description,
                'Notes': diagnostic.notes ?? '',
              });
            }
          }

          // Add medical notes
          for (final note in clinicalFile.medicalNotes) {
            if (note.authorId == currentUserId) {
              recordsList.add({
                'id': note.id,
                'Patient': patientName,
                'PatientId': patientId,
                'Date': note.date,
                'Type': 'Medical Note',
                'Description': note.content,
                'Notes': note.noteType ?? '',
              });
            }
          }

          // Add treatments
          for (final treatment in clinicalFile.treatments) {
            if (treatment.doctorId == currentUserId) {
              recordsList.add({
                'id': treatment.id,
                'Patient': patientName,
                'PatientId': patientId,
                'Date': treatment.date,
                'Type': 'Treatment',
                'Description': treatment.medication,
                'Notes': treatment.description,
              });
            }
          }
        }
      }

      // Sort by date (newest first)
      recordsList.sort((a, b) {
        final dateA = a['Date'] as DateTime;
        final dateB = b['Date'] as DateTime;
        return dateB.compareTo(dateA);
      });

      if (mounted) {
        setState(() {
          _recordsList = recordsList;
        });
      }
    } catch (e) {
      debugPrint('Error loading medical records: $e');
    }
  }

  Future<void> _addMedicalRecord() async {
    if (_selectedPatientId == null && _patientsList.isNotEmpty) {
      // Show patient selection dialog
      final result = await _showPatientSelectionDialog();
      if (result == null) return;
      _selectedPatientId = result;
    }

    if (_selectedPatientId != null && mounted) {
      Navigator.pushNamed(
        context,
        '/medic/records/add',
        arguments: {'patientId': _selectedPatientId},
      ).then((_) => _loadMedicalRecords());
    }
  }

  Future<String?> _showPatientSelectionDialog() async {
    return showDialog<String?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Patient'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _patientsList.length,
              itemBuilder: (context, index) {
                final patient = _patientsList[index];
                return ListTile(
                  title: Text(patient['Name'] as String),
                  subtitle: Text('${patient['Age']} years, ${patient['Gender']}'),
                  onTap: () {
                    Navigator.pop(context, patient['id'] as String);
                  },
                );
              },
            ),
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

  void _viewRecord(Map<String, dynamic> record) {
    Navigator.pushNamed(
      context,
      '/medic/records/view/${record['id']}',
      arguments: {
        'recordData': record,
        'patientId': record['PatientId'],
      },
    ).then((_) => _loadMedicalRecords());
  }

  void _editRecord(Map<String, dynamic> record) {
    Navigator.pushNamed(
      context,
      '/medic/records/edit/${record['id']}',
      arguments: {
        'recordData': record,
        'patientId': record['PatientId'],
      },
    ).then((_) => _loadMedicalRecords());
  }

  Future<void> _deleteRecord(Map<String, dynamic> record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Medical Record'),
          content: const Text('Are you sure you want to delete this record? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final patientId = record['PatientId'] as String;
      final recordId = record['id'] as String;
      final recordType = record['Type'] as String;

      bool success = false;
      if (recordType == 'Diagnostic') {
        // Delete diagnostic
        success = await FirestoreService.deleteDiagnostic(patientId, recordId);
      } else if (recordType == 'Medical Note') {
        // Delete medical note
        success = await FirestoreService.deleteMedicalNote(patientId, recordId);
      } else if (recordType == 'Treatment') {
        // Delete treatment
        success = await FirestoreService.deleteTreatment(patientId, recordId);
      }

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record deleted successfully')),
          );
          _loadMedicalRecords();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete record')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error deleting record: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting record: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
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
          currentPath: '/medic/records',
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Medical Records'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Refresh',
                  onPressed: _loadMedicalRecords,
                ),
                const SizedBox(width: 16),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: _addMedicalRecord,
              child: const Icon(Icons.add),
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
        title: const Text('Medical Records'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadMedicalRecords,
          ),
        ],
      ),
      drawer: Drawer(
        child: AppSidebar(
          currentPath: '/medic/records',
          userRole: 'medicalPersonnel',
          userName: _doctorName,
          userEmail: _doctorEmail,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMedicalRecord,
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

    if (_recordsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No medical records found'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _addMedicalRecord,
              icon: const Icon(Icons.add),
              label: const Text('Add Record'),
            ),
          ],
        ),
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
                  'Medical Records Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      title: 'Total Records',
                      value: _recordsList.length.toString(),
                      icon: Icons.folder,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'Diagnostics',
                      value: _recordsList.where((r) => r['Type'] == 'Diagnostic').length.toString(),
                      icon: Icons.medical_services,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'Treatments',
                      value: _recordsList.where((r) => r['Type'] == 'Treatment').length.toString(),
                      icon: Icons.healing,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'Medical Notes',
                      value: _recordsList.where((r) => r['Type'] == 'Medical Note').length.toString(),
                      icon: Icons.note,
                      color: Colors.purple,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: DataTableWidget(
            columns: const ['Patient', 'Date', 'Type', 'Description', 'Actions'],
            rows: _recordsList.map((record) {
              return {
                'id': record['id'],
                'Patient': record['Patient'],
                'Date': _formatDate(record['Date']),
                'Type': record['Type'],
                'Description': record['Description'],
              };
            }).toList(),
            onRowTap: (row) {
              final recordIndex = _recordsList.indexWhere((r) => r['id'] == row['id']);
              if (recordIndex != -1) {
                _viewRecord(_recordsList[recordIndex]);
              }
            },
            onEdit: (row) {
              final recordIndex = _recordsList.indexWhere((r) => r['id'] == row['id']);
              if (recordIndex != -1) {
                _editRecord(_recordsList[recordIndex]);
              }
            },
            onDelete: (row) {
              final recordIndex = _recordsList.indexWhere((r) => r['id'] == row['id']);
              if (recordIndex != -1) {
                _deleteRecord(_recordsList[recordIndex]);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 