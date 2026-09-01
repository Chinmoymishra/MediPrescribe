import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/patient.dart';
import '../repositories/mock_patient_repository.dart';
import '../repositories/patient_repository.dart';

// Patient Repository Provider
final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return MockPatientRepositoryImpl();
});

// All Patients
final patientsProvider = FutureProvider<List<Patient>>((ref) async {
  final patientRepository = ref.watch(patientRepositoryProvider);
  return patientRepository.getAllPatients();
});

// Patient Search Query
final patientSearchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Patients based on search
final filteredPatientsProvider = FutureProvider<List<Patient>>((ref) async {
  final searchQuery = ref.watch(patientSearchQueryProvider);
  final patientRepository = ref.watch(patientRepositoryProvider);
  
  if (searchQuery.isEmpty) {
    return patientRepository.getAllPatients();
  }
  
  return patientRepository.searchPatients(searchQuery);
});

// Get Patient by ID
final getPatientByIdProvider = FutureProvider.family<Patient?, String>((ref, id) async {
  final patientRepository = ref.watch(patientRepositoryProvider);
  return patientRepository.getPatientById(id);
});

// Patient Notifier for managing patient operations
class PatientNotifier extends StateNotifier<AsyncValue<List<Patient>>> {
  final PatientRepository patientRepository;

  PatientNotifier(this.patientRepository) : super(const AsyncValue.loading());

  Future<void> loadPatients() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => patientRepository.getAllPatients(),
    );
  }

  Future<void> addPatient(Patient patient) async {
    await patientRepository.addPatient(patient);
    await loadPatients();
  }

  Future<void> updatePatient(Patient patient) async {
    await patientRepository.updatePatient(patient);
    await loadPatients();
  }

  Future<void> deletePatient(String id) async {
    await patientRepository.deletePatient(id);
    await loadPatients();
  }
}

final patientsNotifierProvider = StateNotifierProvider<PatientNotifier, AsyncValue<List<Patient>>>((ref) {
  final patientRepository = ref.watch(patientRepositoryProvider);
  return PatientNotifier(patientRepository);
});
