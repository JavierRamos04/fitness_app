import 'package:drift/drift.dart';

import 'exercise_table.dart';
import 'workout_table.dart';

class WorkoutExercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get workoutId =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();

  IntColumn get exerciseId =>
      integer().references(Exercises, #id, onDelete: KeyAction.restrict)();

  IntColumn get orderIndex => integer()();

  IntColumn get sets => integer()();

  IntColumn get minReps => integer()();

  IntColumn get maxReps => integer()();

  IntColumn get restSeconds => integer()();

  TextColumn get setType => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {workoutId, orderIndex},
  ];
}