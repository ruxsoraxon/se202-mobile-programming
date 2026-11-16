# Lab 10 — Teachable Machine Image Classifier

## Model and class list

The app uses `assets/model/model_unquant.tflite` and its matching `assets/model/labels.txt`. The labels are read from the model export in this order:

1. rose
2. sunflower
3. tulip
4. lily
5. daisy
6. dandelion

These are the six exported flower classes. A separate background or “nothing” class is **not** present in this export.

### Part 1 questions

**What happens when the model sees an object outside its classes? What does a background class change?**

The classifier still returns a score for every known class and chooses the largest one; it has no built-in “unknown” answer. It may confidently assign an unrelated object to a flower class. A representative background class can teach it to assign common non-flower scenes to that class, but it does not guarantee that every unfamiliar object will be recognized as unknown.

**Floating point and quantized exports:**

The floating-point model stores weights and uses floating-point input values, so it is generally larger. Quantization stores lower-precision values and can reduce model size and improve performance on supported hardware. A quantized export may require integer pixel input and output handling instead of the floating-point `[-1, 1]` normalization used here. The exact tensor types and scaling must be read from the exported model; they should not be guessed. The committed model is the floating-point `model_unquant.tflite` export.

**Preview evidence:** add the Teachable Machine preview screenshot at `docs/preview.png` after capturing the class bars. Record whether every class reached at least 80% on a fresh example: **Pending phone/model preview.**

## Part 2 — Setup

The app bundles the model and labels from `assets/model/`. Declaring that specific directory includes the files needed by the classifier. Declaring the broader `assets/` directory would also bundle other asset files placed under it, including unrelated files, and can increase the app bundle size.

The `image` package can decode and resize bytes in Dart without Flutter platform services, and `http` can be tested as ordinary Dart networking code with a mocked client. `tflite_flutter` invokes the TensorFlow Lite native runtime, while `image_picker` uses platform channels to access camera/gallery APIs; those platform integrations need Flutter/plugin or device-aware tests.

**Setup checkpoint:** verify `flutter pub get`, `flutter analyze`, and a device launch after running the app. The current app configuration includes the model and labels assets, `image_picker`, `image`, and `tflite_flutter`. The URL-download dependency and flow are not implemented yet.

## Part 3 — Classifier

The app loads one `FlowerClassifier` when the classifier screen starts, shares it for photo predictions, and closes it when that screen is disposed. The class count comes from the model output tensor and is checked against the number of parsed labels; it is not a separately hard-coded number. If the model is retrained with a seventh class, replace the model and labels file together with the same export and verify the output shape and predictions.

Changing normalization from `pixel / 127.5 - 1` to `pixel / 255` changes the model input distribution from `[-1, 1]` to `[0, 1]`. The tensor still contains valid floating-point values with the expected shape, so inference can run without crashing, but the inputs no longer match training and the scores can become unreliable.

**Classifier checks:**

- `parseLabels` normal labels test: **Pending test run/addition.**
- Windows line endings, blank line, and multiword label test: **Pending test run/addition.**
- Correct top label and probabilities totaling approximately 1.0: **Pending phone test.**
- Invalid image and missing-model messages: **Pending verification.**

## Part 4 — Design and screens

**Figma design credit (complete after choosing a reusable Community file):**

- File name: **TODO**
- Author: **TODO**
- Link: **TODO**
- Licence/reuse terms: **TODO**
- Reference exports: `docs/design-1.png` and `docs/design-2.png` (**TODO**)

The current app presents the flower classifier in a single screen. It does not yet implement the handout’s separate Welcome, Home, Result, History, and Model screens or a shared `ThemeData` file.

**Two design changes and why:**

1. **TODO:** describe a design element changed or omitted and the reason.
2. **TODO:** describe another design element changed or omitted and the reason.

The Model screen should read labels from the already-loaded classifier instance. That keeps the displayed class list consistent with the model used for inference and avoids loading/parsing the same asset a second time.

## Part 5 — Sources and evaluation

The current screen supports camera capture, gallery selection, and image import from a URL. I exercised gallery and URL imports on the Samsung SM-A556E. A separate Result screen and session History screen are still not implemented.

### Phone evaluation

Each row below was run on the phone using a distinct image. The first five classes use visually obvious samples from `archive.zip/test`; that directory has no labels, so I assigned the expected labels by visual review. Lily samples are separate Oxford 102 examples (Tiger Lily, Blackberry Lily, and Fire Lily), not images from the Roboflow zips used during training. Their category names are listed on the [Oxford 102 category page](https://www.robots.ox.ac.uk/~vgg/data/flowers/102/categories.html). Most visible confidences are rounded to whole percentages by the app.

The URL attempts used a temporary HTTP server bound to the development computer’s loopback address and `adb reverse`. The debug build permits HTTP for this test; use HTTPS for ordinary external URLs. The camera source is implemented but could not be evaluated here: ADB cannot position a real flower in front of the phone’s camera.

| Expected label | Attempt | Source | Predicted label | Confidence | Correct? | Screenshot |
|---|---:|---|---|---:|---|---|
| rose | 1 | Gallery | rose | 100% | Yes | [Screenshot](docs/evaluation/rose-gallery-1.png) |
| rose | 2 | Gallery | daisy | 100% | No | [Screenshot](docs/evaluation/rose-gallery-2.png) |
| rose | 3 | URL | rose | 100% | Yes | [Screenshot](docs/evaluation/rose-url-1.png) |
| sunflower | 1 | Gallery | sunflower | 100% | Yes | [Screenshot](docs/evaluation/sunflower-gallery-1.png) |
| sunflower | 2 | Gallery | sunflower | 100% | Yes | [Screenshot](docs/evaluation/sunflower-gallery-2.png) |
| sunflower | 3 | URL | dandelion | 55% (sunflower 45%) | No | [Screenshot](docs/evaluation/sunflower-url-1.png) |
| tulip | 1 | Gallery | tulip | 100% | Yes | [Screenshot](docs/evaluation/tulip-gallery-1.png) |
| tulip | 2 | Gallery | tulip | 100% | Yes | [Screenshot](docs/evaluation/tulip-gallery-2.png) |
| tulip | 3 | URL | tulip | 100% | Yes | [Screenshot](docs/evaluation/tulip-url-1.png) |
| lily | 1 | Gallery | rose | 100% | No | [Screenshot](docs/evaluation/lily-gallery-1.png) |
| lily | 2 | Gallery | sunflower | 100% | No | [Screenshot](docs/evaluation/lily-gallery-2.png) |
| lily | 3 | URL | rose | 100% | No | [Screenshot](docs/evaluation/lily-url-1.png) |
| daisy | 1 | Gallery | daisy | 100% | Yes | [Screenshot](docs/evaluation/daisy-gallery-1.png) |
| daisy | 2 | Gallery | daisy | 100% | Yes | [Screenshot](docs/evaluation/daisy-gallery-2.png) |
| daisy | 3 | URL | dandelion | 100% | No | [Screenshot](docs/evaluation/daisy-url-1.png) |
| dandelion | 1 | Gallery | dandelion | 100% | Yes | [Screenshot](docs/evaluation/dandelion-gallery-1.png) |
| dandelion | 2 | Gallery | lily | 100% | No | [Screenshot](docs/evaluation/dandelion-gallery-2.png) |
| dandelion | 3 | URL | lily | 100% | No | [Screenshot](docs/evaluation/dandelion-url-1.png) |

- Overall accuracy: **10/18 (55.6%)**. The five visually labeled Kaggle classes scored 10/15 (66.7%); Lily scored 0/3 on the separate Oxford samples.
- Per class: Rose 2/3, Sunflower 2/3, Tulip 3/3, Lily 0/3, Daisy 2/3, Dandelion 1/3.
- Weakest class: **Lily (0/3)**. There were also high-confidence errors on a rose, a daisy, two dandelions, and all three Lily samples. Confidence is not a guarantee of correctness.
- Phone response time: the result screen was visible by the approximately **2-second ADB capture checkpoint** after confirming/importing an image. This is an end-to-end upper bound, not a stopwatch measurement of `Interpreter.run` alone.
- While classification runs, the selected image is dimmed and a centered circular progress indicator is shown.
- Camera evaluation: **Pending a real flower being presented to the phone camera.** The 18 recorded attempts above use gallery and URL sources only.

**Why can the same object score differently across sources?**

Two training-data reasons are differences in lighting/color balance and differences in framing, distance, angle, or background. These can make a camera photo or downloaded picture look unlike the training examples even when the object is the same.

## Final submission checklist

- [x] Model file and six-line labels file are committed under `assets/model/`.
- [ ] `docs/preview.png` added after previewing the model on a fresh example per class.
- [ ] `docs/design-1.png` and `docs/design-2.png` added; Figma source and licence credited here and in the app.
- [ ] Five required screens and the three image sources implemented and demonstrated.
- [ ] At least two label-parser tests pass.
- [x] `flutter analyze` is clean after the URL-dialog lifecycle fix.
- [ ] Camera demonstration, stopwatch timing of the model call, and remaining checkpoint answers completed.
- [ ] Under-60-second screen recording shows camera, gallery, URL download, and History.
