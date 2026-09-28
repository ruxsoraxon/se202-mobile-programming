/// SE202 Mobile Programming — Lab 2, Exercise 8.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Animal {
  void makeSound() => print('Some generic sound');
}

class Dog extends Animal {
  @override
  void makeSound() => print('Woof');
}

void main() {
  Animal().makeSound();
  Dog().makeSound();
}
