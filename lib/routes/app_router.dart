import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../views/splash_screen.dart';
import '../views/welcome_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/doctor_signup_screen.dart';
import '../views/auth/patient_signup_screen.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/doctor/doctor_dashboard.dart';
import '../views/doctor/patient_management_screen.dart';
import '../views/doctor/patient_details_screen.dart';
import '../views/doctor/add_patient_screen.dart';
import '../views/doctor/prescription_history_screen.dart';
import '../views/doctor/profile_screen.dart';
import '../views/patient/patient_dashboard.dart';
import '../views/patient/prescription_list_screen.dart';
import '../views/patient/prescription_details_screen.dart';
import '../views/prescription/create_prescription_screen.dart';
import '../views/prescription/prescription_preview_screen.dart';
// helloo hjh jkkj fhhf
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  
  return GoRouter(
    redirect: (context, state) {
      if (authState.isLoading) {
        return null;
      }

      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/welcome' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/doctor-signup' ||
          state.matchedLocation == '/patient-signup' ||
          state.matchedLocation == '/forgot-password';

      if (!isLoggedIn && !isLoggingIn && state.matchedLocation != '/splash') {
        return '/welcome';
      }

      if (isLoggedIn && (isLoggingIn || state.matchedLocation == '/splash')) {
        final user = authState.value;
        return user?.role == UserRole.doctor ? '/doctor/dashboard' : '/patient/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) {
          final userRole = state.extra as UserRole?;
          return LoginScreen(userRole: userRole);
        },
      ),
      GoRoute(
        path: '/doctor-signup',
        name: 'doctor-signup',
        builder: (context, state) => const DoctorSignUpScreen(),
      ),
      GoRoute(
        path: '/patient-signup',
        name: 'patient-signup',
        builder: (context, state) => const PatientSignUpScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      // Doctor Routes
      GoRoute(
        path: '/doctor/dashboard',
        name: 'doctor-dashboard',
        builder: (context, state) => const DoctorDashboard(),
      ),
      GoRoute(
        path: '/doctor/patients',
        name: 'doctor-patients',
        builder: (context, state) => const PatientManagementScreen(),
      ),
      GoRoute(
        path: '/doctor/patient/:id',
        name: 'doctor-patient-details',
        builder: (context, state) {
          final patientId = state.pathParameters['id']!;
          return PatientDetailsScreen(patientId: patientId);
        },
      ),
      GoRoute(
        path: '/doctor/add-patient',
        name: 'doctor-add-patient',
        builder: (context, state) => const AddPatientScreen(),
      ),
      GoRoute(
        path: '/doctor/prescriptions',
        name: 'doctor-prescriptions',
        builder: (context, state) => const PrescriptionHistoryScreen(),
      ),
      GoRoute(
        path: '/doctor/profile',
        name: 'doctor-profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      // Prescription Routes
      GoRoute(
        path: '/prescription/create',
        name: 'create-prescription',
        builder: (context, state) => const CreatePrescriptionScreen(),
      ),
      GoRoute(
        path: '/prescription/:id/preview',
        name: 'prescription-preview',
        builder: (context, state) {
          final prescriptionId = state.pathParameters['id']!;
          return PrescriptionPreviewScreen(prescriptionId: prescriptionId);
        },
      ),
      // Patient Routes
      GoRoute(
        path: '/patient/dashboard',
        name: 'patient-dashboard',
        builder: (context, state) => const PatientDashboard(),
      ),
      GoRoute(
        path: '/patient/prescriptions',
        name: 'patient-prescriptions',
        builder: (context, state) => const PrescriptionListScreen(),
      ),
      GoRoute(
        path: '/patient/prescription/:id',
        name: 'patient-prescription-details',
        builder: (context, state) {
          final prescriptionId = state.pathParameters['id']!;
          return PrescriptionDetailsScreen(prescriptionId: prescriptionId);
        },
      ),
      GoRoute(
        path: '/patient/profile',
        name: 'patient-profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    initialLocation: '/splash',
  );
});
