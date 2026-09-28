/// SE202 Mobile Programming — Lab 2, Exercise 11.6
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

Future<void> main() async {
  final raw = Stream.fromIterable(['1', '2', 'x', '4']);

  final numbers = raw
      .map(int.parse) // 'x' throws a FormatException
      .handleError(
        (e) => print('Skipped bad value: ${e.message}'),
        test: (e) => e is FormatException,
      );

  await for (final n in numbers) {
    print(n);
  }
  print('Stream finished');
}
