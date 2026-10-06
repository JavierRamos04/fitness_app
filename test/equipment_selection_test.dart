import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/core/database/app_database.dart';
import 'package:fitness_app/core/database/app_initialization_service.dart';
import 'package:fitness_app/core/database/equipment_repository.dart';
import 'package:fitness_app/core/database/equipment_seed.dart';
import 'package:fitness_app/core/widgets/equipment_selector.dart';

void main() {
  group('EquipmentSelector', () {
    const options = [
      EquipmentData(
        id: 1,
        code: 'dumbbells',
        name: 'Mancuernas',
        isActive: true,
      ),
      EquipmentData(
        id: 2,
        code: 'resistance_band',
        name: 'Banda elástica',
        isActive: true,
      ),
    ];

    Widget buildSelector({
      required Set<String> selected,
      required ValueChanged<Set<String>> onChanged,
      bool enabled = true,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: EquipmentSelector(
            options: options,
            selectedCodes: selected,
            onChanged: onChanged,
            enabled: enabled,
          ),
        ),
      );
    }

    testWidgets('muestra una opción por cada equipo', (tester) async {
      await tester.pumpWidget(
        buildSelector(selected: {}, onChanged: (_) {}),
      );

      expect(find.text('Mancuernas'), findsOneWidget);
      expect(find.text('Banda elástica'), findsOneWidget);
    });

    testWidgets('tocar una opción la agrega a lo seleccionado', (tester) async {
      Set<String>? result;

      await tester.pumpWidget(
        buildSelector(
          selected: {'resistance_band'},
          onChanged: (codes) => result = codes,
        ),
      );

      await tester.tap(find.text('Mancuernas'));
      await tester.pump();

      expect(result, {'resistance_band', 'dumbbells'});
    });

    testWidgets('tocar una opción ya marcada la quita', (tester) async {
      Set<String>? result;

      await tester.pumpWidget(
        buildSelector(
          selected: {'dumbbells', 'resistance_band'},
          onChanged: (codes) => result = codes,
        ),
      );

      await tester.tap(find.text('Mancuernas'));
      await tester.pump();

      expect(result, {'resistance_band'});
    });

    testWidgets('deshabilitado no cambia la selección', (tester) async {
      Set<String>? result;

      await tester.pumpWidget(
        buildSelector(
          selected: {},
          enabled: false,
          onChanged: (codes) => result = codes,
        ),
      );

      await tester.tap(find.text('Mancuernas'));
      await tester.pump();

      expect(result, isNull);
    });
  });

  group('Equipo de casa', () {
    test('los códigos de casa existen en el equipamiento inicial', () {
      final codes =
          initialEquipment.map((equipment) => equipment.code.value).toSet();

      for (final code in homeEquipmentCodes) {
        expect(codes.contains(code), isTrue, reason: 'No existe "$code"');
      }
    });

    test('getHomeOptions devuelve solo el equipo de casa y en orden', () async {
      final database = AppDatabase(
        DatabaseConnection(
          NativeDatabase.memory(),
          closeStreamsSynchronously: true,
        ),
      );

      await AppInitializationService(database).initialize();

      final options = await EquipmentRepository(database).getHomeOptions();

      expect(options.map((item) => item.code).toList(), homeEquipmentCodes);

      await database.close();
    });
  });
}
