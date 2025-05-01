import 'package:flutter/material.dart';
import 'package:e_hospital/screens/admin_dashboard.dart';
import 'package:e_hospital/screens/admin/doctor_management.dart';
import 'package:e_hospital/screens/admin/patient_management.dart';
import 'package:e_hospital/screens/admin/appointment_management.dart';
import 'package:e_hospital/screens/medic_dashboard.dart';
import 'package:e_hospital/screens/medic/medical_record_management.dart';
import 'package:e_hospital/screens/medic/medical_records_screen.dart';
import 'package:e_hospital/screens/login.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>? ?? {};
    final path = settings.name ?? '';

    // Admin routes with IDs
    if (path.startsWith('/admin/doctors/view/')) {
      final doctorId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => DoctorManagement(
          doctorId: doctorId,
          action: 'view',
        ),
      );
    } else if (path.startsWith('/admin/doctors/edit/')) {
      final doctorId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => DoctorManagement(
          doctorId: doctorId,
          action: 'edit',
        ),
      );
    } else if (path.startsWith('/admin/patients/view/')) {
      final patientId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => PatientManagement(
          patientId: patientId,
          action: 'view',
        ),
      );
    } else if (path.startsWith('/admin/patients/edit/')) {
      final patientId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => PatientManagement(
          patientId: patientId,
          action: 'edit',
        ),
      );
    } else if (path.startsWith('/admin/appointments/view/')) {
      final appointmentId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => AppointmentManagement(
          appointmentId: appointmentId,
          action: 'view',
        ),
      );
    } else if (path.startsWith('/admin/appointments/edit/')) {
      final appointmentId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => AppointmentManagement(
          appointmentId: appointmentId,
          action: 'edit',
        ),
      );
    } else if (path.startsWith('/medic/patients/')) {
      final patientId = path.split('/').last;
      if (patientId.isNotEmpty && patientId != 'patients') {
        return MaterialPageRoute(
          builder: (_) => MedicDashboard(
            initialTab: 'patients',
            selectedPatientId: patientId,
          ),
        );
      }
    } else if (path.startsWith('/medic/records/view/')) {
      final recordId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => MedicalRecordManagement(
          recordId: recordId,
          action: 'view',
        ),
      );
    } else if (path.startsWith('/medic/records/edit/')) {
      final recordId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => MedicalRecordManagement(
          recordId: recordId,
          action: 'edit',
        ),
      );
    }
    
    // Standard routes
    switch (settings.name) {
      // Auth routes
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
        
      // Admin routes
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      
      case '/admin/doctors':
        return MaterialPageRoute(builder: (_) => const AdminDashboard(initialTab: 'doctors'));
      
      case '/admin/doctors/add':
        return MaterialPageRoute(
          builder: (_) => const DoctorManagement(action: 'add'),
        );
      
      case '/admin/patients':
        return MaterialPageRoute(builder: (_) => const AdminDashboard(initialTab: 'patients'));
      
      case '/admin/patients/add':
        return MaterialPageRoute(
          builder: (_) => const PatientManagement(action: 'add'),
        );
      
      case '/admin/appointments':
        return MaterialPageRoute(builder: (_) => const AdminDashboard(initialTab: 'appointments'));
      
      case '/admin/appointments/add':
        return MaterialPageRoute(
          builder: (_) => AppointmentManagement(
            action: 'add',
            initialData: args,
          ),
        );
      
      case '/admin/settings':
        return MaterialPageRoute(builder: (_) => const AdminDashboard(initialTab: 'settings'));
      
      // Medic routes
      case '/medic':
        return MaterialPageRoute(builder: (_) => const MedicDashboard());
      
      case '/medic/patients':
        return MaterialPageRoute(builder: (_) => const MedicDashboard(initialTab: 'patients'));
      
      case '/medic/appointments':
        return MaterialPageRoute(builder: (_) => const MedicDashboard(initialTab: 'appointments'));
      
      case '/medic/records':
        // Use MedicDashboard with records tab (to be implemented in MedicDashboard)
        return MaterialPageRoute(builder: (_) => const MedicalRecordsScreen());
        
      case '/medic/records/add':
        return MaterialPageRoute(
          builder: (_) => const MedicalRecordManagement(action: 'add'),
        );
      
      case '/medic/profile':
        return MaterialPageRoute(builder: (_) => const MedicDashboard(initialTab: 'profile'));
      
      // Default route (404)
      default:
        return _errorRoute();
    }
  }
  
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Error'),
          ),
          body: const Center(
            child: Text('Page not found'),
          ),
        );
      },
    );
  }
} 