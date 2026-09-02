import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/prescription.dart';
import '../models/prescribed_medicine.dart';
import '../models/patient.dart';

enum PatientType { existing, newPatient }

// Prescription Creation Form State
class PrescriptionFormState {
  final PatientType patientType;
  final String? patientId;
  final String diagnosis;
  final String symptoms;
  final List<PrescribedMedicine> medicines;
  final String? notes;
  final DateTime? followUpDate;

  // New patient fields (only used when patientType == PatientType.newPatient)
  final String newPatientName;
  final String newPatientAge;
  final Gender newPatientGender;
  final String newPatientPhone;
  final String newPatientEmail;
  final String? newPatientBloodGroup;
  final String? newPatientAddress;

  PrescriptionFormState({
    this.patientType = PatientType.existing,
    this.patientId,
    this.diagnosis = '',
    this.symptoms = '',
    this.medicines = const [],
    this.notes,
    this.followUpDate,
    this.newPatientName = '',
    this.newPatientAge = '',
    this.newPatientGender = Gender.male,
    this.newPatientPhone = '',
    this.newPatientEmail = '',
    this.newPatientBloodGroup,
    this.newPatientAddress,
  });

  PrescriptionFormState copyWith({
    PatientType? patientType,
    String? patientId,
    bool clearPatientId = false,
    String? diagnosis,
    String? symptoms,
    List<PrescribedMedicine>? medicines,
    String? notes,
    DateTime? followUpDate,
    bool clearFollowUpDate = false,
    String? newPatientName,
    String? newPatientAge,
    Gender? newPatientGender,
    String? newPatientPhone,
    String? newPatientEmail,
    String? newPatientBloodGroup,
    String? newPatientAddress,
  }) {
    return PrescriptionFormState(
      patientType: patientType ?? this.patientType,
      patientId: clearPatientId ? null : (patientId ?? this.patientId),
      diagnosis: diagnosis ?? this.diagnosis,
      symptoms: symptoms ?? this.symptoms,
      medicines: medicines ?? this.medicines,
      notes: notes ?? this.notes,
      followUpDate: clearFollowUpDate ? null : (followUpDate ?? this.followUpDate),
      newPatientName: newPatientName ?? this.newPatientName,
      newPatientAge: newPatientAge ?? this.newPatientAge,
      newPatientGender: newPatientGender ?? this.newPatientGender,
      newPatientPhone: newPatientPhone ?? this.newPatientPhone,
      newPatientEmail: newPatientEmail ?? this.newPatientEmail,
      newPatientBloodGroup: newPatientBloodGroup ?? this.newPatientBloodGroup,
      newPatientAddress: newPatientAddress ?? this.newPatientAddress,
    );
  }

  bool get isPatientValid {
    if (patientType == PatientType.existing) {
      return patientId != null;
    }
    return newPatientName.trim().isNotEmpty &&
        newPatientAge.trim().isNotEmpty &&
        newPatientPhone.trim().isNotEmpty;
  }

  bool get isValid {
    return isPatientValid &&
        diagnosis.trim().isNotEmpty &&
        symptoms.trim().isNotEmpty &&
        medicines.isNotEmpty;
  }
}

// Prescription Form Notifier
class PrescriptionFormNotifier extends StateNotifier<PrescriptionFormState> {
  PrescriptionFormNotifier() : super(PrescriptionFormState());

  void setPatientType(PatientType type) {
    state = state.copyWith(patientType: type, clearPatientId: true);
  }

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
    if (date == null) {
      state = state.copyWith(clearFollowUpDate: true);
    } else {
      state = state.copyWith(followUpDate: date);
    }
  }

  void setNewPatientName(String value) => state = state.copyWith(newPatientName: value);
  void setNewPatientAge(String value) => state = state.copyWith(newPatientAge: value);
  void setNewPatientGender(Gender value) => state = state.copyWith(newPatientGender: value);
  void setNewPatientPhone(String value) => state = state.copyWith(newPatientPhone: value);
  void setNewPatientEmail(String value) => state = state.copyWith(newPatientEmail: value);
  void setNewPatientBloodGroup(String value) => state = state.copyWith(newPatientBloodGroup: value);
  void setNewPatientAddress(String value) => state = state.copyWith(newPatientAddress: value);

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

  // Auto-fills prescription-specific fields from a previous prescription
  // while keeping the currently selected patient identity.
  void applyPreviousPrescription(Prescription previous) {
    state = state.copyWith(
      diagnosis: previous.diagnosis,
      symptoms: previous.symptoms,
      medicines: previous.medicines,
      notes: previous.notes ?? '',
      followUpDate: previous.followUpDate,
      clearFollowUpDate: previous.followUpDate == null,
    );
  }

  // Clears prescription-specific data but keeps the selected patient
  // (identity/type), for the Reset Form action.
  void resetPrescriptionFields() {
    state = PrescriptionFormState(
      patientType: state.patientType,
      patientId: state.patientId,
      newPatientName: state.patientType == PatientType.newPatient ? state.newPatientName : '',
      newPatientAge: state.patientType == PatientType.newPatient ? state.newPatientAge : '',
      newPatientGender: state.newPatientGender,
      newPatientPhone: state.patientType == PatientType.newPatient ? state.newPatientPhone : '',
      newPatientEmail: state.patientType == PatientType.newPatient ? state.newPatientEmail : '',
      newPatientBloodGroup: state.patientType == PatientType.newPatient ? state.newPatientBloodGroup : null,
      newPatientAddress: state.patientType == PatientType.newPatient ? state.newPatientAddress : null,
    );
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
