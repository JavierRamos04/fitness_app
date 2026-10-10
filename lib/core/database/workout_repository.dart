import 'package:drift/drift.dart';

import 'app_database.dart';

class WorkoutRepository {
  WorkoutRepository(this._database);

  final AppDatabase _database;

  Future<List<Workout>> getAll() {
    return (_database.select(_database.workouts)
      ..orderBy([
            (table) => OrderingTerm.desc(table.createdAt),
      ]))
        .get();
  }

  Future<List<Workout>> getAllForUser(int userId) {
    return (_database.select(_database.workouts)
      ..where((table) => table.userId.equals(userId))
      ..orderBy([
            (table) => OrderingTerm.desc(table.createdAt),
      ]))
        .get();
  }

  Future<Workout?> getById(int workoutId) {
    return (_database.select(_database.workouts)
      ..where((table) => table.id.equals(workoutId)))
        .getSingleOrNull();
  }

  Future<int> save({
    required int userId,
    required String name,
    required String goal,
    required String difficulty,
    required int daysPerWeek,
    required int estimatedDurationMinutes,
    String? planKey,
    int? planPosition,
  }) async {
    return _database.into(_database.workouts).insert(
      WorkoutsCompanion.insert(
        userId: userId,
        name: name,
        goal: goal,
        difficulty: difficulty,
        daysPerWeek: daysPerWeek,
        estimatedDurationMinutes: estimatedDurationMinutes,
        createdAt: DateTime.now(),
        planKey: Value(planKey),
        planPosition: Value(planPosition),
      ),
    );
  }

  Future<void> update(Workout workout) async {
    await _database.update(_database.workouts).replace(workout);
  }

  Future<void> setActive(int workoutId) async {
    final targetWorkout = await getById(workoutId);

    if (targetWorkout == null) {
      throw StateError(
        'No se encontró la rutina que se quiere activar.',
      );
    }

    await _database.transaction(() async {
      await (_database.update(_database.workouts)
        ..where(
              (table) => table.userId.equals(targetWorkout.userId),
        ))
          .write(
        const WorkoutsCompanion(
          isActive: Value(false),
        ),
      );

      await (_database.update(_database.workouts)
        ..where(
              (table) => table.id.equals(workoutId),
        ))
          .write(
        const WorkoutsCompanion(
          isActive: Value(true),
        ),
      );
    });
  }

  /// Rutinas de un plan semanal, en el orden del plan.
  Future<List<Workout>> getPlanWorkouts({
    required int userId,
    required String planKey,
  }) {
    return (_database.select(_database.workouts)
      ..where(
            (table) =>
        table.userId.equals(userId) & table.planKey.equals(planKey),
      )
      ..orderBy([
            (table) => OrderingTerm.asc(table.planPosition),
            (table) => OrderingTerm.asc(table.id),
      ]))
        .get();
  }

  /// Activa la siguiente rutina del plan al que pertenece [workoutId]
  /// (después de la última vuelve a la primera) y la devuelve.
  ///
  /// Devuelve `null` si la rutina ya no existe o no pertenece a un plan; en
  /// ese caso no se cambia nada.
  Future<Workout?> activateNextInPlan(int workoutId) async {
    final current = await getById(workoutId);
    final planKey = current?.planKey;

    if (current == null || planKey == null) {
      return null;
    }

    final planWorkouts = await getPlanWorkouts(
      userId: current.userId,
      planKey: planKey,
    );

    final index = planWorkouts.indexWhere((item) => item.id == workoutId);

    if (index == -1) {
      return null;
    }

    final next = planWorkouts[(index + 1) % planWorkouts.length];

    await setActive(next.id);

    return next;
  }

  Future<void> delete(int workoutId) async {
    await (_database.delete(_database.workouts)
      ..where((table) => table.id.equals(workoutId)))
        .go();
  }

  Future<Workout?> getActiveForUser(int userId) {
    return (_database.select(_database.workouts)
      ..where(
            (table) =>
        table.userId.equals(userId) &
        table.isActive.equals(true),
      ))
        .getSingleOrNull();
  }
}