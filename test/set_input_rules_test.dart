import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/services/set_input_rules.dart';
import 'package:fitness_app/core/utils/workout_labels.dart';

void main() {
  group('SetInputRules.validate', () {
    String? check(String reps, [String weight = '']) =>
        SetInputRules.validate(repetitionsText: reps, weightText: weight);

    test('acepta datos normales', () {
      expect(check('10'), isNull);
      expect(check('8', '82.5'), isNull);
      expect(check('8', '82,5'), isNull);
      expect(check('12', '0'), isNull);
    });

    test('pide las repeticiones', () {
      expect(check(''), 'Introduce las repeticiones.');
      expect(check('   '), 'Introduce las repeticiones.');
    });

    test('rechaza repeticiones inválidas', () {
      expect(check('abc'), contains('número válido'));
      expect(check('0'), contains('número válido'));
      expect(check('-3'), contains('número válido'));
      expect(check('7.5'), contains('número válido'));
    });

    test('rechaza repeticiones exageradas', () {
      expect(check('300'), isNull);
      expect(check('301'), contains('300'));
      expect(check('69190'), contains('300'));
    });

    test('rechaza peso inválido o exagerado', () {
      expect(check('10', 'abc'), contains('peso debe ser'));
      expect(check('10', '-5'), contains('peso debe ser'));
      expect(check('10', '600'), isNull);
      expect(check('10', '600.5'), contains('600 kg'));
      expect(check('10', '9999'), contains('600 kg'));
    });
  });

  group('SetInputRules textos', () {
    test('título de captura', () {
      expect(
        SetInputRules.registerTitle(nextSetIndex: 1, plannedSets: 3),
        'Registrar serie 1 de 3',
      );
      expect(
        SetInputRules.registerTitle(nextSetIndex: 3, plannedSets: 3),
        'Registrar serie 3 de 3',
      );
      expect(
        SetInputRules.registerTitle(nextSetIndex: 4, plannedSets: 3),
        'Registrar serie extra',
      );
      expect(
        SetInputRules.registerTitle(nextSetIndex: 1, plannedSets: 0),
        'Registrar serie extra',
      );
    });

    test('mensaje de primera vez sin equipo habla de esfuerzo, no de peso',
        () {
      final message = SetInputRules.firstTimeMessage(
        noEquipment: true,
        minReps: 8,
        maxReps: 12,
      );

      expect(message, contains('8-12'));
      expect(message, contains('1-3'));
      expect(message, isNot(contains('peso ligero')));
    });

    test('mensaje de primera vez con equipo indica cómo elegir el peso', () {
      final message = SetInputRules.firstTimeMessage(
        noEquipment: false,
        minReps: 10,
        maxReps: 10,
      );

      expect(message, contains('un peso'));
      expect(message, contains('10 repeticiones'));
      expect(message, contains('1-3'));
    });

    test('etiqueta y ayuda del peso según el ejercicio', () {
      expect(
        SetInputRules.weightLabel(noEquipment: true),
        'Peso extra (kg, opcional)',
      );
      expect(SetInputRules.weightLabel(noEquipment: false), 'Peso (kg)');
      expect(
        SetInputRules.weightHint(noEquipment: true),
        'Vacío = tu peso corporal',
      );
      expect(SetInputRules.weightHint(noEquipment: false), 'Ej. 80');
    });
  });

  group('workout_labels', () {
    test('formatSetsReps', () {
      expect(formatSetsReps(sets: 3, minReps: 8, maxReps: 12), '3×8-12');
      expect(formatSetsReps(sets: 4, minReps: 10, maxReps: 10), '4×10');
    });

    test('todayLabel', () {
      expect(todayLabel(), 'RUTINA ACTIVA');
      expect(
        todayLabel(planPosition: 2, planSize: 4),
        'HOY TOCA · DÍA 2 DE 4',
      );
      expect(todayLabel(planPosition: 2), 'HOY TOCA · DÍA 2');
      expect(todayLabel(planPosition: 5, planSize: 3), 'HOY TOCA · DÍA 5');
    });
  });
}
