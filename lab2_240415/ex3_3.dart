/// SE202 Mobile Programming — Lab 2, Exercise 3.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main() {
  int n = 5;
  int f1 = 1;
  for (int i = 1; i <= n; i++) f1 *= i;

  int f2 = 1;
  for (final i in List.generate(n, (i) => i + 1)) f2 *= i;

  print('for: $f1, for-in: $f2');
}
