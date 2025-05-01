import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class MedicDashboard extends StatefulWidget {
  const MedicDashboard({super.key});

  @override
  State<MedicDashboard> createState() => _MedicDashboardState();
}

class _MedicDashboardState extends State<MedicDashboard> with SingleTickerProviderStateMixin {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late TabController _tabController;
  List<Map<String, dynamic>> _assignedPatients = [];
  List<String> _assignedPatientIds = [];
  Map<String, dynamic>? _currentUserData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Load current medical personnel data
      final userDoc = await _db.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        setState(() => _isLoading = false);
        return;
      }

      final userData = userDoc.data() ?? {};
      _assignedPatientIds = List<String>.from(userData['assignedPatientIds'] ?? []);
      
      // Load assigned patient details
      final patients = <Map<String, dynamic>>[];
      
      for (final patientId in _assignedPatientIds) {
        try {
          final patientDoc = await _db.collection('users').doc(patientId).get();
          if (patientDoc.exists) {
            final data = patientDoc.data() ?? {};
            patients.add({
              'id': patientDoc.id,
              'name': data['name'] ?? data['email']?.split('@').first ?? 'Unknown',
              'email': data['email'] ?? 'No email',
              'medicalCondition': data['medicalCondition'] ?? 'Not specified',
              'bloodType': data['bloodType'] ?? 'Unknown',
              'lastCheckup': data['lastCheckup'] ?? 'Not available',
              'vitals': data['vitals'] ?? {
                'heartRate': '72 bpm',
                'bloodPressure': '120/80 mmHg',
                'temperature': '36.6 °C',
                'oxygenSaturation': '98%',
              },
              'treatments': data['treatments'] ?? [],
              'diagnostics': data['diagnostics'] ?? [],
              'lastUpdated': data['lastUpdated'] ?? DateTime.now().toString(),
            });
          }
        } catch (e) {
          debugPrint('Error loading patient $patientId: $e');
        }
      }
      
      setState(() {
        _currentUserData = userData;
        _assignedPatients = patients;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() => _isLoading = false);
    }
  }

  void _signOut() async {
    await _auth.signOut();
    if (mounted) {
      context.go('/login');
    }
  }
  
  Future<void> _updatePatientDiagnostic(String patientId) async {
    final TextEditingController diagnosticController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Diagnostic'),
        content: TextField(
          controller: diagnosticController,
          decoration: const InputDecoration(
            labelText: 'Diagnostic',
            hintText: 'Enter medical diagnostic',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final diagnostic = diagnosticController.text.trim();
              if (diagnostic.isEmpty) return;
              
              Navigator.pop(context);
              
              try {
                final patientDoc = await _db.collection('users').doc(patientId).get();
                final data = patientDoc.data() ?? {};
                final List<dynamic> currentDiagnostics = List.from(data['diagnostics'] ?? []);
                
                currentDiagnostics.add({
                  'description': diagnostic,
                  'date': DateTime.now().toIso8601String(),
                  'doctorId': _auth.currentUser?.uid,
                  'doctorName': _currentUserData?['name'] ?? 'Unknown Doctor',
                });
                
                await _db.collection('users').doc(patientId).update({
                  'diagnostics': currentDiagnostics,
                  'medicalCondition': diagnostic,
                  'lastUpdated': DateTime.now().toString(),
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Diagnostic updated successfully')),
                );
                
                _loadUserInfo();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating diagnostic: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _addTreatment(String patientId) async {
    final TextEditingController treatmentController = TextEditingController();
    final TextEditingController medicationController = TextEditingController();
    final TextEditingController dosageController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prescribe Treatment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: treatmentController,
                decoration: const InputDecoration(
                  labelText: 'Treatment Plan',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: medicationController,
                decoration: const InputDecoration(
                  labelText: 'Medication',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage & Frequency',
                  hintText: 'e.g., 500mg 3x daily',
                  border: OutlineInputBorder(),
                ),
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
              final treatment = treatmentController.text.trim();
              final medication = medicationController.text.trim();
              final dosage = dosageController.text.trim();
              
              if (treatment.isEmpty || medication.isEmpty || dosage.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All fields are required')),
                );
                return;
              }
              
              Navigator.pop(context);
              
              try {
                final patientDoc = await _db.collection('users').doc(patientId).get();
                final data = patientDoc.data() ?? {};
                final List<dynamic> currentTreatments = List.from(data['treatments'] ?? []);
                
                currentTreatments.add({
                  'description': treatment,
                  'medication': medication,
                  'dosage': dosage,
                  'date': DateTime.now().toIso8601String(),
                  'doctorId': _auth.currentUser?.uid,
                  'doctorName': _currentUserData?['name'] ?? 'Unknown Doctor',
                });
                
                await _db.collection('users').doc(patientId).update({
                  'treatments': currentTreatments,
                  'lastUpdated': DateTime.now().toString(),
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Treatment added successfully')),
                );
                
                _loadUserInfo();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding treatment: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _viewPatientClinicalFile(String patientId) async {
    final patient = _assignedPatients.firstWhere((p) => p['id'] == patientId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${patient['name']}\'s Clinical File'),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: ListView(
            shrinkWrap: true,
            children: [
              _infoTile('Full Name', patient['name']),
              _infoTile('Email', patient['email']),
              _infoTile('Medical Condition', patient['medicalCondition']),
              _infoTile('Blood Type', patient['bloodType']),
              _infoTile('Last Updated', patient['lastUpdated']),
              
              const Divider(),
              const Text('Vitals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              
              if (patient['vitals'] != null && patient['vitals'] is Map && (patient['vitals'] as Map).isNotEmpty) ...[
                _infoTile('Heart Rate', patient['vitals']['heartRate'] ?? 'N/A'),
                _infoTile('Blood Pressure', patient['vitals']['bloodPressure'] ?? 'N/A'),
                _infoTile('Temperature', patient['vitals']['temperature'] ?? 'N/A'),
                _infoTile('Oxygen Saturation', patient['vitals']['oxygenSaturation'] ?? 'N/A'),
              ] else
                const Text('No vitals information available'),
              
              const Divider(),
              const Text('Diagnostics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              
              if (patient['diagnostics'] != null && patient['diagnostics'] is List && (patient['diagnostics'] as List).isNotEmpty)
                ...List.generate((patient['diagnostics'] as List).length, (index) {
                  final diagnostic = (patient['diagnostics'] as List)[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${diagnostic['description']}'),
                          Text('Date: ${diagnostic['date']}'),
                          Text('Doctor: ${diagnostic['doctorName']}'),
                        ],
                      ),
                    ),
                  );
                })
              else
                const Text('No diagnostic information available'),
                
              const Divider(),
              const Text('Treatments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              
              if (patient['treatments'] != null && patient['treatments'] is List && (patient['treatments'] as List).isNotEmpty)
                ...List.generate((patient['treatments'] as List).length, (index) {
                  final treatment = (patient['treatments'] as List)[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Medication: ${treatment['medication']}'),
                          Text('Dosage: ${treatment['dosage']}'),
                          Text('Description: ${treatment['description']}'),
                          Text('Date: ${treatment['date']}'),
                          Text('Doctor: ${treatment['doctorName']}'),
                        ],
                      ),
                    ),
                  );
                })
              else
                const Text('No treatment information available'),
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
  
  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$title:',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard: ${_currentUserData?['name'] ?? 'Loading...'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUserInfo,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Assigned Patients'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildAssignedPatientsTab(),
                _buildProfileTab(),
              ],
            ),
    );
  }

  Widget _buildAssignedPatientsTab() {
    return _assignedPatients.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'No patients assigned to you yet',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                Text(
                  'The hospital administrator will assign patients to you',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _assignedPatients.length,
            itemBuilder: (context, index) {
              final patient = _assignedPatients[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  title: Text(patient['name']),
                  subtitle: Text('Medical Condition: ${patient['medicalCondition']}'),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoTile('Blood Type', patient['bloodType']),
                          const SizedBox(height: 16),
                          
                          // Vitals section
                          const Text(
                            'Latest Vitals',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (patient['vitals'] != null && (patient['vitals'] as Map).isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                children: [
                                  _buildVitalRow(
                                    icon: Icons.favorite,
                                    label: 'Heart Rate',
                                    value: patient['vitals']['heartRate'] ?? 'N/A',
                                  ),
                                  _buildVitalRow(
                                    icon: Icons.speed,
                                    label: 'Blood Pressure',
                                    value: patient['vitals']['bloodPressure'] ?? 'N/A',
                                  ),
                                  _buildVitalRow(
                                    icon: Icons.thermostat,
                                    label: 'Temperature',
                                    value: patient['vitals']['temperature'] ?? 'N/A',
                                  ),
                                  _buildVitalRow(
                                    icon: Icons.air,
                                    label: 'O₂ Saturation',
                                    value: patient['vitals']['oxygenSaturation'] ?? 'N/A',
                                    isLast: true,
                                  ),
                                ],
                              ),
                            )
                          else
                            const Text('No vitals available'),
                          
                          const SizedBox(height: 24),
                          
                          // Action buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildActionButton(
                                label: 'View Clinical File',
                                icon: Icons.visibility,
                                onPressed: () => _viewPatientClinicalFile(patient['id']),
                              ),
                              _buildActionButton(
                                label: 'Update Diagnostic',
                                icon: Icons.medical_information,
                                onPressed: () => _updatePatientDiagnostic(patient['id']),
                              ),
                              _buildActionButton(
                                label: 'Add Treatment',
                                icon: Icons.medication,
                                onPressed: () => _addTreatment(patient['id']),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildVitalRow({
    required IconData icon,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 22, color: Colors.blue.shade700),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Divider(color: Colors.blue.shade200, height: 1),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
    );
  }

  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 60,
            backgroundColor: Colors.blue,
            child: Icon(Icons.medical_services, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            _currentUserData?['name'] ?? 'Loading...',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _currentUserData?['email'] ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Medical Personnel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Assigned Patients',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Total: ${_assignedPatients.length}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.assignment),
                    title: Text('View Recent Diagnostics'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.medication),
                    title: Text('Prescribed Treatments'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
