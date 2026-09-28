/// SE202 Mobile Programming — Lab 2, Exercise 10.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

abstract class Shape {
  double area();
}

class Circle extends Shape {
  final double r;
  Circle(this.r);
  @override
  double area() => 3.14159 * r * r;
}

class Rectangle extends Shape {
  final double w, h;
  Rectangle(this.w, this.h);
  @override
  double area() => w * h;
}

void main() {
  final List<Shape> shapes = [Circle(1), Rectangle(2, 3)];

  final Shape s = shapes.first;
  if (s is Circle) print('It is a circle, radius ${s.r}');

  final rect = shapes[1] as Rectangle;
  print('Width via cast: ${rect.w}');
}
