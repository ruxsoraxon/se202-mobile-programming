/// SE202 Mobile Programming — Lab 2, Exercise 10.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

sealed class Shape {
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

String describe(Shape s) => switch (s) {
      Circle(r: final r) => 'Circle r=$r',
      Rectangle(w: final w, h: final h) => 'Rectangle ${w}x$h',
    };

void main() {
  for (final s in [Circle(1), Rectangle(2, 3)]) {
    print('${describe(s)} -> area ${s.area().toStringAsFixed(2)}');
  }
}
