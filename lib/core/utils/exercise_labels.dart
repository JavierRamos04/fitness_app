// Textos en español para los códigos internos del catálogo de ejercicios.
//
// Si llega un código que no conoce, devuelve el mismo código para no
// ocultar el dato.

String difficultyLabel(String difficulty) {
  switch (difficulty) {
    case 'beginner':
      return 'Principiante';
    case 'intermediate':
      return 'Intermedio';
    case 'advanced':
      return 'Avanzado';
    default:
      return difficulty;
  }
}

String muscleLabel(String muscle) {
  switch (muscle) {
    case 'chest':
      return 'Pecho';
    case 'back':
      return 'Espalda';
    case 'latissimus':
      return 'Espalda (dorsales)';
    case 'upper_back':
      return 'Espalda alta';
    case 'lower_back':
      return 'Espalda baja';
    case 'quadriceps':
      return 'Cuádriceps';
    case 'hamstrings':
      return 'Isquiotibiales';
    case 'glutes':
      return 'Glúteos';
    case 'calves':
      return 'Pantorrillas';
    case 'shoulders':
      return 'Hombros';
    case 'rear_delts':
      return 'Deltoides posterior';
    case 'biceps':
      return 'Bíceps';
    case 'triceps':
      return 'Tríceps';
    case 'forearms':
      return 'Antebrazos';
    case 'core':
      return 'Core';
    case 'full_body':
      return 'Cuerpo completo';
    default:
      return muscle;
  }
}

String exerciseTypeLabel(String type) {
  switch (type) {
    case 'strength':
      return 'Fuerza';
    case 'bodyweight':
      return 'Peso corporal';
    case 'core':
      return 'Core';
    case 'cardio':
      return 'Cardio';
    case 'mobility':
      return 'Movilidad';
    case 'stretching':
      return 'Estiramiento';
    default:
      return type;
  }
}

String movementPatternLabel(String pattern) {
  switch (pattern) {
    case 'squat':
      return 'Sentadilla';
    case 'lunge':
      return 'Zancada';
    case 'hinge':
      return 'Bisagra de cadera';
    case 'hip_extension':
      return 'Extensión de cadera';
    case 'hip_abduction':
      return 'Abducción de cadera';
    case 'knee_extension':
      return 'Extensión de rodilla';
    case 'knee_flexion':
      return 'Flexión de rodilla';
    case 'calf_raise':
      return 'Elevación de talones';
    case 'horizontal_push':
      return 'Empuje horizontal';
    case 'vertical_push':
      return 'Empuje vertical';
    case 'horizontal_pull':
      return 'Tirón horizontal';
    case 'vertical_pull':
      return 'Tirón vertical';
    case 'elbow_flexion':
      return 'Flexión de codo';
    case 'elbow_extension':
      return 'Extensión de codo';
    case 'shoulder_abduction':
      return 'Abducción de hombro';
    case 'back_extension':
      return 'Extensión de espalda';
    case 'core_flexion':
      return 'Flexión de tronco';
    case 'core_anti_extension':
      return 'Anti-extensión del tronco';
    case 'core_anti_rotation':
      return 'Anti-rotación del tronco';
    case 'core_anti_lateral_flexion':
      return 'Anti-flexión lateral del tronco';
    case 'carry':
      return 'Acarreo';
    case 'locomotion':
      return 'Locomoción';
    default:
      return pattern;
  }
}

/// Minúsculas y sin acentos, para buscar sin que importen los acentos:
/// "Tríceps" y "triceps" se consideran iguales.
String normalizeForSearch(String text) {
  const accented = 'áàäâãéèëêíìïîóòöôõúùüûñ';
  const plain = 'aaaaaeeeeiiiiooooouuuun';

  var result = text.trim().toLowerCase();

  for (var i = 0; i < accented.length; i++) {
    result = result.replaceAll(accented[i], plain[i]);
  }

  return result;
}
