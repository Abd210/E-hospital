import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/firestore_service.dart';
import 'services/auth_service.dart';

import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/admin_dashboard.dart';
import 'screens/medic_dashboard.dart';
import 'screens/patient_dashboard.dart';

/// auth-state stream
final authProvider =
    StreamProvider<User?>((ref) => FirebaseAuth.instance.authStateChanges());

/// a future provider that gets the role every time we're logged in
final roleProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(authProvider).value;
  if (user == null) return null;
  return fetchRole();
});

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable:
        GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      
      // Admin routes
      GoRoute(
        path: '/admin', 
        builder: (_, __) => const AdminDashboard(),
        routes: [
          GoRoute(path: 'doctors', builder: (_, __) => const AdminDashboard()),
          GoRoute(path: 'patients', builder: (_, __) => const AdminDashboard()),
          GoRoute(path: 'appointments', builder: (_, __) => const AdminDashboard()),
          GoRoute(path: 'departments', builder: (_, __) => const AdminDashboard()),
          GoRoute(path: 'staff', builder: (_, __) => const AdminDashboard()),
          GoRoute(path: 'reports', builder: (_, __) => const AdminDashboard()),
          GoRoute(path: 'settings', builder: (_, __) => const AdminDashboard()),
        ]
      ),
      
      // Medic routes
      GoRoute(
        path: '/medic', 
        builder: (_, __) => const MedicDashboard(),
        routes: [
          GoRoute(path: 'patients', builder: (_, __) => const MedicDashboard()),
          GoRoute(path: 'patients/:id', builder: (context, state) {
            final patientId = state.pathParameters['id']!;
            return MedicDashboard(selectedPatientId: patientId);
          }),
          GoRoute(path: 'appointments', builder: (_, __) => const MedicDashboard()),
          GoRoute(path: 'records', builder: (_, __) => const MedicDashboard()),
          GoRoute(path: 'prescriptions', builder: (_, __) => const MedicDashboard()),
          GoRoute(path: 'lab-results', builder: (_, __) => const MedicDashboard()),
          GoRoute(path: 'profile', builder: (_, __) => const MedicDashboard()),
        ]
      ),
      
      // Patient routes
      GoRoute(
        path: '/patient', 
        builder: (_, __) => const PatientDashboard(),
        routes: [
          GoRoute(path: 'appointments', builder: (_, __) => const PatientDashboard()),
          GoRoute(path: 'doctors', builder: (_, __) => const PatientDashboard()),
          GoRoute(path: 'records', builder: (_, __) => const PatientDashboard()),
          GoRoute(path: 'prescriptions', builder: (_, __) => const PatientDashboard()),
          GoRoute(path: 'lab-results', builder: (_, __) => const PatientDashboard()),
          GoRoute(path: 'profile', builder: (_, __) => const PatientDashboard()),
        ]
      ),
    ],
    redirect: (ctx, state) async {
      // 1) if not logged in → everything redirects to /login
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return state.path == '/login' ? null : '/login';

      // 2) fetch role once
      final role = await fetchRole();
      final target = switch (role) {
        'hospitalAdmin'     => '/admin',
        'medicalPersonnel'  => '/medic',
        _                   => '/patient',
      };

      // Allow navigation to the target path or any sub-path of target
      final path = state.path ?? '/';
      return path.startsWith(target) ? null : target;
    },
  );
});

/// helper to refresh router on auth change
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() { _sub.cancel(); super.dispose(); }
}
