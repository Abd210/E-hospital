import 'package:flutter/material.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/patient.dart';
import 'package:e_hospital/models/clinical_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientManagement extends StatefulWidget {
  final String? patientId;
  final String action; // 'view', 'add', 'edit'
  
  const PatientManagement({
    Key? key, 
    this.patientId,
    required this.action,
  }) : super(key: key);

  @override
  State<PatientManagement> createState() => _PatientManagementState();
}

class _PatientManagementState extends State<PatientManagement> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicalConditionController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Patient data
  Patient? _patientData;
  List<Map<String, dynamic>> _appointmentsList = [];
  List<Map<String, dynamic>> _medicalRecordsList = [];
  List<Map<String, dynamic>> _prescriptionsList = [];
  List<Map<String, dynamic>> _labResultsList = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.action != 'add' && widget.patientId != null) {
      _loadPatientData();
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _bloodGroupController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _medicalConditionController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get patient data
      final userResult = await FirestoreService.getPatientById(widget.patientId!);
      if (userResult != null && mounted) {
        // Create a Patient from User
        final patient = Patient.fromUser(userResult);
        
        setState(() {
          _patientData = patient;
          
          // Populate form controllers with patient data
          _nameController.text = patient.name;
          _emailController.text = patient.email;
          _phoneController.text = patient.phone ?? '';
          
          // Profile data
          _ageController.text = patient.age.toString();
          _genderController.text = patient.gender;
          _addressController.text = patient.profile?['address'] ?? '';
          _bloodGroupController.text = patient.profile?['bloodGroup'] ?? '';
          _heightController.text = (patient.profile?['height'] ?? '').toString();
          _weightController.text = (patient.profile?['weight'] ?? '').toString();
          _allergiesController.text = patient.allergies;
          _medicalConditionController.text = patient.medicalCondition;
        });
        
        // Load clinical file data
        final clinicalFile = await FirestoreService.getClinicalFileByPatientId(widget.patientId!);
        if (clinicalFile != null && mounted) {
          // Load diagnostics
          setState(() {
            _medicalRecordsList = clinicalFile.diagnostics.map((diagnostic) => {
              'id': diagnostic.id,
              'Date': diagnostic.date,
              'Doctor': diagnostic.doctorName,
              'Diagnosis': diagnostic.description,
              'Notes': diagnostic.notes ?? '',
            }).toList();
            
            // Load treatments
            _prescriptionsList = clinicalFile.treatments.map((treatment) => {
              'id': treatment.id,
              'Date': treatment.date,
              'Doctor': treatment.doctorName,
              'Medication': treatment.medication,
              'Dosage': treatment.dosage,
              'Frequency': treatment.frequency,
              'Duration': treatment.duration,
            }).toList();
            
            // Load discharge summary
            if (clinicalFile.dischargeSummary != null) {
              _labResultsList = [{
                'id': clinicalFile.dischargeSummary!.id,
                'Date': clinicalFile.dischargeSummary!.dischargeDate,
                'TestName': 'Discharge Summary',
                'Result': clinicalFile.dischargeSummary!.finalDiagnosis,
                'ReferenceRange': clinicalFile.dischargeSummary!.followUpInstructions,
                'Notes': clinicalFile.dischargeSummary!.summary,
              }];
            } else {
              _labResultsList = [];
            }
          });
        } else {
          // Create mock data if no clinical file exists yet
          setState(() {
            _medicalRecordsList = [];
            _prescriptionsList = [];
            _labResultsList = [];
          });
        }
        
        // Load patient's appointments
        await _loadPatientAppointments();
      }
    } catch (e) {
      debugPrint('Error loading patient data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patient data: $e')),
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
  
  Future<void> _loadPatientAppointments() async {
    try {
      final appointments = await FirestoreService.getPatientAppointments(widget.patientId!);
      _appointmentsList = appointments.map((appointment) => {
        'id': appointment.id,
        'Doctor': appointment.doctorName,
        'Date': appointment.appointmentDate,
        'Time': appointment.time,
        'Type': appointment.type.toString().split('.').last,
        'Status': appointment.status.toString().split('.').last,
      }).toList();
    } catch (e) {
      debugPrint('Error loading patient appointments: $e');
    }
  }
  
  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Prepare patient data
      final patientData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'role': 'patient',
        'profile': {
          'age': int.tryParse(_ageController.text) ?? 0,
          'gender': _genderController.text,
          'address': _addressController.text,
          'bloodGroup': _bloodGroupController.text,
          'height': double.tryParse(_heightController.text) ?? 0,
          'weight': double.tryParse(_weightController.text) ?? 0,
          'allergies': _allergiesController.text,
          'medicalCondition': _medicalConditionController.text,
          'lastUpdated': Timestamp.now(),
        }
      };
      
      if (widget.action == 'add') {
        // Create new patient with authentication
        final password = _passwordController.text;
        final result = await FirestoreService.createPatientWithAuth(patientData, password);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'])),
          );
          
          if (result['success']) {
            Navigator.pushReplacementNamed(context, '/admin/patients');
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else if (widget.action == 'edit') {
        // Update existing patient - no need to update authentication
        await FirestoreService.updatePatient(widget.patientId!, patientData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient updated successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving patient: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _deletePatient() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Patient'),
          content: Text('Are you sure you want to delete ${_patientData?.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirestoreService.deletePatient(widget.patientId!);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Patient deleted successfully')),
                    );
                    Navigator.pushReplacementNamed(context, '/admin/patients');
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting patient: $e')),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
  
  void _addMedicalRecord() {
    // Implement adding a new medical record
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Medical Record'),
        content: const Text('This functionality will be implemented soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _addPrescription() {
    // Implement adding a new prescription
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Prescription'),
        content: const Text('This functionality will be implemented soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _addLabResult() {
    // Implement adding a new lab result
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Lab Result'),
        content: const Text('This functionality will be implemented soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: _buildAppBarActions(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ResponsiveLayout(
                mobile: _buildMobileContent(),
                desktop: _buildDesktopContent(),
              ),
            ),
    );
  }
  
  String _getTitle() {
    switch (widget.action) {
      case 'add':
        return 'Add New Patient';
      case 'edit':
        return 'Edit Patient';
      case 'view':
        return 'Patient Details';
      default:
        return 'Patient Management';
    }
  }
  
  List<Widget> _buildAppBarActions() {
    List<Widget> actions = [];
    
    if (widget.action == 'view') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context, 
              '/admin/patients/edit/${widget.patientId}',
            );
          },
        ),
      );
      actions.add(
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: _deletePatient,
        ),
      );
      actions.add(
        ElevatedButton(
          onPressed: () async {
            // Get current user ID (assume it's a doctor for testing)
            final doctorId = FirebaseAuth.instance.currentUser?.uid;
            if (doctorId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User not authenticated')),
              );
              return;
            }
            
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
            
            try {
              // Create sample appointments
              await FirestoreService.createSampleAppointments(doctorId, widget.patientId!);
              
              if (context.mounted) {
                // Hide loading indicator
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sample appointments created successfully')),
                );
                
                // Reload patient data
                _loadPatientData();
              }
            } catch (e) {
              if (context.mounted) {
                // Hide loading indicator
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating sample appointments: $e')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
          ),
          child: const Text('Create Test Appointments'),
        ),
      );
      actions.add(
        ElevatedButton(
          onPressed: () async {
            // Get current user ID (assume it's a doctor for testing)
            final doctorId = FirebaseAuth.instance.currentUser?.uid;
            if (doctorId == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User not authenticated')),
              );
              return;
            }
            
            // Show loading indicator
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const Center(child: CircularProgressIndicator()),
            );
            
            try {
              // Create direct test appointment
              final success = await FirestoreService.addDirectTestAppointment(doctorId, widget.patientId!);
              
              if (context.mounted) {
                // Hide loading indicator
                Navigator.pop(context);
                
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Direct test appointment created successfully')),
                  );
                  
                  // Wait a moment to ensure Firestore is updated
                  await Future.delayed(const Duration(seconds: 1));
                  
                  // Reload patient data
                  _loadPatientData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to create direct test appointment')),
                  );
                }
              }
            } catch (e) {
              if (context.mounted) {
                // Hide loading indicator
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating direct test appointment: $e')),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: const Text('Create Direct Test'),
        ),
      );
    } else if (widget.action == 'edit' || widget.action == 'add') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _savePatient,
        ),
      );
    }
    
    return actions;
  }
  
  Widget _buildMobileContent() {
    if (widget.action == 'view') {
      return _buildViewContent();
    } else {
      return _buildForm();
    }
  }
  
  Widget _buildDesktopContent() {
    if (widget.action == 'view') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildPatientInfo(),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            flex: 2,
            child: _buildClinicalRecords(),
          ),
        ],
      );
    } else {
      return _buildForm();
    }
  }
  
  Widget _buildViewContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildPatientInfo(),
          ),
        ),
        const SizedBox(height: 24),
        _buildClinicalRecords(),
      ],
    );
  }
  
  Widget _buildPatientInfo() {
    if (_patientData == null) {
      return const Center(child: Text('Patient data not found'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.secondary.withOpacity(0.2),
              child: Icon(
                Icons.person,
                size: 40,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _patientData!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient ID: ${_patientData!.id.substring(0, 8)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_patientData!.age} years, ${_patientData!.gender}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Blood Group: ${_patientData!.profile?['bloodGroup'] ?? 'Unknown'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 10),
        _buildInfoRow(Icons.email, 'Email', _patientData!.email),
        _buildInfoRow(Icons.phone, 'Phone', _patientData!.phone ?? 'Not provided'),
        _buildInfoRow(Icons.location_on, 'Address', _patientData!.profile?['address'] ?? 'Not provided'),
        _buildInfoRow(Icons.height, 'Height', '${_patientData!.profile?['height'] ?? 'N/A'} cm'),
        _buildInfoRow(Icons.monitor_weight, 'Weight', '${_patientData!.profile?['weight'] ?? 'N/A'} kg'),
        const SizedBox(height: 16),
        Card(
          color: AppColors.background,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(Icons.medical_services, 'Medical Condition', _patientData!.medicalCondition),
                _buildInfoRow(Icons.warning, 'Allergies', _patientData!.allergies.isNotEmpty ? _patientData!.allergies : 'None reported'),
                _buildInfoRow(Icons.medication, 'Current Medication', _patientData!.currentMedication.isNotEmpty ? _patientData!.currentMedication : 'None'),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildClinicalRecords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clinical File',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Diagnostics'),
            Tab(text: 'Treatments'),
            Tab(text: 'Discharge Summary'),
          ],
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDiagnosticsTab(),
              _buildTreatmentsTab(),
              _buildDischargeSummaryTab(),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildDiagnosticsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Diagnostic'),
              onPressed: _addDiagnostic,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _medicalRecordsList.isEmpty
              ? const Center(child: Text('No diagnostics found'))
              : ListView.builder(
                  itemCount: _medicalRecordsList.length,
                  itemBuilder: (context, index) {
                    final record = _medicalRecordsList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDate(record['Date']),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  record['Doctor'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Diagnosis: ${record['Diagnosis']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(record['Notes']),
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
  
  Widget _buildTreatmentsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Treatment'),
              onPressed: _addTreatment,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _prescriptionsList.isEmpty
              ? const Center(child: Text('No treatments found'))
              : ListView.builder(
                  itemCount: _prescriptionsList.length,
                  itemBuilder: (context, index) {
                    final prescription = _prescriptionsList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDate(prescription['Date']),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  prescription['Doctor'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              prescription['Medication'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Dosage: ${prescription['Dosage']}'),
                            Text('Frequency: ${prescription['Frequency']}'),
                            Text('Duration: ${prescription['Duration']}'),
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
  
  Widget _buildDischargeSummaryTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Discharge Summary'),
              onPressed: _addDischargeSummary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _labResultsList.isEmpty
              ? const Center(child: Text('No discharge summary found'))
              : ListView.builder(
                  itemCount: _labResultsList.length,
                  itemBuilder: (context, index) {
                    final labResult = _labResultsList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDate(labResult['Date']),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  labResult['TestName'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Final Diagnosis: ${labResult['Result']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Follow-up Instructions: ${labResult['ReferenceRange']}'),
                            Text('Notes: ${labResult['Notes']}'),
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
  
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter patient name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.action == 'add')
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          decoration: const InputDecoration(
                            labelText: 'Age',
                            prefixIcon: Icon(Icons.cake),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _genderController,
                          decoration: const InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Medical Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bloodGroupController,
                    decoration: const InputDecoration(
                      labelText: 'Blood Group',
                      prefixIcon: Icon(Icons.bloodtype),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _heightController,
                          decoration: const InputDecoration(
                            labelText: 'Height (cm)',
                            prefixIcon: Icon(Icons.height),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            prefixIcon: Icon(Icons.monitor_weight),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _allergiesController,
                    decoration: const InputDecoration(
                      labelText: 'Allergies',
                      prefixIcon: Icon(Icons.warning_amber),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _medicalConditionController,
                    decoration: const InputDecoration(
                      labelText: 'Medical Condition',
                      prefixIcon: Icon(Icons.medical_services),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _savePatient,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
            child: Text(
              widget.action == 'add' ? 'Create Patient' : 'Update Patient',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.secondary,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(
              label,
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
  
  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('MMM dd, yyyy').format(date);
    }
    return date.toString();
  }
  
  Color _getStatusColor(String status) {
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
  
  void _addDiagnostic() {
    // Implement adding a new diagnostic
    final _descriptionController = TextEditingController();
    final _notesController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    
    DateTime _diagnosisDate = DateTime.now();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Diagnostic'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Diagnosis',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a diagnosis';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _diagnosisDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    
                    if (pickedDate != null && context.mounted) {
                      _diagnosisDate = pickedDate;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Diagnosis Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_diagnosisDate),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final user = await FirestoreService.getCurrentUser();
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not authenticated')),
                  );
                  return;
                }
                
                // Create diagnostic
                final diagnostic = Diagnostic(
                  id: '', // Will be generated by the service
                  description: _descriptionController.text,
                  doctorId: user.id,
                  doctorName: user.name,
                  date: _diagnosisDate,
                  notes: _notesController.text,
                );
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                try {
                  // Add diagnostic
                  final success = await FirestoreService.addDiagnostic(
                    widget.patientId!,
                    diagnostic,
                  );
                  
                  if (context.mounted) {
                    // Hide loading indicator
                    Navigator.pop(context);
                    
                    if (success) {
                      Navigator.pop(context); // Close form dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Diagnostic added successfully')),
                      );
                      
                      // Reload patient data
                      _loadPatientData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add diagnostic')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Hide loading indicator
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding diagnostic: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _addTreatment() {
    // Implement adding a new treatment
    final _medicationController = TextEditingController();
    final _descriptionController = TextEditingController();
    final _dosageController = TextEditingController();
    final _frequencyController = TextEditingController();
    final _durationController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    
    DateTime _treatmentDate = DateTime.now();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Treatment'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _medicationController,
                  decoration: const InputDecoration(
                    labelText: 'Medication/Treatment',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medication/treatment';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _frequencyController,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description/Notes',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _treatmentDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    
                    if (pickedDate != null && context.mounted) {
                      _treatmentDate = pickedDate;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Treatment Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_treatmentDate),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final user = await FirestoreService.getCurrentUser();
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User not authenticated')),
                  );
                  return;
                }
                
                // Create treatment
                final treatment = Treatment(
                  id: '', // Will be generated by the service
                  medication: _medicationController.text,
                  description: _descriptionController.text,
                  doctorId: user.id,
                  doctorName: user.name,
                  date: _treatmentDate,
                  dosage: _dosageController.text,
                  frequency: _frequencyController.text,
                  duration: _durationController.text,
                );
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                try {
                  // Add treatment
                  final success = await FirestoreService.addTreatment(
                    widget.patientId!,
                    treatment,
                  );
                  
                  if (context.mounted) {
                    // Hide loading indicator
                    Navigator.pop(context);
                    
                    if (success) {
                      Navigator.pop(context); // Close form dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Treatment added successfully')),
                      );
                      
                      // Reload patient data
                      _loadPatientData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add treatment')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Hide loading indicator
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding treatment: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  void _addDischargeSummary() {
    // Implement adding a new discharge summary
    final _summaryController = TextEditingController();
    final _finalDiagnosisController = TextEditingController();
    final _followUpInstructionsController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    
    DateTime _dischargeDate = DateTime.now();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Discharge Summary'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _finalDiagnosisController,
                  decoration: const InputDecoration(
                    labelText: 'Final Diagnosis',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a final diagnosis';
                    }
                    return null;
                  },
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _summaryController,
                  decoration: const InputDecoration(
                    labelText: 'Summary',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a summary';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _followUpInstructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Follow-Up Instructions',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter follow-up instructions';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _dischargeDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    
                    if (pickedDate != null && context.mounted) {
                      _dischargeDate = pickedDate;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Discharge Date',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('yyyy-MM-dd').format(_dischargeDate),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                // Create discharge summary
                final dischargeSummary = DischargeSummary(
                  id: '', // Will be generated by the service
                  summary: _summaryController.text,
                  dischargeDate: _dischargeDate,
                  finalDiagnosis: _finalDiagnosisController.text,
                  followUpInstructions: _followUpInstructionsController.text,
                );
                
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                try {
                  // Update discharge summary
                  final success = await FirestoreService.updateDischargeSummary(
                    widget.patientId!,
                    dischargeSummary,
                  );
                  
                  if (context.mounted) {
                    // Hide loading indicator
                    Navigator.pop(context);
                    
                    if (success) {
                      Navigator.pop(context); // Close form dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Discharge summary added successfully')),
                      );
                      
                      // Reload patient data
                      _loadPatientData();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add discharge summary')),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    // Hide loading indicator
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error adding discharge summary: $e')),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
} 