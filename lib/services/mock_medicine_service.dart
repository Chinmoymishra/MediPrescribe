import 'package:uuid/uuid.dart';
import '../models/medicine.dart';

class MockMedicineService {
  static final List<Medicine> medicines = [
    Medicine(
      id: const Uuid().v4(),
      name: 'Paracetamol',
      genericName: 'Acetaminophen',
      strength: '500 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Paracetamol',
      genericName: 'Acetaminophen',
      strength: '650 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Paracetamol',
      genericName: 'Acetaminophen',
      strength: '125 mg',
      form: MedicineForm.syrup,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Paracip',
      genericName: 'Acetaminophen',
      strength: '500 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Pacimol',
      genericName: 'Acetaminophen',
      strength: '650 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Amoxicillin',
      genericName: 'Amoxicillin Trihydrate',
      strength: '500 mg',
      form: MedicineForm.capsule,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Amoxicillin',
      genericName: 'Amoxicillin Trihydrate',
      strength: '250 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Azithromycin',
      genericName: 'Azithromycin Dihydrate',
      strength: '500 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Azithromycin',
      genericName: 'Azithromycin Dihydrate',
      strength: '250 mg',
      form: MedicineForm.syrup,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Cetirizine',
      genericName: 'Cetirizine HCl',
      strength: '10 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Cetirizine',
      genericName: 'Cetirizine HCl',
      strength: '5 mg',
      form: MedicineForm.syrup,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Pantoprazole',
      genericName: 'Pantoprazole Sodium',
      strength: '40 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Omeprazole',
      genericName: 'Omeprazole',
      strength: '20 mg',
      form: MedicineForm.capsule,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Omeprazole',
      genericName: 'Omeprazole',
      strength: '10 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Metformin',
      genericName: 'Metformin HCl',
      strength: '500 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Amlodipine',
      genericName: 'Amlodipine Besylate',
      strength: '5 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Amlodipine',
      genericName: 'Amlodipine Besylate',
      strength: '10 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Atorvastatin',
      genericName: 'Atorvastatin Calcium',
      strength: '10 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Atorvastatin',
      genericName: 'Atorvastatin Calcium',
      strength: '20 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Ibuprofen',
      genericName: 'Ibuprofen',
      strength: '400 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Vitamin D3',
      genericName: 'Cholecalciferol',
      strength: '1000 IU',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Vitamin D3',
      genericName: 'Cholecalciferol',
      strength: '1000 IU',
      form: MedicineForm.syrup,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Calcium',
      genericName: 'Calcium Carbonate',
      strength: '500 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Zinc',
      genericName: 'Zinc Sulphate',
      strength: '20 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Aspirin',
      genericName: 'Acetylsalicylic Acid',
      strength: '75 mg',
      form: MedicineForm.tablet,
    ),
    Medicine(
      id: const Uuid().v4(),
      name: 'Cough Syrup',
      genericName: 'Dextromethorphan + Chlorpheniramine',
      strength: '10 mg + 2 mg',
      form: MedicineForm.syrup,
    ),
  ];

  static List<Medicine> searchMedicines(String query) {
    if (query.isEmpty) {
      return [];
    }
    
    final lowerQuery = query.toLowerCase();
    return medicines.where((medicine) {
      return medicine.name.toLowerCase().contains(lowerQuery) ||
          medicine.genericName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static List<Medicine> getAllMedicines() {
    return medicines;
  }

  static Medicine? getMedicineById(String id) {
    try {
      return medicines.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}
