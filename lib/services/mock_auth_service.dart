import 'package:uuid/uuid.dart';
import '../models/doctor.dart';
import '../models/patient.dart';
import '../models/user.dart';
import 'mock_doctor_service.dart';
import 'mock_patient_service.dart';

class MockAuthService {
  static const String _debugPassword = 'password123';

  static Future<BaseUser?> loginDoctor(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (password != _debugPassword) {
      return null;
    }

    return MockDoctorService.getDoctorByEmail(email);
  }

  static Future<BaseUser?> loginPatient(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (password != _debugPassword) {
      return null;
    }

    return MockPatientService.getPatientByEmail(email);
  }

  static Future<Doctor?> signUpDoctor({
    required String name,
    required String email,
    required String phone,
    required String registrationNumber,
    required String specialization,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if email already exists
    if (MockDoctorService.getDoctorByEmail(email) != null) {
      return null;
    }

    final doctor = Doctor(
      id: 'doctor_${const Uuid().v4()}',
      name: name,
      email: email,
      phone: phone,
      registrationNumber: registrationNumber,
      specialization: specialization,
    );

    MockDoctorService.addDoctor(doctor);
    return doctor;
  }

  static Future<Patient?> signUpPatient({
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfBirth,
    required Gender gender,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if email already exists
    if (MockPatientService.getPatientByEmail(email) != null) {
      return null;
    }

    final patient = Patient(
      id: 'patient_${const Uuid().v4()}',
      name: name,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
    );

    MockPatientService.addPatient(patient);
    return patient;
  }

  static Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation - always succeeds
    return true;
  }
}
