# Lab 11 — REST API with Bloc and Cubit

## Part 1 — Setup and first request

The app uses `https://dummyjson.com/products`. This public demo endpoint does not require an API key. `bin/peek.dart` requests product 1 and prints its status code, title, and the runtime type of its nested `dimensions` value. The response snapshot is saved at `test/fixtures/product.json` for offline tests.

### Questions

In the sample product response:

- Numeric values include `id`, `price`, and `rating`.
- String values include `title`, `brand`, and `thumbnail`.
- `tags` is a list of strings.
- `dimensions` is a nested object.
- `reviews` is a list of nested objects.

Changing the request path to `/products/0` returns HTTP 404 and a JSON error object indicating that product 0 was not found. The API client turns non-success status codes into `ProductApiException` messages for the UI.

## Part 2 — Models

`jsonDecode` represents JSON numbers as `num`; a value such as `price` may be an integer or a double, so the model converts it with `(value as num).toDouble()`. `brand` is nullable because it is not present on every product. Missing `tags` become an empty list. Nested dimensions and reviews each have their own `fromJson` parser, and `ProductPage` parses the response's product list and pagination values.

## Part 3 — Cubit states

`ProductsCubit` loads the product page, and `DetailsCubit` loads one product by ID. Their screens display loading, success, and failure states using exhaustive Dart switches. The API client accepts an injected `http.Client`, so the Cubits and API can be exercised without live network requests.

## Part 4 — Search Bloc

Search input is represented by `SearchQueryChanged`; the Bloc emits idle, loading, loaded, or failure states. The `restartable` event transformer makes the latest query authoritative. Older HTTP requests may finish, but their cancelled handlers cannot publish stale results.

## Part 5 — Offline checks

Tests cover the product and page parsers, optional fields, HTTP request/error handling, both Cubits, and search behavior. They use the saved fixture or a mocked HTTP client and do not call DummyJSON.

## Submission checklist

- [x] Flutter project and Android scaffold created in `api_catalog/`.
- [x] `bin/peek.dart` and a saved product response fixture added.
- [x] Typed product, review, dimensions, and paginated response models added.
- [x] HTTP client, Cubits, search Bloc, and catalogue/detail/search screens added.
- [x] Offline model, API, Cubit, and Bloc tests added.
- [x] `flutter test` passes after correcting asynchronous Cubit stream assertions (9 tests).
- [x] `flutter analyze` reports no issues.
- [x] Web scaffold generated so the app can run on the detected Chrome target.
- [ ] Run the app on an Android phone or emulator; no supported Android device was connected during verification.
