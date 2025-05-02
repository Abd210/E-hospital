import 'package:flutter/material.dart';
import 'package:e_hospital/models/clinical_model.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class PatientMedicalRecordsScreen extends StatefulWidget {
  const PatientMedicalRecordsScreen({Key? key}) : super(key: key);

  @override
  State<PatientMedicalRecordsScreen> createState() => _PatientMedicalRecordsScreenState();
}

class _PatientMedicalRecordsScreenState extends State<PatientMedicalRecordsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  ClinicalFile? _clinicalFile;
  String _patientId = '';
  final _dateFormat = DateFormat('MMM d, yyyy');
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMedicalRecords();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMedicalRecords() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Get current user ID
      final currentUser = auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not logged in');
      }
      
      _patientId = currentUser.uid;
      
      // Get clinical file
      _clinicalFile = await FirestoreService.getClinicalFileByPatientId(_patientId);
      
    } catch (e) {
      debugPrint('Error loading medical records: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading medical records: $e')),
      );
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
      appBar: AppBar(
        title: const Text('My Clinical File'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Diagnostics'),
            Tab(text: 'Treatments'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clinicalFile == null
              ? _buildNoClinicalFile()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildDiagnosticsTab(),
                    _buildTreatmentsTab(),
                  ],
                ),
    );
  }
  
  Widget _buildNoClinicalFile() {
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
          const Text(
            'No Medical Records Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your doctor will create your medical records when you visit.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Name', _clinicalFile!.patientName),
                  if (_clinicalFile!.medicalCondition != null)
                    _buildInfoRow('Medical Condition', _clinicalFile!.medicalCondition!),
                  if (_clinicalFile!.bloodType != null)
                    _buildInfoRow('Blood Type', _clinicalFile!.bloodType!),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          if (_clinicalFile!.vitals != null) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vital Signs',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildVitalsInfo(_clinicalFile!.vitals!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          if (_clinicalFile!.dischargeSummary != null) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Discharge Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Date: ${_dateFormat.format(_clinicalFile!.dischargeSummary!.dischargeDate)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Final Diagnosis', _clinicalFile!.dischargeSummary!.finalDiagnosis),
                    _buildInfoRow('Summary', _clinicalFile!.dischargeSummary!.summary),
                    _buildInfoRow('Follow Up Instructions', _clinicalFile!.dischargeSummary!.followUpInstructions),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          _buildSummaryCard(
            title: 'Diagnostics',
            count: _clinicalFile!.diagnostics.length,
            icon: Icons.medical_information_outlined,
            color: Colors.blue,
            onTap: () {
              _tabController.animateTo(1);
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildSummaryCard(
            title: 'Treatments',
            count: _clinicalFile!.treatments.length,
            icon: Icons.healing_outlined,
            color: Colors.green,
            onTap: () {
              _tabController.animateTo(2);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$count ${count == 1 ? 'record' : 'records'}',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildVitalsInfo(Map<String, dynamic> vitals) {
    return Column(
      children: [
        Row(
          children: [
            _buildVitalCard(
              title: 'Temperature',
              value: vitals['temperature']?.toString() ?? 'N/A',
              unit: '°C',
              icon: Icons.thermostat_outlined,
              color: Colors.orange,
            ),
            const SizedBox(width: 16),
            _buildVitalCard(
              title: 'Heart Rate',
              value: vitals['heartRate']?.toString() ?? 'N/A',
              unit: 'bpm',
              icon: Icons.favorite_border,
              color: Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildVitalCard(
              title: 'Blood Pressure',
              value: vitals['bloodPressure']?.toString() ?? 'N/A',
              unit: 'mmHg',
              icon: Icons.speed_outlined,
              color: Colors.purple,
            ),
            const SizedBox(width: 16),
            _buildVitalCard(
              title: 'Oxygen Level',
              value: vitals['oxygenLevel']?.toString() ?? 'N/A',
              unit: '%',
              icon: Icons.air_outlined,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildVitalCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$value $unit',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDiagnosticsTab() {
    final diagnostics = _clinicalFile!.diagnostics;
    
    if (diagnostics.isEmpty) {
      return const Center(
        child: Text('No diagnostics found'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diagnostics.length,
      itemBuilder: (context, index) {
        final diagnostic = diagnostics[index];
        
        return Card(
          elevation: 2,
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
                        diagnostic.description,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _dateFormat.format(diagnostic.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (diagnostic.symptoms != null && diagnostic.symptoms!.isNotEmpty) ...[
                  const Text(
                    'Symptoms:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(diagnostic.symptoms!.join(', ')),
                  const SizedBox(height: 8),
                ],
                if (diagnostic.notes != null && diagnostic.notes!.isNotEmpty) ...[
                  const Text(
                    'Notes:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(diagnostic.notes!),
                  const SizedBox(height: 8),
                ],
                Text(
                  'Diagnosed by: ${diagnostic.doctorName}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildTreatmentsTab() {
    final treatments = _clinicalFile!.treatments;
    
    if (treatments.isEmpty) {
      return const Center(
        child: Text('No treatments found'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: treatments.length,
      itemBuilder: (context, index) {
        final treatment = treatments[index];
        
        return Card(
          elevation: 2,
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
                        treatment.medication,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Chip(
                      label: Text(
                        treatment.isCompleted == true ? 'Completed' : 'Active',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: treatment.isCompleted == true ? Colors.blue : Colors.green,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildInfoRow('Date', _dateFormat.format(treatment.date)),
                if (treatment.startDate != null)
                  _buildInfoRow('Start Date', _dateFormat.format(treatment.startDate!)),
                _buildInfoRow('Description', treatment.description),
                if (treatment.notes != null && treatment.notes!.isNotEmpty)
                  _buildInfoRow('Notes', treatment.notes!),
                _buildInfoRow('Administered By', treatment.doctorName),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
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
} 