import 'package:drift/drift.dart';

import 'session_exercise_table.dart';

class WorkoutSets extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionExerciseId =>
      integer().references(
        SessionExercises,
        #id,
        onDelete: KeyAction.cascade,
      )();

  IntColumn get setIndex => integer()();

  RealColumn get weightKg => real().nullable()();

  IntColumn get repetitions => integer()();

  TextColumn get setType => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sessionExerciseId, setIndex},
  ];
}