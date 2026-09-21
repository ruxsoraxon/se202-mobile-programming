/// SE202 Mobile Programming — Lab 2, Exercise 1.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main(List<String> arguments) {
  if (arguments.length != 2) {
    print('Warning! Usage: dart run ex1_5.dart <arg1> <arg2>');
    return;
  }
  print('Got: ${arguments[0]} and ${arguments[1]}');
}
