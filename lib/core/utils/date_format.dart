// Formato de fechas en español, sin depender de paquetes de localización
// (la app funciona sin internet y no necesita inicializar datos de idioma).

const List<String> _weekdays = [
  'lunes',
  'martes',
  'miércoles',
  'jueves',
  'viernes',
  'sábado',
  'domingo',
];

const List<String> _months = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

/// "martes 13 de octubre".
String formatLongDate(DateTime date) {
  final weekday = _weekdays[date.weekday - 1];
  final month = _months[date.month - 1];

  return '$weekday ${date.day} de $month';
}
