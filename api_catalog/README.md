# API Catalogue — Lab 11

A Flutter REST API client backed by [DummyJSON](https://dummyjson.com/products). The app demonstrates typed JSON models, HTTP error handling, Cubit state, and event driven search with Bloc.

## Run

```sh
flutter pub get
flutter run -d chrome
```

For a phone or emulator, use `flutter run` after connecting or starting an Android device. The app needs internet access. DummyJSON is a public test API and does not require an account or API key.

To inspect the sample product response from the terminal:

```sh
dart run bin/peek.dart
```

## Structure

```text
lib/
  bloc/       search events, state, and bloc
  cubit/      product list and detail cubits and states
  data/       HTTP API client
  models/     product, dimensions, review, and product page
  screens/    catalogue, product detail, and search screens
test/         model, API, Cubit, and Bloc tests
NOTES.md      lab answers and completion checklist
```

## Check

```sh
flutter analyze
flutter test
```
