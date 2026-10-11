// Formato de números para mostrar en pantalla.

/// Muestra [value] con un decimal solo cuando hace falta: 177.0 → "177",
/// 79.5 → "79.5".
String formatNumber(double value) {
  final rounded = (value * 10).round() / 10;

  if (rounded == rounded.roundToDouble()) {
    return rounded.toStringAsFixed(0);
  }

  return rounded.toStringAsFixed(1);
}

/// Elige entre singular y plural: pluralize(1, 'serie', 'series') → "1 serie".
String pluralize(int count, String singular, String plural) {
  return '$count ${count == 1 ? singular : plural}';
}
