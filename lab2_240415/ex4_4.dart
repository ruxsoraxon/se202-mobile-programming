/// SE202 Mobile Programming — Lab 2, Exercise 4.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

List<int> transformAll(List<int> numbers, int Function(int) transformer) =>
    numbers.map(transformer).toList();

void main() {
  print(transformAll([1, 2, 3, 4], (n) => n * n));
}
