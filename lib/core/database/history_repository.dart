import 'package:drift/drift.dart';

import 'app_database.dart';

class TrainingHistoryItem {
  const TrainingHistoryItem({
    required this.session,
    required this.workoutName,
    required this.exerciseCount,
    required this.setCount,
    required this.totalRepetitions,
    required this.totalVolumeKg,
  });

  final Session session;
  final String? workoutName;
  final int exerciseCount;
  final int setCount;
  final int totalRepetitions;
  final double totalVolumeKg;
}

class HistoryRepository {
  HistoryRepository(this._database);

  final AppDatabase _database;

  Future<List<TrainingHistoryItem>> getCompletedForUser(
      int userId,
      ) async {
    final sessions = await (_database.select(_database.sessions)
      ..where(
            (table) =>
        table.userId.equals(userId) &
        table.status.equals('completed'),
      )
      ..orderBy([
            (table) => OrderingTerm.desc(table.startedAt),
      ]))
        .get();

    final history = <TrainingHistoryItem>[];

    for (final session in sessions) {
      String? workoutName;

      final workoutId = session.workoutId;

      if (workoutId != null) {
        final workout = await (_database.select(_database.workouts)
          ..where(
                (table) => table.id.equals(workoutId),
          ))
            .getSingleOrNull();

        workoutName = workout?.name;
      }

      final sessionExercises =
      await (_database.select(_database.sessionExercises)
        ..where(
              (table) => table.sessionId.equals(session.id),
        )
        ..orderBy([
              (table) => OrderingTerm.asc(table.orderIndex),
        ]))
          .get();

      var setCount = 0;
      var totalRepetitions = 0;
      var totalVolumeKg = 0.0;

      for (final sessionExercise in sessionExercises) {
        final sets = await (_database.select(_database.workoutSets)
          ..where(
                (table) => table.sessionExerciseId.equals(
              sessionExercise.id,
            ),
          ))
            .get();

        setCount += sets.length;

        for (final set in sets) {
          totalRepetitions += set.repetitions;

          final weightKg = set.weightKg;

          if (weightKg != null) {
            totalVolumeKg += weightKg * set.repetitions;
          }
        }
      }

      history.add(
        TrainingHistoryItem(
          session: session,
          workoutName: workoutName,
          exerciseCount: sessionExercises.length,
          setCount: setCount,
          totalRepetitions: totalRepetitions,
          totalVolumeKg: totalVolumeKg,
        ),
      );
    }

    return history;
  }
}