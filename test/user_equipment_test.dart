import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/user_equipment_repository.dart';

void main() {
  group('Equipo del usuario', () {
    late AppDatabase database;
    late UserEquipmentRepository repository;
    late int userId;

    Future<int> createUser() {
      return database.into(database.users).insert(
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
    }

    setUp(() async {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      repository = UserEquipmentRepository(database);

      // Siembra el catálogo de equipamiento.
      await AppInitializationService(database).initialize();

      userId = await createUser();
    });

    tearDown(() async {
      await database.close();
    });

    test('un usuario nuevo no tiene equipo guardado', () async {
      expect(await repository.getCodes(userId), isEmpty);
    });

    test('guarda el equipo y lo devuelve igual', () async {
      await repository.replaceAll(userId, {'dumbbells', 'bench'});

      expect(await repository.getCodes(userId), {'dumbbells', 'bench'});
    });

    test('guardar de nuevo reemplaza lo anterior en vez de acumular', () async {
      await repository.replaceAll(userId, {'dumbbells'});
      await repository.replaceAll(userId, {'resistance_band'});

      expect(await repository.getCodes(userId), {'resistance_band'});
    });

    test('guardar un conjunto vacío borra todo el equipo', () async {
      await repository.replaceAll(userId, {'dumbbells', 'barbell'});
      await repository.replaceAll(userId, {});

      expect(await repository.getCodes(userId), isEmpty);
    });

    test('ignora los códigos que no existen en el catálogo', () async {
      await repository.replaceAll(userId, {'dumbbells', 'no_existe'});

      expect(await repository.getCodes(userId), {'dumbbells'});
    });

    test('no mezcla el equipo de usuarios distintos', () async {
      final otherUserId = await createUser();

      await repository.replaceAll(userId, {'dumbbells'});
      await repository.replaceAll(otherUserId, {'barbell'});

      expect(await repository.getCodes(userId), {'dumbbells'});
      expect(await repository.getCodes(otherUserId), {'barbell'});
    });

    test('al borrar el usuario se borra también su equipo', () async {
      await repository.replaceAll(userId, {'dumbbells', 'bench'});

      await database.delete(database.users).go();

      final remaining = await database.select(database.userEquipment).get();

      expect(remaining, isEmpty);
    });
  });

  group('Migración de la base de datos', () {
    // Tabla de rutinas tal como era antes de la versión 3 (sin las columnas
    // del plan semanal).
    const oldWorkoutsTable =
        'CREATE TABLE workouts ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'user_id INTEGER NOT NULL, '
        'name TEXT NOT NULL, '
        'goal TEXT NOT NULL, '
        'difficulty TEXT NOT NULL, '
        'days_per_week INTEGER NOT NULL, '
        'estimated_duration_minutes INTEGER NOT NULL, '
        'is_active INTEGER NOT NULL DEFAULT 0, '
        'created_at INTEGER NOT NULL'
        ');';

    AppDatabase openOldDatabase({required int version, bool withRow = false}) {
      return AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(
            setup: (rawDatabase) {
              rawDatabase.execute(oldWorkoutsTable);

              if (withRow) {
                rawDatabase.execute(
                  "INSERT INTO workouts (user_id, name, goal, difficulty, "
                  "days_per_week, estimated_duration_minutes, is_active, "
                  "created_at) VALUES (1, 'Rutina vieja', 'strength', "
                  "'beginner', 3, 45, 1, 1700000000);",
                );
              }

              rawDatabase.execute('PRAGMA user_version = $version;');
            },
          ),
          closeStreamsSynchronously: true,
        ),
      );
    }

    test('pasar de la versión 1 a la 2 crea la tabla user_equipment', () async {
      final upgrading = openOldDatabase(version: 1);

      final rows = await upgrading
          .customSelect(
            "SELECT name FROM sqlite_master "
            "WHERE type = 'table' AND name = 'user_equipment'",
          )
          .get();

      expect(rows.length, 1);

      await upgrading.close();
    });

    test('pasar de la versión 2 a la 3 añade las columnas del plan y '
        'conserva las rutinas', () async {
      final upgrading = openOldDatabase(version: 2, withRow: true);

      final workouts = await upgrading.select(upgrading.workouts).get();

      expect(workouts.length, 1);
      expect(workouts.first.name, 'Rutina vieja');
      expect(workouts.first.isActive, isTrue);
      expect(workouts.first.planKey, isNull);
      expect(workouts.first.planPosition, isNull);

      await upgrading.close();
    });
  });
}
