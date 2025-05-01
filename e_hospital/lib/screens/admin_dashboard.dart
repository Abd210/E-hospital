import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> with SingleTickerProviderStateMixin {
  final _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _patients = [];
  bool _isLoading = true;
  late TabController _tabController;
  
  final _newDoctorEmailController = TextEditingController();
  final _newDoctorPasswordController = TextEditingController();
  final _newDoctorNameController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUsers();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _newDoctorEmailController.dispose();
    _newDoctorPasswordController.dispose();
    _newDoctorNameController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final snapshot = await _db.collection('users').get();
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'email': data['email'] ?? 'No email',
          'role': data['role'] ?? 'patient',
          'name': data['name'] ?? data['email']?.split('@').first ?? 'Unknown',
          'assignedPatientIds': data['assignedPatientIds'] ?? [],
          'medicalCondition': data['medicalCondition'] ?? 'Unknown',
          'bloodType': data['bloodType'] ?? 'Unknown',
          'vitals': data['vitals'] ?? {},
          'diagnostics': data['diagnostics'] ?? [],
          'treatments': data['treatments'] ?? [],
          'lastUpdated': data['lastUpdated'] ?? DateTime.now().toString(),
        };
      }).toList();
      
      final doctors = users.where((user) => user['role'] == 'medicalPersonnel').toList();
      final patients = users.where((user) => user['role'] == 'patient').toList();
      
      setState(() {
        _users = users;
        _doctors = doctors;
        _patients = patients;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading users: $e');
      setState(() {
        _users = [];
        _doctors = [];
        _patients = [];
        _isLoading = false;
      });
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      context.go('/login');
    }
  }
  
  Future<void> _addNewDoctor() async {
    final email = _newDoctorEmailController.text.trim();
    final password = _newDoctorPasswordController.text.trim();
    final name = _newDoctorNameController.text.trim();
    
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      // Create user with email and password
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Add user data to Firestore
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'role': 'medicalPersonnel',
        'assignedPatientIds': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medical personnel added successfully')),
      );
      
      // Clear form fields
      _newDoctorEmailController.clear();
      _newDoctorPasswordController.clear();
      _newDoctorNameController.clear();
      
      // Reload user list
      _loadUsers();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating medical personnel: $e')),
      );
      setState(() => _isLoading = false);
    }
  }
  
  Future<void> _assignPatientToDoctor(String doctorId, String patientId) async {
    try {
      // Get current assigned patients
      final doctorDoc = await _db.collection('users').doc(doctorId).get();
      final List<dynamic> currentPatients = doctorDoc.data()?['assignedPatientIds'] ?? [];
      
      // Add patient if not already assigned
      if (!currentPatients.contains(patientId)) {
        await _db.collection('users').doc(doctorId).update({
          'assignedPatientIds': [...currentPatients, patientId],
          'lastUpdated': DateTime.now().toString(),
        });
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient assigned successfully')),
      );
      
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error assigning patient: $e')),
      );
    }
  }
  
  Future<void> _updatePatientRecord(String patientId) async {
    final patient = _patients.firstWhere((p) => p['id'] == patientId);
    
    TextEditingController medicalConditionController = TextEditingController(text: patient['medicalCondition']);
    TextEditingController bloodTypeController = TextEditingController(text: patient['bloodType']);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${patient['name']}\'s Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: medicalConditionController,
                decoration: const InputDecoration(labelText: 'Medical Condition'),
              ),
              TextField(
                controller: bloodTypeController,
                decoration: const InputDecoration(labelText: 'Blood Type'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _db.collection('users').doc(patientId).update({
                  'medicalCondition': medicalConditionController.text,
                  'bloodType': bloodTypeController.text,
                  'lastUpdated': DateTime.now().toString(),
                });
                _loadUsers();
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Patient record updated')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating patient record: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  Map<String, dynamic>? _getPatientById(String patientId) {
    try {
      return _patients.firstWhere((p) => p['id'] == patientId);
    } catch (e) {
      return null;
    }
  }
  
  Future<void> _viewPatientRecords(String patientId) async {
    final patient = _patients.firstWhere((p) => p['id'] == patientId);
    
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
  
  Future<void> _viewDoctorPatients(String doctorId) async {
    final doctor = _doctors.firstWhere((d) => d['id'] == doctorId);
    final assignedPatientIds = doctor['assignedPatientIds'] as List;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${doctor['name']}\'s Patients'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: assignedPatientIds.isEmpty
              ? const Center(child: Text('No patients assigned'))
              : ListView.builder(
                  itemCount: assignedPatientIds.length,
                  itemBuilder: (context, index) {
                    final patientId = assignedPatientIds[index];
                    final patient = _getPatientById(patientId);
                    
                    if (patient == null) {
                      return ListTile(
                        title: Text('Unknown Patient (ID: $patientId)'),
                        subtitle: const Text('Patient not found'),
                      );
                    }
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(patient['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Condition: ${patient['medicalCondition']}'),
                            Text('Blood Type: ${patient['bloodType']}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.visibility),
                          onPressed: () {
                            Navigator.pop(context); // Close current dialog
                            _viewPatientRecords(patient['id']);
                          },
                        ),
                      ),
                    );
                  },
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
        title: const Text('Hospital Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Medical Personnel'),
            Tab(text: 'Patients'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Overview Tab
                _buildOverviewTab(),
                
                // Medical Personnel Tab
                _buildMedicalPersonnelTab(),
                
                // Patients Tab
                _buildPatientsTab(),
              ],
            ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hospital Statistics',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Patients',
                  value: _patients.length.toString(),
                  icon: Icons.people,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  title: 'Medical Personnel',
                  value: _doctors.length.toString(),
                  icon: Icons.medical_services,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _patients.length > 5 ? 5 : _patients.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final patient = _patients[index];
                return ListTile(
                  title: Text(patient['name']),
                  subtitle: Text('Last updated: ${patient['lastUpdated']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => _viewPatientRecords(patient['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalPersonnelTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Medical Personnel',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newDoctorNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newDoctorEmailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newDoctorPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addNewDoctor,
                    child: const Text('Add Medical Personnel'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'All Medical Personnel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _doctors.isEmpty 
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No medical personnel found')),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = _doctors[index];
                    final assignedPatients = (doctor['assignedPatientIds'] as List).length;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        title: Text(doctor['name']),
                        subtitle: Text('Email: ${doctor['email']} | Patients: $assignedPatients'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.people),
                                      label: const Text('View Patients'),
                                      onPressed: () => _viewDoctorPatients(doctor['id']),
                                    ),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.person_add),
                                      label: const Text('Assign Patient'),
                                      onPressed: () => _showAssignPatientDialog(doctor['id']),
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
                ),
        ],
      ),
    );
  }

  Widget _buildPatientsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Patients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _patients.isEmpty
              ? const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No patients found')),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _patients.length,
                  itemBuilder: (context, index) {
                    final patient = _patients[index];
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ExpansionTile(
                        title: Text(patient['name']),
                        subtitle: Text('Condition: ${patient['medicalCondition']}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _infoTile('Email', patient['email']),
                                _infoTile('Blood Type', patient['bloodType']),
                                _infoTile('Last Updated', patient['lastUpdated']),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.visibility),
                                      label: const Text('View Clinical File'),
                                      onPressed: () => _viewPatientRecords(patient['id']),
                                    ),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Update Record'),
                                      onPressed: () => _updatePatientRecord(patient['id']),
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
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(
                  icon,
                  color: color,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignPatientDialog(String doctorId) {
    final doctor = _doctors.firstWhere((d) => d['id'] == doctorId);
    final assignedPatientIds = doctor['assignedPatientIds'] as List;
    final unassignedPatients = _patients.where((p) => !assignedPatientIds.contains(p['id'])).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Patient to ${doctor['name']}'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: unassignedPatients.isEmpty
              ? const Center(child: Text('No unassigned patients available'))
              : ListView.builder(
                  itemCount: unassignedPatients.length,
                  itemBuilder: (context, index) {
                    final patient = unassignedPatients[index];
                    return ListTile(
                      title: Text(patient['name']),
                      subtitle: Text('Condition: ${patient['medicalCondition']}'),
                      onTap: () {
                        Navigator.pop(context);
                        _assignPatientToDoctor(doctorId, patient['id']);
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
      ),
    );
  }
}
