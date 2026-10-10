import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/exercise_repository.dart';
import 'package:fitness_app/core/database/workout_exercise_repository.dart';
import 'package:fitness_app/core/database/workout_repository.dart';
import 'package:fitness_app/core/services/routine_generator.dart';
import 'package:fitness_app/core/services/routine_planner.dart';
import 'package:fitness_app/core/services/suggested_routine_service.dart';

void main() {
  late AppDatabase database;
  late SuggestedRoutineService service;
  late WorkoutRepository workouts;
  late int userId;

  setUp(() async {
    database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    service = SuggestedRoutineService(database);
    workouts = WorkoutRepository(database);

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
  });

  tearDown(() async {
    await database.close();
  });

  Future<List<PlannedRoutine>> generatePlan(int days) async {
    final catalog = await ExerciseRepository(database).getGeneratorCatalog();

    return const RoutinePlanner().generate(
      profile: GeneratorProfile(
        level: 'beginner',
        goal: 'general_fitness',
        minutes: 45,
        equipment: <String>{},
      ),
      catalog: catalog,
      daysPerWeek: days,
    );
  }

  Future<List<int>> savePlan(int days, {String suffix = ' · Casa'}) async {
    final plan = await generatePlan(days);

    return service.savePlanAndActivate(
      userId: userId,
      goal: 'general_fitness',
      difficulty: 'beginner',
      daysPerWeek: days,
      plan: plan,
      nameSuffix: suffix,
    );
  }

  test('guarda todas las rutinas del plan con su orden y su clave', () async {
    final plan = await generatePlan(3);
    final ids = await savePlan(3);

    expect(ids.length, 3);

    final saved = [for (final id in ids) (await workouts.getById(id))!];

    expect(saved.map((w) => w.name).toList(), [
      'Cuerpo completo A · Casa',
      'Cuerpo completo B · Casa',
      'Cuerpo completo C · Casa',
    ]);
    expect(saved.map((w) => w.planPosition).toList(), [1, 2, 3]);
    expect(saved.map((w) => w.planKey).toSet().length, 1);
    expect(saved.first.planKey, isNotNull);
    expect(saved.every((w) => w.userId == userId), isTrue);

    for (var index = 0; index < ids.length; index++) {
      final exercises = await WorkoutExerciseRepository(
        database,
      ).getForWorkout(ids[index]);

      expect(
        exercises.map((e) => e.exerciseId).toList(),
        plan[index].routine.exercises.map((e) => e.exercise.id).toList(),
      );
    }
  });

  test('solo la primera rutina del plan queda activa', () async {
    final ids = await savePlan(3);

    final active = await workouts.getActiveForUser(userId);

    expect(active, isNotNull);
    expect(active!.id, ids.first);

    final all = await workouts.getAllForUser(userId);

    expect(all.where((w) => w.isActive).length, 1);
  });

  test('la rotación avanza por el plan y vuelve al principio', () async {
    final ids = await savePlan(3);

    final second = await workouts.activateNextInPlan(ids[0]);
    expect(second!.id, ids[1]);
    expect((await workouts.getActiveForUser(userId))!.id, ids[1]);

    final third = await workouts.activateNextInPlan(ids[1]);
    expect(third!.id, ids[2]);

    final first = await workouts.activateNextInPlan(ids[2]);
    expect(first!.id, ids[0]);
    expect((await workouts.getActiveForUser(userId))!.id, ids[0]);
  });

  test('una rutina suelta no rota y no cambia la rutina activa', () async {
    final looseId = await workouts.save(
      userId: userId,
      name: 'Suelta',
      goal: 'strength',
      difficulty: 'beginner',
      daysPerWeek: 3,
      estimatedDurationMinutes: 40,
    );

    await workouts.setActive(looseId);

    expect(await workouts.activateNextInPlan(looseId), isNull);
    expect((await workouts.getActiveForUser(userId))!.id, looseId);
  });

  test('una rutina que ya no existe no rota', () async {
    expect(await workouts.activateNextInPlan(9999), isNull);
  });

  test('con un plan de un solo día la rotación se queda en la misma', () async {
    final ids = await savePlan(1);

    final next = await workouts.activateNextInPlan(ids.single);

    expect(next!.id, ids.single);
    expect((await workouts.getActiveForUser(userId))!.id, ids.single);
  });

  test('dos planes guardados rotan por separado', () async {
    final firstPlan = await savePlan(2);
    // La clave usa microsegundos; se espera para garantizar claves distintas.
    await Future<void>.delayed(const Duration(milliseconds: 5));
    final secondPlan = await savePlan(2);

    expect((await workouts.getActiveForUser(userId))!.id, secondPlan.first);

    final next = await workouts.activateNextInPlan(firstPlan.first);

    expect(next!.id, firstPlan.last);
  });

  test('un plan vacío no guarda nada', () async {
    expect(
      () => service.savePlanAndActivate(
        userId: userId,
        goal: 'general_fitness',
        difficulty: 'beginner',
        daysPerWeek: 3,
        plan: const [],
      ),
      throwsArgumentError,
    );

    expect(await workouts.getAllForUser(userId), isEmpty);
  });
}
