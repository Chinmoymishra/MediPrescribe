import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/doctor.dart';
import '../models/patient.dart';
import '../repositories/mock_auth_repository.dart';
import '../repositories/auth_repository.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepositoryImpl();
});

// Current User Role
final currentUserRoleProvider = StateProvider<UserRole?>((ref) => null);

// Current User (Doctor or Patient)
final currentUserProvider = StateProvider<BaseUser?>((ref) => null);

// Auth State Notifier
class AuthNotifier extends StateNotifier<AsyncValue<BaseUser?>> {
  final AuthRepository authRepository;

  AuthNotifier(this.authRepository) : super(const AsyncValue.data(null));

  Future<void> loginDoctor(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.loginDoctor(email, password),
    );
  }

  Future<void> loginPatient(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.loginPatient(email, password),
    );
  }

  Future<void> signUpDoctor({
    required String name,
    required String email,
    required String phone,
    required String registrationNumber,
    required String specialization,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.signUpDoctor(
        name: name,
        email: email,
        phone: phone,
        registrationNumber: registrationNumber,
        specialization: specialization,
        password: password,
      ),
    );
  }

  Future<void> signUpPatient({
    required String name,
    required String email,
    required String phone,
    required DateTime dateOfBirth,
    required Gender gender,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => authRepository.signUpPatient(
        name: name,
        email: email,
        phone: phone,
        dateOfBirth: dateOfBirth,
        gender: gender,
        password: password,
      ),
    );
  }

  Future<bool> resetPassword(String email) async {
    return await authRepository.resetPassword(email);
  }

  void logout() {
    state = const AsyncValue.data(null);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<BaseUser?>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthNotifier(authRepository);
});
