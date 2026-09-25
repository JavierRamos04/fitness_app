import 'package:drift/drift.dart';

import 'exercise_table.dart';
import 'session_table.dart';

class SessionExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId =>
      integer().references(Sessions, #id, onDelete: KeyAction.cascade)();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.restrict)();

  IntColumn get orderIndex => integer()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sessionId, orderIndex},
  ];
}