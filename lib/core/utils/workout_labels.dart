// Textos cortos para describir ejercicios planeados dentro de una rutina.

/// "3×8-12" o, si el rango es de un solo valor, "3×10". Con [timed] el rango
/// son segundos: "3×20-40 s".
String formatSetsReps({
  required int sets,
  required int minReps,
  required int maxReps,
  bool timed = false,
}) {
  final reps = minReps == maxReps ? '$minReps' : '$minReps-$maxReps';

  return timed ? '$sets×$reps s' : '$sets×$reps';
}

/// Etiqueta de la tarjeta "Hoy toca": "HOY TOCA · DÍA 2 DE 4".
/// Sin plan (rutina suelta), "RUTINA ACTIVA".
String todayLabel({int? planPosition, int? planSize}) {
  if (planPosition == null) {
    return 'RUTINA ACTIVA';
  }

  if (planSize == null || planSize < planPosition) {
    return 'HOY TOCA · DÍA $planPosition';
  }

  return 'HOY TOCA · DÍA $planPosition DE $planSize';
}
