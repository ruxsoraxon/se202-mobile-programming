/// SE202 Mobile Programming — Lab 2, Exercise 8.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

abstract class Shape {
  double area(); // abstract: every subclass must implement it

  void describe() => print('$runtimeType with area ${area().toStringAsFixed(2)}');
}

class Square extends Shape {
  final double side;
  Square(this.side);

  @override
  double area() => side * side;
}

void main() {
  Square(3).describe();
}
