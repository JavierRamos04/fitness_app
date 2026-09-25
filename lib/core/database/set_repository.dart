import 'package:drift/drift.dart';

import 'app_database.dart';

class SetRepository {
  SetRepository(this._database);

  final AppDatabase _database;

  Future<List<WorkoutSet>> getForSessionExercise(
      int sessionExerciseId,
      ) {
    return (_database.select(_database.workoutSets)
      ..where(
            (table) => table.sessionExerciseId.equals(sessionExerciseId),
      )
      ..orderBy([
            (table) => OrderingTerm.asc(table.setIndex),
      ]))
        .get();
  }

  Future<void> save({
    required int sessionExerciseId,
    required int setIndex,
    double? weightKg,
    required int repetitions,
    required String setType,
  }) async {
    await _database.into(_database.workoutSets).insert(
      WorkoutSetsCompanion.insert(
        sessionExerciseId: sessionExerciseId,
        setIndex: setIndex,
        weightKg: Value(weightKg),
        repetitions: repetitions,
        setType: setType,
      ),
    );
  }

  Future<void> update(WorkoutSet workoutSet) async {
    await _database.update(_database.workoutSets).replace(workoutSet);
  }

  Future<void> delete(int workoutSetId) async {
    await (_database.delete(_database.workoutSets)
      ..where((table) => table.id.equals(workoutSetId)))
        .go();
  }
}