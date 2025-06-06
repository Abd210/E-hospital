import 'package:flutter/material.dart';
import 'package:e_hospital/screens/admin_dashboard.dart';
import 'package:e_hospital/screens/admin/doctor_management.dart';
import 'package:e_hospital/screens/admin/patient_management.dart';
import 'package:e_hospital/screens/admin/appointment_management.dart';
import 'package:e_hospital/screens/medic_dashboard.dart';
import 'package:e_hospital/screens/medic/doctor_profile.dart';
import 'package:e_hospital/screens/medic/my_patients_screen.dart';
import 'package:e_hospital/screens/login.dart';
import 'package:e_hospital/screens/patient_dashboard.dart';
import 'package:e_hospital/screens/patient/appointments_screen.dart';
import 'package:e_hospital/screens/patient/medical_records_screen.dart';
import 'package:e_hospital/screens/doctor/doctor_appointment_list_screen.dart';
import 'package:e_hospital/screens/doctor/doctor_appointment_form.dart';
import 'package:e_hospital/screens/doctor/doctor_patient_detail_screen.dart';
import 'package:e_hospital/screens/doctor/simple_patient_records.dart';
import 'package:e_hospital/clinical_file/patient_clinical_screen.dart';
import 'package:e_hospital/clinical_file/doctor_clinical_screen.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>? ?? {};
    final path = settings.name ?? '';

    // Check exact match for '/medic/patients' first
    if (path == '/medic/patients') {
      return MaterialPageRoute(builder: (_) => const MyPatientsScreen());
    }
    
    // Add a new route for '/medic/my-patients'
    if (path == '/medic/my-patients') {
      return MaterialPageRoute(builder: (_) => const MyPatientsScreen());
    }
    
    // Add route for doctor appointments
    if (path == '/doctor/appointments') {
      return MaterialPageRoute(builder: (_) => const DoctorAppointmentListScreen());
    }
    
    // Add route for doctor appointment creation
    if (path == '/doctor/appointments/add') {
      return MaterialPageRoute(builder: (_) => const DoctorAppointmentForm());
    }
    
    // Add route for doctor appointment view
    if (path.startsWith('/doctor/appointments/view/')) {
      final appointmentId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => DoctorAppointmentForm(
          appointmentId: appointmentId,
          isViewMode: true,
        ),
      );
    }
    
    // Add route for medic appointment view (alias of doctor appointment view)
    if (path.startsWith('/medic/appointments/view/')) {
      final appointmentId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => DoctorAppointmentForm(
          appointmentId: appointmentId,
          isViewMode: true,
        ),
      );
    }
    
    // Add route for medic appointment add
    if (path == '/medic/appointments/add') {
      return MaterialPageRoute(builder: (_) => const DoctorAppointmentForm());
    }
    
    // Add route for medic records
    if (path == '/medic/records') {
      // Redirect to the clinical screen
      return MaterialPageRoute(builder: (_) => const DoctorClinicalScreen());
    }
    
    // Add route for doctor patient details
    if (path.startsWith('/doctor/patients/')) {
      final patientId = path.split('/').last;
      return MaterialPageRoute(
        builder: (_) => DoctorPatientDetailScreen(patientId: patientId),
      );
    }
    
    // Add route for simplified patient records
    if (path.startsWith('/doctor/patient-records/')) {
      final patientId = path.split('/').last;
      final patientName = args['patientName'] as String? ?? 'Patient';
      return MaterialPageRoute(builder: (_) => DoctorClinicalScreen(
        patientId: patientId,
        patientName: patientName,
      ));
    }
    
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
      // Only match if there's something after the '/medic/patients/' prefix
      final segments = path.split('/');
      if (segments.length > 3 && segments[3].isNotEmpty) {
        final patientId = segments[3];
        // Patient detail page - show clinical screen for that patient
        return MaterialPageRoute(
          builder: (_) => DoctorClinicalScreen(
            patientId: patientId,
            patientName: 'Patient', // We'll get the actual name in the screen
          ),
        );
      }
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
      
      case '/medic/appointments':
        // Use the MedicDashboard with initialTab set to appointments
        return MaterialPageRoute(builder: (_) => const MedicDashboard(initialTab: 'appointments'));
      
      case '/medic/appointments/all':
        // This route is for the "View All & Filter" button
        return MaterialPageRoute(builder: (_) => const DoctorAppointmentListScreen());
      
      case '/medic/profile':
        return MaterialPageRoute(builder: (_) => const DoctorProfileScreen());
      
      // Patient routes
      case '/patient':
        return MaterialPageRoute(builder: (_) => const PatientDashboard());
      
      case '/patient/appointments':
        return MaterialPageRoute(builder: (_) => const PatientAppointmentsScreen());
      
      case '/patient/doctors':
        return MaterialPageRoute(builder: (_) => const PatientDashboard(initialTab: 'doctors'));
      
      case '/patient/records':
        // Clinical Files screen
        return MaterialPageRoute(builder: (_) => const PatientClinicalScreen());
      
      case '/patient/prescriptions':
        return MaterialPageRoute(builder: (_) => const PatientDashboard(initialTab: 'prescriptions'));
      
      case '/patient/lab-results':
        return MaterialPageRoute(builder: (_) => const PatientDashboard(initialTab: 'lab-results'));
      
      case '/patient/profile':
        return MaterialPageRoute(builder: (_) => const PatientDashboard(initialTab: 'profile'));
      
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