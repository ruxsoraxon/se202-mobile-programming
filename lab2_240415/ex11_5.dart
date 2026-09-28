/// SE202 Mobile Programming — Lab 2, Exercise 11.5
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

Future<void> main() async {
  final stream = Stream.fromIterable([1, 1, 2, 3, 3, 4, 5, 6]);
  await for (final v in stream
      .distinct()
      .where((x) => x.isEven)
      .map((x) => x * x)) {
    print(v);
  }
}
