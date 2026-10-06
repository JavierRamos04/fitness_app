import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/equipment_seed.dart';
import 'package:fitness_app/core/database/exercise_equipment_seed.dart';
import 'package:fitness_app/core/database/exercise_repository.dart';
import 'package:fitness_app/core/database/exercise_seed.dart';

void main() {
  group('Catálogo inicial (datos)', () {
    test('tiene 57 ejercicios con nombres únicos', () {
      final names = initialExercises
          .map((exercise) => exercise.name.value.trim().toLowerCase())
          .toList();

      expect(names.length, 57);
      expect(names.toSet().length, names.length);
    });

    test('todos los ejercicios tienen textos completos y dificultad válida', () {
      const validDifficulties = {'beginner', 'intermediate', 'advanced'};

      for (final exercise in initialExercises) {
        final name = exercise.name.value;

        final fields = {
          'description': exercise.description.value,
          'primaryMuscle': exercise.primaryMuscle.value,
          'movementPattern': exercise.movementPattern.value,
          'exerciseType': exercise.exerciseType.value,
          'technique': exercise.technique.value,
          'commonMistakes': exercise.commonMistakes.value,
          'considerations': exercise.considerations.value,
          'instructions': exercise.instructions.value,
        };

        fields.forEach((field, value) {
          expect(
            value.trim().isNotEmpty,
            isTrue,
            reason: '$name tiene el campo $field vacío',
          );
        });

        expect(
          validDifficulties.contains(exercise.difficulty.value),
          isTrue,
          reason: '$name tiene una dificultad no válida',
        );
      }
    });

    test('el equipamiento tiene códigos únicos', () {
      final codes =
          initialEquipment.map((equipment) => equipment.code.value).toList();

      expect(codes.toSet().length, codes.length);
    });

    test('el mapa de requisitos solo usa ejercicios y equipos que existen', () {
      final exerciseNames = initialExercises
          .map((exercise) => exercise.name.value.trim().toLowerCase())
          .toSet();

      final equipmentCodes =
          initialEquipment.map((equipment) => equipment.code.value).toSet();

      for (final entry in exerciseEquipmentRequirements.entries) {
        expect(
          exerciseNames.contains(entry.key.trim().toLowerCase()),
          isTrue,
          reason: 'Ejercicio inexistente en el mapa: ${entry.key}',
        );

        for (final code in entry.value) {
          expect(
            equipmentCodes.contains(code),
            isTrue,
            reason: 'Equipo inexistente "$code" en ${entry.key}',
          );
        }
      }
    });
  });

  group('Siembra y consulta de equipamiento', () {
    late AppDatabase database;
    late ExerciseRepository exerciseRepository;

    setUp(() async {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      exerciseRepository = ExerciseRepository(database);

      await AppInitializationService(database).initialize();
    });

    tearDown(() async {
      await database.close();
    });

    Future<Set<String>> availableNames(Set<String> ownedCodes) async {
      final available = await exerciseRepository.getAvailableForEquipment(
        ownedCodes,
      );

      return available.map((exercise) => exercise.name).toSet();
    }

    Future<List<int>> counts() async {
      final exercises = await database.select(database.exercises).get();
      final equipment = await database.select(database.equipment).get();
      final links = await database.select(database.exerciseEquipment).get();

      return [exercises.length, equipment.length, links.length];
    }

    test('initialize() siembra ejercicios, equipamiento y vínculos', () async {
      final expectedLinks = exerciseEquipmentRequirements.values.fold<int>(
        0,
        (total, codes) => total + codes.length,
      );

      expect(await counts(), [
        initialExercises.length,
        initialEquipment.length,
        expectedLinks,
      ]);
    });

    test('initialize() es idempotente: ejecutarlo otra vez no duplica', () async {
      final before = await counts();

      await AppInitializationService(database).initialize();
      await AppInitializationService(database).initialize();

      expect(await counts(), before);
    });

    test('sin equipo solo devuelve ejercicios que no requieren nada', () async {
      final names = await availableNames({});

      expect(names.length, 25);
      expect(names, contains('Flexiones'));
      expect(names, contains('Remo invertido bajo mesa'));
      expect(names, isNot(contains('Press de banca')));
      expect(names, isNot(contains('Sentadilla goblet')));
    });

    test('con mancuernas exige tener todo el equipo del ejercicio', () async {
      final onlyDumbbells = await availableNames({'dumbbells'});

      expect(onlyDumbbells, contains('Sentadilla goblet'));
      expect(onlyDumbbells, contains('Press de suelo con mancuernas'));
      expect(onlyDumbbells, isNot(contains('Press inclinado con mancuernas')));

      final withBench = await availableNames({'dumbbells', 'bench'});

      expect(withBench, contains('Press inclinado con mancuernas'));
    });

    test('con banda elástica se desbloquean los tirones', () async {
      final names = await availableNames({'resistance_band'});

      expect(names, contains('Remo con banda'));
      expect(names, contains('Jalón con banda'));
      expect(names, contains('Pallof press'));
    });

    test('con todo el equipamiento devuelve el catálogo completo', () async {
      final allCodes =
          initialEquipment.map((equipment) => equipment.code.value).toSet();

      final names = await availableNames(allCodes);

      expect(names.length, initialExercises.length);
    });
  });
}
