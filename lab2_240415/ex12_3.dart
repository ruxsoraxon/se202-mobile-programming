/// SE202 Mobile Programming — Lab 2, Exercise 12.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void greet(String? name) {
  if (name == null || name.isEmpty) {
    throw ArgumentError('name must not be null or empty');
  }
  print('Hello, $name');
}

void main() {
  greet('Ruxsoraxon');
  try {
    greet('');
  } on ArgumentError catch (e) {
    print('Caught: ${e.message}');
  }
}
