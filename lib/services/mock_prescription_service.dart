import 'package:uuid/uuid.dart';
import '../models/prescription.dart';
import '../models/prescribed_medicine.dart';
import 'mock_medicine_service.dart';

class MockPrescriptionService {
  static final List<Prescription> prescriptions = [
    Prescription(
      id: 'rx_001',
      doctorId: 'doctor_1',
      patientId: 'patient_1',
      date: DateTime.now().subtract(const Duration(days: 2)),
      diagnosis: 'Common Cold with Fever',
      symptoms: 'Runny nose, sore throat, mild fever',
      medicines: [
        PrescribedMedicine(
          id: 'prx_med_1',
          medicine: MockMedicineService.medicines[0],
          dose: '1 tablet',
          frequency: Frequency.twiceDaily,
          duration: '5 days',
          instructions: [Instruction.afterFood],
        ),
        PrescribedMedicine(
          id: 'prx_med_2',
          medicine: MockMedicineService.medicines[9],
          dose: '1 tablet',
          frequency: Frequency.onceDaily,
          duration: '7 days',
          instructions: [Instruction.atBedtime],
        ),
      ],
      notes: 'Stay hydrated. Rest for 24 hours.',
      followUpDate: DateTime.now().add(const Duration(days: 5)),
      status: PrescriptionStatus.sent,
    ),
    Prescription(
      id: 'rx_002',
      doctorId: 'doctor_1',
      patientId: 'patient_2',
      date: DateTime.now().subtract(const Duration(days: 5)),
      diagnosis: 'Hypertension',
      symptoms: 'Elevated blood pressure readings',
      medicines: [
        PrescribedMedicine(
          id: 'prx_med_3',
          medicine: MockMedicineService.medicines[15],
          dose: '1 tablet',
          frequency: Frequency.onceDaily,
          duration: '30 days',
          instructions: [Instruction.beforeFood],
        ),
      ],
      notes: 'Monitor blood pressure daily. Follow up after 2 weeks.',
      followUpDate: DateTime.now().add(const Duration(days: 14)),
      status: PrescriptionStatus.sent,
    ),
    Prescription(
      id: 'rx_003',
      doctorId: 'doctor_2',
      patientId: 'patient_3',
      date: DateTime.now().subtract(const Duration(days: 1)),
      diagnosis: 'Gastritis',
      symptoms: 'Stomach pain, nausea',
      medicines: [
        PrescribedMedicine(
          id: 'prx_med_4',
          medicine: MockMedicineService.medicines[11],
          dose: '1 tablet',
          frequency: Frequency.onceDaily,
          duration: '14 days',
          instructions: [Instruction.beforeFood],
        ),
      ],
      notes: 'Avoid spicy food. Take medicine before breakfast.',
      followUpDate: DateTime.now().add(const Duration(days: 7)),
      status: PrescriptionStatus.sent,
    ),
    Prescription(
      id: 'rx_004',
      doctorId: 'doctor_1',
      patientId: 'patient_4',
      date: DateTime.now(),
      diagnosis: 'Bacterial Infection',
      symptoms: 'Throat infection, fever',
      medicines: [
        PrescribedMedicine(
          id: 'prx_med_5',
          medicine: MockMedicineService.medicines[5],
          dose: '1 capsule',
          frequency: Frequency.threeTimesDaily,
          duration: '7 days',
          instructions: [Instruction.afterFood],
        ),
      ],
      notes: 'Complete the full course. Do not skip doses.',
      status: PrescriptionStatus.draft,
    ),
  ];

  static Prescription? getPrescriptionById(String id) {
    try {
      return prescriptions.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Prescription> getPrescriptionsByDoctorId(String doctorId) {
    return prescriptions.where((p) => p.doctorId == doctorId).toList();
  }

  static List<Prescription> getPrescriptionsByPatientId(String patientId) {
    return prescriptions.where((p) => p.patientId == patientId).toList();
  }

  static List<Prescription> getAllPrescriptions() {
    return prescriptions;
  }

  static List<Prescription> searchPrescriptions(String query) {
    if (query.isEmpty) {
      return prescriptions;
    }

    final lowerQuery = query.toLowerCase();
    return prescriptions.where((prescription) {
      return prescription.diagnosis.toLowerCase().contains(lowerQuery) ||
          prescription.symptoms.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static void addPrescription(Prescription prescription) {
    prescriptions.add(prescription);
  }

  static void updatePrescription(Prescription prescription) {
    final index = prescriptions.indexWhere((p) => p.id == prescription.id);
    if (index != -1) {
      prescriptions[index] = prescription;
    }
  }

  static void deletePrescription(String id) {
    prescriptions.removeWhere((p) => p.id == id);
  }

  static Prescription duplicatePrescription(String id, String newPatientId) {
    final original = getPrescriptionById(id);
    if (original == null) {
      throw Exception('Prescription not found');
    }

    final newPrescription = Prescription(
      id: 'rx_${const Uuid().v4()}',
      doctorId: original.doctorId,
      patientId: newPatientId,
      date: DateTime.now(),
      diagnosis: original.diagnosis,
      symptoms: original.symptoms,
      medicines: original.medicines,
      notes: original.notes,
      status: PrescriptionStatus.draft,
    );

    prescriptions.add(newPrescription);
    return newPrescription;
  }
}
