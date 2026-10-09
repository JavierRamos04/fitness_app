// Sugerencia de carga para la próxima sesión según lo hecho la última vez.
//
// Lógica pura (sin base de datos ni Flutter) para poder probarla fácilmente.
// Regla de doble progresión: se mantiene el peso y se suben repeticiones
// hasta el máximo del rango; cuando todas las series de trabajo llegan al
// máximo, se sube el peso y se vuelve al mínimo del rango.

class PerformedSet {
  const PerformedSet({required this.weightKg, required this.repetitions});

  final double? weightKg;
  final int repetitions;
}

class ProgressionSuggestion {
  const ProgressionSuggestion({
    required this.weightKg,
    required this.repetitions,
    required this.message,
    required this.increasesLoad,
  });

  /// Peso sugerido; `null` si el ejercicio se hace sin peso.
  final double? weightKg;
  final int repetitions;
  final String message;

  /// `true` si se recomienda subir el peso respecto a la última vez.
  final bool increasesLoad;
}

class ProgressionAdvisor {
  const ProgressionAdvisor._();

  /// Incremento de peso recomendado al llegar al máximo del rango.
  static const double weightStepKg = 2.5;

  static ProgressionSuggestion? suggest({
    required List<PerformedSet> lastSets,
    required int minReps,
    required int maxReps,
  }) {
    final sets = lastSets.where((set) => set.repetitions > 0).toList();

    if (sets.isEmpty) {
      return null;
    }

    final weights = sets
        .map((set) => set.weightKg)
        .whereType<double>()
        .where((weight) => weight > 0)
        .toList();

    // Ejercicio sin peso (peso corporal).
    if (weights.isEmpty) {
      final best = sets
          .map((set) => set.repetitions)
          .reduce((a, b) => a > b ? a : b);

      if (best >= maxReps) {
        return ProgressionSuggestion(
          weightKg: null,
          repetitions: best + 1,
          message: 'Llegaste a $best repeticiones sin peso. '
              'Intenta ${best + 1} o añade peso si puedes.',
          increasesLoad: false,
        );
      }

      return ProgressionSuggestion(
        weightKg: null,
        repetitions: best + 1,
        message: 'Intenta ${best + 1} repeticiones en cada serie.',
        increasesLoad: false,
      );
    }

    final topWeight = weights.reduce((a, b) => a > b ? a : b);

    final workingSets = sets
        .where((set) => (set.weightKg ?? 0) == topWeight)
        .toList();

    final lowestReps = workingSets
        .map((set) => set.repetitions)
        .reduce((a, b) => a < b ? a : b);

    if (lowestReps >= maxReps) {
      final next = topWeight + weightStepKg;

      return ProgressionSuggestion(
        weightKg: next,
        repetitions: minReps,
        message: 'Completaste $maxReps repeticiones en todas las series. '
            'Sube a ${_format(next)} kg y busca $minReps repeticiones.',
        increasesLoad: true,
      );
    }

    if (lowestReps < minReps) {
      return ProgressionSuggestion(
        weightKg: topWeight,
        repetitions: minReps,
        message: 'Mantén ${_format(topWeight)} kg y busca llegar a '
            '$minReps repeticiones en todas las series.',
        increasesLoad: false,
      );
    }

    final target = lowestReps + 1 > maxReps ? maxReps : lowestReps + 1;

    return ProgressionSuggestion(
      weightKg: topWeight,
      repetitions: target,
      message: 'Mantén ${_format(topWeight)} kg e intenta $target '
          'repeticiones. Al llegar a $maxReps en todas las series, '
          'sube el peso.',
      increasesLoad: false,
    );
  }

  static String _format(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toString();
  }
}
