// Agrupa las rutinas del usuario por plan semanal para mostrarlas ordenadas.
//
// Lógica pura (sin Flutter) para poder probarla fácilmente.

import '../database/app_database.dart';
import '../utils/number_format.dart';

/// Separador entre el nombre de la rutina y el lugar: "Empuje · Casa".
const String _locationSeparator = ' · ';

/// Un plan semanal (varias rutinas con el mismo `planKey`) o, si [planKey] es
/// `null`, el conjunto de rutinas sueltas.
class WorkoutGroup {
  const WorkoutGroup({required this.planKey, required this.workouts});

  final String? planKey;

  /// Rutinas del grupo; en un plan, en el orden Día 1, Día 2…
  final List<Workout> workouts;

  bool get isPlan => planKey != null;

  /// Lugar con el que se creó el plan ("Casa", "Gimnasio"), si todas las
  /// rutinas del plan lo comparten en su nombre.
  String? get location {
    if (!isPlan || workouts.isEmpty) {
      return null;
    }

    final locations = workouts.map((workout) => _locationOf(workout.name));

    final first = locations.first;

    if (first == null || locations.any((item) => item != first)) {
      return null;
    }

    return first;
  }

  /// "Plan de 3 días · Casa". Para las rutinas sueltas, "Rutinas sueltas".
  String get title {
    if (!isPlan) {
      return 'Rutinas sueltas';
    }

    final days = workouts.isEmpty ? 0 : workouts.first.daysPerWeek;
    final base = 'Plan de ${pluralize(days, 'día', 'días')}';
    final place = location;

    return place == null ? base : '$base$_locationSeparator$place';
  }

  /// Nombre de la rutina para mostrarlo dentro de su grupo. En un plan se
  /// quita el lugar, porque ya aparece en el título del grupo.
  String displayName(Workout workout) {
    if (!isPlan || location == null) {
      return workout.name;
    }

    final index = workout.name.lastIndexOf(_locationSeparator);

    return index <= 0 ? workout.name : workout.name.substring(0, index);
  }
}

String? _locationOf(String name) {
  final index = name.lastIndexOf(_locationSeparator);

  if (index <= 0) {
    return null;
  }

  final place = name.substring(index + _locationSeparator.length).trim();

  return place.isEmpty ? null : place;
}

/// Agrupa [workouts] (que llegan de la más reciente a la más antigua).
///
/// - Primero los planes, el más reciente arriba; dentro de cada plan, por
///   `planPosition` (Día 1, Día 2…).
/// - Al final, un único grupo con las rutinas sueltas (si hay).
List<WorkoutGroup> groupWorkouts(List<Workout> workouts) {
  final planOrder = <String>[];
  final byPlan = <String, List<Workout>>{};
  final loose = <Workout>[];

  for (final workout in workouts) {
    final key = workout.planKey;

    if (key == null) {
      loose.add(workout);
      continue;
    }

    if (!byPlan.containsKey(key)) {
      planOrder.add(key);
    }

    byPlan.putIfAbsent(key, () => <Workout>[]).add(workout);
  }

  final groups = <WorkoutGroup>[];

  for (final key in planOrder) {
    final items = [...byPlan[key]!]
      ..sort((a, b) {
        final byPosition = (a.planPosition ?? 1 << 30).compareTo(
          b.planPosition ?? 1 << 30,
        );

        return byPosition != 0 ? byPosition : a.id.compareTo(b.id);
      });

    groups.add(WorkoutGroup(planKey: key, workouts: items));
  }

  if (loose.isNotEmpty) {
    groups.add(WorkoutGroup(planKey: null, workouts: loose));
  }

  return groups;
}
