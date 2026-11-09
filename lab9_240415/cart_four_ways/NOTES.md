# Lab 9 notes

## Part 1: shared model and UI

- `CartLine` is immutable so every quantity change creates a new value. Mutating a line in place can leave state holders and listeners with the same object identity, hiding a change from equality checks and making updates harder to reason about.
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
