// Reglas y textos de la captura de series durante el entrenamiento.
//
// Lógica pura (sin Flutter) para poder probarla fácilmente.

import '../utils/decimal_parser.dart';

class SetInputRules {
  const SetInputRules._();

  /// Máximo de repeticiones aceptado en una serie.
  static const int maxRepetitions = 300;

  /// Máximo de segundos aceptado en una serie de un ejercicio isométrico.
  static const int maxSeconds = 300;

  /// Máximo de peso aceptado en una serie, en kg.
  static const double maxWeightKg = 600;

  /// Valida lo escrito por el usuario. Devuelve el mensaje de error, o `null`
  /// si los datos son válidos. El peso es opcional (peso corporal).
  ///
  /// Con [timed] el número son segundos (plancha) y no se usa peso.
  static String? validate({
    required String repetitionsText,
    required String weightText,
    bool timed = false,
  }) {
    final repsText = repetitionsText.trim();

    if (repsText.isEmpty) {
      return timed
          ? 'Introduce los segundos.'
          : 'Introduce las repeticiones.';
    }

    final repetitions = int.tryParse(repsText);

    if (repetitions == null || repetitions <= 0) {
      return timed
          ? 'Los segundos deben ser un número válido.'
          : 'Las repeticiones deben ser un número válido.';
    }

    if (timed) {
      if (repetitions > maxSeconds) {
        return 'Los segundos no pueden pasar de $maxSeconds. '
            'Revisa el número que escribiste.';
      }

      return null;
    }

    if (repetitions > maxRepetitions) {
      return 'Las repeticiones no pueden pasar de $maxRepetitions. '
          'Revisa el número que escribiste.';
    }

    final weightRaw = weightText.trim();

    if (weightRaw.isEmpty) {
      return null;
    }

    final weight = parseDecimal(weightRaw);

    if (weight == null || weight < 0) {
      return 'El peso debe ser un número válido.';
    }

    if (weight > maxWeightKg) {
      return 'El peso no puede pasar de ${maxWeightKg.toStringAsFixed(0)} kg. '
          'Revisa el número que escribiste.';
    }

    return null;
  }

  /// Título del bloque de captura: "Registrar serie 2 de 3". Si ya se hicieron
  /// todas las series planeadas, "Registrar serie extra".
  static String registerTitle({
    required int nextSetIndex,
    required int plannedSets,
  }) {
    if (plannedSets <= 0 || nextSetIndex > plannedSets) {
      return 'Registrar serie extra';
    }

    return 'Registrar serie $nextSetIndex de $plannedSets';
  }

  /// Mensaje para la primera vez que se hace un ejercicio.
  static String firstTimeMessage({
    required bool noEquipment,
    required int minReps,
    required int maxReps,
    bool timed = false,
  }) {
    final range = minReps == maxReps ? '$minReps' : '$minReps-$maxReps';

    if (timed) {
      return 'Primera vez con este ejercicio. Mantén la posición con buena '
          'técnica entre $range segundos y anota los segundos que '
          'aguantaste. Si pierdes la postura, detente: es mejor una serie '
          'corta bien hecha.';
    }

    if (noEquipment) {
      return 'Primera vez con este ejercicio. Haz $range repeticiones con '
          'buena técnica y termina cada serie sintiendo que podrías hacer '
          '1-3 más. Si te resulta muy fácil, añade peso (por ejemplo una '
          'mochila); si no llegas, haz las que puedas.';
    }

    return 'Primera vez con este ejercicio. Elige un peso con el que logres '
        '$range repeticiones dejando 1-3 en reserva (que podrías hacer 1-3 '
        'más). Es mejor empezar ligero y subir en la siguiente serie.';
  }

  /// Etiqueta del campo de repeticiones (o de segundos).
  static String repetitionsLabel({required bool timed}) {
    return timed ? 'Segundos' : 'Repeticiones';
  }

  /// Ayuda del campo de repeticiones (o de segundos).
  static String repetitionsHint({required bool timed}) {
    return timed ? 'Ej. 30' : 'Ej. 10';
  }

  /// Texto de una serie ya registrada.
  static String setText({
    required int repetitions,
    required double? weightKg,
    required bool timed,
  }) {
    if (timed) {
      return '$repetitions segundos';
    }

    return weightKg == null
        ? '$repetitions repeticiones'
        : '$weightKg kg · $repetitions repeticiones';
  }

  /// Etiqueta del campo de peso.
  static String weightLabel({required bool noEquipment}) {
    return noEquipment ? 'Peso extra (kg, opcional)' : 'Peso (kg)';
  }

  /// Ayuda del campo de peso.
  static String weightHint({required bool noEquipment}) {
    return noEquipment ? 'Vacío = tu peso corporal' : 'Ej. 80';
  }
}
