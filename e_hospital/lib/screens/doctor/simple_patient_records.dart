import 'package:flutter/material.dart';
import 'package:e_hospital/models/simplified_clinical_model.dart';
import 'package:e_hospital/services/simplified_firestore_service.dart';
import 'package:e_hospital/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:uuid/uuid.dart';

class SimplePatientRecordsScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  
  const SimplePatientRecordsScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
  }) : super(key: key);

  @override
  State<SimplePatientRecordsScreen> createState() => _SimplePatientRecordsScreenState();
}

class _SimplePatientRecordsScreenState extends State<SimplePatientRecordsScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  late TabController _tabController;
  SimplifiedClinicalFile? _clinicalFile;
  final _dateFormat = DateFormat('MMM d, yyyy');
  
  // Records by type
  List<SimplifiedMedicalRecord> _diagnostics = [];
  List<SimplifiedMedicalRecord> _notes = [];
  List<SimplifiedMedicalRecord> _prescriptions = [];
  List<SimplifiedMedicalRecord> _labResults = [];
  List<SimplifiedMedicalRecord> _treatments = [];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadPatientRecords();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadPatientRecords() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load patient's clinical file with the simplified service
      final clinicalFile = await SimplifiedFirestoreService.getPatientClinicalFile(widget.patientId);
      
      if (clinicalFile != null && mounted) {
        // Group records by type
        final diagnostics = clinicalFile.records.where((r) => r.recordType == 'Diagnostic').toList();
        final notes = clinicalFile.records.where((r) => r.recordType == 'Note').toList();
        final prescriptions = clinicalFile.records.where((r) => r.recordType == 'Prescription').toList();
        final labResults = clinicalFile.records.where((r) => r.recordType == 'LabResult').toList();
        final treatments = clinicalFile.records.where((r) => r.recordType == 'Treatment').toList();
        
        setState(() {
          _clinicalFile = clinicalFile;
          _diagnostics = diagnostics;
          _notes = notes;
          _prescriptions = prescriptions;
          _labResults = labResults;
          _treatments = treatments;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading patient records: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _addRecord(String recordType) async {
    final currentUserId = auth.FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;
    
    // Show dialog to get record details
    final result = await _showAddRecordDialog(recordType);
    if (result == null) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Create a new record
      final newRecord = SimplifiedMedicalRecord(
        id: const Uuid().v4(),
        patientId: widget.patientId,
        patientName: widget.patientName,
        doctorId: currentUserId,
        doctorName: result['doctorName'] ?? 'Dr. Unknown',
        title: result['title'] ?? '',
        description: result['description'] ?? '',
        date: DateTime.now(),
        recordType: recordType,
      );
      
      // Add the record
      final success = await SimplifiedFirestoreService.addMedicalRecord(
        widget.patientId, 
        newRecord,
      );
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Record added successfully')),
        );
        
        // Refresh records
        _loadPatientRecords();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add record')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error adding record: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<Map<String, String>?> _showAddRecordDialog(String recordType) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final doctorNameController = TextEditingController();
    
    // Set title placeholder based on record type
    String titleHint = 'Title';
    String descriptionHint = 'Description';
    
    switch (recordType) {
      case 'Diagnostic':
        titleHint = 'Diagnosis Type';
        descriptionHint = 'Diagnosis Description';
        break;
      case 'Note':
        titleHint = 'Note Title';
        descriptionHint = 'Note Content';
        break;
      case 'Prescription':
        titleHint = 'Medication Name';
        descriptionHint = 'Dosage and Instructions';
        break;
      case 'LabResult':
        titleHint = 'Test Name';
        descriptionHint = 'Test Results';
        break;
      case 'Treatment':
        titleHint = 'Treatment Name';
        descriptionHint = 'Treatment Details';
        break;
    }
    
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add $recordType'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: titleHint,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: descriptionHint,
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: doctorNameController,
                  decoration: const InputDecoration(
                    labelText: 'Doctor Name',
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
              onPressed: () {
                if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                  return;
                }
                
                Navigator.pop(context, {
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'doctorName': doctorNameController.text,
                });
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.patientName}\'s Records'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Diagnostics'),
            Tab(text: 'Notes'),
            Tab(text: 'Prescriptions'),
            Tab(text: 'Lab Results'),
            Tab(text: 'Treatments'),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _clinicalFile == null
              ? _buildNoRecordsFound()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRecordsList(_diagnostics, 'No diagnoses found'),
                    _buildRecordsList(_notes, 'No notes found'),
                    _buildRecordsList(_prescriptions, 'No prescriptions found'),
                    _buildRecordsList(_labResults, 'No lab results found'),
                    _buildRecordsList(_treatments, 'No treatments found'),
                  ],
                ),
    );
  }
  
  Widget _buildAddButton() {
    final recordTypes = ['Diagnostic', 'Note', 'Prescription', 'LabResult', 'Treatment'];
    
    return FloatingActionButton(
      onPressed: () {
        final recordType = recordTypes[_tabController.index];
        _addRecord(recordType);
      },
      child: const Icon(Icons.add),
    );
  }
  
  Widget _buildNoRecordsFound() {
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
            'No Records Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Record'),
            onPressed: () {
              final recordType = ['Diagnostic', 'Note', 'Prescription', 'LabResult', 'Treatment'][_tabController.index];
              _addRecord(recordType);
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecordsList(List<SimplifiedMedicalRecord> records, String emptyMessage) {
    if (records.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return _buildRecordCard(record);
      },
    );
  }
  
  Widget _buildRecordCard(SimplifiedMedicalRecord record) {
    return Card(
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
                    record.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  _dateFormat.format(record.date),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              record.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Added by: ${record.doctorName}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
            if (record.attachments.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Attachments:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: record.attachments.map((attachment) {
                  return Chip(
                    label: Text(attachment.split('/').last),
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 
 