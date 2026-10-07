import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/equipment_seed.dart';
import 'package:fitness_app/core/database/exercise_equipment_seed.dart';
import 'package:fitness_app/core/database/exercise_seed.dart';
import 'package:fitness_app/core/services/routine_generator.dart';

/// Catálogo real (el mismo que se siembra en la app), sin base de datos.
List<GeneratorExercise> buildCatalog() {
  final exercises = initialExercises;

  return [
    for (var index = 0; index < exercises.length; index++)
      GeneratorExercise(
        id: index + 1,
        name: exercises[index].name.value,
        primaryMuscle: exercises[index].primaryMuscle.value,
        movementPattern: exercises[index].movementPattern.value,
        difficulty: exercises[index].difficulty.value,
        requiredEquipment:
            (exerciseEquipmentRequirements[exercises[index].name.value] ??
                    const <String>[])
                .toSet(),
      ),
  ];
}

int levelRank(String level) {
  switch (level) {
    case 'intermediate':
      return 1;
    case 'advanced':
      return 2;
    default:
      return 0;
  }
}

void main() {
  final catalog = buildCatalog();
  final allEquipment =
      initialEquipment.map((equipment) => equipment.code.value).toSet();

  const generator = RoutineGenerator();

  SuggestedRoutine generate({
    required String level,
    required String goal,
    required int minutes,
    required Set<String> equipment,
    int variant = 0,
  }) {
    return generator.generate(
      profile: GeneratorProfile(
        level: level,
        goal: goal,
        minutes: minutes,
        equipment: equipment,
      ),
      catalog: catalog,
      variant: variant,
    );
  }

  List<String> namesOf(SuggestedRoutine routine) {
    return routine.exercises.map((item) => item.exercise.name).toList();
  }

  group('Reglas que se cumplen siempre', () {
    final equipmentSets = <String, Set<String>>{
      'sin equipo': {},
      'solo banda': {'resistance_band'},
      'mancuernas y banco': {'dumbbells', 'bench'},
      'casa completa': {
        'dumbbells',
        'resistance_band',
        'bench',
        'pull_up_bar',
        'barbell',
      },
      'gimnasio': allEquipment,
    };

    const levels = ['beginner', 'intermediate', 'advanced'];
    const goals = ['strength', 'hypertrophy', 'fat_loss', 'general_fitness'];
    const minutesOptions = [15, 20, 30, 45, 60, 75, 90, 120];
    const timeBased = {'Plancha', 'Plancha lateral', 'Farmer walk'};

    test('en todas las combinaciones de perfil, equipo y variante', () {
      for (final equipmentEntry in equipmentSets.entries) {
        for (final level in levels) {
          for (final goal in goals) {
            for (final minutes in minutesOptions) {
              for (var variant = 0; variant < 4; variant++) {
                final label =
                    '${equipmentEntry.key} / $level / $goal / '
                    '$minutes min / variante $variant';

                final routine = generate(
                  level: level,
                  goal: goal,
                  minutes: minutes,
                  equipment: equipmentEntry.value,
                  variant: variant,
                );

                final names = namesOf(routine);

                expect(
                  names.length >= 3 && names.length <= 9,
                  isTrue,
                  reason: 'Cantidad de ejercicios fuera de 3 a 9: $label',
                );

                expect(
                  names.toSet().length,
                  names.length,
                  reason: 'Ejercicios repetidos: $label',
                );

                if (routine.exercises.length > 3) {
                  expect(
                    routine.estimatedMinutes <= minutes,
                    isTrue,
                    reason: 'Se pasa del tiempo disponible: $label',
                  );
                }

                for (final item in routine.exercises) {
                  final exercise = item.exercise;

                  expect(
                    equipmentEntry.value.containsAll(
                      exercise.requiredEquipment,
                    ),
                    isTrue,
                    reason: '${exercise.name} pide equipo que no hay: $label',
                  );

                  expect(
                    levelRank(exercise.difficulty) <= levelRank(level),
                    isTrue,
                    reason: '${exercise.name} es demasiado difícil: $label',
                  );

                  expect(
                    timeBased.contains(exercise.name),
                    isFalse,
                    reason: '${exercise.name} se mide en tiempo: $label',
                  );

                  expect(item.sets >= 2, isTrue, reason: label);
                  expect(item.minReps <= item.maxReps, isTrue, reason: label);
                  expect(item.restSeconds > 0, isTrue, reason: label);
                }
              }
            }
          }
        }
      }
    });

    test('es determinista: mismos datos, misma rutina', () {
      final first = generate(
        level: 'intermediate',
        goal: 'hypertrophy',
        minutes: 60,
        equipment: allEquipment,
      );

      final second = generate(
        level: 'intermediate',
        goal: 'hypertrophy',
        minutes: 60,
        equipment: allEquipment,
      );

      expect(namesOf(first), namesOf(second));
    });
  });

  group('Repeticiones y descanso según el objetivo', () {
    SuggestedExercise firstExercise(String goal) {
      return generate(
        level: 'intermediate',
        goal: goal,
        minutes: 60,
        equipment: allEquipment,
      ).exercises.first;
    }

    void expectPrescription(
      SuggestedExercise item,
      int minReps,
      int maxReps,
      int restSeconds,
    ) {
      expect(item.minReps, minReps);
      expect(item.maxReps, maxReps);
      expect(item.restSeconds, restSeconds);
    }

    test('fuerza: pocas repeticiones y descanso largo', () {
      final item = firstExercise('strength');

      expect(item.exercise.name, 'Sentadilla con barra');
      expect(item.sets, 4);
      expectPrescription(item, 4, 6, 150);
    });

    test('masa muscular: 8 a 12 repeticiones y descanso medio', () {
      final item = firstExercise('hypertrophy');

      expect(item.sets, 3);
      expectPrescription(item, 8, 12, 75);
    });

    test('perder grasa: muchas repeticiones y descanso corto', () {
      expectPrescription(firstExercise('fat_loss'), 12, 15, 45);
    });

    test('condición física: rango intermedio', () {
      expectPrescription(firstExercise('general_fitness'), 10, 12, 60);
    });

    test('un objetivo desconocido usa condición física', () {
      expectPrescription(firstExercise('xyz'), 10, 12, 60);
    });

    test('los accesorios usan un rango más alto que los principales', () {
      final routine = generate(
        level: 'intermediate',
        goal: 'hypertrophy',
        minutes: 60,
        equipment: allEquipment,
      );

      final biceps = routine.exercises.firstWhere(
        (item) => item.exercise.primaryMuscle == 'biceps',
      );

      expect(biceps.minReps, 10);
      expect(biceps.maxReps, 15);
      expect(biceps.restSeconds, 60);
    });

    test('sin carga externa, fuerza no usa el rango de 4 a 6', () {
      final routine = generate(
        level: 'beginner',
        goal: 'strength',
        minutes: 45,
        equipment: {},
      );

      final pushUps = routine.exercises.firstWhere(
        (item) => item.exercise.name == 'Flexiones',
      );

      expect(pushUps.minReps, 8);
      expect(pushUps.maxReps, 10);
      expect(pushUps.restSeconds, 90);
    });
  });

  group('Selección de ejercicios', () {
    test('gimnasio avanzado con fuerza elige los levantamientos con barra', () {
      final routine = generate(
        level: 'advanced',
        goal: 'strength',
        minutes: 75,
        equipment: allEquipment,
      );

      expect(namesOf(routine).take(4).toList(), [
        'Sentadilla con barra',
        'Press de banca',
        'Dominadas',
        'Peso muerto convencional',
      ]);
    });

    test('un principiante no recibe ejercicios de nivel superior', () {
      final routine = generate(
        level: 'beginner',
        goal: 'hypertrophy',
        minutes: 60,
        equipment: allEquipment,
      );

      for (final item in routine.exercises) {
        expect(item.exercise.difficulty, 'beginner');
      }
    });

    test('sin equipo incluye espalda baja y sugiere una banda elástica', () {
      final routine = generate(
        level: 'beginner',
        goal: 'general_fitness',
        minutes: 45,
        equipment: {},
      );

      expect(namesOf(routine), contains('Superman'));
      expect(routine.equipmentTip, isNotNull);
      expect(routine.equipmentTip, contains('banda elástica'));
    });

    test('con banda elástica hay tirones y no se sugiere nada', () {
      final routine = generate(
        level: 'beginner',
        goal: 'general_fitness',
        minutes: 30,
        equipment: {'resistance_band'},
      );

      expect(namesOf(routine), contains('Remo con banda'));
      expect(routine.equipmentTip, isNull);
    });

    test('perder grasa incluye un ejercicio de cardio', () {
      final routine = generate(
        level: 'beginner',
        goal: 'fat_loss',
        minutes: 45,
        equipment: {},
      );

      final hasCardio = routine.exercises.any(
        (item) => item.exercise.movementPattern == 'locomotion',
      );

      expect(hasCardio, isTrue);
    });

    test('con mucho tiempo y poco equipo se añade volumen extra', () {
      final routine = generate(
        level: 'beginner',
        goal: 'strength',
        minutes: 90,
        equipment: {},
      );

      final legExercises = routine.exercises.where(
        (item) =>
            item.exercise.movementPattern == 'squat' ||
            item.exercise.movementPattern == 'lunge',
      );

      expect(routine.exercises.length, 9);
      expect(legExercises.length, 2);
    });

    test('con muy poco tiempo se mantiene un mínimo de 3 ejercicios', () {
      final routine = generate(
        level: 'advanced',
        goal: 'strength',
        minutes: 15,
        equipment: allEquipment,
      );

      expect(routine.exercises.length, 3);
    });

    test('"Generar otra" cambia la rutina sin romper las reglas', () {
      const homeEquipment = {'dumbbells', 'resistance_band', 'bench'};

      final first = generate(
        level: 'intermediate',
        goal: 'hypertrophy',
        minutes: 60,
        equipment: homeEquipment,
        variant: 0,
      );

      final second = generate(
        level: 'intermediate',
        goal: 'hypertrophy',
        minutes: 60,
        equipment: homeEquipment,
        variant: 1,
      );

      expect(namesOf(first), isNot(namesOf(second)));
    });
  });
}
