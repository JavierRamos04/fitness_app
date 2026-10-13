import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/core/widgets/app_bottom_nav.dart';

/// Relación de contraste WCAG entre dos colores.
double contrast(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  final lighter = first > second ? first : second;
  final darker = first > second ? second : first;

  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  final themes = {
    'claro': AppTheme.lightTheme(),
    'oscuro': AppTheme.darkTheme(),
  };

  group('AppTheme', () {
    test('usa Material 3 y las fuentes de la app', () {
      for (final entry in themes.entries) {
        final theme = entry.value;

        expect(theme.useMaterial3, isTrue, reason: entry.key);
        expect(
          theme.textTheme.bodyMedium?.fontFamily,
          AppTheme.bodyFont,
          reason: entry.key,
        );
        expect(
          theme.textTheme.headlineMedium?.fontFamily,
          AppTheme.displayFont,
          reason: entry.key,
        );
        expect(
          theme.textTheme.titleLarge?.fontFamily,
          AppTheme.displayFont,
          reason: entry.key,
        );
      }
    });

    test('el tema oscuro no usa negro absoluto y el claro es más luminoso', () {
      final dark = AppTheme.darkTheme().colorScheme;
      final light = AppTheme.lightTheme().colorScheme;

      expect(dark.surface, isNot(const Color(0xFF000000)));
      expect(light.surface.computeLuminance(),
          greaterThan(dark.surface.computeLuminance()));
    });

    test('las tarjetas se distinguen del fondo', () {
      for (final entry in themes.entries) {
        final theme = entry.value;

        expect(
          theme.cardTheme.color,
          isNot(theme.colorScheme.surface),
          reason: entry.key,
        );
      }
    });

    test('los botones principales son lima con texto oscuro', () {
      for (final entry in themes.entries) {
        final style = entry.value.filledButtonTheme.style!;

        expect(style.backgroundColor!.resolve({}), AppTheme.lime,
            reason: entry.key);
        expect(style.foregroundColor!.resolve({}), AppTheme.onLime,
            reason: entry.key);
      }

      expect(contrast(AppTheme.onLime, AppTheme.lime), greaterThan(7));
    });

    test('el contraste del texto cumple 4.5:1 en ambos temas', () {
      for (final entry in themes.entries) {
        final theme = entry.value;
        final scheme = theme.colorScheme;
        final card = theme.cardTheme.color!;

        final pairs = <String, List<Color>>{
          'texto sobre fondo': [scheme.onSurface, scheme.surface],
          'texto sobre tarjeta': [scheme.onSurface, card],
          'texto secundario sobre fondo': [
            scheme.onSurfaceVariant,
            scheme.surface,
          ],
          'texto secundario sobre tarjeta': [scheme.onSurfaceVariant, card],
          'texto terciario sobre fondo': [scheme.outline, scheme.surface],
          'texto terciario sobre tarjeta': [scheme.outline, card],
          'texto secundario sobre campos': [
            scheme.onSurfaceVariant,
            scheme.surfaceContainerHigh,
          ],
          'texto terciario sobre campos': [
            scheme.outline,
            scheme.surfaceContainerHigh,
          ],
          'acento sobre fondo': [scheme.primary, scheme.surface],
          'acento sobre tarjeta': [scheme.primary, card],
          'texto sobre botón de acento': [scheme.onPrimary, scheme.primary],
          'texto sobre contenedor de acento': [
            scheme.onPrimaryContainer,
            scheme.primaryContainer,
          ],
          'acento sobre contenedor de acento': [
            scheme.primary,
            scheme.primaryContainer,
          ],
          'error sobre tarjeta': [scheme.error, card],
          'error sobre fondo': [scheme.error, scheme.surface],
          'advertencia sobre tarjeta': [scheme.tertiary, card],
        };

        for (final pair in pairs.entries) {
          expect(
            contrast(pair.value[0], pair.value[1]),
            greaterThanOrEqualTo(4.5),
            reason: '${entry.key}: ${pair.key}',
          );
        }
      }
    });
  });

  group('AppBottomNav', () {
    const destinations = [
      AppNavDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home_rounded,
        label: 'Inicio',
      ),
      AppNavDestination(
        icon: Icons.fitness_center_outlined,
        selectedIcon: Icons.fitness_center,
        label: 'Rutinas',
      ),
      AppNavDestination(
        icon: Icons.play_arrow_rounded,
        selectedIcon: Icons.play_arrow_rounded,
        label: 'Entrenar',
      ),
      AppNavDestination(
        icon: Icons.insights_outlined,
        selectedIcon: Icons.insights,
        label: 'Progreso',
      ),
      AppNavDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Perfil',
      ),
    ];

    Widget app({
      required ValueChanged<int> onSelected,
      int currentIndex = 0,
      ThemeData? theme,
      double textScale = 1,
    }) {
      return MaterialApp(
        theme: theme ?? AppTheme.darkTheme(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          );
        },
        home: Scaffold(
          bottomNavigationBar: AppBottomNav(
            destinations: destinations,
            currentIndex: currentIndex,
            onSelected: onSelected,
            featuredIndex: 2,
          ),
        ),
      );
    }

    testWidgets('muestra las cinco etiquetas', (tester) async {
      await tester.pumpWidget(app(onSelected: (_) {}));

      for (final destination in destinations) {
        expect(find.text(destination.label), findsOneWidget);
      }
    });

    testWidgets('avisa qué destino se tocó', (tester) async {
      final taps = <int>[];

      await tester.pumpWidget(app(onSelected: taps.add));

      await tester.tap(find.text('Rutinas'));
      await tester.tap(find.text('Entrenar'));
      await tester.tap(find.text('Perfil'));

      expect(taps, [1, 2, 4]);
    });

    testWidgets('funciona en tema claro', (tester) async {
      await tester.pumpWidget(
        app(onSelected: (_) {}, currentIndex: 2, theme: AppTheme.lightTheme()),
      );

      expect(find.text('Entrenar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('no desborda en pantalla angosta con texto grande', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320 * 3, 640 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        app(onSelected: (_) {}, currentIndex: 3, textScale: 2),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Progreso'), findsOneWidget);
    });
  });
}
