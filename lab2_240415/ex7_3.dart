/// SE202 Mobile Programming — Lab 2, Exercise 7.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

String label(Day d) => switch (d) {
      Day.saturday || Day.sunday => 'Weekend',
      _ => 'Weekday',
    };

void main() {
  for (final d in Day.values) {
    print('${d.name}: ${label(d)}');
  }
}
