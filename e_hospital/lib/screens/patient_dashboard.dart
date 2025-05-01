import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

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
      
      // Here we'd fetch patient-specific data from Firestore
      // For this example, we'll use some mock data
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate network delay
      
      setState(() {
        _patientData = {
          'name': user.displayName ?? user.email?.split('@').first ?? 'Patient',
          'email': user.email,
          'medicalCondition': 'Healthy',
          'allergies': ['None'],
          'medications': ['Vitamin D', 'Iron supplement'],
          'bloodType': 'O+',
          'appointments': [
            {
              'date': '2023-06-25',
              'time': '10:00 AM',
              'doctor': 'Dr. Smith',
              'reason': 'Annual checkup',
            }
          ],
          'healthStats': {
            'height': '175 cm',
            'weight': '70 kg',
            'bmi': '22.9',
            'bloodPressure': '120/80',
          }
        };
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

  void _signOut() async {
    await _auth.signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Dashboard'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patientData == null
              ? const Center(child: Text('Unable to load data'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildProfileSection(),
                      const SizedBox(height: 16),
                      _buildHealthStatsSection(),
                      const SizedBox(height: 16),
                      _buildAppointmentsSection(),
                      const SizedBox(height: 16),
                      _buildMedicationsSection(),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book appointment functionality coming soon')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Book Appointment'),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.teal.shade100,
                  child: Text(
                    _patientData!['name'][0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _patientData!['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _patientData!['email'] ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Chip(
                        backgroundColor: Colors.teal.shade50,
                        label: Text(
                          'Blood Type: ${_patientData!['bloodType']}',
                          style: TextStyle(color: Colors.teal.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthStatsSection() {
    final stats = _patientData!['healthStats'] as Map<String, dynamic>;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'Health Stats',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Height', stats['height']),
                _buildStatItem('Weight', stats['weight']),
                _buildStatItem('BMI', stats['bmi']),
                _buildStatItem('BP', stats['bloodPressure']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsSection() {
    final appointments = _patientData!['appointments'] as List;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Upcoming Appointments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            appointments.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('No upcoming appointments')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index] as Map<String, dynamic>;
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.event, color: Colors.white),
                        ),
                        title: Text(appointment['reason']),
                        subtitle: Text('${appointment['date']} at ${appointment['time']}'),
                        trailing: Text(
                          appointment['doctor'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationsSection() {
    final medications = _patientData!['medications'] as List;
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medication, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Medications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            medications.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('No medications')),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Icon(Icons.local_pharmacy, color: Colors.white),
                        ),
                        title: Text(medications[index]),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
