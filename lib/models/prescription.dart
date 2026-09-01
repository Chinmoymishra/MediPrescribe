import 'prescribed_medicine.dart';
import 'doctor.dart';
import 'patient.dart';

enum PrescriptionStatus {
  draft,
  sent,
  completed,
}

class Prescription {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime date;
  final String diagnosis;
  final String symptoms;
  final List<PrescribedMedicine> medicines;
  final String? notes;
  final DateTime? followUpDate;
  final PrescriptionStatus status;

  Prescription({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.date,
    required this.diagnosis,
    required this.symptoms,
    required this.medicines,
    this.notes,
    this.followUpDate,
    required this.status,
  });

  String get statusDisplay {
    switch (status) {
      case PrescriptionStatus.draft:
        return 'Draft';
      case PrescriptionStatus.sent:
        return 'Sent';
      case PrescriptionStatus.completed:
        return 'Completed';
    }
  }

  Prescription copyWith({
    String? id,
    String? doctorId,
    String? patientId,
    DateTime? date,
    String? diagnosis,
    String? symptoms,
    List<PrescribedMedicine>? medicines,
    String? notes,
    DateTime? followUpDate,
    PrescriptionStatus? status,
  }) {
    return Prescription(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      patientId: patientId ?? this.patientId,
      date: date ?? this.date,
      diagnosis: diagnosis ?? this.diagnosis,
      symptoms: symptoms ?? this.symptoms,
      medicines: medicines ?? this.medicines,
      notes: notes ?? this.notes,
      followUpDate: followUpDate ?? this.followUpDate,
      status: status ?? this.status,
    );
  }
}
