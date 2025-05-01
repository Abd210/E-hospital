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
  late TabController _tabController;
  List<Map<String, dynamic>> _assignedPatients = [];
  bool _isLoading = true;
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserInfo();
    _loadAssignedPatients();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email;
      });
    }
  }

  Future<void> _loadAssignedPatients() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      // In a real app, you would have a reference to assigned patients
      // For this example, we'll fetch all patients
      final snapshot = await _db.collection('users')
          .where('role', isEqualTo: 'patient')
          .get();
      
      final patients = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'email': data['email'] ?? 'No email',
          'name': data['name'] ?? 'Unknown',
          'medicalCondition': data['medicalCondition'] ?? 'None',
          'lastCheckup': data['lastCheckup'] ?? 'Not available',
        };
      }).toList();
      
      setState(() {
        _assignedPatients = patients;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading patients: $e');
      setState(() {
        _assignedPatients = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Staff Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAssignedPatients,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Patients', icon: Icon(Icons.people)),
            Tab(text: 'Schedule', icon: Icon(Icons.calendar_today)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Patients Tab
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _assignedPatients.isEmpty
                  ? const Center(child: Text('No patients assigned'))
                  : ListView.builder(
                      itemCount: _assignedPatients.length,
                      itemBuilder: (context, index) {
                        final patient = _assignedPatients[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ExpansionTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            title: Text(patient['email'] ?? 'Unknown'),
                            subtitle: Text('ID: ${patient['id']}'),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _InfoRow(label: 'Name', value: patient['name']),
                                    _InfoRow(label: 'Medical Condition', value: patient['medicalCondition']),
                                    _InfoRow(label: 'Last Checkup', value: patient['lastCheckup']),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.edit_note),
                                          label: const Text('Update Record'),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Record update functionality coming soon')),
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.message),
                                          label: const Text('Contact'),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Messaging functionality coming soon')),
                                            );
                                          },
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
          
          // Schedule Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.calendar_today, size: 100, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  'Welcome Dr. ${_currentUserEmail?.split('@').first ?? 'Doctor'}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Your Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Card(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No appointments scheduled for today'),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Create Appointment'),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Appointment scheduling coming soon')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value.isEmpty ? 'Not available' : value),
          ),
        ],
      ),
    );
  }
}
