import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prescription.dart';
import '../models/prescribed_medicine.dart';

// Prescription Creation Form State
class PrescriptionFormState {
  final String? patientId;
  final String diagnosis;
  final String symptoms;
  final List<PrescribedMedicine> medicines;
  final String? notes;
  final DateTime? followUpDate;

  PrescriptionFormState({
    this.patientId,
    this.diagnosis = '',
    this.symptoms = '',
    this.medicines = const [],
    this.notes,
    this.followUpDate,
  });

  PrescriptionFormState copyWith({
    String? patientId,
    String? diagnosis,
    String? symptoms,
    List<PrescribedMedicine>? medicines,
    String? notes,
    DateTime? followUpDate,
  }) {
    return PrescriptionFormState(
      patientId: patientId ?? this.patientId,
      diagnosis: diagnosis ?? this.diagnosis,
      symptoms: symptoms ?? this.symptoms,
      medicines: medicines ?? this.medicines,
      notes: notes ?? this.notes,
      followUpDate: followUpDate ?? this.followUpDate,
    );
  }

  bool get isValid {
    return patientId != null &&
        diagnosis.isNotEmpty &&
        symptoms.isNotEmpty &&
        medicines.isNotEmpty;
  }
}

// Prescription Form Notifier
class PrescriptionFormNotifier extends StateNotifier<PrescriptionFormState> {
  PrescriptionFormNotifier() : super(PrescriptionFormState());

  void setPatientId(String patientId) {
    state = state.copyWith(patientId: patientId);
  }

  void setDiagnosis(String diagnosis) {
    state = state.copyWith(diagnosis: diagnosis);
  }

  void setSymptoms(String symptoms) {
    state = state.copyWith(symptoms: symptoms);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void setFollowUpDate(DateTime? date) {
    state = state.copyWith(followUpDate: date);
  }

  void addMedicine(PrescribedMedicine medicine) {
    final updatedMedicines = [...state.medicines, medicine];
    state = state.copyWith(medicines: updatedMedicines);
  }

  void removeMedicine(String medicineId) {
    final updatedMedicines = state.medicines
        .where((m) => m.id != medicineId)
        .toList();
    state = state.copyWith(medicines: updatedMedicines);
  }

  void updateMedicine(String medicineId, PrescribedMedicine updatedMedicine) {
    final updatedMedicines = state.medicines.map((m) {
      return m.id == medicineId ? updatedMedicine : m;
    }).toList();
    state = state.copyWith(medicines: updatedMedicines);
  }

  void reset() {
    state = PrescriptionFormState();
  }
}

final prescriptionFormProvider = StateNotifierProvider<PrescriptionFormNotifier, PrescriptionFormState>((ref) {
  return PrescriptionFormNotifier();
});

// Selected medicine for editing
final selectedMedicineForEditingProvider = StateProvider<PrescribedMedicine?>((ref) => null);

// Current editing medicine index
final editingMedicineIndexProvider = StateProvider<int?>((ref) => null);
