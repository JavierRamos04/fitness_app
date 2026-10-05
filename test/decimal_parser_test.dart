import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/utils/decimal_parser.dart';

void main() {
  group('parseDecimal', () {
    test('acepta punto como separador decimal', () {
      expect(parseDecimal('72.5'), 72.5);
    });

    test('acepta coma como separador decimal', () {
      expect(parseDecimal('72,5'), 72.5);
    });

    test('acepta enteros', () {
      expect(parseDecimal('80'), 80.0);
    });

    test('ignora espacios al inicio y al final', () {
      expect(parseDecimal('  72,5  '), 72.5);
    });

    test('devuelve null si el texto está vacío', () {
      expect(parseDecimal(''), isNull);
      expect(parseDecimal('   '), isNull);
    });

    test('devuelve null si el texto no es un número', () {
      expect(parseDecimal('abc'), isNull);
      expect(parseDecimal('72,5,3'), isNull);
      expect(parseDecimal('7 2'), isNull);
    });
  });
}
