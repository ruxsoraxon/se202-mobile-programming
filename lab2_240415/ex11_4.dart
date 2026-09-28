/// SE202 Mobile Programming — Lab 2, Exercise 11.4
/// Ruxsoraxon Kenjayeva · Student ID 240415 · New Uzbekistan University

import 'dart:async';

Future<void> main() async {
  var count = 0;
  final done = Completer<void>();
  late StreamSubscription<int> sub;

  sub = Stream<int>.periodic(const Duration(milliseconds: 500), (i) => i + 1)
      .listen((tick) {
    print('Tick $tick');
    count++;
    if (count == 5) {
      sub.cancel();
      done.complete();
    }
  });

  await done.future;
  print('Cancelled after 5 ticks');
}
