import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Un destino de la barra inferior.
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Barra inferior flotante en forma de píldora.
///
/// El destino seleccionado se marca con una cápsula de color y la etiqueta en
/// tono de acento. El destino con [featuredIndex] (Entrenar) es un botón
/// cuadrado más grande: en lima sólido cuando está seleccionado y en tono suave
/// cuando no, así siempre se ve como la acción principal de la app.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    this.featuredIndex,
  });

  final List<AppNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final int? featuredIndex;

  static const double _barHeight = 72;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Con el texto muy grande las etiquetas desbordarían la barra.
    final textScaler = MediaQuery.textScalerOf(
      context,
    ).clamp(maxScaleFactor: 1.15);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
          child: Container(
            height: _barHeight,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.8),
              ),
            ),
            child: Row(
              children: [
                for (var index = 0; index < destinations.length; index++)
                  Expanded(
                    child: _NavItem(
                      destination: destinations[index],
                      selected: index == currentIndex,
                      featured: index == featuredIndex,
                      onTap: () => onSelected(index),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.destination,
    required this.selected,
    required this.featured,
    required this.onTap,
  });

  final AppNavDestination destination;
  final bool selected;
  final bool featured;
  final VoidCallback onTap;

  static const Duration _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final labelColor = selected ? scheme.primary : scheme.onSurfaceVariant;

    final Color indicatorColor;
    final Color iconColor;
    final double indicatorWidth;
    final double indicatorHeight;
    final double radius;

    if (featured) {
      indicatorColor = selected ? AppTheme.lime : scheme.primaryContainer;
      iconColor = selected ? AppTheme.onLime : scheme.primary;
      indicatorWidth = 52;
      indicatorHeight = 38;
      radius = 14;
    } else {
      indicatorColor = selected ? scheme.primaryContainer : Colors.transparent;
      iconColor = selected ? scheme.primary : scheme.onSurfaceVariant;
      indicatorWidth = 58;
      indicatorHeight = 32;
      radius = 16;
    }

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 36,
        highlightShape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: _duration,
              curve: Curves.easeOutCubic,
              width: indicatorWidth,
              height: indicatorHeight,
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(radius),
              ),
              child: Icon(
                selected ? destination.selectedIcon : destination.icon,
                size: featured ? 26 : 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                destination.label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.1,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
