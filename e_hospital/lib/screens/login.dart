import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../services/database_initializer.dart';
import '../services/auth_service.dart';
import 'package:flutter/foundation.dart';

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
  bool _isInitializingDatabase = false;

  @override
  void initState() {
    super.initState();
    // Set default values for easier login during development
    _emailController.text = 'admin0@hospital.com';
    _passwordController.text = 'Admin#1000';
  }

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
      // Sign in with Firebase Auth
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get user role for navigation and display a message
      if (mounted) {
        final role = await fetchRole();
        String accountType = "Unknown";
        String route = '/login';
        
        if (role == 'hospitalAdmin') {
          accountType = "Hospital Administrator";
          route = '/admin';
        } else if (role == 'medicalPersonnel') {
          accountType = "Doctor";
          route = '/medic';
        } else if (role == 'patient') {
          accountType = "Patient";
          route = '/patient';
        }
        
        // Show a brief success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged in successfully as $accountType'),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Navigate to the appropriate dashboard
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, route);
          }
        });
      }
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
        'name': email.split('@').first,
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
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Navigate to patient dashboard after creating account
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/patient');
      }
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
      // Use the database initializer instead of the missing populateSampleData method
      await DatabaseInitializer.initializeDatabase(force: true);
      
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
  
  Future<void> _initializeDatabase() async {
    setState(() {
      _isInitializingDatabase = true;
      _errorMessage = null;
    });

    try {
      // Use the huge dataset size for more data
      await DatabaseInitializer.initializeDatabase(size: DatasetSize.huge, force: true);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database initialized with HUGE dataset successfully. You can now log in with the sample accounts.'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error initializing database: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error initializing database: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isInitializingDatabase = false;
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
                colors: [Colors.blue.shade700, Colors.indigo.shade800],
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
                  Icon(
                    Icons.local_hospital,
                    size: 100,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'E-Hospital',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Healthcare Management System',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Login form
                  Card(
                    elevation: 12,
                    shadowColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _isCreatingAccount ? 'Create Account' : 'Welcome Back',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isCreatingAccount 
                                ? 'Fill in your details to register' 
                                : 'Sign in to continue',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          
                          // Error message
                          if (_errorMessage != null) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                          
                          // Email field
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                          ),
                          const SizedBox(height: 20),
                          
                          // Password field
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                              ),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            ),
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _isCreatingAccount ? _createAccount() : _signIn(),
                          ),
                          const SizedBox(height: 30),
                          
                          // Login/Create button
                          ElevatedButton(
                            onPressed: _isLoading 
                                ? null 
                                : (_isCreatingAccount ? _createAccount : _signIn),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.blue.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    _isCreatingAccount ? 'Create Account' : 'Sign In',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Toggle between login and create account
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
                                  ? 'Already have an account? Sign In' 
                                  : 'Don\'t have an account? Create one',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // User credentials info
                  Card(
                    color: Colors.white.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sample Users (Click to Auto-fill):',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildClickableCredentialRow('Admin', 'admin0@hospital.com', 'Admin#1000'),
                          _buildClickableCredentialRow('Doctor', 'doctor0@hospital.com', 'Doctor#1000'),
                          _buildClickableCredentialRow('Patient', 'patient0@example.com', 'Patient#1000'),
                          const SizedBox(height: 8),
                          const Text(
                            'Note: Use the "Initialize HUGE Database" button above to create these users',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
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
        ],
      ),
    );
  }
  
  Widget _buildCredentialRow(String role, String email, String password) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              role,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              email,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              password,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClickableCredentialRow(String role, String email, String password) {
    return InkWell(
      onTap: () {
        setState(() {
          _emailController.text = email;
          _passwordController.text = password;
          _errorMessage = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                role,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                email,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                password,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Icon(
              Icons.content_copy,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
