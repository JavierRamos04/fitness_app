import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/services/workout_grouping.dart';

Workout workout(
  int id,
  String name, {
  String? planKey,
  int? planPosition,
  int daysPerWeek = 3,
}) {
  return Workout(
    id: id,
    userId: 1,
    name: name,
    goal: 'general_fitness',
    difficulty: 'beginner',
    daysPerWeek: daysPerWeek,
    estimatedDurationMinutes: 45,
    isActive: false,
    createdAt: DateTime(2026, 1, 1).add(Duration(minutes: id)),
    planKey: planKey,
    planPosition: planPosition,
  );
}

void main() {
  group('groupWorkouts', () {
    test('lista vacía no genera grupos', () {
      expect(groupWorkouts(const []), isEmpty);
    });

    test('ordena las rutinas de un plan por posición', () {
      // Llegan de la más reciente a la más antigua (Día 3 primero).
      final groups = groupWorkouts([
        workout(3, 'Full body C · Casa', planKey: 'p1', planPosition: 3),
        workout(2, 'Full body B · Casa', planKey: 'p1', planPosition: 2),
        workout(1, 'Full body A · Casa', planKey: 'p1', planPosition: 1),
      ]);

      expect(groups, hasLength(1));
      expect(groups.first.isPlan, isTrue);
      expect(groups.first.workouts.map((w) => w.planPosition), [1, 2, 3]);
    });

    test('planes primero (el más reciente arriba) y sueltas al final', () {
      final groups = groupWorkouts([
        workout(9, 'Mi rutina'),
        workout(8, 'B2 · Gimnasio', planKey: 'nuevo', planPosition: 2),
        workout(7, 'B1 · Gimnasio', planKey: 'nuevo', planPosition: 1),
        workout(5, 'A1 · Casa', planKey: 'viejo', planPosition: 1),
        workout(4, 'Otra suelta'),
      ]);

      expect(groups.map((g) => g.planKey), ['nuevo', 'viejo', null]);
      expect(groups.last.workouts.map((w) => w.id), [9, 4]);
      expect(groups.last.isPlan, isFalse);
    });
  });

  group('WorkoutGroup', () {
    test('título con días y lugar', () {
      final group = groupWorkouts([
        workout(1, 'Empuje · Casa', planKey: 'p', planPosition: 1),
        workout(2, 'Tirón · Casa', planKey: 'p', planPosition: 2),
      ]).first;

      expect(group.location, 'Casa');
      expect(group.title, 'Plan de 3 días · Casa');
    });

    test('un día se escribe en singular', () {
      final group = groupWorkouts([
        workout(1, 'Full body · Gimnasio',
            planKey: 'p', planPosition: 1, daysPerWeek: 1),
      ]).first;

      expect(group.title, 'Plan de 1 día · Gimnasio');
    });

    test('sin lugar común no se muestra lugar', () {
      final group = groupWorkouts([
        workout(1, 'Empuje · Casa', planKey: 'p', planPosition: 1),
        workout(2, 'Tirón · Gimnasio', planKey: 'p', planPosition: 2),
      ]).first;

      expect(group.location, isNull);
      expect(group.title, 'Plan de 3 días');
      expect(group.displayName(group.workouts.first), 'Empuje · Casa');
    });

    test('quita el lugar del nombre dentro del plan', () {
      final group = groupWorkouts([
        workout(1, 'Torso A · Casa', planKey: 'p', planPosition: 1),
      ]).first;

      expect(group.displayName(group.workouts.first), 'Torso A');
    });

    test('las sueltas conservan su nombre y se titulan aparte', () {
      final group = groupWorkouts([workout(1, 'Piernas · mi rutina')]).first;

      expect(group.title, 'Rutinas sueltas');
      expect(group.displayName(group.workouts.first), 'Piernas · mi rutina');
    });
  });
}
