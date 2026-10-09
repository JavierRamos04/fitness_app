import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/services/progression_advisor.dart';

PerformedSet s(double? weight, int reps) =>
    PerformedSet(weightKg: weight, repetitions: reps);

void main() {
  test('sin series devuelve null', () {
    expect(
      ProgressionAdvisor.suggest(lastSets: [], minReps: 8, maxReps: 12),
      isNull,
    );
  });

  test('todas las series en el máximo del rango: sube el peso', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(60, 12), s(60, 12), s(60, 12)],
      minReps: 8,
      maxReps: 12,
    )!;

    expect(result.weightKg, 62.5);
    expect(result.repetitions, 8);
    expect(result.increasesLoad, isTrue);
  });

  test('dentro del rango: mantiene peso y sube una repetición', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(60, 10), s(60, 9), s(60, 8)],
      minReps: 8,
      maxReps: 12,
    )!;

    expect(result.weightKg, 60);
    expect(result.repetitions, 9);
    expect(result.increasesLoad, isFalse);
  });

  test('por debajo del mínimo: mantiene peso y busca el mínimo', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(60, 6), s(60, 5)],
      minReps: 8,
      maxReps: 12,
    )!;

    expect(result.weightKg, 60);
    expect(result.repetitions, 8);
    expect(result.increasesLoad, isFalse);
  });

  test('usa solo las series con el peso más alto', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(50, 12), s(60, 12), s(60, 12)],
      minReps: 8,
      maxReps: 12,
    )!;

    expect(result.weightKg, 62.5);
  });

  test('una serie del peso máximo por debajo del máximo no sube', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(60, 12), s(60, 11)],
      minReps: 8,
      maxReps: 12,
    )!;

    expect(result.weightKg, 60);
    expect(result.repetitions, 12);
    expect(result.increasesLoad, isFalse);
  });

  test('sin peso: sugiere una repetición más que la mejor serie', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(null, 15), s(null, 12)],
      minReps: 12,
      maxReps: 20,
    )!;

    expect(result.weightKg, isNull);
    expect(result.repetitions, 16);
    expect(result.increasesLoad, isFalse);
  });

  test('peso con decimales se muestra sin ceros sobrantes', () {
    final result = ProgressionAdvisor.suggest(
      lastSets: [s(22.5, 12), s(22.5, 12)],
      minReps: 8,
      maxReps: 12,
    )!;

    expect(result.weightKg, 25);
    expect(result.message, contains('25 kg'));
  });
}
