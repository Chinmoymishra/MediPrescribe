import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prescription.dart';
import '../repositories/mock_prescription_repository.dart';
import '../repositories/prescription_repository.dart';

// Prescription Repository Provider
final prescriptionRepositoryProvider = Provider<PrescriptionRepository>((ref) {
  return MockPrescriptionRepositoryImpl();
});

// All Prescriptions
final allPrescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  return prescriptionRepository.getAllPrescriptions();
});

// Get Prescriptions by Doctor ID
final prescriptionsByDoctorIdProvider = FutureProvider.family<List<Prescription>, String>((ref, doctorId) async {
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  return prescriptionRepository.getPrescriptionsByDoctorId(doctorId);
});

// Get Prescriptions by Patient ID
final prescriptionsByPatientIdProvider = FutureProvider.family<List<Prescription>, String>((ref, patientId) async {
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  return prescriptionRepository.getPrescriptionsByPatientId(patientId);
});

// Get Prescription by ID
final getPrescriptionByIdProvider = FutureProvider.family<Prescription?, String>((ref, id) async {
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  return prescriptionRepository.getPrescriptionById(id);
});

// Prescription Search Query
final prescriptionSearchQueryProvider = StateProvider<String>((ref) => '');

// Filtered Prescriptions based on search
final filteredPrescriptionsProvider = FutureProvider<List<Prescription>>((ref) async {
  final searchQuery = ref.watch(prescriptionSearchQueryProvider);
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  
  if (searchQuery.isEmpty) {
    return prescriptionRepository.getAllPrescriptions();
  }
  
  return prescriptionRepository.searchPrescriptions(searchQuery);
});

// Prescription Filter (Today, This Week, This Month, All)
enum PrescriptionFilter { today, thisWeek, thisMonth, all }

final prescriptionFilterProvider = StateProvider<PrescriptionFilter>((ref) {
  return PrescriptionFilter.all;
});

// Filter prescriptions based on date filter
final filteredPrescriptionsByDateProvider = FutureProvider<List<Prescription>>((ref) async {
  final filter = ref.watch(prescriptionFilterProvider);
  final searchQuery = ref.watch(prescriptionSearchQueryProvider);
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  
  List<Prescription> prescriptions;
  if (searchQuery.isEmpty) {
    prescriptions = await prescriptionRepository.getAllPrescriptions();
  } else {
    prescriptions = await prescriptionRepository.searchPrescriptions(searchQuery);
  }
  
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  switch (filter) {
    case PrescriptionFilter.today:
      return prescriptions.where((p) {
        final pDate = DateTime(p.date.year, p.date.month, p.date.day);
        return pDate == today;
      }).toList();
    case PrescriptionFilter.thisWeek:
      final weekAgo = today.subtract(const Duration(days: 7));
      return prescriptions.where((p) {
        return p.date.isAfter(weekAgo) && p.date.isBefore(today.add(const Duration(days: 1)));
      }).toList();
    case PrescriptionFilter.thisMonth:
      final monthAgo = DateTime(today.year, today.month - 1, today.day);
      return prescriptions.where((p) {
        return p.date.isAfter(monthAgo) && p.date.isBefore(today.add(const Duration(days: 1)));
      }).toList();
    case PrescriptionFilter.all:
      return prescriptions;
  }
});

// Prescription Notifier for managing prescription operations
class PrescriptionNotifier extends StateNotifier<AsyncValue<List<Prescription>>> {
  final PrescriptionRepository prescriptionRepository;

  PrescriptionNotifier(this.prescriptionRepository) : super(const AsyncValue.loading());

  Future<void> loadPrescriptions() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => prescriptionRepository.getAllPrescriptions(),
    );
  }

  Future<void> addPrescription(Prescription prescription) async {
    await prescriptionRepository.addPrescription(prescription);
    await loadPrescriptions();
  }

  Future<void> updatePrescription(Prescription prescription) async {
    await prescriptionRepository.updatePrescription(prescription);
    await loadPrescriptions();
  }

  Future<void> deletePrescription(String id) async {
    await prescriptionRepository.deletePrescription(id);
    await loadPrescriptions();
  }

  Future<Prescription> duplicatePrescription(String id, String newPatientId) async {
    final prescription = await prescriptionRepository.duplicatePrescription(id, newPatientId);
    await loadPrescriptions();
    return prescription;
  }
}

final prescriptionsNotifierProvider = StateNotifierProvider<PrescriptionNotifier, AsyncValue<List<Prescription>>>((ref) {
  final prescriptionRepository = ref.watch(prescriptionRepositoryProvider);
  return PrescriptionNotifier(prescriptionRepository);
});
