import 'package:drift/drift.dart';

import 'equipment_table.dart';
import 'user_table.dart';

/// Equipo que el usuario tiene disponible (por ejemplo, en casa).
class UserEquipment extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get userId =>
      integer().references(Users, #id, onDelete: KeyAction.cascade)();

  IntColumn get equipmentId =>
      integer().references(Equipment, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, equipmentId},
  ];
}
