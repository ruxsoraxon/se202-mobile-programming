/// SE202 Mobile Programming — Lab 2, Exercise 7.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

void main() {
  for (final raw in ['friday', 'funday']) {
    try {
      final d = Day.values.byName(raw);
      print('Parsed: $d');
    } on ArgumentError {
      print('"$raw" is not a Day');
    }
  }
}
