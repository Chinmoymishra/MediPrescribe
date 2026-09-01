import '../models/prescription.dart';

abstract class PrescriptionRepository {
  Future<Prescription?> getPrescriptionById(String id);
  Future<List<Prescription>> getPrescriptionsByDoctorId(String doctorId);
  Future<List<Prescription>> getPrescriptionsByPatientId(String patientId);
  Future<List<Prescription>> getAllPrescriptions();
  Future<List<Prescription>> searchPrescriptions(String query);
  Future<void> addPrescription(Prescription prescription);
  Future<void> updatePrescription(Prescription prescription);
  Future<void> deletePrescription(String id);
  Future<Prescription> duplicatePrescription(String id, String newPatientId);
}
