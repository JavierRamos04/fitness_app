import 'package:drift/drift.dart';

import 'app_database.dart';
import 'equipment_seed.dart';

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

  /// Equipo que se puede marcar como "lo tengo en casa", en el orden de
  /// [homeEquipmentCodes].
  Future<List<EquipmentData>> getHomeOptions() async {
    final all = await getAll();
    final byCode = {for (final item in all) item.code: item};

    return [
      for (final code in homeEquipmentCodes)
        if (byCode[code] != null) byCode[code]!,
    ];
  }
}
