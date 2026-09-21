/// SE202 Mobile Programming — Lab 2, Exercise 4.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

int fib(int n) => n <= 1 ? n : fib(n - 1) + fib(n - 2);

void main() {
  print(List.generate(10, (i) => fib(i)));
}
