import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medicine.dart';
import '../repositories/mock_medicine_repository.dart';
import '../repositories/medicine_repository.dart';

// Medicine Repository Provider
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MockMedicineRepositoryImpl();
});

// All Medicines
final allMedicinesProvider = FutureProvider<List<Medicine>>((ref) async {
  final medicineRepository = ref.watch(medicineRepositoryProvider);
  return medicineRepository.getAllMedicines();
});

// Medicine Search Query
final medicineSearchQueryProvider = StateProvider<String>((ref) => '');

// Medicine Suggestions (filtered based on search query)
final medicineSuggestionsProvider = FutureProvider<List<Medicine>>((ref) async {
  final searchQuery = ref.watch(medicineSearchQueryProvider);
  final medicineRepository = ref.watch(medicineRepositoryProvider);
  
  if (searchQuery.isEmpty) {
    return [];
  }
  
  return medicineRepository.searchMedicines(searchQuery);
});

// Get Medicine by ID
final getMedicineByIdProvider = FutureProvider.family<Medicine?, String>((ref, id) async {
  final medicineRepository = ref.watch(medicineRepositoryProvider);
  return medicineRepository.getMedicineById(id);
});

// Update search query
final updateMedicineSearchProvider = Provider<Function(String)>((ref) {
  return (String query) {
    ref.read(medicineSearchQueryProvider.notifier).state = query;
  };
});

// Clear search query
final clearMedicineSearchProvider = Provider<Function()>((ref) {
  return () {
    ref.read(medicineSearchQueryProvider.notifier).state = '';
  };
});
