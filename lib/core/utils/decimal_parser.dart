/// Convierte texto a número aceptando coma o punto como separador decimal.
///
/// El teclado numérico en español puede insertar coma ("72,5") y
/// `double.tryParse` solo entiende punto. Devuelve `null` si el texto no es
/// un número válido.
double? parseDecimal(String text) {
  return double.tryParse(text.trim().replaceAll(',', '.'));
}
