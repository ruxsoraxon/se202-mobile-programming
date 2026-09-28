/// SE202 Mobile Programming — Lab 2, Exercise 5.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

/// Converts temperatures between units.
///
/// **Supported conversions:**
/// * Celsius to Fahrenheit
/// * Fahrenheit to Celsius
///
/// Example:
/// ```dart
/// print(TempConverter.toFahrenheit(100)); // 212.0
/// ```
class TempConverter {
  /// Converts [celsius] to Fahrenheit.
  static double toFahrenheit(double celsius) => celsius * 9 / 5 + 32;

  /// Converts [fahrenheit] to Celsius.
  static double toCelsius(double fahrenheit) => (fahrenheit - 32) * 5 / 9;
}

void main() {
  print(TempConverter.toFahrenheit(100));
  print(TempConverter.toCelsius(212));
}
