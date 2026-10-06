import 'package:drift/drift.dart';

import 'equipment_table.dart';
import 'exercise_equipment_table.dart';
import 'exercise_relationship_table.dart';
import 'exercise_table.dart';
import 'goal_table.dart';
import 'session_exercise_table.dart';
import 'session_table.dart';
import 'set_table.dart';
import 'user_equipment_table.dart';
import 'user_table.dart';
import 'weight_entry_table.dart';
import 'workout_exercise_table.dart';
import 'workout_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    UserEquipment,
    WeightEntries,
    Goals,
    Equipment,
    Exercises,
    ExerciseEquipment,
    ExerciseRelationships,
    Workouts,
    WorkoutExercises,
    Sessions,
    SessionExercises,
    WorkoutSets,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      // Versión 2: equipo disponible del usuario.
      if (from < 2) {
        await migrator.createTable(userEquipment);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}