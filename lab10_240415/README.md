# Bloom — Lab 10 Flower Classifier

Bloom is a Flutter app that classifies flower photos with a bundled Teachable Machine TensorFlow Lite model. Photo inference runs on-device.

## Screens and features

- Welcome and Home screens with a short introduction and entry to classification.
- Classifier screen with camera, gallery, and image URL sources.
- Result screen with ranked class scores and TensorFlow Lite inference time.
- Session History screen with tappable previous results.
- Model screen whose class list is read from the loaded model labels.

History is kept in memory for the current app session and is cleared when the process restarts.

## Run

```sh
flutter pub get
flutter run
```

Without a USB-connected phone, create/start an Android emulator in Android Studio, then run `flutter run` and choose that emulator. To list available emulator profiles, use `flutter emulators`.

Run the included label parser tests and static analyzer with:

```sh
flutter test
flutter analyze
```

## Model files

Keep `assets/model/model_unquant.tflite` and `assets/model/labels.txt` together from the same Teachable Machine export. The app reads the image size and output class count from the model and checks that the label count matches. The current model has six classes: rose, sunflower, tulip, lily, daisy, and dandelion. It expects an RGB image and uses the export's `[-1, 1]` pixel normalization.

The app can confidently misclassify unfamiliar photos; confidence is a score over these six classes, not an unknown-class detector. Evaluation results and remaining submission evidence are documented in [NOTES.md](NOTES.md).
