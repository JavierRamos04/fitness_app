import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/exercise_seed.dart';
import 'package:fitness_app/core/utils/exercise_labels.dart';

void main() {
  group('Etiquetas en español', () {
    test('todos los valores del catálogo tienen etiqueta traducida', () {
      void expectTranslated(String code, String label, String kind) {
        expect(
          label != code && !label.contains('_'),
          isTrue,
          reason: 'Falta la etiqueta en español de $kind "$code"',
        );
      }

      for (final exercise in initialExercises) {
        final muscle = exercise.primaryMuscle.value;
        final pattern = exercise.movementPattern.value;
        final type = exercise.exerciseType.value;
        final difficulty = exercise.difficulty.value;

        expectTranslated(muscle, muscleLabel(muscle), 'músculo');
        expectTranslated(pattern, movementPatternLabel(pattern), 'patrón');
        expectTranslated(type, exerciseTypeLabel(type), 'tipo');
        expectTranslated(difficulty, difficultyLabel(difficulty), 'nivel');
      }
    });

    test('un código desconocido se devuelve tal cual', () {
      expect(muscleLabel('desconocido'), 'desconocido');
      expect(movementPatternLabel('desconocido'), 'desconocido');
      expect(exerciseTypeLabel('desconocido'), 'desconocido');
      expect(difficultyLabel('desconocido'), 'desconocido');
    });
  });

  group('normalizeForSearch', () {
    test('quita acentos y pasa a minúsculas', () {
      expect(normalizeForSearch('Tríceps'), 'triceps');
      expect(normalizeForSearch('Glúteos'), 'gluteos');
      expect(normalizeForSearch('Extensión de rodilla'), 'extension de rodilla');
    });

    test('trata la ñ y la ü como n y u', () {
      expect(normalizeForSearch('Ñandú'), 'nandu');
      expect(normalizeForSearch('Pingüino'), 'pinguino');
    });

    test('ignora espacios al inicio y al final', () {
      expect(normalizeForSearch('  ESPALDA  '), 'espalda');
    });

    test('un texto vacío sigue vacío', () {
      expect(normalizeForSearch(''), '');
    });
  });
}
