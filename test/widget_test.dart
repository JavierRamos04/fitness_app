import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fitness_app/app/app.dart';

void main() {
  testWidgets('La aplicación muestra la navegación principal', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const FitnessApp());

    expect(find.byType(NavigationBar), findsOneWidget);

    expect(find.text('Inicio'), findsNWidgets(2));
    expect(find.text('Rutinas'), findsOneWidget);
    expect(find.text('Entrenar'), findsOneWidget);
    expect(find.text('Progreso'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);

    expect(
      find.text('Entrenamiento del día'),
      findsOneWidget,
    );
  });
}