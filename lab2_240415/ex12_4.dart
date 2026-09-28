/// SE202 Mobile Programming — Lab 2, Exercise 12.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void parse(String input) {
  try {
    final n = int.parse(input);
    print(100 ~/ n);
  } on FormatException {
    print('"$input" is not a number');
  } on UnsupportedError {
    print('Division by zero');
  } catch (e) {
    print('Other error: $e');
  }
}

void main() {
  parse('abc');
  parse('0');
  parse('4');
}
