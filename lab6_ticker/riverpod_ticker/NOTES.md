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