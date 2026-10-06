import 'package:drift/drift.dart';

import 'app_database.dart';

class UserEquipmentRepository {
  UserEquipmentRepository(this._database);

  final AppDatabase _database;

  /// Códigos del equipo que tiene el usuario (por ejemplo, `dumbbells`).
  Future<Set<String>> getCodes(int userId) async {
    final query = _database.select(_database.userEquipment).join([
      innerJoin(
        _database.equipment,
        _database.equipment.id.equalsExp(
          _database.userEquipment.equipmentId,
        ),
      ),
    ])
      ..where(_database.userEquipment.userId.equals(userId));

    final rows = await query.get();

    return rows.map((row) => row.readTable(_database.equipment).code).toSet();
  }

  /// Sustituye todo el equipo del usuario por [codes]. Los códigos que no
  /// existen en el catálogo de equipamiento se ignoran.
  Future<void> replaceAll(int userId, Set<String> codes) async {
    await _database.transaction(() async {
      await (_database.delete(_database.userEquipment)
            ..where((row) => row.userId.equals(userId)))
          .go();

      if (codes.isEmpty) {
        return;
      }

      final equipment = await (_database.select(_database.equipment)
            ..where((row) => row.code.isIn(codes)))
          .get();

      await _database.batch((batch) {
        batch.insertAll(
          _database.userEquipment,
          [
            for (final item in equipment)
              UserEquipmentCompanion.insert(
                userId: userId,
                equipmentId: item.id,
              ),
          ],
        );
      });
    });
  }
}
