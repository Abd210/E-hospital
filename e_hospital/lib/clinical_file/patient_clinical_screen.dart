import 'package:flutter/material.dart';
import 'package:e_hospital/clinical_file/clinical_models.dart';
import 'package:e_hospital/clinical_file/clinical_service.dart';
import 'package:e_hospital/core/widgets/app_sidebar.dart';
import 'package:e_hospital/core/widgets/responsive_layout.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class PatientClinicalScreen extends StatefulWidget {
  const PatientClinicalScreen({Key? key}) : super(key: key);

  @override
  State<PatientClinicalScreen> createState() => _PatientClinicalScreenState();
}

class _PatientClinicalScreenState extends State<PatientClinicalScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  final _dateFormat = DateFormat('MMM d, yyyy');
  
  // Data
  List<Diagnosis> _diagnoses = [];
  List<Prescription> _prescriptions = [];
  List<LaboratoryTest> _laboratoryTests = [];
  
  // User info
  String _patientId = '';
  String _patientName = '';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getCurrentPatient();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _getCurrentPatient() async {
    final user = auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _patientId = user.uid;
        _patientName = user.displayName ?? 'Unknown Patient';
      });
      await _loadPatientData();
    }
  }
  
  Future<void> _loadPatientData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load diagnoses and prescriptions in parallel
      final diagnosesResult = await ClinicalService.getPatientDiagnoses(_patientId);
      final prescriptionsResult = await ClinicalService.getPatientPrescriptions(_patientId);
      final testsResult = await ClinicalService.getPatientLaboratoryTests(_patientId);
      
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
  
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMainContent(isMobile: true),
      tablet: _buildMainContent(isMobile: false),
      desktop: Row(
        children: [
          AppSidebar(
            currentPath: '/patient/records',
            userRole: 'patient',
            userName: _patientName,
          ),
          Expanded(
            child: _buildMainContent(isMobile: false),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMainContent({required bool isMobile}) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Clinical Records'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Diagnoses'),
            Tab(text: 'Prescriptions'),
            Tab(text: 'Lab Tests'),
          ],
        ),
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
  
  Widget _buildDiagnosesTab() {
    if (_diagnoses.isEmpty) {
      return _buildEmptyState('No diagnoses found');
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
      return _buildEmptyState('No prescriptions found');
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
      return _buildEmptyState('No laboratory tests found');
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
          Text(
            'Your doctor will add information when available.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
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
          ],
        ),
      ),
    );
  }
} 