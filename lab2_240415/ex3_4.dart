/// SE202 Mobile Programming — Lab 2, Exercise 3.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

void main() {
  const target = 7;
  int guess = 0;
  while (true) {
    guess++;
    print('Trying $guess...');
    if (guess == target) {
      print('Found it: $target');
      break;
    }
  }
}
