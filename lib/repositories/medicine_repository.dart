import '../models/medicine.dart';

abstract class MedicineRepository {
  Future<Medicine?> getMedicineById(String id);
  Future<List<Medicine>> getAllMedicines();
  Future<List<Medicine>> searchMedicines(String query);
}
