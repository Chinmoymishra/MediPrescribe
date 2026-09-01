import 'package:uuid/uuid.dart';
import '../models/patient.dart';

class MockPatientService {
  static final List<Patient> patients = [
    Patient(
      id: 'patient_1',
      name: 'Amit Singh',
      email: 'amit.singh@email.com',
      phone: '+91-9123456789',
      dateOfBirth: DateTime(1990, 5, 15),
      gender: Gender.male,
      bloodGroup: 'O+',
      address: '123 Main Street, New Delhi',
    ),
    Patient(
      id: 'patient_2',
      name: 'Sneha Patel',
      email: 'sneha.patel@email.com',
      phone: '+91-9123456788',
      dateOfBirth: DateTime(1995, 8, 22),
      gender: Gender.female,
      bloodGroup: 'A+',
      address: '456 Park Avenue, Mumbai',
    ),
    Patient(
      id: 'patient_3',
      name: 'Rohit Verma',
      email: 'rohit.verma@email.com',
      phone: '+91-9123456787',
      dateOfBirth: DateTime(1985, 3, 10),
      gender: Gender.male,
      bloodGroup: 'B+',
      address: '789 Elm Street, Bangalore',
    ),
    Patient(
      id: 'patient_4',
      name: 'Neha Gupta',
      email: 'neha.gupta@email.com',
      phone: '+91-9123456786',
      dateOfBirth: DateTime(2000, 12, 5),
      gender: Gender.female,
      bloodGroup: 'AB+',
      address: '321 Oak Road, Hyderabad',
    ),
    Patient(
      id: 'patient_5',
      name: 'Vikram Desai',
      email: 'vikram.desai@email.com',
      phone: '+91-9123456785',
      dateOfBirth: DateTime(1992, 7, 18),
      gender: Gender.male,
      bloodGroup: 'O-',
      address: '654 Pine Street, Chennai',
    ),
    Patient(
      id: 'patient_6',
      name: 'Ananya Mishra',
      email: 'ananya.mishra@email.com',
      phone: '+91-9123456784',
      dateOfBirth: DateTime(1998, 11, 28),
      gender: Gender.female,
      bloodGroup: 'A-',
      address: '987 Maple Avenue, Kolkata',
    ),
    Patient(
      id: 'patient_7',
      name: 'Arjun Chopra',
      email: 'arjun.chopra@email.com',
      phone: '+91-9123456783',
      dateOfBirth: DateTime(1988, 2, 14),
      gender: Gender.male,
      bloodGroup: 'B-',
      address: '246 Birch Lane, Pune',
    ),
    Patient(
      id: 'patient_8',
      name: 'Divya Reddy',
      email: 'divya.reddy@email.com',
      phone: '+91-9123456782',
      dateOfBirth: DateTime(1996, 6, 9),
      gender: Gender.female,
      bloodGroup: 'AB-',
      address: '135 Cedar Street, Jaipur',
    ),
    Patient(
      id: 'patient_9',
      name: 'Sanjay Kumar',
      email: 'sanjay.kumar@email.com',
      phone: '+91-9123456781',
      dateOfBirth: DateTime(1980, 4, 20),
      gender: Gender.male,
      bloodGroup: 'O+',
      address: '579 Spruce Road, Lucknow',
    ),
    Patient(
      id: 'patient_10',
      name: 'Pallavi Rao',
      email: 'pallavi.rao@email.com',
      phone: '+91-9123456780',
      dateOfBirth: DateTime(1999, 9, 30),
      gender: Gender.female,
      bloodGroup: 'A+',
      address: '802 Willow Avenue, Chandigarh',
    ),
  ];

  static Patient? getPatientById(String id) {
    try {
      return patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static Patient? getPatientByEmail(String email) {
    try {
      return patients.firstWhere((p) => p.email == email);
    } catch (e) {
      return null;
    }
  }

  static List<Patient> getAllPatients() {
    return patients;
  }

  static List<Patient> searchPatients(String query) {
    if (query.isEmpty) {
      return patients;
    }
    
    final lowerQuery = query.toLowerCase();
    return patients.where((patient) {
      return patient.name.toLowerCase().contains(lowerQuery) ||
          patient.phone.contains(query) ||
          patient.email.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static void addPatient(Patient patient) {
    patients.add(patient);
  }

  static void updatePatient(Patient patient) {
    final index = patients.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      patients[index] = patient;
    }
  }

  static void deletePatient(String id) {
    patients.removeWhere((p) => p.id == id);
  }
}
