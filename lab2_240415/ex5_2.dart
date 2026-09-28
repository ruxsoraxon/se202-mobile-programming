/// SE202 Mobile Programming — Lab 2, Exercise 5.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

double circleArea(double r) {
  // Area of a circle: A = pi * r^2
  /* 3.14159 is used for pi so that
     no import of dart:math is needed. */
  return 3.14159 * r * r;
}

void main() {
  print(circleArea(2));
}
