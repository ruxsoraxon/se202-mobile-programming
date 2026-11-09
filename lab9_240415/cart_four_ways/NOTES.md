# Lab 9 notes

## Part 1: shared model and UI

- `CartLine` is immutable so every quantity change creates a new value through `copyWith`. Mutating a line in place would still appear to work in the setState page if `setState` schedules a rebuild, but Riverpod, Cubit, and BLoC can skip an update when the same object compares equal to itself. That is the trap: mutation hides the change from equality checks and makes updates harder to reason about.
- `CartBody` takes values and callbacks so it can render the same cart independently of which state-management approach owns those values. It does not need to know about a provider or bloc.

## Part 2: setState

- A separate order-history page cannot read `_state` from this page. The owner would need to move above both pages and pass the state down, or the app would need a shared state holder such as a provider or bloc.
- `_history` belongs to the widget's `State` object. Hot reload preserves that live object; hot restart recreates the app and clears this in-memory history.
- `total` is calculated from subtotal and coupon discount. Storing it separately can make it disagree with the lines or coupon after one of those changes.
- After checkout's `await`, the page may have been popped and its `State` disposed. Without the `mounted` guard, calling `setState` or using its `BuildContext` for a snackbar can act on a disposed widget and throw.

## Part 3: Riverpod

- The cart state lives in the `ProviderContainer` under the root `ProviderScope`. This cart is `autoDispose`, so its notifier and private undo history are discarded after the page stops listening and Riverpod disposes the provider.
- `ref.watch(cartProvider)` supplies the current cart to the page and subscribes it to changes. `ref.watch(cartProvider.select((state) => state.total))` subscribes the summary only to total changes. The undo provider also watches cart state so changes to the notifier's private history can refresh the Undo button.
- `ref.read(cartProvider.notifier)` gets the notifier for button callbacks without subscribing those callbacks. The notifier uses `ref.read(checkoutApiProvider)` to get the checkout service when submitting. The status listener uses `ref.read(cartProvider)` to get the success or error detail after the selected status changes.
- The summary rebuilds less often than the setState page because Riverpod compares the selected total and skips the summary when that value is unchanged. Typing into the coupon field does not change provider state; applying an invalid coupon changes the error but still leaves the total unchanged.
- Riverpod's `ref.watch` is the display subscription, `ref.read` is a one-off lookup, and `ref.listen` handles side effects. They correspond roughly to `BlocBuilder`, `context.read`, and `BlocListener`; `select` corresponds to `buildWhen`. `setState` has no provider lookup equivalent because the widget owns and rebuilds its own local state.
- Checkout state changes in the notifier and the page handles messages with `ref.listen`, so the async operation does not call `setState` or use a page `BuildContext`. The consumer's listener is managed with its lifetime; the notifier is not a widget `State` that needs a widget `mounted` check before UI work. Because this provider is auto-disposed, the notifier also checks `ref.mounted` after awaiting the API so it does not publish a result after its provider has been disposed.

### Riverpod tests

The provider tests run without pumping widgets. One checks two additions plus `SAVE10`; the other overrides the API with a mock that throws and verifies failure leaves the cart lines intact.

## Part 4: Cubit

- `BlocProvider` is placed above the page subtree so its descendants can access the Cubit. Putting it inside `CartBody` would scope it to that subtree, make it unavailable to the app bar and checkout controls, and risk creating a fresh Cubit when that body is rebuilt.
- `context.read<CartCubit>()` performs one-off event/action access, `BlocBuilder` rebuilds from state, and `BlocListener` handles one-time effects such as snackbars. Riverpod equivalents are `ref.read`, `ref.watch`, and `ref.listen`.
- The summary uses `BlocSelector` over just lines and coupon, so checkout status/error transitions do not rebuild it. The debug output makes those rebuilds visible. State equality compares all values and line contents; applying the same coupon twice produces an equal state and the second emission is dropped.
- Undo history lives in the Cubit. Adding `canUndo` to immutable state makes history availability observable to widgets and keeps the Undo button declarative.
- The Cubit tests assert the exact addition/coupon emissions and a failed checkout sequence, including that the cart remains intact.

## Part 5: BLoC

- UI actions become named immutable events (`ProductAdded`, `QuantityChanged`, `CouponApplied`, `CheckoutRequested`, `UndoRequested`). `on<E>` registers each handler. The page dispatches events; it does not call state mutation methods on the BLoC.
- `Bloc.observer` logs each transition with its event, state status, item count, and total. Cubit's `onChange` can report old/new states but has no event field, because a Cubit has no event layer.
- The checkout handler uses `droppable()`. While one checkout event is waiting on the API, additional checkout events are discarded. The third `blocTest` holds the first checkout open briefly, adds three requests, and verifies a single API call and one submitting state.
- BLoC undo snapshots are stored in `CartState.history`. Product additions, quantity changes, coupon changes, and a successful checkout add snapshots; submitting, success/failure status transitions, and Undo itself do not independently create history entries. `UndoRequested` restores the last snapshot and the remaining history.
- The event layer is useful for checkout because duplicate taps can be dropped declaratively and every action is traceable in transition logs. It is overhead for a simple quantity change; a Cubit method expresses that directly. In setState, disabling the button or guarding with a boolean prevents duplicate work. In Riverpod, the notifier can check its submitting state before starting.

## Final checkpoint questions

1. **Where state lives and when it dies:** setState keeps it in the page's `State` object; it dies when that page leaves the widget tree. Riverpod keeps it in the root `ProviderContainer`; this cart is `autoDispose`, so it dies after no listener remains and disposal runs. Cubit keeps it in the Cubit created by `BlocProvider`; it dies when the provider's subtree is disposed and closes the Cubit. BLoC keeps it in the BLoC created by `BlocProvider`; it dies when that subtree is disposed and closes the BLoC.
2. **Mutation API:** a Riverpod notifier exposes methods that assign a new value to its protected `state`; a Cubit exposes named methods that call `emit`; a BLoC accepts events through `add(event)`. setState has no separate state-holder API: its widget's `State` object is updated inside `setState(() { ... })`.
3. **UI mapping:** `ref.watch` roughly matches `BlocBuilder`; `ref.read` roughly matches `context.read`; `ref.listen` roughly matches `BlocListener`; `ref.watch(provider.select(...))` roughly matches `buildWhen`/`BlocSelector`. setState has no subscription API—the owner rebuilds and passes values and callbacks down.
4. **Equality and immutability:** Riverpod, Cubit, and BLoC skip equal states to avoid unnecessary notifications and rebuilds. For that to work, state and nested values need value equality, and updates must create new immutable values instead of mutating old ones. This project implements equality for `CartLine`, `CartSnapshot`, and `CartState` and replaces changed lists/objects.
5. **Guard after checkout `await`:** setState checks `mounted` before using the disposed page or its context. The Riverpod listener is managed by its consumer; this auto-disposed notifier also checks `ref.mounted` before publishing after the await. Cubit checks `isClosed`; BLoC checks `emit.isDone` because its handler may have been cancelled or completed.

## Comparison table

Line counts below are nonblank, non-comment Dart lines in each style's implementation files and test file. Shared model, widgets, API, and app shell are excluded. File counts include implementation plus that style's test.

| Style | Implementation LOC | Test LOC | Files | Strength | Weakness |
|---|---:|---:|---:|---|---|
| setState | 143 | 22 | 2 | Fewest concepts and files; direct for local state | State is tied to one page and the page rebuilds broadly |
| Riverpod | 148 | 33 | 3 | State is accessible outside the page and selected values rebuild narrowly | Provider/ref lifecycle and auto-dispose rules add concepts |
| Cubit | 148 | 49 | 3 | Clear named methods and exact state-emission tests | No event object to record why a state changed; history must be tracked separately |
| BLoC | 226 | 78 | 5 | Events are traceable and transformers can control async event handling | Most files and boilerplate for straightforward actions |

