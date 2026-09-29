import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Índices de las 5 pestañas principales, en el mismo orden que
/// las ramas definidas en `app_router.dart`.
class MainTab {
  const MainTab._();

  static const int home = 0;
  static const int workouts = 1;
  static const int training = 2;
  static const int progress = 3;
  static const int profile = 4;
}

/// Índice de la pestaña principal que está visible en este momento.
///
/// Las pantallas de las pestañas permanecen vivas mientras el usuario
/// cambia de pestaña (`StatefulShellRoute.indexedStack`), por lo que
/// `initState` solo se ejecuta la primera vez. Cada pantalla que muestra
/// datos modificables desde otra pestaña escucha este valor para volver a
/// cargar sus datos cuando su pestaña vuelve a ser visible.
///
/// Se expone como `ValueNotifier` y las pantallas lo leen con `ref.read`
/// (no con `ref.watch`) para no depender de que Riverpod pause los
/// listeners de los widgets que no están visibles.
final activeTabProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(MainTab.home);

  ref.onDispose(notifier.dispose);

  return notifier;
});
