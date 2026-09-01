import '../models/medicine.dart';
import '../services/mock_medicine_service.dart';
import 'medicine_repository.dart';

class MockMedicineRepositoryImpl implements MedicineRepository {
  @override
  Future<Medicine?> getMedicineById(String id) async {
    return MockMedicineService.getMedicineById(id);
  }

  @override
  Future<List<Medicine>> getAllMedicines() async {
    return MockMedicineService.getAllMedicines();
  }

  @override
  Future<List<Medicine>> searchMedicines(String query) async {
    return MockMedicineService.searchMedicines(query);
  }
}
