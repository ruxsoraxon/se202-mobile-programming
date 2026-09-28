/// SE202 Mobile Programming — Lab 2, Exercise 9.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

mixin Walker {
  void walk() => print('$runtimeType is walking');
}

mixin Swimmer {
  void swim() => print('$runtimeType is swimming');
}

mixin Flyable {
  void fly() => print('$runtimeType is flying');
}

class Duck with Walker, Swimmer, Flyable {}

void main() {
  final d = Duck();
  d.walk();
  d.swim();
  d.fly();
}
