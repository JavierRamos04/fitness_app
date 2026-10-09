import '../database/app_database.dart';
import '../database/workout_exercise_repository.dart';
import '../database/workout_repository.dart';
import 'routine_generator.dart';

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
}
