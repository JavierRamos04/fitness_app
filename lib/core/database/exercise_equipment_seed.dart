/// Equipo que necesita cada ejercicio, indexado por el nombre del ejercicio.
///
/// Reglas:
/// - Un ejercicio solo se puede hacer si el usuario tiene TODO el equipo de su
///   lista.
/// - Un ejercicio que no aparece aquí no necesita equipo (peso corporal).
/// - Si un ejercicio admite varias opciones, aquí va la menos exigente; las
///   variantes más exigentes son ejercicios distintos.
/// - Los códigos deben existir en `initialEquipment`.
const Map<String, List<String>> exerciseEquipmentRequirements = {
  // Mancuernas
  'Sentadilla goblet': ['dumbbells'],
  'Peso muerto rumano': ['dumbbells'],
  'Press militar con mancuernas': ['dumbbells'],
  'Elevaciones laterales': ['dumbbells'],
  'Curl de bíceps': ['dumbbells'],
  'Curl martillo': ['dumbbells'],
  'Remo con mancuerna': ['dumbbells'],
  'Extensión de tríceps por encima de la cabeza': ['dumbbells'],
  'Farmer walk': ['dumbbells'],
  'Press de suelo con mancuernas': ['dumbbells'],
  'Press inclinado con mancuernas': ['dumbbells', 'bench'],

  // Banda elástica
  'Pallof press': ['resistance_band'],
  'Remo con banda': ['resistance_band'],
  'Jalón con banda': ['resistance_band'],
  'Face pull con banda': ['resistance_band'],
  'Press de pecho con banda': ['resistance_band'],
  'Curl de bíceps con banda': ['resistance_band'],
  'Extensión de tríceps con banda': ['resistance_band'],
  'Caminata lateral con banda': ['resistance_band'],

  // Barra de dominadas
  'Dominadas': ['pull_up_bar'],

  // Barra con discos
  'Peso muerto convencional': ['barbell'],
  'Sentadilla con barra': ['barbell'],
  'Press de banca': ['barbell', 'bench'],

  // Polea
  'Jalón al pecho': ['cable_machine'],
  'Remo sentado en polea': ['cable_machine'],
  'Extensión de tríceps en polea': ['cable_machine'],
  'Face pull': ['cable_machine'],

  // Máquinas de gimnasio
  'Prensa de piernas': ['gym_machine'],
  'Curl femoral': ['gym_machine'],
  'Extensión de rodilla': ['gym_machine'],
  'Dominadas asistidas': ['gym_machine'],
  'Fondos en paralelas': ['gym_machine'],
};
