import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/history_repository.dart';
import 'package:fitness_app/core/database/session_exercise_repository.dart';
import 'package:fitness_app/core/database/session_repository.dart';
import 'package:fitness_app/core/database/set_repository.dart';
import 'package:fitness_app/core/database/workout_repository.dart';

void main() {
  late AppDatabase database;
  late int userId;
  late List<Exercise> exercises;

  setUp(() async {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    await AppInitializationService(database).initialize();

    userId = await database.into(database.users).insert(
          UsersCompanion.insert(
            birthDate: DateTime(1995, 5, 20),
            heightCm: 175,
            currentWeightKg: 80,
            fitnessLevel: 'beginner',
            trainingLocation: 'home',
            weeklyFrequency: 3,
            availableMinutes: 45,
          ),
        );

    exercises = await database.select(database.exercises).get();
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> completedSession({
    int? workoutId,
    required List<int> exerciseIds,
  }) async {
    final sessions = SessionRepository(database);
    final sessionExercises = SessionExerciseRepository(database);
    final sets = SetRepository(database);

    final startedAt = DateTime(2026, 10, 1, 10);

    final sessionId = await sessions.save(
      userId: userId,
      workoutId: workoutId,
      startedAt: startedAt,
    );

    for (var index = 0; index < exerciseIds.length; index++) {
      final sessionExerciseId = await sessionExercises.save(
        sessionId: sessionId,
        exerciseId: exerciseIds[index],
        orderIndex: index + 1,
      );

      await sets.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 1,
        weightKg: 20,
        repetitions: 10,
        setType: 'normal',
      );
    }

    await sessions.complete(
      sessionId: sessionId,
      completedAt: startedAt.add(const Duration(minutes: 30)),
      durationSeconds: 1800,
    );
  }

  test('el historial incluye los nombres de los ejercicios en orden',
      () async {
    await completedSession(
      exerciseIds: [exercises[2].id, exercises[0].id, exercises[1].id],
    );

    final history = await HistoryRepository(database).getCompletedForUser(
      userId,
    );

    expect(history.length, 1);
    expect(history.first.exerciseNames, [
      exercises[2].name,
      exercises[0].name,
      exercises[1].name,
    ]);
    expect(history.first.exerciseCount, 3);
    expect(history.first.setCount, 3);
    expect(history.first.totalVolumeKg, 600);
  });

  test('sin rutina el nombre es null pero los ejercicios siguen', () async {
    await completedSession(exerciseIds: [exercises[0].id]);

    final history = await HistoryRepository(database).getCompletedForUser(
      userId,
    );

    expect(history.first.workoutName, isNull);
    expect(history.first.exerciseNames, [exercises[0].name]);
  });

  test('con rutina conserva su nombre', () async {
    final workoutId = await WorkoutRepository(database).save(
      userId: userId,
      name: 'Empuje · Casa',
      goal: 'strength',
      difficulty: 'beginner',
      daysPerWeek: 3,
      estimatedDurationMinutes: 40,
    );

    await completedSession(
      workoutId: workoutId,
      exerciseIds: [exercises[0].id],
    );

    final history = await HistoryRepository(database).getCompletedForUser(
      userId,
    );

    expect(history.first.workoutName, 'Empuje · Casa');
  });
}
