import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/database_provider.dart';

void main() {
  testWidgets('La aplicación muestra el onboarding en un inicio sin usuario', (
    WidgetTester tester,
  ) async {
    final database = AppDatabase(
      DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(database)],
        child: const FitnessApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Configura tu perfil'), findsOneWidget);

    expect(find.text('Cuéntanos un poco sobre ti'), findsOneWidget);

    expect(find.text('Continuar'), findsOneWidget);

    await database.close();
  });
}
