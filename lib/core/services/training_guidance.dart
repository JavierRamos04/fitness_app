// Guía de entrenamiento: consejos antes de empezar y resumen al terminar.
//
// Lógica pura (sin Flutter ni base de datos) para poder probarla fácilmente.

import '../utils/number_format.dart';

/// Una serie registrada durante la sesión (solo en memoria).
class LoggedSet {
  const LoggedSet({
    required this.exerciseName,
    required this.repetitions,
    this.weightKg,
    this.isTimed = false,
  });

  final String exerciseName;

  /// Repeticiones o, si [isTimed], segundos mantenidos.
  final int repetitions;

  /// `true` en ejercicios isométricos (plancha), medidos en segundos.
  final bool isTimed;

  /// `null` si se hizo con el peso corporal.
  final double? weightKg;
}

class SessionSummary {
  const SessionSummary({
    required this.exerciseCount,
    required this.setCount,
    required this.totalRepetitions,
    required this.volumeKg,
    required this.duration,
    this.totalSeconds = 0,
  });

  /// Ejercicios distintos en los que se registró al menos una serie.
  final int exerciseCount;
  final int setCount;
  final int totalRepetitions;

  /// Segundos en posición de los ejercicios isométricos.
  final int totalSeconds;

  /// Suma de peso × repeticiones de las series con peso.
  final double volumeKg;
  final Duration duration;

  /// Duración en minutos, redondeada hacia arriba (mínimo 1).
  int get minutes {
    final value = (duration.inSeconds / 60).ceil();

    return value < 1 ? 1 : value;
  }
}

class TrainingGuidance {
  const TrainingGuidance._();

  /// Consejos para leer antes de empezar, según el objetivo de la rutina
  /// (`strength`, `hypertrophy`, `fat_loss`, `general_fitness`) y el nivel
  /// (`beginner`, `intermediate`, `advanced`).
  static List<String> preWorkoutTips({
    required String goal,
    required String level,
  }) {
    final tips = <String>[
      'Calienta 3-5 minutos: movilidad de hombros, caderas y tobillos y '
          'unas repeticiones suaves del primer ejercicio.',
      'Termina cada serie dejando 1-3 repeticiones "en reserva": que '
          'sientas que podrías hacer 1-3 más con buena técnica.',
    ];

    switch (goal) {
      case 'strength':
        tips.add(
          'Para ganar fuerza, descansa lo que indica la rutina (a veces '
          'más de 2 minutos) y mueve el peso con control.',
        );
        break;
      case 'hypertrophy':
        tips.add(
          'Para ganar músculo, baja despacio (2-3 segundos) y siente el '
          'músculo trabajar. Sube peso o repeticiones poco a poco.',
        );
        break;
      case 'fat_loss':
        tips.add(
          'Para perder grasa, mantén un ritmo constante y respeta los '
          'descansos cortos; la constancia pesa más que la intensidad.',
        );
        break;
      default:
        tips.add(
          'Busca terminar la sesión con energía: la regularidad vale más '
          'que una sola sesión muy dura.',
        );
    }

    if (level == 'beginner') {
      tips.add(
        'Si es tu primera vez, prioriza la técnica sobre el peso o la '
        'velocidad. Toca "Ver técnica" en cada ejercicio.',
      );
    } else {
      tips.add(
        'Cuando llegues al máximo de repeticiones en todas las series, '
        'sube la carga o la dificultad en la siguiente sesión.',
      );
    }

    tips.add(
      'Si sientes dolor agudo (no la molestia normal del esfuerzo), '
      'detente y cambia el ejercicio.',
    );

    return tips;
  }

  /// Resume las series registradas en la sesión.
  static SessionSummary summarize({
    required List<LoggedSet> sets,
    required Duration duration,
  }) {
    var totalReps = 0;
    var totalSeconds = 0;
    var volume = 0.0;

    for (final set in sets) {
      if (set.isTimed) {
        totalSeconds += set.repetitions;
        continue;
      }

      totalReps += set.repetitions;

      final weight = set.weightKg;

      if (weight != null && weight > 0) {
        volume += weight * set.repetitions;
      }
    }

    return SessionSummary(
      exerciseCount: sets.map((set) => set.exerciseName).toSet().length,
      setCount: sets.length,
      totalRepetitions: totalReps,
      totalSeconds: totalSeconds,
      volumeKg: volume,
      duration: duration,
    );
  }

  /// Líneas del resumen para mostrar al terminar.
  static List<String> summaryLines(SessionSummary summary) {
    return [
      'Duración: ${summary.minutes} min',
      'Ejercicios: ${summary.exerciseCount}',
      'Series: ${summary.setCount}',
      if (summary.totalRepetitions > 0 || summary.totalSeconds == 0)
        'Repeticiones: ${summary.totalRepetitions}',
      if (summary.totalSeconds > 0)
        'Tiempo en posición: ${summary.totalSeconds} s',
      if (summary.volumeKg > 0)
        'Volumen levantado: ${formatNumber(summary.volumeKg)} kg',
    ];
  }

  /// Mensaje de cierre según lo que se hizo respecto a lo planeado.
  static String closingMessage({
    required int plannedExercises,
    required int doneExercises,
  }) {
    if (plannedExercises > 0 && doneExercises >= plannedExercises) {
      return 'Completaste toda la rutina. Descansa, come bien y duerme: '
          'ahí es donde el cuerpo mejora.';
    }

    return 'Hiciste $doneExercises de $plannedExercises ejercicios. '
        'Entrenar aunque sea una parte cuenta: la próxima intenta '
        'completarla.';
  }
}
