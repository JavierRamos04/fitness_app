import 'package:drift/drift.dart';

import 'app_database.dart';
import 'equipment_seed.dart';
import 'exercise_equipment_seed.dart';
import 'exercise_seed.dart';
import 'user_repository.dart';

class AppInitializationService {
  AppInitializationService(this._database);

  final AppDatabase _database;

  Future<bool> initialize() async {
    await _seedExercises();
    await _seedEquipment();
    await _seedExerciseEquipment();

    final userRepository = UserRepository(_database);
    final user = await userRepository.getUser();

    return user != null;
  }

  Future<void> _seedExercises() async {
    final existingExercises = await _database.select(_database.exercises).get();

    final existingNames = existingExercises
        .map((exercise) => exercise.name.trim().toLowerCase())
        .toSet();

    final exercisesToInsert = initialExercises.where((exercise) {
      final name = exercise.name.value.trim().toLowerCase();

      return !existingNames.contains(name);
    }).toList();

    if (exercisesToInsert.isEmpty) {
      return;
    }

    await _database.batch((batch) {
      batch.insertAll(_database.exercises, exercisesToInsert);
    });
  }

  /// Inserta el equipamiento que falte. `code` es único, así que lo que ya
  /// existe se ignora y es seguro ejecutarlo en cada arranque.
  Future<void> _seedEquipment() async {
    await _database.batch((batch) {
      batch.insertAll(
        _database.equipment,
        initialEquipment,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  /// Vincula cada ejercicio con el equipo que necesita. La pareja
  /// (ejercicio, equipo) es única, así que los vínculos ya creados se ignoran.
  Future<void> _seedExerciseEquipment() async {
    final exercises = await _database.select(_database.exercises).get();
    final equipment = await _database.select(_database.equipment).get();

    final exerciseIdsByName = {
      for (final exercise in exercises)
        exercise.name.trim().toLowerCase(): exercise.id,
    };

    final equipmentIdsByCode = {
      for (final item in equipment) item.code: item.id,
    };

    final links = <ExerciseEquipmentCompanion>[];

    exerciseEquipmentRequirements.forEach((exerciseName, equipmentCodes) {
      final exerciseId = exerciseIdsByName[exerciseName.trim().toLowerCase()];

      if (exerciseId == null) {
        return;
      }

      for (final code in equipmentCodes) {
        final equipmentId = equipmentIdsByCode[code];

        if (equipmentId == null) {
          continue;
        }

        links.add(
          ExerciseEquipmentCompanion.insert(
            exerciseId: exerciseId,
            equipmentId: equipmentId,
          ),
        );
      }
    });

    if (links.isEmpty) {
      return;
    }

    await _database.batch((batch) {
      batch.insertAll(
        _database.exerciseEquipment,
        links,
        mode: InsertMode.insertOrIgnore,
      );
    });
  }
}
