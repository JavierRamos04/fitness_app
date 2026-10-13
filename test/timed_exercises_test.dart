import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/data/exercise_guides.dart';
import 'package:fitness_app/core/services/timed_exercises.dart';

void main() {
  group('isTimedExercise', () {
    test('reconoce las planchas y nada más', () {
      expect(isTimedExercise('Plancha'), isTrue);
      expect(isTimedExercise('Plancha lateral'), isTrue);
      expect(isTimedExercise('Flexiones'), isFalse);
      expect(isTimedExercise('Farmer walk'), isFalse);
      expect(isTimedExercise(''), isFalse);
    });

    test('todos tienen guía de técnica', () {
      for (final name in timedExerciseNames) {
        expect(guideForExercise(name), isNotNull, reason: name);
      }
    });
  });

  group('TimedExercises.suggest', () {
    test('sin series válidas no sugiere nada', () {
      expect(
        TimedExercises.suggest(
          lastSeconds: const [],
          minSeconds: 20,
          maxSeconds: 40,
        ),
        isNull,
      );
      expect(
        TimedExercises.suggest(
          lastSeconds: const [0, -5],
          minSeconds: 20,
          maxSeconds: 40,
        ),
        isNull,
      );
    });

    test('sube 5 segundos sobre la mejor serie', () {
      final suggestion = TimedExercises.suggest(
        lastSeconds: const [25, 30, 20],
        minSeconds: 20,
        maxSeconds: 40,
      )!;

      expect(suggestion.repetitions, 35);
      expect(suggestion.weightKg, isNull);
      expect(suggestion.message, contains('35 segundos'));
      expect(suggestion.increasesLoad, isFalse);
    });

    test('no pasa del máximo del rango mientras no lo haya alcanzado', () {
      final suggestion = TimedExercises.suggest(
        lastSeconds: const [38],
        minSeconds: 20,
        maxSeconds: 40,
      )!;

      expect(suggestion.repetitions, 40);
    });

    test('al llegar al máximo propone más tiempo o una versión difícil', () {
      final suggestion = TimedExercises.suggest(
        lastSeconds: const [40, 40, 40],
        minSeconds: 20,
        maxSeconds: 40,
      )!;

      expect(suggestion.repetitions, 45);
      expect(suggestion.message, contains('más difícil'));
    });
  });
}
