import 'package:drift/drift.dart';

import 'equipment_table.dart';
import 'exercise_table.dart';

class ExerciseEquipment extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.cascade)();

  IntColumn get equipmentId =>
      integer().references(Equipment, #id, onDelete: KeyAction.cascade)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {exerciseId, equipmentId},
  ];
}