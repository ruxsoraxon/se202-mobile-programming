/// SE202 Mobile Programming — Lab 2, Exercise 9.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

mixin Flyable {
  void fly() => print('$runtimeType is flying');
}

class Bird with Flyable {}

void main() {
  Bird().fly();
}
