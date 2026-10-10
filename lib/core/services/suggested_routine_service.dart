import '../database/app_database.dart';
import '../database/workout_exercise_repository.dart';
import '../database/workout_repository.dart';
import 'routine_generator.dart';
import 'routine_planner.dart';

/// Guarda como rutina real una rutina sugerida y la deja activa.
class SuggestedRoutineService {
  SuggestedRoutineService(this._database);

  final AppDatabase _database;

  /// Crea la rutina con todos sus ejercicios y la activa, todo en una sola
  /// transacción: si algo falla no queda nada a medias. Devuelve el id.
  Future<int> saveAndActivate({
    required int userId,
    required String name,
    required String goal,
    required String difficulty,
    required int daysPerWeek,
    required SuggestedRoutine routine,
  }) {
    final workoutRepository = WorkoutRepository(_database);
    final workoutExerciseRepository = WorkoutExerciseRepository(_database);

    return _database.transaction(() async {
      final workoutId = await workoutRepository.save(
        userId: userId,
        name: name,
        goal: goal,
        difficulty: difficulty,
        daysPerWeek: daysPerWeek,
        estimatedDurationMinutes: routine.estimatedMinutes,
      );

      for (var index = 0; index < routine.exercises.length; index++) {
        final item = routine.exercises[index];

        await workoutExerciseRepository.save(
          workoutId: workoutId,
          exerciseId: item.exercise.id,
          orderIndex: index + 1,
          sets: item.sets,
          minReps: item.minReps,
          maxReps: item.maxReps,
          restSeconds: item.restSeconds,
          setType: 'normal',
        );
      }

      await workoutRepository.setActive(workoutId);

      return workoutId;
    });
  }

  /// Guarda todas las rutinas de un plan semanal y deja activa la primera,
  /// todo en una sola transacción. Devuelve los ids en el orden del plan.
  ///
  /// [nameSuffix] se añade al nombre de cada rutina (p. ej. " · Casa").
  Future<List<int>> savePlanAndActivate({
    required int userId,
    required String goal,
    required String difficulty,
    required int daysPerWeek,
    required List<PlannedRoutine> plan,
    String nameSuffix = '',
  }) {
    if (plan.isEmpty) {
      throw ArgumentError('El plan no tiene rutinas.');
    }

    final workoutRepository = WorkoutRepository(_database);
    final workoutExerciseRepository = WorkoutExerciseRepository(_database);
    final planKey = 'plan-${DateTime.now().microsecondsSinceEpoch}';

    return _database.transaction(() async {
      final ids = <int>[];

      for (var position = 0; position < plan.length; position++) {
        final item = plan[position];

        final workoutId = await workoutRepository.save(
          userId: userId,
          name: '${item.day.name}$nameSuffix',
          goal: goal,
          difficulty: difficulty,
          daysPerWeek: daysPerWeek,
          estimatedDurationMinutes: item.routine.estimatedMinutes,
          planKey: planKey,
          planPosition: position + 1,
        );

        for (var index = 0; index < item.routine.exercises.length; index++) {
          final exercise = item.routine.exercises[index];

          await workoutExerciseRepository.save(
            workoutId: workoutId,
            exerciseId: exercise.exercise.id,
            orderIndex: index + 1,
            sets: exercise.sets,
            minReps: exercise.minReps,
            maxReps: exercise.maxReps,
            restSeconds: exercise.restSeconds,
            setType: 'normal',
          );
        }

        ids.add(workoutId);
      }

      await workoutRepository.setActive(ids.first);

      return ids;
    });
  }
}
