import '../models/patient.dart';

abstract class PatientRepository {
  Future<Patient?> getPatientById(String id);
  Future<List<Patient>> getAllPatients();
  Future<List<Patient>> searchPatients(String query);
  Future<void> addPatient(Patient patient);
  Future<void> updatePatient(Patient patient);
  Future<void> deletePatient(String id);
}
