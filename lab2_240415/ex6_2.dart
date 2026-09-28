/// SE202 Mobile Programming — Lab 2, Exercise 6.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Person {
  String name;
  int age;
  Person(this.name, this.age);
}

void main() {
  final p = Person('Ruxsoraxon', 20);
  print('${p.name}, ${p.age}');
}
