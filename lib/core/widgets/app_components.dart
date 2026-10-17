import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

// Componentes compartidos de la nueva identidad visual. Las pantallas deben
// usarlos (y el tema) en lugar de repetir estilos sueltos.

/// Título de una sección de pantalla, con una acción opcional a la derecha.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Etiqueta corta en lima sólido ("HOY TOCA", "ACTIVA") para destacar un estado.
class AppPill extends StatelessWidget {
  const AppPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.lime,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: AppTheme.onLime,
        ),
      ),
    );
  }
}

/// Opción seleccionable de ancho completo, con icono, descripción opcional y
/// marca de selección. Sustituye a los chips cuando hay que elegir una sola
/// opción importante (nivel, lugar de entrenamiento...).
class AppOptionTile extends StatelessWidget {
  const AppOptionTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: subtitle == null ? title : '$title. $subtitle',
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        color: selected
            ? scheme.primaryContainer
            : Theme.of(context).cardTheme.color ?? scheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected ? AppTheme.lime : scheme.outlineVariant,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppTheme.lime
                          : scheme.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 24,
                      color: selected ? AppTheme.onLime : scheme.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.3,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  selected ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: selected ? scheme.primary : scheme.outline,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Icono dentro de un círculo suave, para encabezar tarjetas.
class AppIconBadge extends StatelessWidget {
  const AppIconBadge({super.key, required this.icon, this.size = 44});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size * 0.5, color: scheme.primary),
    );
  }
}

/// Dato corto con icono (por ejemplo "3 series" o "60 s"), en forma de píldora.
class AppMetaChip extends StatelessWidget {
  const AppMetaChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta con una cifra grande, su unidad opcional y una etiqueta.
class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.unit,
  });

  final IconData icon;
  final String value;
  final String label;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppIconBadge(icon: icon, size: 40),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    unit!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Una fila de la vista previa de la tarjeta protagonista.
class AppHeroLine {
  const AppHeroLine({required this.name, required this.detail});

  final String name;
  final String detail;
}

/// Tarjeta protagonista: lima sólido con texto oscuro. Se usa una sola vez por
/// pantalla, para la acción principal (empezar a entrenar).
class AppHeroCard extends StatelessWidget {
  const AppHeroCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.chips = const [],
    this.lines = const [],
    this.moreLabel,
    this.actionIcon = Icons.play_arrow_rounded,
  });

  /// Etiqueta pequeña sobre el título ("Hoy toca · Día 2 de 4").
  final String eyebrow;
  final String title;
  final String actionLabel;
  final VoidCallback? onAction;
  final IconData actionIcon;

  /// Datos cortos bajo el título: (icono, texto).
  final List<(IconData, String)> chips;

  /// Vista previa de los ejercicios.
  final List<AppHeroLine> lines;

  /// Texto cuando hay más ejercicios que los mostrados ("+2 más").
  final String? moreLabel;

  @override
  Widget build(BuildContext context) {
    const ink = AppTheme.onLime;
    final softInk = ink.withValues(alpha: 0.72);
    final hairline = ink.withValues(alpha: 0.14);

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppTheme.lime),
        child: Stack(
          children: [
            Positioned(
              right: -28,
              top: -18,
              child: Transform.rotate(
                angle: -0.5,
                child: Icon(
                  Icons.fitness_center,
                  size: 170,
                  color: ink.withValues(alpha: 0.07),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: softInk,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: ink,
                    ),
                  ),
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final chip in chips)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: ink.withValues(alpha: 0.11),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(chip.$1, size: 16, color: ink),
                                const SizedBox(width: 6),
                                Text(
                                  chip.$2,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (lines.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    for (var index = 0; index < lines.length; index++) ...[
                      if (index > 0) Container(height: 1, color: hairline),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                lines[index].name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              lines[index].detail,
                              style: TextStyle(
                                fontFamily: AppTheme.displayFont,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: softInk,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (moreLabel != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          moreLabel!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: softInk,
                          ),
                        ),
                      ),
                  ],
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onAction,
                      style: FilledButton.styleFrom(
                        backgroundColor: ink,
                        foregroundColor: AppTheme.lime,
                        minimumSize: const Size.fromHeight(56),
                      ),
                      icon: Icon(actionIcon, size: 26),
                      label: Text(actionLabel),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Estado vacío: icono, explicación breve y acciones.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actions = const [],
  });

  final IconData icon;
  final String title;
  final String message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconBadge(icon: icon, size: 84),
        const SizedBox(height: 20),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            height: 1.35,
            color: scheme.onSurfaceVariant,
          ),
        ),
        if (actions.isNotEmpty) ...[
          const SizedBox(height: 24),
          for (var index = 0; index < actions.length; index++) ...[
            if (index > 0) const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: actions[index]),
          ],
        ],
      ],
    );
  }
}
