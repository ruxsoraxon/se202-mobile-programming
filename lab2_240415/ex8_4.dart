/// SE202 Mobile Programming — Lab 2, Exercise 8.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Shape {
  final String name;
  Shape(this.name);

  double area() => 0;

  void info() => print('$name: area ${area().toStringAsFixed(2)}');
}

class Polygon extends Shape {
  final int sides;
  Polygon(super.name, this.sides);

  @override
  void info() {
    super.info();
    print('  sides: $sides');
  }
}

class Triangle extends Polygon {
  final double base, height;
  Triangle(this.base, this.height) : super('Triangle', 3);

  @override
  double area() => 0.5 * base * height;
}

void main() {
  final t = Triangle(4, 3);
  t.info();
  print(t is Polygon); // true
  print(t is Shape); // true
}
