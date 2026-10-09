import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/exercise_repository.dart';
import 'package:fitness_app/core/database/workout_exercise_repository.dart';
import 'package:fitness_app/core/database/workout_repository.dart';
import 'package:fitness_app/core/services/routine_generator.dart';
import 'package:fitness_app/core/services/suggested_routine_service.dart';

void main() {
  late AppDatabase database;
  late SuggestedRoutineService service;
  late int userId;

  setUp(() async {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    service = SuggestedRoutineService(database);

    await AppInitializationService(database).initialize();

    userId = await database
        .into(database.users)
        .insert(
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
  });

  tearDown(() async {
    await database.close();
  });

  Future<SuggestedRoutine> generateHomeRoutine() async {
    final catalog = await ExerciseRepository(database).getGeneratorCatalog();

    return const RoutineGenerator().generate(
      profile: GeneratorProfile(
        level: 'beginner',
        goal: 'general_fitness',
        minutes: 45,
        equipment: <String>{},
      ),
      catalog: catalog,
    );
  }

  test('el catálogo del generador sale completo y en orden', () async {
    final catalog = await ExerciseRepository(database).getGeneratorCatalog();

    expect(catalog.length, 57);

    final ids = catalog.map((exercise) => exercise.id).toList();
    final sortedIds = [...ids]..sort();

    expect(ids, sortedIds);

    final benchPress = catalog.firstWhere(
      (exercise) => exercise.name == 'Press de banca',
    );
    final pushUps = catalog.firstWhere(
      (exercise) => exercise.name == 'Flexiones',
    );

    expect(benchPress.requiredEquipment, {'barbell', 'bench'});
    expect(pushUps.requiredEquipment, isEmpty);
  });

  test('guarda la rutina con todos sus ejercicios y la deja activa', () async {
    final routine = await generateHomeRoutine();

    final workoutId = await service.saveAndActivate(
      userId: userId,
      name: 'Cuerpo completo · Casa',
      goal: 'general_fitness',
      difficulty: 'beginner',
      daysPerWeek: 3,
      routine: routine,
    );

    final workout = await WorkoutRepository(database).getById(workoutId);

    expect(workout, isNotNull);
    expect(workout!.name, 'Cuerpo completo · Casa');
    expect(workout.goal, 'general_fitness');
    expect(workout.difficulty, 'beginner');
    expect(workout.daysPerWeek, 3);
    expect(workout.estimatedDurationMinutes, routine.estimatedMinutes);
    expect(workout.isActive, isTrue);

    final saved = await WorkoutExerciseRepository(
      database,
    ).getForWorkout(workoutId);

    expect(saved.length, routine.exercises.length);

    for (var index = 0; index < saved.length; index++) {
      final expected = routine.exercises[index];

      expect(saved[index].orderIndex, index + 1);
      expect(saved[index].exerciseId, expected.exercise.id);
      expect(saved[index].sets, expected.sets);
      expect(saved[index].minReps, expected.minReps);
      expect(saved[index].maxReps, expected.maxReps);
      expect(saved[index].restSeconds, expected.restSeconds);
      expect(saved[index].setType, 'normal');
    }
  });

  test('al guardar, la rutina anterior deja de estar activa', () async {
    final workoutRepository = WorkoutRepository(database);

    final previousId = await workoutRepository.save(
      userId: userId,
      name: 'Anterior',
      goal: 'strength',
      difficulty: 'beginner',
      daysPerWeek: 3,
      estimatedDurationMinutes: 40,
    );

    await workoutRepository.setActive(previousId);

    final newId = await service.saveAndActivate(
      userId: userId,
      name: 'Cuerpo completo · Casa',
      goal: 'general_fitness',
      difficulty: 'beginner',
      daysPerWeek: 3,
      routine: await generateHomeRoutine(),
    );

    final previous = await workoutRepository.getById(previousId);
    final active = await workoutRepository.getActiveForUser(userId);

    expect(previous!.isActive, isFalse);
    expect(active!.id, newId);
  });

  test('si falla un ejercicio no queda nada guardado', () async {
    const invalidRoutine = SuggestedRoutine(
      exercises: [
        SuggestedExercise(
          exercise: GeneratorExercise(
            id: 99999,
            name: 'No existe',
            primaryMuscle: 'chest',
            movementPattern: 'horizontal_push',
            difficulty: 'beginner',
            requiredEquipment: <String>{},
          ),
          sets: 3,
          minReps: 8,
          maxReps: 12,
          restSeconds: 60,
        ),
      ],
      estimatedMinutes: 20,
    );

    await expectLater(
      service.saveAndActivate(
        userId: userId,
        name: 'Rutina inválida',
        goal: 'general_fitness',
        difficulty: 'beginner',
        daysPerWeek: 3,
        routine: invalidRoutine,
      ),
      throwsA(anything),
    );

    expect(await WorkoutRepository(database).getAll(), isEmpty);
  });
}
