import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/database_provider.dart';
import 'package:fitness_app/core/database/goal_repository.dart';
import 'package:fitness_app/core/database/providers/repository_providers.dart';
import 'package:fitness_app/core/database/user_repository.dart';
import 'package:fitness_app/core/database/weight_entry_repository.dart';
import 'package:fitness_app/core/database/exercise_equipment_repository.dart';
import 'package:fitness_app/core/database/exercise_relationship_repository.dart';
import 'package:fitness_app/core/database/workout_repository.dart';
import 'package:fitness_app/core/database/workout_exercise_repository.dart';
import 'package:fitness_app/core/database/session_exercise_repository.dart';
import 'package:fitness_app/core/database/set_repository.dart';
import 'package:fitness_app/core/database/session_repository.dart';
import 'package:fitness_app/features/training/workout_session_controller.dart';


void main() {
  late AppDatabase database;
  late UserRepository repository;

  setUp(() {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    repository = UserRepository(database);
  });

  tearDown(() async {
    await database.close();
  });

  test('La base de datos puede guardar y recuperar un usuario', () async {
    final birthDate = DateTime(2000, 5, 15);

    await repository.saveUser(
      UsersCompanion.insert(
        birthDate: birthDate,
        heightCm: 175,
        currentWeightKg: 80,
        fitnessLevel: 'beginner',
        trainingLocation: 'gym',
        weeklyFrequency: 4,
        availableMinutes: 60,
      ),
    );

    final user = await repository.getUser();

    expect(user != null, isTrue);
    expect(user!.birthDate, birthDate);
    expect(user.heightCm, 175);
    expect(user.currentWeightKg, 80);
    expect(user.fitnessLevel, 'beginner');
    expect(user.trainingLocation, 'gym');
    expect(user.weeklyFrequency, 4);
    expect(user.availableMinutes, 60);
  });

  test('La base de datos puede guardar y recuperar registros de peso', () async {
    final birthDate = DateTime(2000, 5, 15);

    await repository.saveUser(
      UsersCompanion.insert(
        birthDate: birthDate,
        heightCm: 175,
        currentWeightKg: 80,
        fitnessLevel: 'beginner',
        trainingLocation: 'gym',
        weeklyFrequency: 4,
        availableMinutes: 60,
      ),
    );

    final user = await repository.getUser();

    expect(user != null, isTrue);

    final weightRepository = WeightEntryRepository(database);

    final firstDate = DateTime(2026, 9, 1);
    final secondDate = DateTime(2026, 9, 8);

    await weightRepository.save(
      userId: user!.id,
      recordedAt: firstDate,
      weightKg: 80,
    );

    await weightRepository.save(
      userId: user.id,
      recordedAt: secondDate,
      weightKg: 78.5,
    );

    final entries = await weightRepository.getAll();

    expect(entries, hasLength(2));
    expect(entries.first.weightKg, 78.5);
    expect(entries.first.recordedAt, secondDate);
    expect(entries.last.weightKg, 80);
    expect(entries.last.recordedAt, firstDate);
  });


  test('Riverpod puede proporcionar los repositories', () {
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
    );

    addTearDown(container.dispose);

    final userRepository = container.read(userRepositoryProvider);
    final weightEntryRepository = container.read(
      weightEntryRepositoryProvider,
    );
    final goalRepository = container.read(goalRepositoryProvider);

    expect(userRepository, isA<UserRepository>());
    expect(weightEntryRepository, isA<WeightEntryRepository>());
    expect(goalRepository, isA<GoalRepository>());
  });


  test('La base de datos puede guardar y actualizar objetivos', () async {
    final birthDate = DateTime(2000, 5, 15);

    await repository.saveUser(
      UsersCompanion.insert(
        birthDate: birthDate,
        heightCm: 175,
        currentWeightKg: 80,
        fitnessLevel: 'beginner',
        trainingLocation: 'gym',
        weeklyFrequency: 4,
        availableMinutes: 60,
      ),
    );

    final user = await repository.getUser();

    expect(user != null, isTrue);

    final goalRepository = GoalRepository(database);

    final startDate = DateTime(2026, 9, 1);
    final targetDate = DateTime(2026, 12, 1);

    await goalRepository.save(
      userId: user!.id,
      type: 'weight',
      name: 'Llegar a 72 kg',
      targetValue: 72,
      unit: 'kg',
      startDate: startDate,
      targetDate: targetDate,
      status: 'active',
    );

    await goalRepository.save(
      userId: user.id,
      type: 'fitness',
      name: 'Mejorar condición física',
      targetValue: 10,
      unit: 'sesiones',
      startDate: DateTime(2026, 9, 5),
      status: 'active',
    );

    final goals = await goalRepository.getAll();

    expect(goals, hasLength(2));

    expect(goals.first.name, 'Mejorar condición física');
    expect(goals.first.targetDate == null, isTrue);

    expect(goals.last.name, 'Llegar a 72 kg');
    expect(goals.last.targetValue, 72);
    expect(goals.last.unit, 'kg');
    expect(goals.last.startDate, startDate);
    expect(goals.last.targetDate, targetDate);
    expect(goals.last.status, 'active');

    final updatedGoal = goals.last.copyWith(
      status: 'completed',
    );

    await goalRepository.updateGoal(updatedGoal);

    final updatedGoals = await goalRepository.getAll();
    final completedGoal = updatedGoals.last;

    expect(completedGoal.status, 'completed');
  });


  test(
    'ExerciseEquipment permite relaciones válidas y rechaza duplicados',
        () async {
      final exerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press de banca',
          description: 'Ejercicio de empuje horizontal.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Rebotar la barra o perder la estabilidad.',
          considerations: 'Usar una carga adecuada.',
          instructions: 'Descender y empujar la barra de forma controlada.',
        ),
      );

      final dumbbellsId = await database.into(database.equipment).insert(
        EquipmentCompanion.insert(
          code: 'dumbbells-test',
          name: 'Mancuernas',
        ),
      );

      final benchId = await database.into(database.equipment).insert(
        EquipmentCompanion.insert(
          code: 'bench-test',
          name: 'Banco',
        ),
      );

      final repository = ExerciseEquipmentRepository(database);

      await repository.save(
        exerciseId: exerciseId,
        equipmentId: dumbbellsId,
      );

      await repository.save(
        exerciseId: exerciseId,
        equipmentId: benchId,
      );

      final relationships = await repository.getAll();

      expect(relationships, hasLength(2));

      expect(
        relationships.any(
              (relationship) =>
          relationship.exerciseId == exerciseId &&
              relationship.equipmentId == dumbbellsId,
        ),
        isTrue,
      );

      expect(
        relationships.any(
              (relationship) =>
          relationship.exerciseId == exerciseId &&
              relationship.equipmentId == benchId,
        ),
        isTrue,
      );

      expect(
            () => repository.save(
          exerciseId: exerciseId,
          equipmentId: dumbbellsId,
        ),
        throwsA(isA<SqliteException>()),
      );
    },
  );


  test(
    'La base de datos puede guardar y recuperar relaciones entre ejercicios',
        () async {
      final firstExerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press de banca',
          description: 'Ejercicio de empuje horizontal.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder estabilidad o rebotar la barra.',
          considerations: 'Usar una carga adecuada.',
          instructions: 'Descender y empujar de forma controlada.',
        ),
      );

      final secondExerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press con mancuernas',
          description: 'Press horizontal realizado con mancuernas.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Controlar la bajada y mantener estabilidad.',
          commonMistakes: 'Dejar caer los brazos o perder el control.',
          considerations: 'Usar mancuernas adecuadas al nivel.',
          instructions: 'Descender las mancuernas y empujar de forma controlada.',
        ),
      );

      final thirdExerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press en máquina',
          description: 'Press horizontal realizado en máquina.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener una trayectoria controlada.',
          commonMistakes: 'Bloquear bruscamente los codos.',
          considerations: 'Ajustar correctamente la máquina.',
          instructions: 'Empujar y regresar lentamente a la posición inicial.',
        ),
      );

      final repository = ExerciseRelationshipRepository(database);

      await repository.save(
        exerciseId: firstExerciseId,
        relatedExerciseId: secondExerciseId,
        relationshipType: 'variation',
      );

      await repository.save(
        exerciseId: firstExerciseId,
        relatedExerciseId: thirdExerciseId,
        relationshipType: 'substitution',
      );

      final relationships = await repository.getForExercise(
        firstExerciseId,
      );

      expect(relationships, hasLength(2));

      expect(
        relationships.any(
              (relationship) =>
          relationship.relatedExerciseId == secondExerciseId &&
              relationship.relationshipType == 'variation',
        ),
        isTrue,
      );

      expect(
        relationships.any(
              (relationship) =>
          relationship.relatedExerciseId == thirdExerciseId &&
              relationship.relationshipType == 'substitution',
        ),
        isTrue,
      );

      expect(
            () => repository.save(
          exerciseId: firstExerciseId,
          relatedExerciseId: secondExerciseId,
          relationshipType: 'variation',
        ),
        throwsA(isA<SqliteException>()),
      );
    },
  );


  test('Las rutinas pueden crearse y solo una puede estar activa', () async {
    final birthDate = DateTime(2000, 5, 15);

    await repository.saveUser(
      UsersCompanion.insert(
        birthDate: birthDate,
        heightCm: 175,
        currentWeightKg: 80,
        fitnessLevel: 'beginner',
        trainingLocation: 'gym',
        weeklyFrequency: 4,
        availableMinutes: 60,
      ),
    );

    final user = await repository.getUser();

    expect(user != null, isTrue);

    final workoutRepository = WorkoutRepository(database);

    await workoutRepository.save(
      userId: user!.id,
      name: 'Fuerza 3 días',
      goal: 'strength',
      difficulty: 'beginner',
      daysPerWeek: 3,
      estimatedDurationMinutes: 60,
    );

    await workoutRepository.save(
      userId: user.id,
      name: 'Hipertrofia 4 días',
      goal: 'hypertrophy',
      difficulty: 'intermediate',
      daysPerWeek: 4,
      estimatedDurationMinutes: 75,
    );

    final workouts = await workoutRepository.getAll();

    expect(workouts, hasLength(2));
    expect(
      workouts.any((workout) => workout.name == 'Fuerza 3 días'),
      isTrue,
    );
    expect(
      workouts.any((workout) => workout.name == 'Hipertrofia 4 días'),
      isTrue,
    );
    expect(workouts.every((workout) => !workout.isActive), isTrue);

    await workoutRepository.setActive(workouts.last.id);

    var updatedWorkouts = await workoutRepository.getAll();

    final activeFirst = updatedWorkouts.where((workout) => workout.isActive);

    expect(activeFirst, hasLength(1));
    expect(activeFirst.first.id, workouts.last.id);

    await workoutRepository.setActive(workouts.first.id);

    updatedWorkouts = await workoutRepository.getAll();

    final activeSecond = updatedWorkouts.where((workout) => workout.isActive);

    expect(activeSecond, hasLength(1));
    expect(activeSecond.first.id, workouts.first.id);
  });


  test(
    'Las rutinas pueden contener ejercicios configurados',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final workoutId = await database.into(database.workouts).insert(
        WorkoutsCompanion.insert(
          userId: userId,
          name: 'Fuerza 3 días',
          goal: 'strength',
          difficulty: 'beginner',
          daysPerWeek: 3,
          estimatedDurationMinutes: 60,
          createdAt: DateTime(2026, 9, 9),
        ),
      );

      final squatId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener el control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions: 'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final benchPressId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press de banca',
          description: 'Ejercicio de empuje horizontal.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener estabilidad y control.',
          commonMistakes: 'Perder la trayectoria o rebotar la barra.',
          considerations: 'Utilizar una carga adecuada.',
          instructions: 'Descender y empujar de forma controlada.',
        ),
      );

      final repository = WorkoutExerciseRepository(database);

      await repository.save(
        workoutId: workoutId,
        exerciseId: squatId,
        orderIndex: 1,
        sets: 3,
        minReps: 8,
        maxReps: 10,
        restSeconds: 120,
        setType: 'normal',
      );

      await repository.save(
        workoutId: workoutId,
        exerciseId: benchPressId,
        orderIndex: 2,
        sets: 3,
        minReps: 8,
        maxReps: 10,
        restSeconds: 120,
        setType: 'normal',
      );

      final exercises = await repository.getForWorkout(workoutId);

      expect(exercises, hasLength(2));

      expect(exercises[0].exerciseId, squatId);
      expect(exercises[0].orderIndex, 1);
      expect(exercises[0].sets, 3);
      expect(exercises[0].minReps, 8);
      expect(exercises[0].maxReps, 10);
      expect(exercises[0].restSeconds, 120);
      expect(exercises[0].setType, 'normal');

      expect(exercises[1].exerciseId, benchPressId);
      expect(exercises[1].orderIndex, 2);

      final updatedExercise = exercises[0].copyWith(
        sets: 4,
        minReps: 6,
        maxReps: 8,
      );

      await repository.update(updatedExercise);

      var updatedExercises = await repository.getForWorkout(workoutId);

      expect(updatedExercises[0].sets, 4);
      expect(updatedExercises[0].minReps, 6);
      expect(updatedExercises[0].maxReps, 8);

      await repository.delete(updatedExercises[1].id);

      updatedExercises = await repository.getForWorkout(workoutId);

      expect(updatedExercises, hasLength(1));
      expect(updatedExercises.first.exerciseId, squatId);

      expect(
            () => repository.save(
          workoutId: workoutId,
          exerciseId: squatId,
          orderIndex: 1,
          sets: 3,
          minReps: 8,
          maxReps: 10,
          restSeconds: 120,
          setType: 'normal',
        ),
        throwsA(isA<SqliteException>()),
      );
    },
  );

  test(
    'Las sesiones pueden registrar ejercicios realizados',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final workoutId = await database.into(database.workouts).insert(
        WorkoutsCompanion.insert(
          userId: userId,
          name: 'Fuerza 3 días',
          goal: 'strength',
          difficulty: 'beginner',
          daysPerWeek: 3,
          estimatedDurationMinutes: 60,
          createdAt: DateTime(2026, 9, 9),
        ),
      );

      final sessionId = await database.into(database.sessions).insert(
        SessionsCompanion.insert(
          userId: userId,
          workoutId: Value(workoutId),
          startedAt: DateTime(2026, 9, 9, 18, 0),
          status: 'in_progress',
        ),
      );

      final squatId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions: 'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final benchPressId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press de banca',
          description: 'Ejercicio de empuje horizontal.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener estabilidad y control.',
          commonMistakes: 'Perder la trayectoria o rebotar la barra.',
          considerations: 'Utilizar una carga adecuada.',
          instructions: 'Descender y empujar de forma controlada.',
        ),
      );

      final rowId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Remo',
          description: 'Ejercicio de tracción horizontal.',
          primaryMuscle: 'back',
          difficulty: 'beginner',
          movementPattern: 'pull',
          exerciseType: 'strength',
          technique: 'Mantener la espalda estable.',
          commonMistakes: 'Realizar el movimiento con impulso.',
          considerations: 'Mantener una carga adecuada.',
          instructions: 'Tirar del peso hacia el torso de forma controlada.',
        ),
      );

      final repository = SessionExerciseRepository(database);

      await repository.save(
        sessionId: sessionId,
        exerciseId: squatId,
        orderIndex: 1,
      );

      await repository.save(
        sessionId: sessionId,
        exerciseId: benchPressId,
        orderIndex: 2,
      );

      await repository.save(
        sessionId: sessionId,
        exerciseId: rowId,
        orderIndex: 3,
      );

      var exercises = await repository.getForSession(sessionId);

      expect(exercises, hasLength(3));

      expect(exercises[0].exerciseId, squatId);
      expect(exercises[0].orderIndex, 1);

      expect(exercises[1].exerciseId, benchPressId);
      expect(exercises[1].orderIndex, 2);

      expect(exercises[2].exerciseId, rowId);
      expect(exercises[2].orderIndex, 3);

      final updatedExercise = exercises[0].copyWith(
        orderIndex: 2,
      );

      expect(
            () => repository.update(updatedExercise),
        throwsA(isA<SqliteException>()),
      );

      final validUpdate = exercises[0].copyWith(
        orderIndex: 1,
      );

      await repository.update(validUpdate);

      exercises = await repository.getForSession(sessionId);

      expect(exercises, hasLength(3));

      await repository.delete(exercises[2].id);

      exercises = await repository.getForSession(sessionId);

      expect(exercises, hasLength(2));
      expect(
        exercises.every((exercise) => exercise.exerciseId != rowId),
        isTrue,
      );
    },
  );

  test(
    'Las sesiones pueden registrar y administrar series',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final sessionId = await database.into(database.sessions).insert(
        SessionsCompanion.insert(
          userId: userId,
          startedAt: DateTime(2026, 9, 9, 18, 0),
          status: 'in_progress',
        ),
      );

      final exerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions: 'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final sessionExerciseId =
      await database.into(database.sessionExercises).insert(
        SessionExercisesCompanion.insert(
          sessionId: sessionId,
          exerciseId: exerciseId,
          orderIndex: 1,
        ),
      );

      final repository = SetRepository(database);

      await repository.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 1,
        weightKg: 80,
        repetitions: 10,
        setType: 'normal',
      );

      await repository.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 2,
        weightKg: 80,
        repetitions: 9,
        setType: 'normal',
      );

      await repository.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 3,
        weightKg: 80,
        repetitions: 8,
        setType: 'normal',
      );

      final sets = await repository.getForSessionExercise(
        sessionExerciseId,
      );

      expect(sets, hasLength(3));

      expect(sets[0].setIndex, 1);
      expect(sets[0].weightKg, 80);
      expect(sets[0].repetitions, 10);

      expect(sets[1].setIndex, 2);
      expect(sets[1].weightKg, 80);
      expect(sets[1].repetitions, 9);

      expect(sets[2].setIndex, 3);
      expect(sets[2].weightKg, 80);
      expect(sets[2].repetitions, 8);

      final updatedSet = sets[0].copyWith(
        weightKg: const Value(82.5),
        repetitions: 9,
      );

      await repository.update(updatedSet);

      var updatedSets = await repository.getForSessionExercise(
        sessionExerciseId,
      );

      expect(updatedSets[0].weightKg, 82.5);
      expect(updatedSets[0].repetitions, 9);

      final bodyweightExerciseId =
      await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Flexiones',
          description: 'Ejercicio de empuje con peso corporal.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener el cuerpo estable.',
          commonMistakes: 'Perder la alineación corporal.',
          considerations: 'Adaptar la dificultad al nivel.',
          instructions: 'Descender y empujar el cuerpo de forma controlada.',
        ),
      );

      final bodyweightSessionExerciseId =
      await database.into(database.sessionExercises).insert(
        SessionExercisesCompanion.insert(
          sessionId: sessionId,
          exerciseId: bodyweightExerciseId,
          orderIndex: 2,
        ),
      );

      await repository.save(
        sessionExerciseId: bodyweightSessionExerciseId,
        setIndex: 1,
        repetitions: 12,
        setType: 'normal',
      );

      final bodyweightSets = await repository.getForSessionExercise(
        bodyweightSessionExerciseId,
      );

      expect(bodyweightSets, hasLength(1));
      expect(bodyweightSets.first.weightKg == null, isTrue);
      expect(bodyweightSets.first.repetitions, 12);

      expect(
            () => repository.save(
          sessionExerciseId: sessionExerciseId,
          setIndex: 1,
          weightKg: 80,
          repetitions: 10,
          setType: 'normal',
        ),
        throwsA(isA<SqliteException>()),
      );

      await repository.delete(updatedSets[2].id);

      updatedSets = await repository.getForSessionExercise(
        sessionExerciseId,
      );

      expect(updatedSets, hasLength(2));
      expect(
        updatedSets.any((workoutSet) => workoutSet.setIndex == 3),
        isFalse,
      );
    },
  );

  test(
    'Las sesiones pueden iniciarse, completarse y cancelarse',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final workoutId = await database.into(database.workouts).insert(
        WorkoutsCompanion.insert(
          userId: userId,
          name: 'Fuerza 3 días',
          goal: 'strength',
          difficulty: 'beginner',
          daysPerWeek: 3,
          estimatedDurationMinutes: 60,
          createdAt: DateTime(2026, 9, 9),
        ),
      );

      final repository = SessionRepository(database);

      final startedAt = DateTime(2026, 9, 9, 18, 0);

      await repository.save(
        userId: userId,
        workoutId: workoutId,
        startedAt: startedAt,
      );

      var sessions = await repository.getAll();

      expect(sessions, hasLength(1));
      expect(sessions.first.userId, userId);
      expect(sessions.first.workoutId, workoutId);
      expect(sessions.first.startedAt, startedAt);
      expect(sessions.first.status, 'in_progress');
      expect(sessions.first.completedAt == null, isTrue);
      expect(sessions.first.durationSeconds == null, isTrue);

      final sessionId = sessions.first.id;

      final completedAt = DateTime(2026, 9, 9, 18, 52);

      await repository.complete(
        sessionId: sessionId,
        completedAt: completedAt,
        durationSeconds: 3120,
      );

      sessions = await repository.getAll();

      expect(sessions, hasLength(1));
      expect(sessions.first.status, 'completed');
      expect(sessions.first.completedAt, completedAt);
      expect(sessions.first.durationSeconds, 3120);

      await repository.save(
        userId: userId,
        workoutId: workoutId,
        startedAt: DateTime(2026, 9, 10, 18, 0),
      );

      sessions = await repository.getAll();

      expect(sessions, hasLength(2));

      final inProgressSession = sessions.firstWhere(
            (session) => session.status == 'in_progress',
      );

      await repository.cancel(inProgressSession.id);

      sessions = await repository.getAll();

      final cancelledSession = sessions.firstWhere(
            (session) => session.id == inProgressSession.id,
      );

      expect(cancelledSession.status, 'cancelled');
    },
  );


  test(
    'Un entrenamiento completo puede guardarse y recuperarse',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final workoutRepository = WorkoutRepository(database);
      final workoutExerciseRepository = WorkoutExerciseRepository(database);
      final sessionRepository = SessionRepository(database);
      final sessionExerciseRepository = SessionExerciseRepository(database);
      final setRepository = SetRepository(database);

      await workoutRepository.save(
        userId: userId,
        name: 'Fuerza 3 días',
        goal: 'strength',
        difficulty: 'beginner',
        daysPerWeek: 3,
        estimatedDurationMinutes: 60,
      );

      final workouts = await workoutRepository.getAll();

      expect(workouts, hasLength(1));

      final workoutId = workouts.first.id;

      final squatId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions:
          'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final benchPressId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Press de banca',
          description: 'Ejercicio de empuje horizontal.',
          primaryMuscle: 'chest',
          difficulty: 'beginner',
          movementPattern: 'push',
          exerciseType: 'strength',
          technique: 'Mantener estabilidad y control.',
          commonMistakes: 'Perder la trayectoria o rebotar la barra.',
          considerations: 'Utilizar una carga adecuada.',
          instructions:
          'Descender y empujar de forma controlada.',
        ),
      );

      await workoutExerciseRepository.save(
        workoutId: workoutId,
        exerciseId: squatId,
        orderIndex: 1,
        sets: 3,
        minReps: 8,
        maxReps: 10,
        restSeconds: 120,
        setType: 'normal',
      );

      await workoutExerciseRepository.save(
        workoutId: workoutId,
        exerciseId: benchPressId,
        orderIndex: 2,
        sets: 3,
        minReps: 8,
        maxReps: 10,
        restSeconds: 120,
        setType: 'normal',
      );

      final plannedExercises =
      await workoutExerciseRepository.getForWorkout(workoutId);

      expect(plannedExercises, hasLength(2));
      expect(plannedExercises[0].exerciseId, squatId);
      expect(plannedExercises[1].exerciseId, benchPressId);

      final startedAt = DateTime(2026, 9, 9, 18, 0);

      await sessionRepository.save(
        userId: userId,
        workoutId: workoutId,
        startedAt: startedAt,
      );

      final sessions = await sessionRepository.getAll();

      expect(sessions, hasLength(1));

      final sessionId = sessions.first.id;

      expect(sessions.first.status, 'in_progress');

      await sessionExerciseRepository.save(
        sessionId: sessionId,
        exerciseId: squatId,
        orderIndex: 1,
      );

      await sessionExerciseRepository.save(
        sessionId: sessionId,
        exerciseId: benchPressId,
        orderIndex: 2,
      );

      final performedExercises =
      await sessionExerciseRepository.getForSession(sessionId);

      expect(performedExercises, hasLength(2));
      expect(performedExercises[0].exerciseId, squatId);
      expect(performedExercises[1].exerciseId, benchPressId);

      final squatSessionExerciseId = performedExercises[0].id;
      final benchSessionExerciseId = performedExercises[1].id;

      await setRepository.save(
        sessionExerciseId: squatSessionExerciseId,
        setIndex: 1,
        weightKg: 80,
        repetitions: 10,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: squatSessionExerciseId,
        setIndex: 2,
        weightKg: 80,
        repetitions: 9,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: squatSessionExerciseId,
        setIndex: 3,
        weightKg: 80,
        repetitions: 8,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: benchSessionExerciseId,
        setIndex: 1,
        weightKg: 60,
        repetitions: 10,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: benchSessionExerciseId,
        setIndex: 2,
        weightKg: 60,
        repetitions: 9,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: benchSessionExerciseId,
        setIndex: 3,
        weightKg: 60,
        repetitions: 8,
        setType: 'normal',
      );

      final squatSets = await setRepository.getForSessionExercise(
        squatSessionExerciseId,
      );

      final benchSets = await setRepository.getForSessionExercise(
        benchSessionExerciseId,
      );

      expect(squatSets, hasLength(3));
      expect(benchSets, hasLength(3));

      expect(squatSets[0].weightKg, 80);
      expect(squatSets[0].repetitions, 10);
      expect(squatSets[2].weightKg, 80);
      expect(squatSets[2].repetitions, 8);

      expect(benchSets[0].weightKg, 60);
      expect(benchSets[0].repetitions, 10);
      expect(benchSets[2].weightKg, 60);
      expect(benchSets[2].repetitions, 8);

      final completedAt = DateTime(2026, 9, 9, 18, 52);

      await sessionRepository.complete(
        sessionId: sessionId,
        completedAt: completedAt,
        durationSeconds: 3120,
      );

      final completedSessions = await sessionRepository.getAll();

      expect(completedSessions, hasLength(1));
      expect(completedSessions.first.status, 'completed');
      expect(completedSessions.first.completedAt, completedAt);
      expect(completedSessions.first.durationSeconds, 3120);

      final finalExercises =
      await sessionExerciseRepository.getForSession(sessionId);

      expect(finalExercises, hasLength(2));

      final finalSquatSets = await setRepository.getForSessionExercise(
        finalExercises[0].id,
      );

      final finalBenchSets = await setRepository.getForSessionExercise(
        finalExercises[1].id,
      );

      expect(finalSquatSets, hasLength(3));
      expect(finalBenchSets, hasLength(3));
    },
  );

  test(
    'La integridad de los entrenamientos protege el historial',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final workoutId = await database.into(database.workouts).insert(
        WorkoutsCompanion.insert(
          userId: userId,
          name: 'Fuerza 3 días',
          goal: 'strength',
          difficulty: 'beginner',
          daysPerWeek: 3,
          estimatedDurationMinutes: 60,
          createdAt: DateTime(2026, 9, 9),
        ),
      );

      final exerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions:
          'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final sessionId = await database.into(database.sessions).insert(
        SessionsCompanion.insert(
          userId: userId,
          workoutId: Value(workoutId),
          startedAt: DateTime(2026, 9, 9, 18, 0),
          status: 'completed',
          completedAt: Value(DateTime(2026, 9, 9, 18, 52)),
          durationSeconds: const Value(3120),
        ),
      );

      final sessionExerciseId =
      await database.into(database.sessionExercises).insert(
        SessionExercisesCompanion.insert(
          sessionId: sessionId,
          exerciseId: exerciseId,
          orderIndex: 1,
        ),
      );

      final setId = await database.into(database.workoutSets).insert(
        WorkoutSetsCompanion.insert(
          sessionExerciseId: sessionExerciseId,
          setIndex: 1,
          weightKg: const Value(80),
          repetitions: 10,
          setType: 'normal',
        ),
      );

      expect(
        await database.select(database.sessions).get(),
        hasLength(1),
      );

      expect(
        await database.select(database.sessionExercises).get(),
        hasLength(1),
      );

      expect(
        await database.select(database.workoutSets).get(),
        hasLength(1),
      );

      expect(
            () => (database.delete(database.exercises)
          ..where((table) => table.id.equals(exerciseId)))
            .go(),
        throwsA(isA<SqliteException>()),
      );

      final exercisesAfterFailedDelete =
      await database.select(database.exercises).get();

      expect(exercisesAfterFailedDelete, hasLength(1));
      expect(exercisesAfterFailedDelete.first.id, exerciseId);

      await (database.delete(database.workouts)
        ..where((table) => table.id.equals(workoutId)))
          .go();

      final sessionsAfterWorkoutDelete =
      await database.select(database.sessions).get();

      expect(sessionsAfterWorkoutDelete, hasLength(1));
      expect(sessionsAfterWorkoutDelete.first.id, sessionId);
      expect(sessionsAfterWorkoutDelete.first.workoutId == null, isTrue);

      final sessionExerciseRepository =
      SessionExerciseRepository(database);

      final setRepository = SetRepository(database);

      final sessionExercises =
      await sessionExerciseRepository.getForSession(sessionId);

      expect(sessionExercises, hasLength(1));
      expect(sessionExercises.first.id, sessionExerciseId);

      final sets = await setRepository.getForSessionExercise(
        sessionExerciseId,
      );

      expect(sets, hasLength(1));
      expect(sets.first.id, setId);

      await (database.delete(database.sessions)
        ..where((table) => table.id.equals(sessionId)))
          .go();

      final remainingSessions = await database.select(database.sessions).get();
      final remainingSessionExercises =
      await database.select(database.sessionExercises).get();
      final remainingSets = await database.select(database.workoutSets).get();

      expect(remainingSessions, isEmpty);
      expect(remainingSessionExercises, isEmpty);
      expect(remainingSets, isEmpty);

      final remainingExercises =
      await database.select(database.exercises).get();

      expect(remainingExercises, hasLength(1));
      expect(remainingExercises.first.id, exerciseId);
    },
  );

  test(
    'Riverpod puede ejecutar un entrenamiento completo',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final squatId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions:
          'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(database),
        ],
      );

      addTearDown(container.dispose);

      final workoutRepository = container.read(
        workoutRepositoryProvider,
      );
      final workoutExerciseRepository = container.read(
        workoutExerciseRepositoryProvider,
      );
      final sessionRepository = container.read(
        sessionRepositoryProvider,
      );
      final sessionExerciseRepository = container.read(
        sessionExerciseRepositoryProvider,
      );
      final setRepository = container.read(
        setRepositoryProvider,
      );

      await workoutRepository.save(
        userId: userId,
        name: 'Fuerza 3 días',
        goal: 'strength',
        difficulty: 'beginner',
        daysPerWeek: 3,
        estimatedDurationMinutes: 60,
      );

      final workouts = await workoutRepository.getAll();

      expect(workouts, hasLength(1));

      final workoutId = workouts.first.id;

      await workoutExerciseRepository.save(
        workoutId: workoutId,
        exerciseId: squatId,
        orderIndex: 1,
        sets: 3,
        minReps: 8,
        maxReps: 10,
        restSeconds: 120,
        setType: 'normal',
      );

      final plannedExercises =
      await workoutExerciseRepository.getForWorkout(workoutId);

      expect(plannedExercises, hasLength(1));
      expect(plannedExercises.first.exerciseId, squatId);

      await sessionRepository.save(
        userId: userId,
        workoutId: workoutId,
        startedAt: DateTime(2026, 9, 9, 18, 0),
      );

      final sessions = await sessionRepository.getAll();

      expect(sessions, hasLength(1));
      expect(sessions.first.status, 'in_progress');

      final sessionId = sessions.first.id;

      await sessionExerciseRepository.save(
        sessionId: sessionId,
        exerciseId: squatId,
        orderIndex: 1,
      );

      final performedExercises =
      await sessionExerciseRepository.getForSession(sessionId);

      expect(performedExercises, hasLength(1));

      final sessionExerciseId = performedExercises.first.id;

      await setRepository.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 1,
        weightKg: 80,
        repetitions: 10,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 2,
        weightKg: 80,
        repetitions: 9,
        setType: 'normal',
      );

      await setRepository.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: 3,
        weightKg: 80,
        repetitions: 8,
        setType: 'normal',
      );

      final sets = await setRepository.getForSessionExercise(
        sessionExerciseId,
      );

      expect(sets, hasLength(3));
      expect(sets[0].weightKg, 80);
      expect(sets[0].repetitions, 10);
      expect(sets[1].repetitions, 9);
      expect(sets[2].repetitions, 8);

      await sessionRepository.complete(
        sessionId: sessionId,
        completedAt: DateTime(2026, 9, 9, 18, 52),
        durationSeconds: 3120,
      );

      final completedSessions = await sessionRepository.getAll();

      expect(completedSessions, hasLength(1));
      expect(completedSessions.first.status, 'completed');
      expect(completedSessions.first.durationSeconds, 3120);

      final finalSets = await setRepository.getForSessionExercise(
        sessionExerciseId,
      );

      expect(finalSets, hasLength(3));
    },
  );

  test(
    'WorkoutSessionController puede ejecutar una sesión completa',
        () async {
      final userId = await database.into(database.users).insert(
        UsersCompanion.insert(
          birthDate: DateTime(2000, 5, 15),
          heightCm: 175,
          currentWeightKg: 80,
          fitnessLevel: 'beginner',
          trainingLocation: 'gym',
          weeklyFrequency: 4,
          availableMinutes: 60,
        ),
      );

      final exerciseId = await database.into(database.exercises).insert(
        ExercisesCompanion.insert(
          name: 'Sentadilla',
          description: 'Ejercicio para tren inferior.',
          primaryMuscle: 'quadriceps',
          difficulty: 'beginner',
          movementPattern: 'squat',
          exerciseType: 'strength',
          technique: 'Mantener control durante todo el movimiento.',
          commonMistakes: 'Perder la alineación de las rodillas.',
          considerations: 'Utilizar una carga adecuada.',
          instructions:
          'Descender de forma controlada y volver a la posición inicial.',
        ),
      );

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(database),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(
        workoutSessionControllerProvider.notifier,
      );

      expect(
        container.read(workoutSessionControllerProvider).isActive,
        isFalse,
      );

      await controller.startSession(
        userId: userId,
        startedAt: DateTime(2026, 9, 9, 18, 0),
      );

      var state = container.read(workoutSessionControllerProvider);

      expect(state.isActive, isTrue);
      expect(state.sessionId != null, isTrue);
      expect(state.currentExerciseId == null, isTrue);

      await controller.addExercise(
        exerciseId: exerciseId,
        orderIndex: 1,
      );

      state = container.read(workoutSessionControllerProvider);

      expect(state.isActive, isTrue);
      expect(state.sessionId != null, isTrue);
      expect(state.currentExerciseId != null, isTrue);

      final sessionExerciseId = state.currentExerciseId!;

      await controller.addSet(
        setIndex: 1,
        weightKg: 80,
        repetitions: 10,
        setType: 'normal',
      );

      await controller.addSet(
        setIndex: 2,
        weightKg: 80,
        repetitions: 9,
        setType: 'normal',
      );

      final sets = await SetRepository(database).getForSessionExercise(
        sessionExerciseId,
      );

      expect(sets, hasLength(2));
      expect(sets[0].weightKg, 80);
      expect(sets[0].repetitions, 10);
      expect(sets[1].weightKg, 80);
      expect(sets[1].repetitions, 9);

      final sessionId = state.sessionId!;

      await controller.completeSession(
        completedAt: DateTime(2026, 9, 9, 18, 30),
        durationSeconds: 1800,
      );

      state = container.read(workoutSessionControllerProvider);

      expect(state.isActive, isFalse);
      expect(state.sessionId == null, isTrue);
      expect(state.currentExerciseId == null, isTrue);

      final completedSession =
      await SessionRepository(database).getAll();

      expect(completedSession, hasLength(1));
      expect(completedSession.first.id, sessionId);
      expect(completedSession.first.status, 'completed');
      expect(completedSession.first.durationSeconds, 1800);
    },
  );

  test(
    'WorkoutSessionController valida operaciones sin sesión ni ejercicio activos',
        () async {
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(database),
        ],
      );

      addTearDown(container.dispose);

      final controller = container.read(
        workoutSessionControllerProvider.notifier,
      );

      var state = container.read(workoutSessionControllerProvider);

      expect(state.isActive, isFalse);
      expect(state.sessionId == null, isTrue);
      expect(state.currentExerciseId == null, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage == null, isTrue);

      await controller.addExercise(
        exerciseId: 1,
        orderIndex: 1,
      );

      state = container.read(workoutSessionControllerProvider);

      expect(state.isActive, isFalse);
      expect(state.sessionId == null, isTrue);
      expect(state.currentExerciseId == null, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'No hay una sesión activa.');

      await controller.addSet(
        setIndex: 1,
        weightKg: 80,
        repetitions: 10,
        setType: 'normal',
      );

      state = container.read(workoutSessionControllerProvider);

      expect(state.isActive, isFalse);
      expect(state.sessionId == null, isTrue);
      expect(state.currentExerciseId == null, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.errorMessage, 'No hay un ejercicio activo.');
    },
  );
}

