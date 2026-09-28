/// SE202 Mobile Programming — Lab 2, Exercise 6.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class AppConfig {
  // Created once, the first time it is used.
  // Dart runs code in a single thread per isolate, so there is no race here.
  static final AppConfig _instance = AppConfig._internal();

  AppConfig._internal(); // private: nobody outside can call it

  factory AppConfig() => _instance; // always returns the same object

  String theme = 'light';
}

void main() {
  final a = AppConfig();
  final b = AppConfig();
  a.theme = 'dark';
  print(b.theme); // dark
  print(identical(a, b)); // true
}
