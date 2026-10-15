import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// "05:07" o, a partir de una hora, "1:05:07".
String formatElapsed(Duration duration) {
  final total = duration.inSeconds < 0 ? 0 : duration.inSeconds;
  final hours = total ~/ 3600;
  final minutes = (total % 3600) ~/ 60;
  final seconds = total % 60;

  final mm = minutes.toString().padLeft(2, '0');
  final ss = seconds.toString().padLeft(2, '0');

  return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
}

/// Cronómetro de la sesión. Tiene su propio temporizador: solo se redibuja
/// este widget cada segundo, no toda la pantalla.
class SessionClock extends StatefulWidget {
  const SessionClock({super.key, required this.startedAt});

  final DateTime startedAt;

  @override
  State<SessionClock> createState() => _SessionClockState();
}

class _SessionClockState extends State<SessionClock> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final elapsed = DateTime.now().difference(widget.startedAt);

    return Semantics(
      label: 'Tiempo de entrenamiento ${formatElapsed(elapsed)}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: scheme.primaryContainer,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer_outlined, size: 18, color: scheme.primary),
            const SizedBox(width: 6),
            Text(
              formatElapsed(elapsed),
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Barra segmentada: un tramo por ejercicio de la rutina.
class ExerciseProgressBar extends StatelessWidget {
  const ExerciseProgressBar({
    super.key,
    required this.total,
    required this.currentIndex,
  });

  final int total;

  /// Índice (desde 0) del ejercicio actual.
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      label: 'Ejercicio ${currentIndex + 1} de $total',
      excludeSemantics: true,
      child: Row(
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index > 0) const SizedBox(width: 4),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 6,
                decoration: BoxDecoration(
                  color: index < currentIndex
                      ? scheme.primary
                      : index == currentIndex
                      ? scheme.primary.withValues(alpha: 0.55)
                      : scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Valor numérico grande con botones [−] y [+] debajo. Se puede escribir en el
/// campo o ajustar con los botones, sin abrir el teclado.
class StepperField extends StatelessWidget {
  const StepperField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
    required this.decrementTooltip,
    required this.incrementTooltip,
    required this.onDecrement,
    required this.onIncrement,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String decrementTooltip;
  final String incrementTooltip;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.displayFont,
              fontSize: 46,
              fontWeight: FontWeight.w700,
              height: 1.15,
              color: scheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintMaxLines: 2,
              hintStyle: TextStyle(
                fontFamily: AppTheme.bodyFont,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: scheme.outline,
              ),
              filled: false,
              isDense: true,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 6),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _StepButton(
                  icon: Icons.remove,
                  tooltip: decrementTooltip,
                  background: scheme.surfaceContainerHighest,
                  foreground: scheme.onSurface,
                  onPressed: onDecrement,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StepButton(
                  icon: Icons.add,
                  tooltip: incrementTooltip,
                  background: scheme.primaryContainer,
                  foreground: scheme.primary,
                  onPressed: onIncrement,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onPressed,
          child: SizedBox(
            height: 50,
            child: Center(child: Icon(icon, size: 26, color: foreground)),
          ),
        ),
      ),
    );
  }
}

/// Cuenta atrás del descanso entre series, con un anillo de progreso.
class RestTimerCard extends StatelessWidget {
  const RestTimerCard({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.onSkip,
  });

  final int remainingSeconds;
  final int totalSeconds;
  final VoidCallback onSkip;

  String get _formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  double get _progress {
    if (totalSeconds <= 0) {
      return 0;
    }

    return (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      color: scheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        child: Row(
          children: [
            SizedBox(
              width: 76,
              height: 76,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 6,
                      color: scheme.primary,
                      backgroundColor: scheme.onPrimaryContainer.withValues(
                        alpha: 0.16,
                      ),
                    ),
                  ),
                  Text(
                    _formattedTime,
                    style: TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descanso',
                    style: TextStyle(
                      fontFamily: AppTheme.displayFont,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  Text(
                    'Respira y prepara la siguiente serie.',
                    style: TextStyle(
                      fontSize: 14,
                      color: scheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(onPressed: onSkip, child: const Text('Omitir')),
          ],
        ),
      ),
    );
  }
}

/// Fila de una serie ya registrada.
class SetRow extends StatelessWidget {
  const SetRow({super.key, required this.index, required this.summary});

  final int index;

  /// Texto de la serie, por ejemplo "82.5 kg × 8".
  final String summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: scheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              summary,
              style: const TextStyle(
                fontFamily: AppTheme.displayFont,
                fontSize: 26,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ),
          Icon(Icons.check_rounded, color: scheme.primary),
        ],
      ),
    );
  }
}
