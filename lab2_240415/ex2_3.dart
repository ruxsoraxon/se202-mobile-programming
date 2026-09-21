/// SE202 Mobile Programming — Lab 2, Exercise 2.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main() {
  final now = DateTime.now();         // OK: value known at runtime
  // const bad = DateTime.now();      // ERROR: not a compile-time constant
  const fixed = Duration(seconds: 5); // OK: compile-time constant
  print('final now   = $now');
  print('const fixed = $fixed');
}
