/// SE202 Mobile Programming — Lab 2, Exercise 5.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

/// Validation helpers for user input.
class Validator {
  /// Checks whether [age] is a valid human age.
  ///
  /// Returns `true` if [age] is between 0 and 120.
  /// Throws an [ArgumentError] if [age] is negative.
  static bool isValidAge(int age) {
    if (age < 0) throw ArgumentError('age cannot be negative');
    return age <= 120;
  }
}

void main() {
  print(Validator.isValidAge(20));
}
