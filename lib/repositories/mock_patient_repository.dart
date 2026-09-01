import '../models/patient.dart';
import '../services/mock_patient_service.dart';
import 'patient_repository.dart';

class MockPatientRepositoryImpl implements PatientRepository {
  @override
  Future<Patient?> getPatientById(String id) async {
    return MockPatientService.getPatientById(id);
  }

  @override
  Future<List<Patient>> getAllPatients() async {
    return MockPatientService.getAllPatients();
  }

  @override
  Future<List<Patient>> searchPatients(String query) async {
    return MockPatientService.searchPatients(query);
  }

  @override
  Future<void> addPatient(Patient patient) async {
    MockPatientService.addPatient(patient);
  }

  @override
  Future<void> updatePatient(Patient patient) async {
    MockPatientService.updatePatient(patient);
  }

  @override
  Future<void> deletePatient(String id) async {
    MockPatientService.deletePatient(id);
  }
}
