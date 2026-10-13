// Ejercicios que se miden en segundos (isométricos), como la plancha.
//
// La app guarda cada serie con "repeticiones"; en estos ejercicios ese número
// son los segundos mantenidos. Lógica pura para poder probarla fácilmente.

import 'progression_advisor.dart';

/// Ejercicios del catálogo que se miden en segundos.
const Set<String> timedExerciseNames = {
  'Plancha',
  'Plancha lateral',
};

bool isTimedExercise(String name) => timedExerciseNames.contains(name);

class TimedExercises {
  const TimedExercises._();

  /// Rango de segundos por serie que se prescribe.
  static const int minSeconds = 20;
  static const int maxSeconds = 40;

  /// Descanso entre series, en segundos.
  static const int restSeconds = 45;

  /// Segundos que se suben de una sesión a la siguiente.
  static const int stepSeconds = 5;

  /// Sugerencia para la próxima sesión a partir de los segundos de la última.
  /// Devuelve `null` si no hay series válidas.
  static ProgressionSuggestion? suggest({
    required List<int> lastSeconds,
    required int minSeconds,
    required int maxSeconds,
  }) {
    final valid = lastSeconds.where((value) => value > 0).toList();

    if (valid.isEmpty) {
      return null;
    }

    final best = valid.reduce((a, b) => a > b ? a : b);

    if (best >= maxSeconds) {
      return ProgressionSuggestion(
        weightKg: null,
        repetitions: best + stepSeconds,
        message: 'Aguantaste $best segundos. Intenta ${best + stepSeconds} '
            'o pasa a una versión más difícil (mira "Ver técnica").',
        increasesLoad: false,
      );
    }

    final target = best + stepSeconds > maxSeconds
        ? maxSeconds
        : best + stepSeconds;

    return ProgressionSuggestion(
      weightKg: null,
      repetitions: target,
      message: 'Intenta $target segundos en cada serie. Si pierdes la '
          'postura, detente.',
      increasesLoad: false,
    );
  }
}
