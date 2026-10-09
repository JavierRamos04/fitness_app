import 'package:drift/drift.dart';

import '../services/routine_generator.dart';
import 'app_database.dart';

class ExerciseRepository {
  ExerciseRepository(this._database);

  final AppDatabase _database;

  /// Ejercicios activos ordenados por nombre.
  Future<List<Exercise>> getAll() {
    return (_database.select(_database.exercises)
          ..where((exercise) => exercise.isActive.equals(true))
          ..orderBy([(exercise) => OrderingTerm.asc(exercise.name)]))
        .get();
  }

  /// Equipo que necesita cada ejercicio: `idEjercicio -> {códigos de equipo}`.
  /// Los ejercicios sin equipo no aparecen en el mapa.
  Future<Map<int, Set<String>>> getRequiredEquipmentCodes() async {
    final query = _database.select(_database.exerciseEquipment).join([
      innerJoin(
        _database.equipment,
        _database.equipment.id.equalsExp(
          _database.exerciseEquipment.equipmentId,
        ),
      ),
    ]);

    final rows = await query.get();
    final result = <int, Set<String>>{};

    for (final row in rows) {
      final link = row.readTable(_database.exerciseEquipment);
      final equipment = row.readTable(_database.equipment);

      result.putIfAbsent(link.exerciseId, () => <String>{}).add(equipment.code);
    }

    return result;
  }

  /// Ejercicios que se pueden hacer con [ownedEquipmentCodes]: aquellos cuyo
  /// equipo necesario está completo dentro de lo que se tiene. Los ejercicios
  /// sin equipo siempre se incluyen.
  Future<List<Exercise>> getAvailableForEquipment(
    Set<String> ownedEquipmentCodes,
  ) async {
    final exercises = await getAll();
    final requirements = await getRequiredEquipmentCodes();

    return exercises.where((exercise) {
      final needed = requirements[exercise.id] ?? const <String>{};

      return needed.every(ownedEquipmentCodes.contains);
    }).toList();
  }

  /// Catálogo en el formato que usa el generador de rutinas, en orden de
  /// creación (el orden desempata de forma estable entre ejercicios).
  Future<List<GeneratorExercise>> getGeneratorCatalog() async {
    final exercises = [...await getAll()]
      ..sort((a, b) => a.id.compareTo(b.id));

    final requirements = await getRequiredEquipmentCodes();

    return [
      for (final exercise in exercises)
        GeneratorExercise(
          id: exercise.id,
          name: exercise.name,
          primaryMuscle: exercise.primaryMuscle,
          movementPattern: exercise.movementPattern,
          difficulty: exercise.difficulty,
          requiredEquipment: requirements[exercise.id] ?? const <String>{},
        ),
    ];
  }
}
