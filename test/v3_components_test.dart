import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/widgets/app_components.dart';

void main() {
  for (final entry in {
    'oscuro': AppTheme.darkTheme(),
    'claro': AppTheme.lightTheme(),
  }.entries) {
    testWidgets('AppPill usa lima con texto oscuro (${entry.key})', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: entry.value,
          home: const Scaffold(body: Center(child: AppPill(label: 'ACTIVA'))),
        ),
      );

      expect(find.text('ACTIVA'), findsOneWidget);

      final box = tester.widget<Container>(
        find.descendant(
          of: find.byType(AppPill),
          matching: find.byType(Container),
        ),
      );
      final decoration = box.decoration as BoxDecoration;

      expect(decoration.color, AppTheme.lime);

      final text = tester.widget<Text>(find.text('ACTIVA'));

      expect(text.style?.color, AppTheme.onLime);
    });
  }
}
