import 'package:drift/drift.dart';

import 'app_database.dart';

class EquipmentRepository {
  EquipmentRepository(this._database);

  final AppDatabase _database;

  /// Equipamiento activo, en el orden en que se sembró.
  Future<List<EquipmentData>> getAll() {
    return (_database.select(_database.equipment)
          ..where((equipment) => equipment.isActive.equals(true))
          ..orderBy([(equipment) => OrderingTerm.asc(equipment.id)]))
        .get();
  }
}
