import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/equipment_seed.dart';
import 'package:fitness_app/core/database/exercise_equipment_seed.dart';
import 'package:fitness_app/core/database/exercise_seed.dart';
import 'package:fitness_app/core/services/routine_generator.dart';
import 'package:fitness_app/core/services/routine_planner.dart';

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

  const planner = RoutinePlanner();

  const lowerPatterns = {
    'squat',
    'lunge',
    'hinge',
    'hip_extension',
    'calf_raise',
  };

  List<PlannedRoutine> plan({
    String level = 'intermediate',
    String goal = 'hypertrophy',
    int minutes = 60,
    Set<String>? equipment,
    required int days,
    int variant = 0,
  }) {
    return planner.generate(
      profile: GeneratorProfile(
        level: level,
        goal: goal,
        minutes: minutes,
        equipment: equipment ?? allEquipment,
      ),
      catalog: catalog,
      daysPerWeek: days,
      variant: variant,
    );
  }

  group('Días del plan', () {
    test('cantidad de rutinas según los días por semana', () {
      expect(planner.daysFor(0).length, 1);
      expect(planner.daysFor(1).length, 1);
      expect(planner.daysFor(2).length, 2);
      expect(planner.daysFor(3).length, 3);
      expect(planner.daysFor(4).length, 4);
      expect(planner.daysFor(5).length, 5);
      expect(planner.daysFor(6).length, 3);
      expect(planner.daysFor(7).length, 3);
    });

    test('2 y 3 días son de cuerpo completo', () {
      for (final days in [2, 3]) {
        expect(
          planner.daysFor(days).every(
                (day) => day.focus == RoutineFocus.fullBody,
              ),
          isTrue,
        );
      }
    });

    test('4 días: torso y pierna alternados', () {
      expect(
        planner.daysFor(4).map((day) => day.focus).toList(),
        [
          RoutineFocus.upper,
          RoutineFocus.lower,
          RoutineFocus.upper,
          RoutineFocus.lower,
        ],
      );
    });

    test('6 y 7 días: empuje, tirón y pierna', () {
      expect(
        planner.daysFor(6).map((day) => day.focus).toList(),
        [RoutineFocus.push, RoutineFocus.pull, RoutineFocus.lower],
      );
    });

    test('los nombres de un mismo plan no se repiten', () {
      for (var days = 1; days <= 7; days++) {
        final names = planner.daysFor(days).map((day) => day.name).toList();

        expect(names.toSet().length, names.length, reason: '$days días');
      }
    });
  });

  group('Enfoque de cada rutina', () {
    test('torso no incluye ejercicios de pierna', () {
      final routine = plan(days: 4).first.routine;

      expect(routine.exercises, isNotEmpty);

      for (final item in routine.exercises) {
        expect(
          lowerPatterns.contains(item.exercise.movementPattern),
          isFalse,
          reason: item.exercise.name,
        );
      }
    });

    test('pierna solo incluye pierna, core o cardio', () {
      final routine = plan(days: 4)[1].routine;

      expect(routine.exercises, isNotEmpty);

      for (final item in routine.exercises) {
        final pattern = item.exercise.movementPattern;

        expect(
          lowerPatterns.contains(pattern) ||
              pattern.startsWith('core_') ||
              pattern == 'locomotion',
          isTrue,
          reason: item.exercise.name,
        );
      }
    });

    test('empuje y tirón no incluyen pierna ni se mezclan entre sí', () {
      final days = plan(days: 5);
      final push = days[0].routine;
      final pull = days[1].routine;

      const pullPatterns = {
        'horizontal_pull',
        'vertical_pull',
        'back_extension',
      };
      const pushPatterns = {'horizontal_push', 'vertical_push'};

      for (final item in push.exercises) {
        final pattern = item.exercise.movementPattern;

        expect(lowerPatterns.contains(pattern), isFalse);
        expect(pullPatterns.contains(pattern), isFalse);
      }

      for (final item in pull.exercises) {
        final pattern = item.exercise.movementPattern;

        expect(lowerPatterns.contains(pattern), isFalse);
        expect(pushPatterns.contains(pattern), isFalse);
      }
    });

    test('dos días del mismo tipo no son idénticos', () {
      final days = plan(days: 4);

      List<int> ids(PlannedRoutine item) =>
          item.routine.exercises.map((e) => e.exercise.id).toList();

      expect(ids(days[0]), isNot(ids(days[2])), reason: 'Torso A y B');
      expect(ids(days[1]), isNot(ids(days[3])), reason: 'Pierna A y B');
    });

    test('es determinista: mismos datos, mismo plan', () {
      List<List<int>> ids(List<PlannedRoutine> value) => value
          .map((item) => item.routine.exercises.map((e) => e.exercise.id).toList())
          .toList();

      expect(ids(plan(days: 5)), ids(plan(days: 5)));
    });
  });

  group('Reglas que se cumplen en cada día de cada plan', () {
    final equipmentSets = <String, Set<String>>{
      'sin equipo': {},
      'mancuernas y banco': {'dumbbells', 'bench'},
      'gimnasio': allEquipment,
    };

    test('equipo, nivel, tiempo y sin repetidos', () {
      for (final equipmentEntry in equipmentSets.entries) {
        for (final level in ['beginner', 'intermediate', 'advanced']) {
          for (final goal in [
            'strength',
            'hypertrophy',
            'fat_loss',
            'general_fitness',
          ]) {
            for (var days = 1; days <= 7; days++) {
              for (var variant = 0; variant < 2; variant++) {
                final result = plan(
                  level: level,
                  goal: goal,
                  minutes: 45,
                  equipment: equipmentEntry.value,
                  days: days,
                  variant: variant,
                );

                final reason =
                    '${equipmentEntry.key}/$level/$goal/$days días/v$variant';

                expect(result.length, planner.daysFor(days).length,
                    reason: reason);

                for (final item in result) {
                  final exercises = item.routine.exercises;

                  expect(exercises, isNotEmpty,
                      reason: '$reason ${item.day.name}');

                  final ids = exercises.map((e) => e.exercise.id).toList();

                  expect(ids.toSet().length, ids.length,
                      reason: '$reason ${item.day.name}');

                  if (exercises.length > 3) {
                    expect(item.routine.estimatedMinutes, lessThanOrEqualTo(45),
                        reason: '$reason ${item.day.name}');
                  }

                  for (final entry in exercises) {
                    expect(
                      equipmentEntry.value
                          .containsAll(entry.exercise.requiredEquipment),
                      isTrue,
                      reason: '$reason ${entry.exercise.name}',
                    );
                    expect(
                      levelRank(entry.exercise.difficulty),
                      lessThanOrEqualTo(levelRank(level)),
                      reason: '$reason ${entry.exercise.name}',
                    );
                    expect(entry.minReps, lessThanOrEqualTo(entry.maxReps));
                  }
                }
              }
            }
          }
        }
      }
    });
  });

  group('Calidad del plan semanal', () {
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

    /// Series semanales por grupo muscular. Con 6 o 7 días el plan de 3
    /// rutinas se repite, así que cada rutina cuenta doble.
    Map<String, int> weeklySets(List<PlannedRoutine> result, int days) {
      const groups = {
        'chest': 'chest',
        'shoulders': 'shoulders',
        'upper_back': 'back',
        'latissimus': 'back',
        'lower_back': 'lowBack',
        'quadriceps': 'quads',
        'hamstrings': 'posterior',
        'glutes': 'posterior',
      };

      final repeats = days >= 6 ? 2 : 1;
      final totals = <String, int>{};

      for (final item in result) {
        for (final entry in item.routine.exercises) {
          final group = groups[entry.exercise.primaryMuscle];

          if (group != null) {
            totals[group] = (totals[group] ?? 0) + entry.sets * repeats;
          }
        }
      }

      return totals;
    }

    test('sin equipo, el día de tirón tiene ejercicios de espalda de verdad',
        () {
      final days = plan(
        level: 'beginner',
        goal: 'strength',
        minutes: 60,
        equipment: <String>{},
        days: 6,
      );

      final names = days[1].routine.exercises
          .map((item) => item.exercise.name)
          .toList();

      expect(days[1].day.name, 'Tirón');
      expect(names.length, greaterThanOrEqualTo(4));
      expect(names, contains('Remo invertido con rodillas dobladas'));
      expect(names, contains('Remo con mochila'));
    });

    test('con 60 minutos o más, cada semana trabaja pecho, espalda, '
        'cuádriceps y cadera, y equilibra empuje y tirón', () {
      for (final equipmentEntry in equipmentSets.entries) {
        for (final level in levels) {
          for (final goal in goals) {
            for (final minutes in [60, 90]) {
              for (var days = 2; days <= 7; days++) {
                for (var variant = 0; variant < 2; variant++) {
                  final label =
                      '${equipmentEntry.key} / $level / $goal / $minutes min / '
                      '$days días / variante $variant';

                  final totals = weeklySets(
                    plan(
                      level: level,
                      goal: goal,
                      minutes: minutes,
                      equipment: equipmentEntry.value,
                      days: days,
                      variant: variant,
                    ),
                    days,
                  );

                  expect(totals['chest'] ?? 0, greaterThan(0), reason: label);
                  expect(totals['back'] ?? 0, greaterThan(0), reason: label);
                  expect(totals['quads'] ?? 0, greaterThan(0), reason: label);
                  expect(totals['posterior'] ?? 0, greaterThan(0),
                      reason: label);

                  final push =
                      (totals['chest'] ?? 0) + (totals['shoulders'] ?? 0);
                  final pull =
                      (totals['back'] ?? 0) + (totals['lowBack'] ?? 0);
                  final ratio = push / pull;

                  expect(ratio, inInclusiveRange(0.5, 2.5),
                      reason: 'Empuje/tirón $ratio: $label');
                }
              }
            }
          }
        }
      }
    });

    test('en planes de 2 o 3 días el ejercicio de core no se repite', () {
      for (final equipmentEntry in equipmentSets.entries) {
        for (final level in levels) {
          for (final goal in goals) {
            for (final minutes in [45, 60, 90]) {
              for (final days in [2, 3]) {
                final names = [
                  for (final item in plan(
                    level: level,
                    goal: goal,
                    minutes: minutes,
                    equipment: equipmentEntry.value,
                    days: days,
                  ))
                    for (final entry in item.routine.exercises)
                      if (entry.exercise.movementPattern.startsWith('core_'))
                        entry.exercise.name,
                ];

                expect(
                  names.toSet().length,
                  names.length,
                  reason:
                      '${equipmentEntry.key} / $level / $goal / $minutes min / '
                      '$days días: $names',
                );
              }
            }
          }
        }
      }
    });

    test('los tres días de cuerpo completo conservan ejercicios distintos', () {
      final days = plan(days: 3, minutes: 60);

      final lists = [
        for (final item in days)
          item.routine.exercises.map((entry) => entry.exercise.id).toList(),
      ];

      expect(lists[0], isNot(lists[1]));
      expect(lists[1], isNot(lists[2]));
      expect(lists[0], isNot(lists[2]));
    });
  });
}
