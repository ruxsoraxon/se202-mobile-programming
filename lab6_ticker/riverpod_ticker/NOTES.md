## Part 2

- This is dependency injection. tickerProvider asks Riverpod for the feed instead of building it, so tests and the error demo can swap in TickFeed(failAfter: 5) through overrides without touching tickerProvider. If it were built inside, we’d have no way to replace it. In Part 4, tickFeedProvider also becomes the place that reacts to the failAfter toggle.
- When nothing is watching the provider any more (the page is gone), Riverpod cancels the stream subscription, so the generator stops, and it throws away the state. The next time something watches it, it starts from scratch, including a fresh 800 ms loading phase. Without autoDispose, the feed would keep ticking in the background forever.
- During the 800 ms. It holds AsyncLoading, and hasValue is false, because nothing has been emitted yet. hasValue becomes true after the first tick, and it stays true even if an error or reload comes later.

## Part 3

3.3 The analyzer says: 
Analyzing riverpod_ticker...                                            

  error - The type 'AsyncValue<List<Tick>>' isn't exhaustively matched by the switch cases since it doesn't match the pattern
         'AsyncLoading<List<Tick>>()'. Try adding a wildcard pattern or cases that match 'AsyncLoading<List<Tick>>()' -
         lib\ticker_page.dart:15:13 - non_exhaustive_switch_expression

1 issue found. (ran in 6.1s)
So the compiler tells me when I forget a state.

3.4 The empty-list and one-item arms must come before the general AsyncData arm, because a switch takes the first arm that matches, and AsyncData(:final value) matches every list, so the special arms would never run.

## Part 4

4.3 I wrapped the list in a RefreshIndicator that calls ref.refresh(tickerProvider.future). The Retry button uses ref.invalidate, and with it the old rows stayed visible with a thin progress bar. Riverpod keeps the previous value and just sets isLoading, and my AsyncValue(:final value?, isLoading: true) arm draws it. ref.refresh(...future) returns a Future so RefreshIndicator can await it and keep its spinner until new data arrives. ref.invalidate returns nothing, so there is nothing to wait for.

4.4 My arms already handle it: the isLoading-with-value arm sits above AsyncLoading(), so once there is an old value, the full-screen spinner never shows. isRefreshing means a forced recompute after a value existed (like Retry). isReloading means a recompute because a dependency changed (like the failAfter toggle changing tickFeedProvider).

## Checkpoint questions

1. AsyncValue is sealed and has three subtypes: AsyncData, AsyncLoading and AsyncError. If a switch expression misses one, the analyzer reports a non_exhaustive_switch_expression error, e.g. "The type 'AsyncValue<List<Tick>>' isn't exhaustively matched by the switch cases since it doesn't match the pattern 'AsyncLoading<List<Tick>>()'".

2. AsyncError.value is non-null when a value existed before the error, for example the feed sends ticks and then fails (my banner over dimmed rows). It is null when the error happens before any data arrived, for example the first load fails (my "Could not load ticker" screen).

3. ref.invalidate(provider) marks the state as stale and returns nothing; it recomputes when someone next needs it, or at once if a widget is watching it. ref.refresh(provider) invalidates it and returns the new state straight away. ref.refresh(provider.future) does the same but returns a Future for the new value, so you can await it, which is why RefreshIndicator uses it.

4. A switch checks arms from top to bottom and takes the first match. A state that is loading but still holds old data would also match the general AsyncData(:final value) arm, which would draw plain rows and hide the progress bar. So AsyncValue(:final value?, isLoading: true) must sit above it.

5. A switch expression is checked for completeness by the compiler, and it can match on content and conditions (empty list, value?, isLoading: true). .when is still convenient for simple cases with just data, error and loading callbacks and no extra conditions, because it is shorter.

## Stretch 4: AsyncValue.guard

balanceProvider is a one-shot FutureProvider whose body is AsyncValue.guard(...). guard catches the exception and returns it as an AsyncError value, so the provider itself finishes as AsyncData that contains an AsyncError (see the nested switch in BalanceDialog). In the stream case the error arrives as an AsyncError on the provider itself, keeps the previous value, and Riverpod 3 would retry it automatically. With guard the error never reaches the provider, so there is no automatic retry and the screen has to unwrap the inner value.