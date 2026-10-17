import 'package:drift/drift.dart';

import 'app_database.dart';

/// Series de la última vez que el usuario completó un ejercicio.
class LastPerformance {
  const LastPerformance({
    required this.sessionStartedAt,
    required this.sets,
  });

  final DateTime sessionStartedAt;
  final List<WorkoutSet> sets;
}

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

  /// Devuelve las series de la sesión COMPLETADA más reciente del usuario
  /// en la que se registró al menos una serie de [exerciseId], o `null` si
  /// nunca lo ha entrenado. Las sesiones en curso o canceladas se ignoran.
  Future<LastPerformance?> getLastPerformance({
    required int userId,
    required int exerciseId,
  }) async {
    final query = _database.select(_database.sessionExercises).join([
      innerJoin(
        _database.sessions,
        _database.sessions.id.equalsExp(
          _database.sessionExercises.sessionId,
        ),
      ),
    ])
      ..where(
        _database.sessions.userId.equals(userId) &
        _database.sessions.status.equals('completed') &
        _database.sessionExercises.exerciseId.equals(exerciseId),
      )
      ..orderBy([
        OrderingTerm.desc(_database.sessions.startedAt),
        OrderingTerm.desc(_database.sessions.id),
        OrderingTerm.desc(_database.sessionExercises.id),
      ]);

    final rows = await query.get();

    for (final row in rows) {
      final sessionExercise = row.readTable(_database.sessionExercises);
      final session = row.readTable(_database.sessions);

      final sets = await getForSessionExercise(sessionExercise.id);

      if (sets.isNotEmpty) {
        return LastPerformance(
          sessionStartedAt: session.startedAt,
          sets: sets,
        );
      }
    }

    return null;
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

  /// Corrige las repeticiones (o segundos) y el peso de una serie. Un
  /// [weightKg] `null` deja la serie sin peso (peso corporal).
  Future<void> updateValues({
    required int workoutSetId,
    required int repetitions,
    required double? weightKg,
  }) async {
    await (_database.update(_database.workoutSets)
          ..where((table) => table.id.equals(workoutSetId)))
        .write(
      WorkoutSetsCompanion(
        repetitions: Value(repetitions),
        weightKg: Value(weightKg),
      ),
    );
  }

  /// Borra una serie y renumera las restantes del ejercicio para que sigan
  /// siendo 1, 2, 3… sin huecos (así la siguiente serie nueva no choca).
  Future<void> deleteAndReindex(int workoutSetId) async {
    await _database.transaction(() async {
      final row = await (_database.select(_database.workoutSets)
            ..where((table) => table.id.equals(workoutSetId)))
          .getSingleOrNull();

      if (row == null) {
        return;
      }

      await delete(workoutSetId);

      final remaining = await getForSessionExercise(row.sessionExerciseId);

      for (var index = 0; index < remaining.length; index++) {
        final expected = index + 1;

        if (remaining[index].setIndex != expected) {
          await (_database.update(_database.workoutSets)
                ..where((table) => table.id.equals(remaining[index].id)))
              .write(WorkoutSetsCompanion(setIndex: Value(expected)));
        }
      }
    });
  }

  Future<void> delete(int workoutSetId) async {
    await (_database.delete(_database.workoutSets)
      ..where((table) => table.id.equals(workoutSetId)))
        .go();
  }
}