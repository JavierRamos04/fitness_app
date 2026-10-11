import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/data/exercise_guides.dart';
import 'package:fitness_app/core/database/exercise_seed.dart';
import 'package:fitness_app/core/widgets/exercise_guide_view.dart';

void main() {
  final names =
      initialExercises.map((exercise) => exercise.name.value).toList();

  group('Guías de técnica', () {
    test('todos los ejercicios del catálogo tienen guía', () {
      final missing = names.where((name) => guideForExercise(name) == null);

      expect(missing, isEmpty);
    });

    test('no hay guías de ejercicios que no existen', () {
      final extra = exerciseGuides.keys.where((name) => !names.contains(name));

      expect(extra, isEmpty);
    });

    test('cada guía tiene contenido suficiente', () {
      for (final entry in exerciseGuides.entries) {
        final guide = entry.value;

        expect(guide.steps.length, inInclusiveRange(3, 7), reason: entry.key);
        expect(guide.cues.length, inInclusiveRange(2, 4), reason: entry.key);
        expect(guide.mistakes.length, inInclusiveRange(2, 4),
            reason: entry.key);
        expect(
          guide.easier != null || guide.harder != null,
          isTrue,
          reason: '${entry.key} debería tener al menos una progresión',
        );
      }
    });

    test('los textos están completos y sin espacios sobrantes', () {
      for (final entry in exerciseGuides.entries) {
        final guide = entry.value;

        final texts = <String>[
          ...guide.steps,
          ...guide.cues,
          ...guide.mistakes,
          if (guide.easier != null) guide.easier!,
          if (guide.harder != null) guide.harder!,
          if (guide.safety != null) guide.safety!,
          if (guide.breathing != null) guide.breathing!,
        ];

        for (final text in texts) {
          expect(text, text.trim(), reason: '${entry.key}: "$text"');
          expect(text.endsWith('.'), isTrue,
              reason: '${entry.key}: "$text"');
          expect(text.contains('  '), isFalse,
              reason: '${entry.key}: "$text"');
          expect(text.length, greaterThan(5),
              reason: '${entry.key}: "$text"');
        }
      }
    });

    test('los ejercicios de core isométricos explican cómo respirar', () {
      for (final name in ['Plancha', 'Plancha lateral', 'Dead bug']) {
        expect(guideForExercise(name)!.breathing, isNotNull, reason: name);
      }
    });

    test('los ejercicios con banda mencionan la banda', () {
      for (final name in names.where((name) => name.contains('banda'))) {
        final guide = guideForExercise(name)!;
        final all = [
          ...guide.steps,
          ...guide.cues,
          ...guide.mistakes,
        ].join(' ').toLowerCase();

        expect(all.contains('banda'), isTrue, reason: name);
      }
    });
  });

  group('Vista de la guía', () {
    Future<void> pump(WidgetTester tester, Widget child) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: child)),
        ),
      );
    }

    testWidgets('muestra las secciones de un ejercicio con guía',
        (tester) async {
      await pump(tester, const ExerciseGuideView(name: 'Flexiones'));

      expect(find.text('Cómo hacerlo'), findsOneWidget);
      expect(find.text('Puntos clave'), findsOneWidget);
      expect(find.text('Errores frecuentes'), findsOneWidget);
      expect(find.text('Respiración'), findsOneWidget);
      expect(find.text('Ajusta la dificultad'), findsOneWidget);
      expect(
        find.text(guideForExercise('Flexiones')!.steps.first),
        findsOneWidget,
      );
      expect(find.text(guideDisclaimer), findsOneWidget);
    });

    testWidgets('muestra el aviso de seguridad cuando existe',
        (tester) async {
      await pump(tester, const ExerciseGuideView(name: 'Sentadilla con barra'));

      expect(
        find.text(guideForExercise('Sentadilla con barra')!.safety!),
        findsOneWidget,
      );
    });

    testWidgets('sin guía muestra el texto de respaldo', (tester) async {
      await pump(
        tester,
        const ExerciseGuideView(
          name: 'Ejercicio inventado',
          fallbackText: 'Texto de respaldo.',
        ),
      );

      expect(find.text('Texto de respaldo.'), findsOneWidget);
      expect(find.text('Cómo hacerlo'), findsNothing);
    });

    testWidgets('sin guía ni respaldo muestra un aviso', (tester) async {
      await pump(tester, const ExerciseGuideView(name: 'Ejercicio inventado'));

      expect(
        find.text('Todavía no hay una guía de técnica para este ejercicio.'),
        findsOneWidget,
      );
    });
  });
}
