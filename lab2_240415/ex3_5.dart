/// SE202 Mobile Programming — Lab 2, Exercise 3.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main() {
  outer:
  for (int i = 1; i <= 3; i++) {
    for (int j = 1; j <= 3; j++) {
      if (j == 2) continue outer; // skip rest of inner loop
      if (i == 3) break outer;    // leave both loops
      print('i=$i j=$j');
    }
  }
}
