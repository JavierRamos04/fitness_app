import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/session_exercise_repository.dart';
import 'package:fitness_app/core/database/session_repository.dart';
import 'package:fitness_app/core/database/set_repository.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/features/training/widgets/edit_set_dialog.dart';
import 'package:fitness_app/features/training/widgets/training_widgets.dart';

void main() {
  group('SetRepository: corregir y borrar series', () {
    late AppDatabase database;
    late SetRepository sets;
    late int sessionExerciseId;

    setUp(() async {
      database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      await AppInitializationService(database).initialize();

      final userId = await database
          .into(database.users)
          .insert(
            UsersCompanion.insert(
              birthDate: DateTime(1995, 5, 20),
              heightCm: 175,
              currentWeightKg: 80,
              fitnessLevel: 'beginner',
              trainingLocation: 'gym',
              weeklyFrequency: 3,
              availableMinutes: 45,
            ),
          );

      final exercises = await database.select(database.exercises).get();

      final sessionId = await SessionRepository(
        database,
      ).save(userId: userId, startedAt: DateTime(2026, 10, 1, 18));

      sessionExerciseId = await SessionExerciseRepository(database).save(
        sessionId: sessionId,
        exerciseId: exercises.first.id,
        orderIndex: 1,
      );

      sets = SetRepository(database);

      for (var index = 1; index <= 4; index++) {
        await sets.save(
          sessionExerciseId: sessionExerciseId,
          setIndex: index,
          weightKg: 50.0 + index,
          repetitions: 10 + index,
          setType: 'normal',
        );
      }
    });

    tearDown(() async {
      await database.close();
    });

    test('updateValues cambia repeticiones y peso sin mover la serie', () async {
      final before = await sets.getForSessionExercise(sessionExerciseId);

      await sets.updateValues(
        workoutSetId: before[1].id,
        repetitions: 8,
        weightKg: 62.5,
      );

      final after = await sets.getForSessionExercise(sessionExerciseId);

      expect(after, hasLength(4));
      expect(after[1].id, before[1].id);
      expect(after[1].setIndex, 2);
      expect(after[1].repetitions, 8);
      expect(after[1].weightKg, 62.5);
      expect(after[0].repetitions, 11);
      expect(after[2].repetitions, 13);
    });

    test('updateValues con peso nulo deja la serie sin peso', () async {
      final before = await sets.getForSessionExercise(sessionExerciseId);

      await sets.updateValues(
        workoutSetId: before.first.id,
        repetitions: 15,
        weightKg: null,
      );

      final after = await sets.getForSessionExercise(sessionExerciseId);

      expect(after.first.weightKg, isNull);
      expect(after.first.repetitions, 15);
    });

    test('deleteAndReindex renumera las series que quedan', () async {
      final before = await sets.getForSessionExercise(sessionExerciseId);

      await sets.deleteAndReindex(before[1].id);

      final after = await sets.getForSessionExercise(sessionExerciseId);

      expect(after.map((set) => set.setIndex), [1, 2, 3]);
      expect(after.map((set) => set.repetitions), [11, 13, 14]);
    });

    test('borrar la primera y la última también deja 1, 2, 3…', () async {
      var current = await sets.getForSessionExercise(sessionExerciseId);

      await sets.deleteAndReindex(current.first.id);

      current = await sets.getForSessionExercise(sessionExerciseId);
      await sets.deleteAndReindex(current.last.id);

      current = await sets.getForSessionExercise(sessionExerciseId);

      expect(current.map((set) => set.setIndex), [1, 2]);
      expect(current.map((set) => set.repetitions), [12, 13]);
    });

    test('tras borrar se puede registrar una serie nueva sin choques', () async {
      final before = await sets.getForSessionExercise(sessionExerciseId);

      await sets.deleteAndReindex(before[0].id);

      final remaining = await sets.getForSessionExercise(sessionExerciseId);

      await sets.save(
        sessionExerciseId: sessionExerciseId,
        setIndex: remaining.length + 1,
        weightKg: 70,
        repetitions: 5,
        setType: 'normal',
      );

      final after = await sets.getForSessionExercise(sessionExerciseId);

      expect(after.map((set) => set.setIndex), [1, 2, 3, 4]);
      expect(after.last.repetitions, 5);
    });

    test('borrar una serie que no existe no hace nada', () async {
      await sets.deleteAndReindex(99999);

      final after = await sets.getForSessionExercise(sessionExerciseId);

      expect(after, hasLength(4));
    });
  });

  group('EditSetDialog', () {
    /// Abre el diálogo; el resultado de cada cierre se añade a la lista.
    Future<List<EditedSet?>> open(
      WidgetTester tester, {
      bool timed = false,
      double? weight = 60,
      int reps = 10,
    }) async {
      final results = <EditedSet?>[];

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme(),
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  onPressed: () async {
                    results.add(
                      await showDialog<EditedSet>(
                      context: context,
                      builder: (_) => EditSetDialog(
                        setNumber: 2,
                        initialRepetitions: reps,
                        initialWeightKg: weight,
                        timed: timed,
                        noEquipment: false,
                      ),
                    ));
                  },
                  child: const Text('Abrir'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();

      return results;
    }

    testWidgets('muestra los valores actuales y devuelve los corregidos', (
      tester,
    ) async {
      final results = await open(tester);

      expect(find.text('Corregir serie 2'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('60'), findsOneWidget);

      await tester.enterText(find.widgetWithText(TextField, '10'), '8');
      await tester.enterText(find.widgetWithText(TextField, '60'), '62,5');
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Corregir serie 2'), findsNothing);
      expect(results.single?.repetitions, 8);
      expect(results.single?.weightKg, 62.5);
    });

    testWidgets('no cierra y avisa si las repeticiones no son válidas', (
      tester,
    ) async {
      await open(tester);

      await tester.enterText(find.widgetWithText(TextField, '10'), '0');
      await tester.tap(find.text('Guardar'));
      await tester.pump();

      expect(find.text('Corregir serie 2'), findsOneWidget);
      expect(find.textContaining('número válido'), findsOneWidget);
    });

    testWidgets('en ejercicios por tiempo no hay campo de peso', (
      tester,
    ) async {
      await open(tester, timed: true, weight: null, reps: 30);

      expect(find.text('Segundos'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Cancelar cierra sin cambios', (tester) async {
      final results = await open(tester);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.text('Corregir serie 2'), findsNothing);
      expect(results.single, isNull);
    });
  });

  group('SetRow con opciones', () {
    testWidgets('el menú ofrece corregir y eliminar', (tester) async {
      var edited = 0;
      var deleted = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme(),
          home: Scaffold(
            body: SetRow(
              index: 3,
              summary: '60 kg × 8',
              onEdit: () => edited++,
              onDelete: () => deleted++,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Corregir'));
      await tester.pumpAndSettle();

      expect(edited, 1);

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(deleted, 1);
    });

    testWidgets('sin acciones muestra la marca de hecho', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme(),
          home: const Scaffold(body: SetRow(index: 1, summary: '12 rep.')),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsNothing);
    });
  });
}
