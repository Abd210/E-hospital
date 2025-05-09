import 'package:flutter/material.dart';
import 'package:e_hospital/clinical_file/clinical_models.dart';
import 'package:e_hospital/clinical_file/clinical_service.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:uuid/uuid.dart';
import 'package:e_hospital/services/firestore_service.dart';

class DoctorClinicalScreen extends StatefulWidget {
  final String? patientId;
  final String? patientName;
  
  const DoctorClinicalScreen({
    Key? key,
    this.patientId,
    this.patientName,
  }) : super(key: key);

  @override
  State<DoctorClinicalScreen> createState() => _DoctorClinicalScreenState();
}

class _DoctorClinicalScreenState extends State<DoctorClinicalScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  final _dateFormat = DateFormat('MMM d, yyyy');
  
  // Data
  List<Diagnosis> _diagnoses = [];
  List<Prescription> _prescriptions = [];
  List<LaboratoryTest> _laboratoryTests = [];
  
  // Doctor info
  String _doctorId = '';
  String _doctorName = '';
  
  // Patient info
  String? _patientId;
  String _patientName = '';
  List<Map<String, dynamic>> _patientsList = [];
  bool _isPatientSelected = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getCurrentDoctor();
    
    if (widget.patientId != null && widget.patientName != null) {
      // If patient info is provided in the widget
      _patientId = widget.patientId;
      _patientName = widget.patientName!;
      _isPatientSelected = true;
      _loadPatientData();
    } else {
      // Otherwise, load the doctor's patients for selection
      _loadDoctorPatients();
    }
    
    // Add listener to tab controller to ensure doctor name is refreshed when tabs change
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _getCurrentDoctor();
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _getCurrentDoctor() async {
    final authUser = auth.FirebaseAuth.instance.currentUser;
    if (authUser != null) {
      setState(() {
        _doctorId = authUser.uid;
      });
      
      // Get the doctor details from Firestore
      try {
        final doctorDetails = await FirestoreService.getUserById(authUser.uid);
        if (doctorDetails != null && mounted) {
          setState(() {
            _doctorName = doctorDetails.name;
          });
        } else if (mounted) {
          setState(() {
            _doctorName = authUser.displayName ?? 'Dr. Unknown';
          });
        }
      } catch (e) {
        debugPrint('Error loading doctor details: $e');
        if (mounted) {
          setState(() {
            _doctorName = authUser.displayName ?? 'Dr. Unknown';
          });
        }
      }
    }
  }
  
  Future<void> _loadPatientData() async {
    if (_patientId == null) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load diagnoses, prescriptions, and laboratory tests in parallel
      final diagnosesResult = await ClinicalService.getPatientDiagnoses(_patientId!);
      final prescriptionsResult = await ClinicalService.getPatientPrescriptions(_patientId!);
      final testsResult = await ClinicalService.getPatientLaboratoryTests(_patientId!);
      
      if (mounted) {
        setState(() {
          _diagnoses = diagnosesResult;
          _prescriptions = prescriptionsResult;
          _laboratoryTests = testsResult;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading patient data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _loadDoctorPatients() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final patients = await FirestoreService.getDoctorPatients(_doctorId);
      
      if (mounted) {
        setState(() {
          _patientsList = patients.map((patient) => {
            'id': patient.id,
            'name': patient.name,
            'email': patient.email,
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading doctor patients: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading patients: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _selectPatient(Map<String, dynamic> patient) {
    setState(() {
      _patientId = patient['id'];
      _patientName = patient['name'];
      _isPatientSelected = true;
    });
    _loadPatientData();
  }
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMainContent(isMobile: true),
      tablet: _buildMainContent(isMobile: false),
      desktop: Row(
        children: [
          AppSidebar(
            currentPath: '/doctor',
            userRole: 'medicalPersonnel',
            userName: _doctorName.isNotEmpty ? _doctorName : 'Doctor',
          ),
          Expanded(
            child: _buildMainContent(isMobile: false),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent({required bool isMobile}) {
    if (!_isPatientSelected) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Clinical Records'),
        ),
        body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildPatientSelectionScreen(),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${_patientName}\'s Clinical File'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Diagnoses'),
            Tab(text: 'Prescriptions'),
            Tab(text: 'Lab Tests'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabController.index == 0) {
            _addDiagnosis();
          } else if (_tabController.index == 1) {
            _addPrescription();
          } else {
            _addLaboratoryTest();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildDiagnosesTab(),
                _buildPrescriptionsTab(),
                _buildLaboratoryTestsTab(),
              ],
            ),
    );
  }
  
  Widget _buildPatientSelectionScreen() {
    if (_patientsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            const Text(
              'No patients assigned to you',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please contact an administrator to assign patients to you',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a Patient',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose a patient to view or manage their clinical records',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: _patientsList.length,
              itemBuilder: (context, index) {
                final patient = _patientsList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(
                        patient['name'][0],
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(patient['name']),
                    subtitle: Text(patient['email']),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _selectPatient(patient),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiagnosesTab() {
    if (_diagnoses.isEmpty) {
      return _buildEmptyState('No diagnoses found for this patient');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _diagnoses.length,
      itemBuilder: (context, index) {
        final diagnosis = _diagnoses[index];
        return _buildDiagnosisCard(diagnosis);
      },
    );
  }
  
  Widget _buildPrescriptionsTab() {
    if (_prescriptions.isEmpty) {
      return _buildEmptyState('No prescriptions found for this patient');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _prescriptions.length,
      itemBuilder: (context, index) {
        final prescription = _prescriptions[index];
        return _buildPrescriptionCard(prescription);
      },
    );
  }
  
  Widget _buildLaboratoryTestsTab() {
    if (_laboratoryTests.isEmpty) {
      return _buildEmptyState('No laboratory tests found for this patient');
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _laboratoryTests.length,
      itemBuilder: (context, index) {
        final test = _laboratoryTests[index];
        return _buildLaboratoryTestCard(test);
      },
    );
  }
  
  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text('Add ${_tabController.index == 0 ? 'Diagnosis' : _tabController.index == 1 ? 'Prescription' : 'Laboratory Test'}'),
            onPressed: () {
              if (_tabController.index == 0) {
                _addDiagnosis();
              } else if (_tabController.index == 1) {
                _addPrescription();
              } else {
                _addLaboratoryTest();
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiagnosisCard(Diagnosis diagnosis) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    diagnosis.type,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _dateFormat.format(diagnosis.date),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              diagnosis.description,
              style: const TextStyle(fontSize: 16),
            ),
            if (diagnosis.notes != null && diagnosis.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Notes:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(diagnosis.notes!),
            ],
            const SizedBox(height: 16),
            Text(
              'Added by: ${diagnosis.doctorName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (diagnosis.doctorId == _doctorId) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () => _editDiagnosis(diagnosis),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => _deleteDiagnosis(diagnosis),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPrescriptionCard(Prescription prescription) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    prescription.medicationName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _dateFormat.format(prescription.date),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Dosage: ${prescription.dosage}'),
            Text('Frequency: ${prescription.frequency}'),
            if (prescription.duration != null) 
              Text('Duration: ${prescription.duration} days'),
            if (prescription.instructions != null && prescription.instructions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Instructions:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(prescription.instructions!),
            ],
            const SizedBox(height: 16),
            Text(
              'Prescribed by: ${prescription.doctorName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (prescription.doctorId == _doctorId) ...[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () => _editPrescription(prescription),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => _deletePrescription(prescription),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLaboratoryTestCard(LaboratoryTest test) {
    Color statusColor;
    IconData statusIcon;
    
    switch (test.status) {
      case 'ordered':
        statusColor = Colors.blue;
        statusIcon = Icons.pending;
        break;
      case 'completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    test.testName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        test.status.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Type: ${test.testType}'),
            Text('Ordered on: ${_dateFormat.format(test.date)}'),
            if (test.resultDate != null) 
              Text('Results date: ${_dateFormat.format(test.resultDate!)}'),
            if (test.results != null && test.results!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Results:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(test.results!),
            ],
            if (test.notes != null && test.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Notes:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(test.notes!),
            ],
            const SizedBox(height: 16),
            Text(
              'Ordered by: ${test.doctorName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (test.doctorId == _doctorId) ...[
                  if (test.status == 'ordered') ...[
                    TextButton.icon(
                      icon: const Icon(Icons.science),
                      label: const Text('Add Results'),
                      onPressed: () => _addTestResults(test),
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit',
                    onPressed: () => _editLaboratoryTest(test),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete',
                    onPressed: () => _deleteLaboratoryTest(test),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void _addDiagnosis() {
    if (_patientId == null) return;
    
    final typeController = TextEditingController();
    final descriptionController = TextEditingController();
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Diagnosis'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: typeController,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  hintText: 'e.g., Hypertension',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter detailed description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Any additional notes',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (typeController.text.isEmpty || descriptionController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }
              
              final diagnosis = Diagnosis(
                id: const Uuid().v4(),
                patientId: _patientId!,
                patientName: _patientName,
                doctorId: _doctorId,
                doctorName: _doctorName,
                type: typeController.text,
                description: descriptionController.text,
                date: DateTime.now(),
                notes: notesController.text.isNotEmpty ? notesController.text : null,
              );
              
              Navigator.pop(context);
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                await ClinicalService.addDiagnosis(diagnosis);
                
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Diagnosis added successfully')),
                  );
                  _loadPatientData(); // Refresh data
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  void _addPrescription() {
    if (_patientId == null) return;
    
    final medicationController = TextEditingController();
    final dosageController = TextEditingController();
    final frequencyController = TextEditingController();
    final durationController = TextEditingController();
    final instructionsController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Prescription'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicationController,
                decoration: const InputDecoration(
                  labelText: 'Medication',
                  hintText: 'e.g., Amoxicillin',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  hintText: 'e.g., 500mg',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  hintText: 'e.g., Twice daily',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (days)',
                  hintText: 'e.g., 7',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Instructions (Optional)',
                  hintText: 'e.g., Take with food',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (medicationController.text.isEmpty || 
                  dosageController.text.isEmpty || 
                  frequencyController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }
              
              // Try to parse duration to int
              int? duration;
              if (durationController.text.isNotEmpty) {
                duration = int.tryParse(durationController.text);
              }
              
              final prescription = Prescription(
                id: const Uuid().v4(),
                patientId: _patientId!,
                patientName: _patientName,
                doctorId: _doctorId,
                doctorName: _doctorName,
                medicationName: medicationController.text,
                dosage: dosageController.text,
                frequency: frequencyController.text,
                date: DateTime.now(),
                duration: duration,
                instructions: instructionsController.text.isNotEmpty ? instructionsController.text : null,
              );
              
              Navigator.pop(context);
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                await ClinicalService.addPrescription(prescription);
                
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Prescription added successfully')),
                  );
                  _loadPatientData(); // Refresh data
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
  
  void _addLaboratoryTest() {
    if (_patientId == null) return;
    
    final testNameController = TextEditingController();
    final testTypeController = TextEditingController();
    final notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Laboratory Test'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: testNameController,
                decoration: const InputDecoration(
                  labelText: 'Test Name',
                  hintText: 'e.g., Complete Blood Count',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: testTypeController,
                decoration: const InputDecoration(
                  labelText: 'Test Type',
                  hintText: 'e.g., Blood Test',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Any specific instructions',
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (testNameController.text.isEmpty || testTypeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all required fields')),
                );
                return;
              }
              
              final test = LaboratoryTest(
                id: const Uuid().v4(),
                patientId: _patientId!,
                patientName: _patientName,
                doctorId: _doctorId,
                doctorName: _doctorName,
                testName: testNameController.text,
                testType: testTypeController.text,
                date: DateTime.now(),
                status: 'ordered',
                notes: notesController.text.isNotEmpty ? notesController.text : null,
              );
              
              Navigator.pop(context);
              
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              try {
                await ClinicalService.addLaboratoryTest(test);
                
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Laboratory test ordered successfully')),
                  );
                  _loadPatientData(); // Refresh data
                }
              } catch (e) {
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Order Test'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _editDiagnosis(Diagnosis diagnosis) async {
    final TextEditingController typeController = TextEditingController(text: diagnosis.type);
    final TextEditingController descriptionController = TextEditingController(text: diagnosis.description);
    final TextEditingController notesController = TextEditingController(text: diagnosis.notes ?? '');
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Diagnosis'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: typeController,
                  decoration: const InputDecoration(
                    labelText: 'Diagnosis Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (typeController.text.isEmpty || descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Type and description are required')),
                  );
                  return;
                }
                
                Navigator.pop(context, {
                  'type': typeController.text,
                  'description': descriptionController.text,
                  'notes': notesController.text,
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
    
    if (result == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final updatedDiagnosis = diagnosis.copyWith(
        type: result['type'],
        description: result['description'],
        notes: result['notes']!.isNotEmpty ? result['notes'] : null,
      );
      
      final success = await ClinicalService.updateDiagnosis(updatedDiagnosis);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnosis updated successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update diagnosis')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error updating diagnosis: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _deleteDiagnosis(Diagnosis diagnosis) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Diagnosis'),
          content: const Text('Are you sure you want to delete this diagnosis? This action cannot be undone.'),
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
    
    if (confirm != true) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await ClinicalService.deleteDiagnosis(diagnosis.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Diagnosis deleted successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete diagnosis')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error deleting diagnosis: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _editPrescription(Prescription prescription) async {
    final TextEditingController medicationController = TextEditingController(text: prescription.medicationName);
    final TextEditingController dosageController = TextEditingController(text: prescription.dosage);
    final TextEditingController frequencyController = TextEditingController(text: prescription.frequency);
    final TextEditingController durationController = TextEditingController(
      text: prescription.duration?.toString() ?? '',
    );
    final TextEditingController instructionsController = TextEditingController(
      text: prescription.instructions ?? '',
    );
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Prescription'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: medicationController,
                  decoration: const InputDecoration(
                    labelText: 'Medication Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: frequencyController,
                  decoration: const InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration (days, optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Instructions (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (medicationController.text.isEmpty || 
                    dosageController.text.isEmpty || 
                    frequencyController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Medication, dosage, and frequency are required')),
                  );
                  return;
                }
                
                Navigator.pop(context, {
                  'medication': medicationController.text,
                  'dosage': dosageController.text,
                  'frequency': frequencyController.text,
                  'duration': durationController.text,
                  'instructions': instructionsController.text,
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
    
    if (result == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      int? duration;
      if (result['duration'] != null && result['duration']!.isNotEmpty) {
        duration = int.tryParse(result['duration']!);
      }
      
      final updatedPrescription = prescription.copyWith(
        medicationName: result['medication'],
        dosage: result['dosage'],
        frequency: result['frequency'],
        duration: duration,
        instructions: result['instructions']!.isNotEmpty ? result['instructions'] : null,
      );
      
      final success = await ClinicalService.updatePrescription(updatedPrescription);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription updated successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update prescription')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error updating prescription: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _deletePrescription(Prescription prescription) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Prescription'),
          content: const Text('Are you sure you want to delete this prescription? This action cannot be undone.'),
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
    
    if (confirm != true) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await ClinicalService.deletePrescription(prescription.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription deleted successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete prescription')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error deleting prescription: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _editLaboratoryTest(LaboratoryTest test) async {
    final TextEditingController testNameController = TextEditingController(text: test.testName);
    final TextEditingController testTypeController = TextEditingController(text: test.testType);
    final TextEditingController notesController = TextEditingController(text: test.notes ?? '');
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Laboratory Test'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: testNameController,
                  decoration: const InputDecoration(
                    labelText: 'Test Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: testTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Test Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (testNameController.text.isEmpty || testTypeController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test name and type are required')),
                  );
                  return;
                }
                
                Navigator.pop(context, {
                  'testName': testNameController.text,
                  'testType': testTypeController.text,
                  'notes': notesController.text,
                });
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
    
    if (result == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final updatedTest = test.copyWith(
        testName: result['testName'],
        testType: result['testType'],
        notes: result['notes']!.isNotEmpty ? result['notes'] : null,
      );
      
      final success = await ClinicalService.updateLaboratoryTest(updatedTest);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laboratory test updated successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update laboratory test')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error updating laboratory test: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _deleteLaboratoryTest(LaboratoryTest test) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Laboratory Test'),
          content: const Text('Are you sure you want to delete this laboratory test? This action cannot be undone.'),
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
    
    if (confirm != true) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await ClinicalService.deleteLaboratoryTest(test.id);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Laboratory test deleted successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete laboratory test')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error deleting laboratory test: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _addTestResults(LaboratoryTest test) async {
    final TextEditingController resultsController = TextEditingController();
    final TextEditingController notesController = TextEditingController(text: test.notes ?? '');
    
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Test Results'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  test.testName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: resultsController,
                  decoration: const InputDecoration(
                    labelText: 'Test Results',
                    border: OutlineInputBorder(),
                    hintText: 'Enter the test results here',
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Additional notes or interpretation',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (resultsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Test results are required')),
                  );
                  return;
                }
                
                Navigator.pop(context, {
                  'results': resultsController.text,
                  'notes': notesController.text,
                });
              },
              child: const Text('Save Results'),
            ),
          ],
        );
      },
    );
    
    if (result == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await ClinicalService.updateTestResults(
        test.id,
        result['results']!,
        notes: result['notes']!.isNotEmpty ? result['notes'] : null,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test results added successfully')),
        );
        _loadPatientData();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add test results')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error adding test results: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 