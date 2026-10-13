import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/services/training_guidance.dart';

void main() {
  group('TrainingGuidance.preWorkoutTips', () {
    test('siempre incluye calentamiento, repeticiones en reserva y dolor', () {
      for (final goal in [
        'strength',
        'hypertrophy',
        'fat_loss',
        'general_fitness',
        'otro',
      ]) {
        final tips = TrainingGuidance.preWorkoutTips(
          goal: goal,
          level: 'intermediate',
        );
        final text = tips.join(' ');

        expect(text, contains('Calienta'), reason: goal);
        expect(text, contains('en reserva'), reason: goal);
        expect(text, contains('dolor agudo'), reason: goal);
      }
    });

    test('el consejo del objetivo cambia según el objetivo', () {
      String tipFor(String goal) => TrainingGuidance.preWorkoutTips(
            goal: goal,
            level: 'intermediate',
          )[2];

      expect(tipFor('strength'), contains('fuerza'));
      expect(tipFor('hypertrophy'), contains('músculo'));
      expect(tipFor('fat_loss'), contains('grasa'));
      expect(tipFor('general_fitness'), isNot(equals(tipFor('strength'))));
    });

    test('principiantes reciben consejo de técnica; el resto, de progresión',
        () {
      final beginner = TrainingGuidance.preWorkoutTips(
        goal: 'hypertrophy',
        level: 'beginner',
      ).join(' ');
      final advanced = TrainingGuidance.preWorkoutTips(
        goal: 'hypertrophy',
        level: 'advanced',
      ).join(' ');

      expect(beginner, contains('Ver técnica'));
      expect(advanced, isNot(contains('Ver técnica')));
      expect(advanced, contains('sube la carga'));
    });
  });

  group('TrainingGuidance.summarize', () {
    test('sin series devuelve ceros', () {
      final summary = TrainingGuidance.summarize(
        sets: const [],
        duration: const Duration(seconds: 20),
      );

      expect(summary.exerciseCount, 0);
      expect(summary.setCount, 0);
      expect(summary.totalRepetitions, 0);
      expect(summary.volumeKg, 0);
      expect(summary.minutes, 1);
    });

    test('suma series, repeticiones y volumen solo de series con peso', () {
      final summary = TrainingGuidance.summarize(
        sets: const [
          LoggedSet(exerciseName: 'Press', repetitions: 10, weightKg: 20),
          LoggedSet(exerciseName: 'Press', repetitions: 8, weightKg: 22.5),
          LoggedSet(exerciseName: 'Flexiones', repetitions: 15),
          LoggedSet(exerciseName: 'Flexiones', repetitions: 12, weightKg: 0),
        ],
        duration: const Duration(minutes: 31, seconds: 10),
      );

      expect(summary.exerciseCount, 2);
      expect(summary.setCount, 4);
      expect(summary.totalRepetitions, 45);
      expect(summary.volumeKg, 380); // 200 + 180
      expect(summary.minutes, 32);
    });

    test('los segundos de isométricos no se mezclan con repeticiones', () {
      final summary = TrainingGuidance.summarize(
        sets: const [
          LoggedSet(exerciseName: 'Flexiones', repetitions: 12),
          LoggedSet(
            exerciseName: 'Plancha',
            repetitions: 30,
            isTimed: true,
          ),
          LoggedSet(
            exerciseName: 'Plancha',
            repetitions: 25,
            isTimed: true,
          ),
        ],
        duration: const Duration(minutes: 10),
      );

      expect(summary.setCount, 3);
      expect(summary.exerciseCount, 2);
      expect(summary.totalRepetitions, 12);
      expect(summary.totalSeconds, 55);
      expect(summary.volumeKg, 0);

      final lines = TrainingGuidance.summaryLines(summary);

      expect(lines, contains('Repeticiones: 12'));
      expect(lines, contains('Tiempo en posición: 55 s'));
    });

    test('solo isométricos: no muestra repeticiones en cero', () {
      final lines = TrainingGuidance.summaryLines(
        TrainingGuidance.summarize(
          sets: const [
            LoggedSet(
              exerciseName: 'Plancha',
              repetitions: 30,
              isTimed: true,
            ),
          ],
          duration: const Duration(minutes: 3),
        ),
      );

      expect(lines.any((line) => line.startsWith('Repeticiones')), isFalse);
      expect(lines, contains('Tiempo en posición: 30 s'));
    });

    test('líneas del resumen', () {
      final withWeight = TrainingGuidance.summaryLines(
        TrainingGuidance.summarize(
          sets: const [
            LoggedSet(exerciseName: 'Press', repetitions: 10, weightKg: 20),
          ],
          duration: const Duration(minutes: 30),
        ),
      );

      expect(withWeight, [
        'Duración: 30 min',
        'Ejercicios: 1',
        'Series: 1',
        'Repeticiones: 10',
        'Volumen levantado: 200 kg',
      ]);

      final bodyweight = TrainingGuidance.summaryLines(
        TrainingGuidance.summarize(
          sets: const [LoggedSet(exerciseName: 'Flexiones', repetitions: 12)],
          duration: const Duration(minutes: 5),
        ),
      );

      expect(bodyweight.any((line) => line.contains('Volumen')), isFalse);
    });
  });

  group('TrainingGuidance.closingMessage', () {
    test('rutina completa', () {
      expect(
        TrainingGuidance.closingMessage(
          plannedExercises: 5,
          doneExercises: 5,
        ),
        contains('Completaste toda la rutina'),
      );
    });

    test('rutina parcial', () {
      expect(
        TrainingGuidance.closingMessage(
          plannedExercises: 5,
          doneExercises: 3,
        ),
        contains('3 de 5 ejercicios'),
      );
    });
  });
}
