import '../models/user.dart';
import '../models/doctor.dart';
import '../models/patient.dart';

abstract class AuthRepository {
  Future<BaseUser?> loginDoctor(String email, String password);
  Future<BaseUser?> loginPatient(String email, String password);
  Future<Doctor?> signUpDoctor({
    required String name,
    required String email,
    required String phone,
    required String registrationNumber,
    required String specialization,
    required String password,
  });
  Future<Patient?> signUpPatient({
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfBirth,
    required Gender gender,
    required String password,
  });
  Future<bool> resetPassword(String email);
}
