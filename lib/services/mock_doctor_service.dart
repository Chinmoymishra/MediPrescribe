import 'package:uuid/uuid.dart';
import '../models/doctor.dart';

class MockDoctorService {
  static final List<Doctor> doctors = [
    Doctor(
      id: 'doctor_1',
      name: 'Dr. Rajesh Kumar',
      email: 'rajesh.kumar@hospital.com',
      phone: '+91-9876543210',
      registrationNumber: 'MR-001234',
      specialization: 'General Medicine',
    ),
    Doctor(
      id: 'doctor_2',
      name: 'Dr. Priya Sharma',
      email: 'priya.sharma@hospital.com',
      phone: '+91-9876543211',
      registrationNumber: 'MR-001235',
      specialization: 'Cardiologist',
    ),
  ];

  static Doctor? getDoctorById(String id) {
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  static Doctor? getDoctorByEmail(String email) {
    try {
      return doctors.firstWhere((d) => d.email == email);
    } catch (e) {
      return null;
    }
  }

  static List<Doctor> getAllDoctors() {
    return doctors;
  }

  static void addDoctor(Doctor doctor) {
    doctors.add(doctor);
  }

  static void updateDoctor(Doctor doctor) {
    final index = doctors.indexWhere((d) => d.id == doctor.id);
    if (index != -1) {
      doctors[index] = doctor;
    }
  }
}
