import 'package:flutter/material.dart';

import '../data/exercise_guides.dart';

/// Abre una hoja con la guía de técnica del ejercicio [name].
///
/// Si el ejercicio no tiene guía, muestra [fallbackText] (por ejemplo, las
/// instrucciones guardadas en la base de datos) o un aviso.
Future<void> showExerciseGuideSheet(
  BuildContext context, {
  required String name,
  String? fallbackText,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Técnica',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ExerciseGuideView(name: name, fallbackText: fallbackText),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}

/// Secciones de la guía de técnica de un ejercicio.
class ExerciseGuideView extends StatelessWidget {
  const ExerciseGuideView({super.key, required this.name, this.fallbackText});

  final String name;
  final String? fallbackText;

  @override
  Widget build(BuildContext context) {
    final guide = guideForExercise(name);
    final colors = Theme.of(context).colorScheme;

    if (guide == null) {
      final fallback = fallbackText?.trim() ?? '';

      return Text(
        fallback.isEmpty
            ? 'Todavía no hay una guía de técnica para este ejercicio.'
            : fallback,
        style: const TextStyle(fontSize: 15, height: 1.45),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle('Cómo hacerlo'),
        for (var index = 0; index < guide.steps.length; index++)
          _NumberedLine(number: index + 1, text: guide.steps[index]),
        const SizedBox(height: 20),
        const _SectionTitle('Puntos clave'),
        for (final cue in guide.cues)
          _IconLine(
            icon: Icons.check_circle_outline,
            color: colors.primary,
            text: cue,
          ),
        const SizedBox(height: 20),
        const _SectionTitle('Errores frecuentes'),
        for (final mistake in guide.mistakes)
          _IconLine(
            icon: Icons.error_outline,
            color: colors.error,
            text: mistake,
          ),
        const SizedBox(height: 20),
        const _SectionTitle('Respiración'),
        Text(
          guide.breathing ?? defaultBreathingTip,
          style: const TextStyle(fontSize: 15, height: 1.45),
        ),
        if (guide.safety != null) ...[
          const SizedBox(height: 20),
          Card(
            color: colors.errorContainer,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.health_and_safety_outlined,
                      color: colors.onErrorContainer),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      guide.safety!,
                      style: TextStyle(
                        color: colors.onErrorContainer,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (guide.easier != null || guide.harder != null) ...[
          const SizedBox(height: 20),
          const _SectionTitle('Ajusta la dificultad'),
          if (guide.easier != null)
            _LabeledLine(label: 'Más fácil', text: guide.easier!),
          if (guide.harder != null)
            _LabeledLine(label: 'Más difícil', text: guide.harder!),
        ],
        const SizedBox(height: 24),
        Text(
          guideDisclaimer,
          style: TextStyle(
            fontSize: 12.5,
            height: 1.4,
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NumberedLine extends StatelessWidget {
  const _NumberedLine({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            child: Text('$number', style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledLine extends StatelessWidget {
  const _LabeledLine({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(text: text),
          ],
        ),
        style: const TextStyle(fontSize: 15, height: 1.45),
      ),
    );
  }
}
