/// SE202 Mobile Programming — Lab 2, Exercise 4.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

String decorate(String word, [String prefix = '<<', String suffix = '>>']) =>
    '$prefix$word$suffix';

void main() {
  print(decorate('Dart'));
  print(decorate('Dart', '[', ']'));
}
