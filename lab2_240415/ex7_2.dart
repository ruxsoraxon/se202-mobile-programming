/// SE202 Mobile Programming — Lab 2, Exercise 7.2
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

void main() {
  for (final d in Day.values) {
    print(d.name);
  }
}
