import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'active_tab_provider.dart';

/// Envuelve el contenido de la navegación principal y publica en
/// [activeTabProvider] el índice de la pestaña visible.
///
/// Se basa en `navigationShell.currentIndex` y no en el callback de la barra
/// inferior, porque algunas pantallas cambian de pestaña con
/// `context.go('/training')` o `context.go('/workouts')`, y esos cambios no
/// pasan por `onDestinationSelected`.
class ActiveTabReporter extends ConsumerStatefulWidget {
  const ActiveTabReporter({
    super.key,
    required this.navigationShell,
    required this.child,
  });

  final StatefulNavigationShell navigationShell;
  final Widget child;

  @override
  ConsumerState<ActiveTabReporter> createState() =>
      _ActiveTabReporterState();
}

class _ActiveTabReporterState extends ConsumerState<ActiveTabReporter> {
  int? _lastReportedIndex;

  @override
  Widget build(BuildContext context) {
    final index = widget.navigationShell.currentIndex;

    if (index != _lastReportedIndex) {
      _lastReportedIndex = index;

      // Se publica después del frame para no notificar a las pantallas
      // mientras el árbol de widgets todavía se está construyendo.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        ref.read(activeTabProvider).value = index;
      });
    }

    return widget.child;
  }
}
