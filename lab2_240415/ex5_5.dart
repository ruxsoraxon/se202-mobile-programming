/// SE202 Mobile Programming — Lab 2, Exercise 5.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

class Animal {
  /// Returns the sound this animal makes.
  String sound() => '...';

  /// Old name for [sound]. Use [sound] instead.
  @Deprecated('Use sound() instead')
  String speak() => sound();
}

class Cat extends Animal {
  /// Cats say meow. Replaces [Animal.sound].
  @override
  String sound() => 'Meow';
}

void main() {
  print(Cat().sound());
}
