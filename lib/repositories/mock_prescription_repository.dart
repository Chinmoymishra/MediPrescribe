import '../models/prescription.dart';
import '../services/mock_prescription_service.dart';
import 'prescription_repository.dart';

class MockPrescriptionRepositoryImpl implements PrescriptionRepository {
  @override
  Future<Prescription?> getPrescriptionById(String id) async {
    return MockPrescriptionService.getPrescriptionById(id);
  }

  @override
  Future<List<Prescription>> getPrescriptionsByDoctorId(String doctorId) async {
    return MockPrescriptionService.getPrescriptionsByDoctorId(doctorId);
  }

  @override
  Future<List<Prescription>> getPrescriptionsByPatientId(String patientId) async {
    return MockPrescriptionService.getPrescriptionsByPatientId(patientId);
  }

  @override
  Future<List<Prescription>> getAllPrescriptions() async {
    return MockPrescriptionService.getAllPrescriptions();
  }

  @override
  Future<List<Prescription>> searchPrescriptions(String query) async {
    return MockPrescriptionService.searchPrescriptions(query);
  }

  @override
  Future<void> addPrescription(Prescription prescription) async {
    MockPrescriptionService.addPrescription(prescription);
  }

  @override
  Future<void> updatePrescription(Prescription prescription) async {
    MockPrescriptionService.updatePrescription(prescription);
  }

  @override
  Future<void> deletePrescription(String id) async {
    MockPrescriptionService.deletePrescription(id);
  }

  @override
  Future<Prescription> duplicatePrescription(String id, String newPatientId) async {
    return MockPrescriptionService.duplicatePrescription(id, newPatientId);
  }
}
