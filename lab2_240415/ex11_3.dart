/// SE202 Mobile Programming — Lab 2, Exercise 11.3
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

Future<int> task(int n) async {
  await Future.delayed(Duration(milliseconds: 300 * n));
  return n * 10;
}

Future<void> main() async {
  final results = await Future.wait([task(1), task(2), task(3)]);
  print('Results: $results, sum = ${results.reduce((a, b) => a + b)}');
}
