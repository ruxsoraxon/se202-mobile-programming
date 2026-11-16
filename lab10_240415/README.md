# Lab 10 — Teachable Machine Flower Classifier

A Flutter app that classifies flower photos on-device with the supplied six-class Teachable Machine TensorFlow Lite model.

## Classes

The class order comes from `assets/model/labels.txt`: rose, sunflower, tulip, lily, daisy, dandelion.

## Run

```sh
flutter pub get
flutter run
```

Open the app and choose **Take photo** or **Choose photo**. The app shows the top class and confidence scores for the remaining classes. Inference runs locally; the image is not uploaded.

## Model compatibility

Keep `model_unquant.tflite` and `labels.txt` from the same Teachable Machine export together in `assets/model/`. The app reads the input image size and class count from the model. This implementation expects an RGB image input and uses Teachable Machine's standard RGB normalization to `[-1, 1]`.

Camera and photo-library permission declarations are included in the Android and iOS app configuration.
