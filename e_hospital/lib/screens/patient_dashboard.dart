import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  Map<String, dynamic>? _patientData;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPatientData();
  }

  Future<void> _loadPatientData() async {
    setState(() => _isLoading = true);
    try {
      final user = _auth.currentUser;
      if (user == null) return;
      
      // Get patient data from Firestore
      final docRef = _db.collection('users').doc(user.uid);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        // Create default user data if it doesn't exist
        final userData = {
          'name': user.displayName ?? user.email?.split('@').first ?? 'Patient',
          'email': user.email,
          'role': 'patient',
          'medicalCondition': 'Healthy',
          'bloodType': 'Unknown',
          'vitals': {
            'heartRate': '72 bpm',
            'bloodPressure': '120/80 mmHg',
            'temperature': '36.6 °C',
            'oxygenSaturation': '98%',
          },
          'treatments': [],
          'diagnostics': [],
          'lastCheckup': 'Not available',
          'createdAt': FieldValue.serverTimestamp(),
        };
        
        await docRef.set(userData);
        setState(() {
          _patientData = userData;
          _isLoading = false;
        });
        return;
      }
      
      // Get user data
      final data = doc.data() ?? {};
      
      // Generate random vitals for simulation
      final randomVitals = _generateSimulatedVitals();
      
      // Update vitals in Firestore 
      await docRef.update({
        'vitals': randomVitals,
        'lastUpdated': DateTime.now().toString(),
      });
      
      data['vitals'] = randomVitals;
      
      setState(() {
        _patientData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading patient data: $e');
      setState(() {
        _patientData = null;
        _isLoading = false;
      });
    }
  }
  
  Map<String, String> _generateSimulatedVitals() {
    final random = math.Random();
    final heartRate = 60 + random.nextInt(40);
    final systolic = 110 + random.nextInt(30);
    final diastolic = 70 + random.nextInt(20);
    final temperature = 36.1 + (random.nextDouble() * 1.0);
    final oxygenSaturation = 95 + random.nextInt(5);
    
    return {
      'heartRate': '$heartRate bpm',
      'bloodPressure': '$systolic/$diastolic mmHg',
      'temperature': '${temperature.toStringAsFixed(1)} °C',
      'oxygenSaturation': '$oxygenSaturation%',
      'lastMeasured': DateTime.now().toString(),
    };
  }

  void _signOut() async {
    await _auth.signOut();
    if (mounted) {
      context.go('/login');
    }
  }
  
  String _formatDate(String isoString) {
    try {
      final date = DateTime.parse(isoString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoString;
    }
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

  void _viewClinicalDetails() {
    if (_patientData == null) return;
    
    final diagnostics = List<Map<String, dynamic>>.from(
      (_patientData!['diagnostics'] ?? []).map((d) => d as Map<String, dynamic>)
    );
    
    final treatments = List<Map<String, dynamic>>.from(
      (_patientData!['treatments'] ?? []).map((t) => t as Map<String, dynamic>)
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('My Clinical File'),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: ListView(
            shrinkWrap: true,
            children: [
              _infoTile('Name', _patientData!['name']),
              _infoTile('Email', _patientData!['email']),
              _infoTile('Medical Condition', _patientData!['medicalCondition']),
              _infoTile('Blood Type', _patientData!['bloodType']),
              
              const Divider(),
              const Text('Diagnostics', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              
              if (diagnostics.isEmpty)
                const Text('No diagnostic information available')
              else
                ...diagnostics.map((diagnostic) => 
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Description: ${diagnostic['description']}'),
                          Text('Date: ${_formatDate(diagnostic['date'])}'),
                          Text('Doctor: ${diagnostic['doctorName']}'),
                        ],
                      ),
                    ),
                  ),
                ),
                
              const Divider(),
              const Text('Treatments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              
              if (treatments.isEmpty)
                const Text('No treatment information available')
              else
                ...treatments.map((treatment) => 
                  Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Medication: ${treatment['medication']}'),
                          Text('Dosage: ${treatment['dosage']}'),
                          Text('Description: ${treatment['description']}'),
                          Text('Date: ${_formatDate(treatment['date'])}'),
                          Text('Doctor: ${treatment['doctorName']}'),
                        ],
                      ),
                    ),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Health Dashboard'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_patientData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('My Health Dashboard'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Unable to load data',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadPatientData,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }
    
    final name = _patientData!['name'] ?? 'Patient';
    final email = _patientData!['email'] ?? '';
    final medicalCondition = _patientData!['medicalCondition'] ?? 'Healthy';
    final bloodType = _patientData!['bloodType'] ?? 'Unknown';
    
    final vitals = _patientData!['vitals'] as Map<String, dynamic>;
    final heartRate = vitals['heartRate'] ?? '72 bpm';
    final bloodPressure = vitals['bloodPressure'] ?? '120/80 mmHg';
    final temperature = vitals['temperature'] ?? '36.6 °C';
    final oxygenSaturation = vitals['oxygenSaturation'] ?? '98%';
    
    final diagnostics = List<Map<String, dynamic>>.from(
      (_patientData!['diagnostics'] ?? []).map((d) => d as Map<String, dynamic>)
    );
    
    final treatments = List<Map<String, dynamic>>.from(
      (_patientData!['treatments'] ?? []).map((t) => t as Map<String, dynamic>)
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatientData,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadPatientData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Profile Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        email,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildInfoChip(
                            label: 'Medical Condition',
                            value: medicalCondition,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 16),
                          _buildInfoChip(
                            label: 'Blood Type',
                            value: bloodType,
                            color: Colors.red,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _viewClinicalDetails,
                        icon: const Icon(Icons.medical_information),
                        label: const Text('View Clinical Details'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Vital Signs Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.favorite, color: Colors.red),
                          const SizedBox(width: 8),
                          const Text(
                            'Current Vital Signs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Updated just now',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildVitalCard(
                              icon: Icons.favorite,
                              title: 'Heart Rate',
                              value: heartRate,
                              color: Colors.red,
                            ),
                          ),
                          Expanded(
                            child: _buildVitalCard(
                              icon: Icons.speed,
                              title: 'Blood Pressure',
                              value: bloodPressure,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildVitalCard(
                              icon: Icons.thermostat,
                              title: 'Temperature',
                              value: temperature,
                              color: Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: _buildVitalCard(
                              icon: Icons.air,
                              title: 'O₂ Saturation',
                              value: oxygenSaturation,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Recent Treatments
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.medication, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text(
                            'Current Treatments',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${treatments.length} active',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      if (treatments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              'No active treatments',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: treatments.length > 3 ? 3 : treatments.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final treatment = treatments[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.medication, color: Colors.white, size: 20),
                              ),
                              title: Text(treatment['medication']),
                              subtitle: Text(treatment['dosage']),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: _viewClinicalDetails,
                              ),
                            );
                          },
                        ),
                        
                      if (treatments.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: TextButton.icon(
                              icon: const Icon(Icons.more_horiz),
                              label: const Text('View All Treatments'),
                              onPressed: _viewClinicalDetails,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Recent Diagnostics
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.medical_information, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Recent Diagnostics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${diagnostics.length} total',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      
                      if (diagnostics.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: Text(
                              'No diagnostic information available',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: diagnostics.length > 3 ? 3 : diagnostics.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final diagnostic = diagnostics[index];
                            return ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.medical_information, color: Colors.white, size: 20),
                              ),
                              title: Text(
                                diagnostic['description'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                'Dr. ${diagnostic['doctorName'].toString().split(' ').last} • ${_formatDate(diagnostic['date'])}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: _viewClinicalDetails,
                              ),
                            );
                          },
                        ),
                        
                      if (diagnostics.length > 3)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: TextButton.icon(
                              icon: const Icon(Icons.more_horiz),
                              label: const Text('View All Diagnostics'),
                              onPressed: _viewClinicalDetails,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildInfoChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVitalCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
