/// SE202 Mobile Programming — Lab 2, Exercise 9.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Vehicle {
  int speed = 0;
}

mixin Turbo on Vehicle {
  void boost() {
    speed += 50;
    print('Boosted to $speed km/h');
  }
}

class Car extends Vehicle with Turbo {}

void main() {
  Car().boost();
}
