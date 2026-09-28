/// SE202 Mobile Programming — Lab 2, Exercise 12.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void level3() => throw StateError('Something broke deep inside');
void level2() => level3();
void level1() => level2();

void main() {
  try {
    level1();
  } catch (e, stackTrace) {
    print('Error: $e');
    print('Stack trace:');
    print(stackTrace);
  }
}
