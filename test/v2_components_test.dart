import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/services/set_input_rules.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/utils/date_format.dart';
import 'package:fitness_app/core/widgets/app_components.dart';
import 'package:fitness_app/features/training/widgets/training_widgets.dart';

Widget host(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme(),
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  group('formatLongDate', () {
    test('escribe día de la semana, día y mes en español', () {
      expect(formatLongDate(DateTime(2026, 10, 13)), 'martes 13 de octubre');
      expect(formatLongDate(DateTime(2026, 1, 1)), 'jueves 1 de enero');
      expect(
        formatLongDate(DateTime(2026, 12, 27)),
        'domingo 27 de diciembre',
      );
      expect(formatLongDate(DateTime(2026, 3, 2)), 'lunes 2 de marzo');
    });
  });

  group('formatElapsed', () {
    test('minutos y segundos con ceros', () {
      expect(formatElapsed(Duration.zero), '00:00');
      expect(formatElapsed(const Duration(seconds: 307)), '05:07');
      expect(formatElapsed(const Duration(minutes: 59, seconds: 59)), '59:59');
    });

    test('muestra horas a partir de los 60 minutos', () {
      expect(formatElapsed(const Duration(hours: 1, minutes: 5, seconds: 7)),
          '1:05:07');
    });

    test('no muestra tiempos negativos', () {
      expect(formatElapsed(const Duration(seconds: -4)), '00:00');
    });
  });

  group('SetInputRules.summary', () {
    test('series por tiempo', () {
      expect(
        SetInputRules.summary(repetitions: 30, weightKg: null, timed: true),
        '30 s',
      );
    });

    test('series sin peso o con peso cero', () {
      expect(
        SetInputRules.summary(repetitions: 12, weightKg: null, timed: false),
        '12 rep.',
      );
      expect(
        SetInputRules.summary(repetitions: 12, weightKg: 0, timed: false),
        '12 rep.',
      );
    });

    test('series con peso', () {
      expect(
        SetInputRules.summary(repetitions: 8, weightKg: 82.5, timed: false),
        '82.5 kg × 8',
      );
      expect(
        SetInputRules.summary(repetitions: 10, weightKg: 60, timed: false),
        '60 kg × 10',
      );
    });
  });

  group('Componentes', () {
    testWidgets('AppHeroCard muestra datos y ejecuta la acción', (
      tester,
    ) async {
      var pressed = 0;

      await tester.pumpWidget(
        host(
          AppHeroCard(
            eyebrow: 'HOY TOCA · DÍA 1 DE 3',
            title: 'Pecho y tríceps',
            chips: const [(Icons.schedule, '45 min')],
            lines: const [
              AppHeroLine(name: 'Press banca', detail: '3×8-12'),
            ],
            moreLabel: '+2 más',
            actionLabel: 'Comenzar entrenamiento',
            onAction: () => pressed++,
          ),
        ),
      );

      expect(find.text('Pecho y tríceps'), findsOneWidget);
      expect(find.text('45 min'), findsOneWidget);
      expect(find.text('Press banca'), findsOneWidget);
      expect(find.text('3×8-12'), findsOneWidget);
      expect(find.text('+2 más'), findsOneWidget);

      await tester.tap(find.text('Comenzar entrenamiento'));
      expect(pressed, 1);
    });

    testWidgets('AppStatCard muestra cifra, unidad y etiqueta', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const AppStatCard(
            icon: Icons.local_fire_department_outlined,
            value: '4',
            unit: 'días',
            label: 'Racha actual',
          ),
        ),
      );

      expect(find.text('4'), findsOneWidget);
      expect(find.text('días'), findsOneWidget);
      expect(find.text('Racha actual'), findsOneWidget);
    });

    testWidgets('AppEmptyState muestra sus acciones', (tester) async {
      await tester.pumpWidget(
        host(
          AppEmptyState(
            icon: Icons.fitness_center,
            title: 'Aún no tienes rutina',
            message: 'Crea una rutina.',
            actions: [
              FilledButton(onPressed: () {}, child: const Text('Crear')),
            ],
          ),
        ),
      );

      expect(find.text('Aún no tienes rutina'), findsOneWidget);
      expect(find.text('Crear'), findsOneWidget);
    });

    testWidgets('StepperField llama a − y + y muestra el valor', (
      tester,
    ) async {
      final controller = TextEditingController(text: '10');
      addTearDown(controller.dispose);

      var down = 0;
      var up = 0;

      await tester.pumpWidget(
        host(
          StepperField(
            controller: controller,
            label: 'Repeticiones',
            hint: 'Ej. 10',
            keyboardType: TextInputType.number,
            decrementTooltip: 'Menos',
            incrementTooltip: 'Más',
            onDecrement: () => down++,
            onIncrement: () => up++,
          ),
        ),
      );

      expect(find.text('Repeticiones'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.remove));
      await tester.tap(find.byIcon(Icons.add));

      expect(down, 1);
      expect(up, 1);
    });

    testWidgets('RestTimerCard formatea el tiempo y permite omitir', (
      tester,
    ) async {
      var skipped = 0;

      await tester.pumpWidget(
        host(
          RestTimerCard(
            remainingSeconds: 75,
            totalSeconds: 90,
            onSkip: () => skipped++,
          ),
        ),
      );

      expect(find.text('01:15'), findsOneWidget);
      expect(find.text('Descanso'), findsOneWidget);

      await tester.tap(find.text('Omitir'));
      expect(skipped, 1);
    });

    testWidgets('SetRow muestra número y resumen', (tester) async {
      await tester.pumpWidget(
        host(const SetRow(index: 2, summary: '82.5 kg × 8')),
      );

      expect(find.text('2'), findsOneWidget);
      expect(find.text('82.5 kg × 8'), findsOneWidget);
    });

    testWidgets('ExerciseProgressBar dibuja un tramo por ejercicio', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const ExerciseProgressBar(total: 5, currentIndex: 2)),
      );

      expect(
        find.descendant(
          of: find.byType(ExerciseProgressBar),
          matching: find.byType(AnimatedContainer),
        ),
        findsNWidgets(5),
      );
    });
  });
}
