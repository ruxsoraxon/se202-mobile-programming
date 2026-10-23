import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/tick.dart';
import '../services/tick_feed.dart';

/// Demo toggle: null = never fail, 5 = fail after 5 ticks.
final failAfterProvider = StateProvider<int?>((ref) => null);

/// Overridable in tests and in the error demo.
final tickFeedProvider = Provider<TickFeed>((ref) {
  return TickFeed(failAfter: ref.watch(failAfterProvider));
});

final tickerProvider = StreamProvider.autoDispose<List<Tick>>(
  (ref) => ref.watch(tickFeedProvider).watch(),
  retry: (retryCount, error) => null, // Riverpod 3 retries errors by default; off for this demo
);


/// One Tick per symbol, derived from the big list state.
final tickProvider = Provider.autoDispose.family<AsyncValue<Tick>, String>((ref, symbol) {
  return ref.watch(tickerProvider).whenData(
        (ticks) => ticks.firstWhere((t) => t.symbol == symbol),
      );
});