import 'package:drift/drift.dart';

import 'app_database.dart';

class SessionExerciseRepository {
  SessionExerciseRepository(this._database);

  final AppDatabase _database;

  Future<List<SessionExercise>> getForSession(int sessionId) {
    return (_database.select(_database.sessionExercises)
      ..where((table) => table.sessionId.equals(sessionId))
      ..orderBy([
            (table) => OrderingTerm.asc(table.orderIndex),
      ]))
        .get();
  }

  Future<int> save({
    required int sessionId,
    required int exerciseId,
    required int orderIndex,
  }) {
    return _database.into(_database.sessionExercises).insert(
      SessionExercisesCompanion.insert(
        sessionId: sessionId,
        exerciseId: exerciseId,
        orderIndex: orderIndex,
      ),
    );
  }

  Future<void> update(SessionExercise sessionExercise) async {
    await _database
        .update(_database.sessionExercises)
        .replace(sessionExercise);
  }

  Future<void> delete(int sessionExerciseId) async {
    await (_database.delete(_database.sessionExercises)
      ..where((table) => table.id.equals(sessionExerciseId)))
        .go();
  }
}