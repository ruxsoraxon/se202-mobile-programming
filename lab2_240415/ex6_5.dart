/// SE202 Mobile Programming — Lab 2, Exercise 6.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Temperature {
  double _celsius = 0;

  double get celsius => _celsius;

  set celsius(double value) {
    if (value < -273.15) throw ArgumentError('Below absolute zero');
    _celsius = value;
  }

  double get fahrenheit => _celsius * 9 / 5 + 32;
}

void main() {
  final t = Temperature();
  t.celsius = 25;
  print('${t.celsius}°C = ${t.fahrenheit}°F');
}
