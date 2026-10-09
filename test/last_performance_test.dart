import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/session_exercise_repository.dart';
import 'package:fitness_app/core/database/session_repository.dart';
import 'package:fitness_app/core/database/set_repository.dart';

void main() {
  late AppDatabase database;
  late SessionRepository sessions;
  late SessionExerciseRepository sessionExercises;
  late SetRepository sets;
  late int userId;
  late int otherUserId;
  late int exerciseA;
  late int exerciseB;

  setUp(() async {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    sessions = SessionRepository(database);
    sessionExercises = SessionExerciseRepository(database);
    sets = SetRepository(database);

    await AppInitializationService(database).initialize();

    Future<int> createUser() {
      return database.into(database.users).insert(
            UsersCompanion.insert(
              birthDate: DateTime(1995, 5, 20),
              heightCm: 175,
              currentWeightKg: 80,
              fitnessLevel: 'beginner',
              trainingLocation: 'gym',
              weeklyFrequency: 3,
              availableMinutes: 45,
            ),
          );
    }

    userId = await createUser();
    otherUserId = await createUser();

    final exercises = await database.select(database.exercises).get();
    exerciseA = exercises[0].id;
    exerciseB = exercises[1].id;
  });

  tearDown(() async {
    await database.close();
  });

  /// Crea una sesión con un ejercicio y las series indicadas
  /// (peso, repeticiones). [status]: completed, cancelled o in_progress.
  Future<int> createSession({
    required int user,
    required DateTime startedAt,
    required int exerciseId,
    required List<(double?, int)> series,
    String status = 'completed',
  }) async {
    final sessionId = await sessions.save(
      userId: user,
      startedAt: startedAt,
    );

    final sessionExerciseId = await sessionExercises.save(
      sessionId: sessionId,
      exerciseId: exerciseId,
      orderIndex: 1,
    );

    for (var i = 0; i < series.length; i++) {
      await sets.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: i + 1,
        weightKg: series[i].$1,
        repetitions: series[i].$2,
        setType: 'normal',
      );
    }

    if (status == 'completed') {
      await sessions.complete(
        sessionId: sessionId,
        completedAt: startedAt.add(const Duration(minutes: 40)),
        durationSeconds: 2400,
      );
    } else if (status == 'cancelled') {
      await sessions.cancel(sessionId);
    }

    return sessionId;
  }

  test('sin historial devuelve null', () async {
    final result = await sets.getLastPerformance(
      userId: userId,
      exerciseId: exerciseA,
    );

    expect(result, isNull);
  });

  test('devuelve las series de la sesión completada más reciente', () async {
    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 1, 10),
      exerciseId: exerciseA,
      series: [(50.0, 10), (50.0, 9)],
    );

    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 8, 10),
      exerciseId: exerciseA,
      series: [(55.0, 8), (55.0, 8), (55.0, 7)],
    );

    final result = await sets.getLastPerformance(
      userId: userId,
      exerciseId: exerciseA,
    );

    expect(result, isNotNull);
    expect(result!.sessionStartedAt, DateTime(2026, 9, 8, 10));
    expect(result.sets.map((s) => s.weightKg), [55, 55, 55]);
    expect(result.sets.map((s) => s.repetitions), [8, 8, 7]);
    expect(result.sets.map((s) => s.setIndex), [1, 2, 3]);
  });

  test('ignora sesiones en curso y canceladas', () async {
    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 1, 10),
      exerciseId: exerciseA,
      series: [(40.0, 12)],
    );

    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 5, 10),
      exerciseId: exerciseA,
      series: [(100.0, 1)],
      status: 'cancelled',
    );

    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 6, 10),
      exerciseId: exerciseA,
      series: [(100.0, 1)],
      status: 'in_progress',
    );

    final result = await sets.getLastPerformance(
      userId: userId,
      exerciseId: exerciseA,
    );

    expect(result!.sessionStartedAt, DateTime(2026, 9, 1, 10));
    expect(result.sets.single.weightKg, 40);
  });

  test('ignora otros usuarios y otros ejercicios', () async {
    await createSession(
      user: otherUserId,
      startedAt: DateTime(2026, 9, 7, 10),
      exerciseId: exerciseA,
      series: [(90.0, 5)],
    );

    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 7, 10),
      exerciseId: exerciseB,
      series: [(30.0, 15)],
    );

    final result = await sets.getLastPerformance(
      userId: userId,
      exerciseId: exerciseA,
    );

    expect(result, isNull);
  });

  test('salta sesiones completadas donde el ejercicio no tiene series',
      () async {
    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 1, 10),
      exerciseId: exerciseA,
      series: [(60.0, 8)],
    );

    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 8, 10),
      exerciseId: exerciseA,
      series: [],
    );

    final result = await sets.getLastPerformance(
      userId: userId,
      exerciseId: exerciseA,
    );

    expect(result!.sessionStartedAt, DateTime(2026, 9, 1, 10));
    expect(result.sets.single.weightKg, 60);
  });

  test('conserva series sin peso (peso corporal)', () async {
    await createSession(
      user: userId,
      startedAt: DateTime(2026, 9, 1, 10),
      exerciseId: exerciseA,
      series: [(null, 15), (null, 12)],
    );

    final result = await sets.getLastPerformance(
      userId: userId,
      exerciseId: exerciseA,
    );

    expect(result!.sets.map((s) => s.weightKg), [null, null]);
    expect(result.sets.map((s) => s.repetitions), [15, 12]);
  });
}
