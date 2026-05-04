class AppValidator {
  AppValidator._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Este campo es requerido';
    return null;
  }

  static String? percentage(String? value) {
    if (value == null || value.trim().isEmpty) return 'Este campo es requerido';
    final num? number = double.tryParse(value);
    if (number == null || number < 1 || number > 100) {
      return 'Ingrese un porcentaje entre 1 y 100';
    }
    return null;
  }

  static String? futureDate(DateTime? date) {
    if (date == null) return 'Selecciona una fecha';
    if (date.isBefore(DateTime.now())) return 'La fecha debe ser futura';
    return null;
  }
}