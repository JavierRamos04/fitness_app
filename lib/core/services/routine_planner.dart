// Plan semanal: decide qué rutinas componen el plan según los días de
// entrenamiento por semana y las genera con [RoutineGenerator].
//
// Lógica pura (sin base de datos ni Flutter).

import 'routine_generator.dart';

/// Un día del plan: qué se trabaja y cómo se llama.
class PlanDay {
  const PlanDay({required this.name, required this.focus});

  final String name;
  final RoutineFocus focus;
}

/// Un día del plan con su rutina ya generada.
class PlannedRoutine {
  const PlannedRoutine({required this.day, required this.routine});

  final PlanDay day;
  final SuggestedRoutine routine;
}

class RoutinePlanner {
  const RoutinePlanner();

  /// Máximo de rutinas distintas en un plan. Con 6 o 7 días por semana el
  /// plan se repite (empuje, tirón, pierna, empuje, tirón, pierna…).
  static const int maxRoutines = 5;

  /// Días del plan para [daysPerWeek] días de entrenamiento por semana.
  List<PlanDay> daysFor(int daysPerWeek) {
    if (daysPerWeek <= 1) {
      return const [
        PlanDay(name: 'Cuerpo completo', focus: RoutineFocus.fullBody),
      ];
    }

    switch (daysPerWeek) {
      case 2:
        return const [
          PlanDay(name: 'Cuerpo completo A', focus: RoutineFocus.fullBody),
          PlanDay(name: 'Cuerpo completo B', focus: RoutineFocus.fullBody),
        ];
      case 3:
        return const [
          PlanDay(name: 'Cuerpo completo A', focus: RoutineFocus.fullBody),
          PlanDay(name: 'Cuerpo completo B', focus: RoutineFocus.fullBody),
          PlanDay(name: 'Cuerpo completo C', focus: RoutineFocus.fullBody),
        ];
      case 4:
        return const [
          PlanDay(name: 'Torso A', focus: RoutineFocus.upper),
          PlanDay(name: 'Pierna A', focus: RoutineFocus.lower),
          PlanDay(name: 'Torso B', focus: RoutineFocus.upper),
          PlanDay(name: 'Pierna B', focus: RoutineFocus.lower),
        ];
      case 5:
        return const [
          PlanDay(name: 'Empuje', focus: RoutineFocus.push),
          PlanDay(name: 'Tirón', focus: RoutineFocus.pull),
          PlanDay(name: 'Pierna A', focus: RoutineFocus.lower),
          PlanDay(name: 'Torso', focus: RoutineFocus.upper),
          PlanDay(name: 'Pierna B', focus: RoutineFocus.lower),
        ];
      default:
        return const [
          PlanDay(name: 'Empuje', focus: RoutineFocus.push),
          PlanDay(name: 'Tirón', focus: RoutineFocus.pull),
          PlanDay(name: 'Pierna', focus: RoutineFocus.lower),
        ];
    }
  }

  /// Genera todas las rutinas del plan. Los días del mismo tipo (por ejemplo
  /// "Torso A" y "Torso B") evitan repetir los mismos ejercicios.
  List<PlannedRoutine> generate({
    required GeneratorProfile profile,
    required List<GeneratorExercise> catalog,
    required int daysPerWeek,
    int variant = 0,
  }) {
    const generator = RoutineGenerator();
    final usedByFocus = <RoutineFocus, Set<int>>{};
    final timesByFocus = <RoutineFocus, int>{};
    final usedCore = <int>{};
    final result = <PlannedRoutine>[];

    for (final day in daysFor(daysPerWeek)) {
      final used = usedByFocus.putIfAbsent(day.focus, () => <int>{});
      final rotation = timesByFocus[day.focus] ?? 0;

      timesByFocus[day.focus] = rotation + 1;

      final routine = generator.generate(
        profile: profile,
        catalog: catalog,
        variant: variant,
        focus: day.focus,
        // El core también se evita entre días de distinto tipo: así no sale
        // el mismo ejercicio de abdomen todos los días.
        avoidIds: {...used, ...usedCore},
        rotation: rotation,
      );

      used.addAll(routine.exercises.map((item) => item.exercise.id));

      usedCore.addAll(
        routine.exercises
            .where((item) => item.exercise.movementPattern.startsWith('core_'))
            .map((item) => item.exercise.id),
      );

      result.add(PlannedRoutine(day: day, routine: routine));
    }

    return result;
  }
}
