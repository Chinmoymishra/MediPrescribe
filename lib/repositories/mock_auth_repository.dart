import '../models/user.dart';
import '../models/doctor.dart';
import '../models/patient.dart';
import '../services/mock_auth_service.dart';
import 'auth_repository.dart';

class MockAuthRepositoryImpl implements AuthRepository {
  @override
  Future<BaseUser?> loginDoctor(String email, String password) {
    return MockAuthService.loginDoctor(email, password);
  }

  @override
  Future<BaseUser?> loginPatient(String email, String password) {
    return MockAuthService.loginPatient(email, password);
  }

  @override
  Future<Doctor?> signUpDoctor({
    required String name,
    required String email,
    required String phone,
    required String registrationNumber,
    required String specialization,
    required String password,
  }) {
    return MockAuthService.signUpDoctor(
      name: name,
      email: email,
      phone: phone,
      registrationNumber: registrationNumber,
      specialization: specialization,
      password: password,
    );
  }

  @override
  Future<Patient?> signUpPatient({
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfBirth,
    required Gender gender,
    required String password,
  }) {
    return MockAuthService.signUpPatient(
      name: name,
      email: email,
      phone: phone,
      dateOfBirth: dateOfBirth,
      gender: gender,
      password: password,
    );
  }

  @override
  Future<bool> resetPassword(String email) {
    return MockAuthService.resetPassword(email);
  }
}
