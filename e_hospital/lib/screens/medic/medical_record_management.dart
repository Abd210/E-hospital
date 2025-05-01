import 'package:flutter/material.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:e_hospital/services/firestore_service.dart';
import 'package:e_hospital/models/clinical_model.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:uuid/uuid.dart';

class MedicalRecordManagement extends StatefulWidget {
  final String? recordId;
  final String action; // 'view', 'add', 'edit'
  
  const MedicalRecordManagement({
    Key? key, 
    this.recordId,
    required this.action,
  }) : super(key: key);

  @override
  State<MedicalRecordManagement> createState() => _MedicalRecordManagementState();
}

class _MedicalRecordManagementState extends State<MedicalRecordManagement> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _patientNameController = TextEditingController();
  final _recordTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _recordDate = DateTime.now();
  
  // Record data
  Map<String, dynamic>? _recordData;
  String? _patientId;
  String _recordType = 'Medical Note'; // Default type
  
  @override
  void initState() {
    super.initState();
    
    // Get arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args.containsKey('patientId')) {
          _patientId = args['patientId'] as String;
          _loadPatientData();
        }
        
        if (args.containsKey('recordData')) {
          _recordData = args['recordData'] as Map<String, dynamic>;
          _populateFormWithRecordData();
        }
      }
    });
  }
  
  @override
  void dispose() {
    _patientNameController.dispose();
    _recordTypeController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPatientData() async {
    if (_patientId == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final patient = await FirestoreService.getPatientById(_patientId!);
      if (patient != null && mounted) {
        setState(() {
          _patientNameController.text = patient.name;
        });
      }
    } catch (e) {
      debugPrint('Error loading patient data: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _populateFormWithRecordData() {
    if (_recordData == null) return;
    
    setState(() {
      // Set the controllers based on record data
      _patientNameController.text = _recordData!['Patient'] as String;
      _recordType = _recordData!['Type'] as String;
      _recordTypeController.text = _recordType;
      _descriptionController.text = _recordData!['Description'] as String;
      _notesController.text = _recordData!['Notes'] as String;
      _recordDate = _recordData!['Date'] as DateTime;
    });
  }
  
  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
      if (currentUserId == null || _patientId == null) {
        throw Exception('User ID or patient ID is missing');
      }
      
      // Get current user (doctor) name
      final doctor = await FirestoreService.getUserById(currentUserId);
      if (doctor == null) {
        throw Exception('Doctor details not found');
      }
      
      bool success = false;
      
      switch (_recordType) {
        case 'Diagnostic':
          // Create or update diagnostic
          final diagnostic = Diagnostic(
            id: widget.recordId ?? const Uuid().v4(),
            description: _descriptionController.text,
            doctorId: currentUserId,
            doctorName: doctor.name,
            date: _recordDate,
            notes: _notesController.text,
          );
          
          if (widget.action == 'add') {
            success = await FirestoreService.addDiagnostic(_patientId!, diagnostic);
          } else if (widget.action == 'edit') {
            success = await FirestoreService.updateDiagnostic(_patientId!, diagnostic);
          }
          break;
          
        case 'Medical Note':
          // Create or update medical note
          final note = MedicalNote(
            id: widget.recordId ?? const Uuid().v4(),
            content: _descriptionController.text,
            authorId: currentUserId,
            authorName: doctor.name,
            authorRole: 'Doctor',
            date: _recordDate,
            noteType: _notesController.text,
          );
          
          if (widget.action == 'add') {
            success = await FirestoreService.addMedicalNote(_patientId!, note);
          } else if (widget.action == 'edit') {
            success = await FirestoreService.updateMedicalNote(_patientId!, note);
          }
          break;
          
        case 'Treatment':
          // Create or update treatment
          final treatment = Treatment(
            id: widget.recordId ?? const Uuid().v4(),
            medication: _descriptionController.text,
            description: _notesController.text,
            doctorId: currentUserId,
            doctorName: doctor.name,
            date: _recordDate,
            dosage: '', // These would ideally be additional form fields
            duration: '',
            frequency: '',
          );
          
          if (widget.action == 'add') {
            success = await FirestoreService.addTreatment(_patientId!, treatment);
          } else if (widget.action == 'edit') {
            success = await FirestoreService.updateTreatment(_patientId!, treatment);
          }
          break;
      }
      
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record saved successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save record')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error saving record: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving record: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recordDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _recordDate && mounted) {
      setState(() {
        _recordDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: _buildAppBarActions(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: widget.action == 'view'
                  ? _buildViewContent()
                  : _buildForm(),
            ),
    );
  }
  
  String _getTitle() {
    switch (widget.action) {
      case 'add':
        return 'Add New Medical Record';
      case 'edit':
        return 'Edit Medical Record';
      case 'view':
        return 'Medical Record Details';
      default:
        return 'Medical Record';
    }
  }
  
  List<Widget> _buildAppBarActions() {
    List<Widget> actions = [];
    
    if (widget.action == 'view') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context, 
              '/medic/records/edit/${widget.recordId}',
              arguments: {
                'recordData': _recordData,
                'patientId': _patientId,
              },
            );
          },
        ),
      );
    } else if (widget.action == 'edit' || widget.action == 'add') {
      actions.add(
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: _saveRecord,
        ),
      );
    }
    
    return actions;
  }
  
  Widget _buildViewContent() {
    if (_recordData == null) {
      return const Center(child: Text('Record data not found'));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: _getRecordTypeColor(_recordData!['Type'] as String).withOpacity(0.2),
                      child: Icon(
                        _getRecordTypeIcon(_recordData!['Type'] as String),
                        size: 40,
                        color: _getRecordTypeColor(_recordData!['Type'] as String),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _recordData!['Type'] as String,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Patient: ${_recordData!['Patient']}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Date: ${DateFormat('MMMM d, yyyy').format(_recordData!['Date'] as DateTime)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 10),
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _recordData!['Description'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _recordData!['Notes'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Record Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _patientNameController,
                    decoration: const InputDecoration(
                      labelText: 'Patient Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Record Type',
                      prefixIcon: Icon(Icons.category),
                      border: OutlineInputBorder(),
                    ),
                    value: _recordType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Diagnostic',
                        child: Text('Diagnostic'),
                      ),
                      DropdownMenuItem(
                        value: 'Medical Note',
                        child: Text('Medical Note'),
                      ),
                      DropdownMenuItem(
                        value: 'Treatment',
                        child: Text('Treatment'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _recordType = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        DateFormat('MMMM d, yyyy').format(_recordDate),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _recordType == 'Treatment' ? 'Medication/Treatment' : 'Description',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: _recordType == 'Treatment' ? 'Medication Name' : 'Description',
                      prefixIcon: Icon(_recordType == 'Treatment' ? Icons.medication : Icons.description),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: _recordType == 'Medical Note' ? 'Note Type' : 'Additional Notes',
                      prefixIcon: Icon(_recordType == 'Medical Note' ? Icons.category : Icons.note),
                      border: const OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveRecord,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                widget.action == 'add' ? 'Create Record' : 'Update Record',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getRecordTypeColor(String type) {
    switch (type) {
      case 'Diagnostic':
        return Colors.blue;
      case 'Medical Note':
        return Colors.purple;
      case 'Treatment':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getRecordTypeIcon(String type) {
    switch (type) {
      case 'Diagnostic':
        return Icons.medical_services;
      case 'Medical Note':
        return Icons.note;
      case 'Treatment':
        return Icons.healing;
      default:
        return Icons.description;
    }
  }
} 