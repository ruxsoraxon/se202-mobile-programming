/// SE202 Mobile Programming — Lab 2, Exercise 7.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

abstract interface class Describable {
  String describe();
}

enum Planet implements Describable {
  mercury(0.39),
  earth(1.0),
  mars(1.52);

  final double distanceAu;
  const Planet(this.distanceAu);

  double get distanceKm => distanceAu * 149.6e6;

  @override
  String describe() => '$name is ${distanceKm.toStringAsFixed(0)} km from the Sun';
}

void main() {
  for (final p in Planet.values) {
    print(p.describe());
  }
}
