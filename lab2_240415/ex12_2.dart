/// SE202 Mobile Programming — Lab 2, Exercise 12.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

int divide(int a, int b) {
  try {
    return a ~/ b;
  } on UnsupportedError {
    print('Cannot divide $a by zero');
    return 0;
  }
}

void main() {
  print(divide(10, 2));
  print(divide(10, 0));
}
