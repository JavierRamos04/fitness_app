import 'package:drift/drift.dart';

import 'app_database.dart';

class WorkoutExerciseRepository {
  WorkoutExerciseRepository(this._database);

  final AppDatabase _database;

  Future<List<WorkoutExercise>> getForWorkout(int workoutId) {
    return (_database.select(_database.workoutExercises)
      ..where((table) => table.workoutId.equals(workoutId))
      ..orderBy([
            (table) => OrderingTerm.asc(table.orderIndex),
      ]))
        .get();
  }

  Future<void> save({
    required int workoutId,
    required int exerciseId,
    required int orderIndex,
    required int sets,
    required int minReps,
    required int maxReps,
    required int restSeconds,
    required String setType,
  }) async {
    await _database.into(_database.workoutExercises).insert(
      WorkoutExercisesCompanion.insert(
        workoutId: workoutId,
        exerciseId: exerciseId,
        orderIndex: orderIndex,
        sets: sets,
        minReps: minReps,
        maxReps: maxReps,
        restSeconds: restSeconds,
        setType: setType,
      ),
    );
  }

  Future<void> update(WorkoutExercise workoutExercise) async {
    await _database
        .update(_database.workoutExercises)
        .replace(workoutExercise);
  }

  Future<void> delete(int workoutExerciseId) async {
    await (_database.delete(_database.workoutExercises)
      ..where((table) => table.id.equals(workoutExerciseId)))
        .go();
  }
}