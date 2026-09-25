import 'app_database.dart';

class ExerciseEquipmentRepository {
  ExerciseEquipmentRepository(this._database);

  final AppDatabase _database;

  Future<void> save({
    required int exerciseId,
    required int equipmentId,
  }) async {
    await _database.into(_database.exerciseEquipment).insert(
      ExerciseEquipmentCompanion.insert(
        exerciseId: exerciseId,
        equipmentId: equipmentId,
      ),
    );
  }

  Future<List<ExerciseEquipmentData>> getAll() {
    return _database.select(_database.exerciseEquipment).get();
  }
}