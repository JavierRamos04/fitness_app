import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/widgets/app_components.dart';

Widget host(ThemeData theme, Widget child) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  );
}

void main() {
  for (final entry in {
    'oscuro': AppTheme.darkTheme(),
    'claro': AppTheme.lightTheme(),
  }.entries) {
    group('AppOptionTile (${entry.key})', () {
      testWidgets('muestra título, descripción y estado sin seleccionar', (
        tester,
      ) async {
        await tester.pumpWidget(
          host(
            entry.value,
            AppOptionTile(
              icon: Icons.home_outlined,
              title: 'Casa',
              subtitle: 'Con tu equipo o con tu peso corporal.',
              selected: false,
              onTap: () {},
            ),
          ),
        );

        expect(find.text('Casa'), findsOneWidget);
        expect(
          find.text('Con tu equipo o con tu peso corporal.'),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsNothing);
      });

      testWidgets('marca la opción seleccionada', (tester) async {
        await tester.pumpWidget(
          host(
            entry.value,
            AppOptionTile(title: 'Gimnasio', selected: true, onTap: () {}),
          ),
        );

        expect(find.byIcon(Icons.check_circle), findsOneWidget);
        expect(find.byIcon(Icons.radio_button_unchecked), findsNothing);
      });

      testWidgets('llama a onTap al pulsarla', (tester) async {
        var taps = 0;

        await tester.pumpWidget(
          host(
            entry.value,
            AppOptionTile(
              title: 'Casa y gimnasio',
              selected: false,
              onTap: () => taps++,
            ),
          ),
        );

        await tester.tap(find.text('Casa y gimnasio'));

        expect(taps, 1);
      });
    });
  }
}
