import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isCreatingAccount = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth state change will redirect user
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _createAccount() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Set default role to patient
      await _db.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'role': 'patient',
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Auth state change will redirect user
    } catch (e) {
      setState(() {
        _errorMessage = 'Account creation failed: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _createSampleUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Sample users data
      final sampleUsers = [
        {'email': 'admin@hospital.com', 'password': 'admin123', 'role': 'hospitalAdmin'},
        {'email': 'doctor1@hospital.com', 'password': 'doctor123', 'role': 'medicalPersonnel'},
        {'email': 'doctor2@hospital.com', 'password': 'doctor123', 'role': 'medicalPersonnel'},
        {'email': 'patient1@example.com', 'password': 'patient123', 'role': 'patient'},
        {'email': 'patient2@example.com', 'password': 'patient123', 'role': 'patient'},
      ];

      for (final userData in sampleUsers) {
        try {
          // Check if user already exists
          final email = userData['email'] as String;
          final existingUsers = await _auth.fetchSignInMethodsForEmail(email);
          
          if (existingUsers.isNotEmpty) {
            debugPrint('User $email already exists, skipping creation');
            continue;
          }
          
          // Create user
          final userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: userData['password'] as String,
          );
          
          // Set user data
          await _db.collection('users').doc(userCredential.user!.uid).set({
            'email': email,
            'role': userData['role'],
            'createdAt': FieldValue.serverTimestamp(),
          });
          
          debugPrint('Created user: $email with role: ${userData['role']}');
        } catch (e) {
          debugPrint('Error creating user: $e');
        }
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sample users created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error creating sample users: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating users: $e'),
            backgroundColor: Colors.red,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade800, Colors.indigo.shade900],
              ),
            ),
          ),
          
          // Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  const Icon(
                    Icons.local_hospital,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'E-Hospital',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Login form
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isCreatingAccount ? 'Create Account' : 'Login',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            obscureText: true,
                          ),
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _isLoading ? null : (_isCreatingAccount ? _createAccount : _signIn),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(),
                                  )
                                : Text(_isCreatingAccount ? 'Create Account' : 'Login'),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _isCreatingAccount = !_isCreatingAccount;
                                      _errorMessage = null;
                                    });
                                  },
                            child: Text(
                              _isCreatingAccount
                                  ? 'Already have an account? Login'
                                  : 'Don\'t have an account? Sign up',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sample users creation
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _createSampleUsers,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.white),
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.people),
                    label: const Text('Create Sample Users'),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Sample user credentials
                  const Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sample Users:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Admin: admin@hospital.com / admin123'),
                          Text('Doctor: doctor1@hospital.com / doctor123'),
                          Text('Patient: patient1@example.com / patient123'),
                        ],
                      ),
                    ),
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
