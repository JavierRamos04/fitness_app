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
    test('pasar de la versión 1 a la 2 crea la tabla user_equipment', () async {
      final upgrading = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(
            setup: (rawDatabase) {
              rawDatabase.execute('PRAGMA user_version = 1;');
            },
          ),
          closeStreamsSynchronously: true,
        ),
      );

      final rows = await upgrading
          .customSelect(
            "SELECT name FROM sqlite_master "
            "WHERE type = 'table' AND name = 'user_equipment'",
          )
          .get();

      expect(rows.length, 1);

      await upgrading.close();
    });
  });
}
