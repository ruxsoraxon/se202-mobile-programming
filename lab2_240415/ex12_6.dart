/// SE202 Mobile Programming — Lab 2, Exercise 12.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

int parseScore(String raw) {
  try {
    return int.parse(raw);
  } on FormatException {
    print('parseScore: logging bad input "$raw"');
    rethrow; // pass the same error up to the caller
  }
}

void main() {
  print(parseScore('95'));
  try {
    parseScore('9x');
  } on FormatException catch (e) {
    print('main: handled -> ${e.message}');
  }
}
