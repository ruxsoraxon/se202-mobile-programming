import 'package:flutter/foundation.dart';
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

/// Set to false in tests so no retry timers are left running.
bool backoffEnabled = true;

/// Give up after this many automatic retries.
const maxRetries = 3;

/// Which automatic retry is waiting or running (0 = none). The banner shows it.
final retryAttempt = ValueNotifier<int>(0);

/// True once all automatic retries are used up.
final retryGaveUp = ValueNotifier<bool>(false);

/// Exponential backoff: retry after 1 s, 2 s, 4 s, then give up.
Duration? tickerRetry(int retryCount, Object error) {
  if (!backoffEnabled) return null;
  if (retryCount >= maxRetries) {
    retryGaveUp.value = true;
    return null;
  }
  retryAttempt.value = retryCount + 1;
  return Duration(seconds: 1 << retryCount);
}

/// Manual "Retry now": clears the counters and rebuilds the provider.
void retryNow(WidgetRef ref) {
  retryAttempt.value = 0;
  retryGaveUp.value = false;
  ref.invalidate(tickerProvider);
}

final tickerProvider = StreamProvider.autoDispose<List<Tick>>(
  (ref) => ref.watch(tickFeedProvider).watch().map((ticks) {
    retryAttempt.value = 0; // data is flowing again
    retryGaveUp.value = false;
    return ticks;
  }),
  retry: tickerRetry,
);


/// One Tick per symbol, derived from the big list state.
final tickProvider = Provider.autoDispose.family<AsyncValue<Tick>, String>((ref, symbol) {
  final state = ref.watch(tickerProvider);
  final ticks = state.value; // last good list, kept during reloads and errors
  if (ticks != null) {
    return AsyncData(ticks.firstWhere((t) => t.symbol == symbol));
  }
  return state.hasError
      ? AsyncError(state.error!, state.stackTrace!)
      : const AsyncLoading();
});