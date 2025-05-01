import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final _db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
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
          'name': data['name'] ?? 'Unknown',
        };
      }).toList();
      
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading users: $e');
      setState(() {
        _users = [];
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
        title: const Text('Hospital Admin Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCard(
                            icon: Icons.admin_panel_settings,
                            value: _users.where((u) => u['role'] == 'hospitalAdmin').length.toString(),
                            label: 'Admins',
                          ),
                          _StatCard(
                            icon: Icons.medical_services,
                            value: _users.where((u) => u['role'] == 'medicalPersonnel').length.toString(),
                            label: 'Medical Staff',
                          ),
                          _StatCard(
                            icon: Icons.person,
                            value: _users.where((u) => u['role'] == 'patient').length.toString(),
                            label: 'Patients',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _users.isEmpty
                      ? const Center(child: Text('No users found'))
                      : ListView.builder(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            final user = _users[index];
                            final role = user['role'] as String;
                            Color roleColor;
                            IconData roleIcon;
                            
                            switch (role) {
                              case 'hospitalAdmin':
                                roleColor = Colors.red;
                                roleIcon = Icons.admin_panel_settings;
                                break;
                              case 'medicalPersonnel':
                                roleColor = Colors.blue;
                                roleIcon = Icons.medical_services;
                                break;
                              default:
                                roleColor = Colors.green;
                                roleIcon = Icons.person;
                                break;
                            }

                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: roleColor.withOpacity(0.2),
                                  child: Icon(roleIcon, color: roleColor),
                                ),
                                title: Text(user['email']),
                                subtitle: Text('Role: ${user['role']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    // Edit user role functionality would go here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Edit user functionality coming soon')),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.indigo),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}
