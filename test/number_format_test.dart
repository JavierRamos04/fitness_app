import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/utils/number_format.dart';

void main() {
  group('formatNumber', () {
    test('quita el decimal cuando es cero', () {
      expect(formatNumber(177.0), '177');
      expect(formatNumber(85), '85');
      expect(formatNumber(0), '0');
    });

    test('conserva un decimal cuando hace falta', () {
      expect(formatNumber(79.5), '79.5');
      expect(formatNumber(402.5), '402.5');
      expect(formatNumber(2.4), '2.4');
    });

    test('redondea a un decimal', () {
      expect(formatNumber(79.54), '79.5');
      expect(formatNumber(85.04), '85');
      expect(formatNumber(85.96), '86');
    });

    test('maneja diferencias negativas', () {
      expect(formatNumber(-5.0), '-5');
      expect(formatNumber(-1.5), '-1.5');
    });
  });

  group('pluralize', () {
    test('usa singular solo con 1', () {
      expect(pluralize(1, 'ejercicio', 'ejercicios'), '1 ejercicio');
      expect(pluralize(1, 'serie', 'series'), '1 serie');
    });

    test('usa plural con 0 y con más de 1', () {
      expect(pluralize(0, 'serie', 'series'), '0 series');
      expect(pluralize(2, 'serie', 'series'), '2 series');
      expect(pluralize(12, 'rep.', 'reps'), '12 reps');
    });
  });
}
