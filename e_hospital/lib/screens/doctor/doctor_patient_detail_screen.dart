import 'package:flutter/material.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/models/patient.dart';
import 'package:e_hospital/models/clinical_model.dart';
import 'package:intl/intl.dart';
import 'package:e_hospital/clinical_file/doctor_clinical_screen.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final String patientId;
  
  const DoctorPatientDetailScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  State<DoctorPatientDetailScreen> createState() => _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  
  // Patient data
  Patient? _patient;
  ClinicalFile? _clinicalFile;
  
  // Appointment and medical records data
  List<Map<String, dynamic>> _appointmentsList = [];
  List<Map<String, dynamic>> _medicalRecordsList = [];
  List<Map<String, dynamic>> _prescriptionsList = [];
  List<Map<String, dynamic>> _labResultsList = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      // Get patient data
      final userResult = await FirestoreService.getPatientById(widget.patientId);
      if (userResult != null) {
        // Create a Patient from User
        final patient = Patient.fromUser(userResult);
        
        // Load clinical file data
        final clinicalFile = await FirestoreService.getClinicalFileByPatientId(widget.patientId);
        
        // Load patient appointments
        final appointments = await FirestoreService.getPatientAppointments(widget.patientId);
        
        // Load medical records
        final medicalRecords = await FirestoreService.getPatientMedicalRecords(widget.patientId);
        
        // Load prescriptions
        final prescriptions = await FirestoreService.getPatientPrescriptions(widget.patientId);
        
        // Load lab results
        final labResults = await FirestoreService.getPatientLabResults(widget.patientId);
        
        if (mounted) {
          setState(() {
            _patient = patient;
            _clinicalFile = clinicalFile;
            
            // Process appointments
            _appointmentsList = appointments.map((appointment) {
              final appointmentDate = appointment.appointmentDate;
              final formattedDate = DateFormat('MMM dd, yyyy').format(appointmentDate);
              
              return {
                'id': appointment.id,
                'doctorName': appointment.doctorName,
                'date': formattedDate,
                'time': appointment.time,
                'purpose': appointment.purpose,
                'status': appointment.status.toString().split('.').last,
                'notes': appointment.notes ?? '',
                'type': appointment.type.toString().split('.').last,
              };
            }).toList();
            
            // Process medical records
            _medicalRecordsList = medicalRecords.map((record) {
              return {
                'id': record.id,
                'title': record.title,
                'date': DateFormat('MMM dd, yyyy').format(record.date),
                'doctorName': record.doctorName,
                'description': record.description,
                'recordType': record.recordType,
              };
            }).toList();
            
            // Process prescriptions
            _prescriptionsList = prescriptions.map((prescription) {
              return {
                'id': prescription.id,
                'medication': prescription.medicationName,
                'dosage': prescription.dosage,
                'instructions': prescription.instructions ?? '',
                'date': DateFormat('MMM dd, yyyy').format(prescription.prescriptionDate),
                'doctorName': prescription.doctorName,
                'refillable': prescription.refills != null && prescription.refills!.isNotEmpty,
                'refillCount': prescription.refills ?? '0',
              };
            }).toList();
            
            // Process lab results
            _labResultsList = labResults.map((result) {
              return {
                'id': result.id,
                'testName': result.testName,
                'date': DateFormat('MMM dd, yyyy').format(result.testDate),
                'labName': result.labName ?? 'Unknown Laboratory',
                'results': result.result,
                'normalRange': result.referenceRange ?? 'N/A',
                'status': result.isAbnormal == true ? 'abnormal' : 'normal',
                'notes': result.notes ?? '',
              };
            }).toList();
            
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Patient not found');
      }
    } catch (e) {
      debugPrint('Error loading patient data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patient data: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_patient?.name ?? 'Patient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadPatientData,
          ),
        ],
        bottom: _isLoading 
          ? null 
          : TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Profile'),
                Tab(text: 'Records'),
                Tab(text: 'Prescriptions'),
                Tab(text: 'Labs'),
              ],
            ),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(),
              _buildMedicalRecordsTab(),
              _buildPrescriptionsTab(),
              _buildLabResultsTab(),
            ],
          ),
    );
  }
  
  Widget _buildProfileTab() {
    if (_patient == null) {
      return const Center(child: Text('Patient data not available'));
    }
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _patient!.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Patient ID: ${_patient!.id.substring(0, 8)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_patient!.age} years, ${_patient!.gender}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Blood Group: ${_patient!.profile?['bloodGroup'] ?? 'Unknown'}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Personal Information
          _buildSectionCard(
            title: 'Personal Information',
            children: [
              _buildInfoRow(Icons.email, 'Email', _patient!.email),
              _buildInfoRow(Icons.phone, 'Phone', _patient!.phone ?? 'Not provided'),
              _buildInfoRow(Icons.location_on, 'Address', _patient!.profile?['address'] ?? 'Not provided'),
              _buildInfoRow(Icons.height, 'Height', '${_patient!.profile?['height'] ?? 'N/A'} cm'),
              _buildInfoRow(Icons.monitor_weight, 'Weight', '${_patient!.profile?['weight'] ?? 'N/A'} kg'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Medical Information
          _buildSectionCard(
            title: 'Medical Information',
            children: [
              _buildInfoRow(Icons.medical_services, 'Medical Condition', _patient!.medicalCondition),
              _buildInfoRow(Icons.warning_amber, 'Allergies', _patient!.allergies),
              if (_patient!.profile?['chronicDiseases'] != null)
                _buildInfoRow(Icons.healing, 'Chronic Diseases', _patient!.profile?['chronicDiseases']),
              if (_patient!.profile?['currentMedication'] != null)
                _buildInfoRow(Icons.medication, 'Current Medication', _patient!.profile?['currentMedication']),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Appointments Section
          _buildSectionCard(
            title: 'Recent Appointments',
            children: [
              if (_appointmentsList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No appointment history found'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _appointmentsList.length > 3 ? 3 : _appointmentsList.length,
                  itemBuilder: (context, index) {
                    final appointment = _appointmentsList[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.calendar_today,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text('${appointment['type']} - ${appointment['purpose']}'),
                      subtitle: Text('${appointment['date']} at ${appointment['time']}'),
                      trailing: _buildStatusChip(appointment['status']),
                    );
                  },
                ),
              if (_appointmentsList.length > 3)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        _tabController.animateTo(1); // Navigate to records tab
                      },
                      child: const Text('View All Appointments'),
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Book Appointment Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Book New Appointment'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/doctor/appointments/add',
                ).then((_) {
                  _loadPatientData(); // Refresh after creating appointment
                });
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMedicalRecordsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Clinical Files Section
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Clinical Files',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Open Clinical File'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorClinicalScreen(
                                patientId: widget.patientId,
                                patientName: _patient?.name ?? 'Patient',
                              ),
                            ),
                          ).then((_) {
                            _loadPatientData(); // Refresh after returning
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Access the patient\'s complete clinical file including diagnoses, prescriptions, and lab tests.',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Appointments Section
          _buildSectionCard(
            title: 'Appointments',
            children: [
              if (_appointmentsList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No appointment history found'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _appointmentsList.length,
                  itemBuilder: (context, index) {
                    final appointment = _appointmentsList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Icon(
                            Icons.calendar_today,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text('${appointment['type']} - ${appointment['purpose']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${appointment['date']} at ${appointment['time']}'),
                            Text('Doctor: ${appointment['doctorName']}'),
                            if (appointment['notes'] != null && appointment['notes'].isNotEmpty)
                              Text('Notes: ${appointment['notes']}'),
                          ],
                        ),
                        trailing: _buildStatusChip(appointment['status']),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Medical Records Section
          _buildSectionCard(
            title: 'Medical Records',
            actionButton: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Record'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/medic/records/add',
                  arguments: {'patientId': widget.patientId},
                ).then((_) {
                  _loadPatientData(); // Refresh after adding record
                });
              },
            ),
            children: [
              if (_medicalRecordsList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No medical records found'),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _medicalRecordsList.length,
                  itemBuilder: (context, index) {
                    final record = _medicalRecordsList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.accent.withOpacity(0.1),
                          child: Icon(
                            Icons.folder,
                            color: AppColors.accent,
                          ),
                        ),
                        title: Text(record['title']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${record['date']}'),
                            Text('Doctor: ${record['doctorName']}'),
                            Text('Type: ${record['recordType']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/medic/records/view/${record['id']}',
                            );
                          },
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildPrescriptionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildSectionCard(
        title: 'Prescriptions',
        actionButton: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Prescription'),
          onPressed: () {
            // Navigate to prescription creation screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Prescription creation feature coming soon')),
            );
          },
        ),
        children: [
          if (_prescriptionsList.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No prescriptions found'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _prescriptionsList.length,
              itemBuilder: (context, index) {
                final prescription = _prescriptionsList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.withOpacity(0.1),
                      child: const Icon(
                        Icons.medication,
                        color: Colors.green,
                      ),
                    ),
                    title: Text(prescription['medication']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dosage: ${prescription['dosage']}'),
                        Text('Issued: ${prescription['date']}'),
                        Text('Doctor: ${prescription['doctorName']}'),
                        Text('Instructions: ${prescription['instructions']}'),
                      ],
                    ),
                    trailing: prescription['refillable'] ? 
                      Chip(
                        label: Text('Refills: ${prescription['refillCount']}'),
                        backgroundColor: Colors.green.withOpacity(0.1),
                      ) : null,
                    isThreeLine: true,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildLabResultsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildSectionCard(
        title: 'Laboratory Results',
        actionButton: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Lab Result'),
          onPressed: () {
            // Navigate to lab result creation screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lab result creation feature coming soon')),
            );
          },
        ),
        children: [
          if (_labResultsList.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No laboratory results found'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _labResultsList.length,
              itemBuilder: (context, index) {
                final labResult = _labResultsList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple.withOpacity(0.1),
                      child: const Icon(
                        Icons.science,
                        color: Colors.purple,
                      ),
                    ),
                    title: Text(labResult['testName']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${labResult['date']}'),
                        Text('Lab: ${labResult['labName']}'),
                        Text('Result: ${labResult['results']}'),
                        Text('Normal Range: ${labResult['normalRange']}'),
                      ],
                    ),
                    trailing: _buildLabStatusChip(labResult['status']),
                    isThreeLine: true,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
  
  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
    Widget? actionButton,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (actionButton != null) actionButton,
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
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
            child: Text(value.isEmpty ? 'Not provided' : value),
          ),
        ],
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
        chipColor = Colors.teal;
        break;
      case 'completed':
        chipColor = Colors.green;
        break;
      case 'cancelled':
        chipColor = Colors.red;
        break;
      case 'rescheduled':
        chipColor = Colors.orange;
        break;
      case 'noshow':
        chipColor = Colors.grey;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Chip(
      label: Text(
        status.capitalize(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      backgroundColor: chipColor,
    );
  }
  
  Widget _buildLabStatusChip(String status) {
    Color chipColor;
    switch (status.toLowerCase()) {
      case 'normal':
        chipColor = Colors.green;
        break;
      case 'abnormal':
        chipColor = Colors.orange;
        break;
      case 'critical':
        chipColor = Colors.red;
        break;
      case 'pending':
        chipColor = Colors.blue;
        break;
      default:
        chipColor = Colors.grey;
    }
    
    return Chip(
      label: Text(
        status.capitalize(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
      backgroundColor: chipColor,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
} 