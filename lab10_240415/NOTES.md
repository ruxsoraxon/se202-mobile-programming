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

**Setup checkpoint:** `flutter pub get`, `flutter analyze`, parser tests, and a debug APK build/install have completed successfully. The app bundles the model and labels, uses `image_picker` for camera/gallery, and `http` for image URL imports. The classifier instance is loaded once by the app and shared across screens.

## Part 3 — Classifier

The app loads one `FlowerClassifier` at startup, shares it across the Home, Classifier, and Model screens, and closes it when the app is disposed. The class count comes from the model output tensor and is checked against the number of parsed labels; it is not separately hard-coded. If the model is retrained with a seventh class, replace the model and labels file together with the same export and verify the output shape and predictions.

Changing normalization from `pixel / 127.5 - 1` to `pixel / 255` changes the model input distribution from `[-1, 1]` to `[0, 1]`. The tensor still contains valid floating-point values with the expected shape, so inference can run without crashing, but the inputs no longer match training and the scores can become unreliable.

**Classifier checks:**

- `parseLabels` numbered labels test: **Passed.**
- Windows line endings, blank line, and multiword label test: **Passed.**
- Top predictions and confidence scores were displayed during the 18-image phone evaluation above; a sum check for every output vector is **not recorded**.
- Invalid image and missing-model messages: **Pending verification.**

## Part 4 — Design and screens

**Figma design credit (complete after choosing a reusable Community file):**

- File name: **TODO**
- Author: **TODO**
- Link: **TODO**
- Licence/reuse terms: **TODO**
- Reference exports: `docs/design-1.png` and `docs/design-2.png` (**TODO**)

The app implements Welcome, Home, Classifier, Result, History, and Model screens with a shared `ThemeData` in `lib/theme/app_theme.dart`. One app-owned classifier instance supplies predictions and the labels shown on the Model screen. History is an in-memory session list; it resets when the app process is restarted.

**Two design changes and why:**

1. The Welcome and Home pages use a light botanical palette and a small illustration made from built-in Material icons. This keeps the app visually focused without adding large decorative image assets.
2. Classification results have a dedicated page with a ranked score list and a confidence note. The evaluation showed high-confidence mistakes, so the interface clarifies that confidence is a model score, not a correctness guarantee.

The implementation uses an original Flutter layout; no external Figma Community file or artwork was used. If the instructor requires a Community-file reference specifically, select one and add its author, link, reuse terms, and reference exports before submission.

## Part 5 — Sources and evaluation

The app supports camera capture, gallery selection, and image import from a URL. Gallery and URL imports were exercised on the Samsung SM-A556E, producing the 18 recorded model results below. The updated multi-screen debug APK was also built, installed, and smoke-tested on that phone after it was unlocked.

**Updated-flow smoke check (separate from the 18-image accuracy count):** I verified Welcome → Home, History, Model, Classifier → Gallery → Result, and opening the saved History result. A Tulip photo from `Lab10Eval` predicted **Tulip (100%)**; the measured `Interpreter.run` time was **190 ms**. See [the refactored Result screen](docs/evaluation/tulip-result-refactored.png) and [the timing capture](docs/evaluation/tulip-inference-time.png).

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
- In the original 18-image run, the result screen was visible by the approximately **2-second ADB capture checkpoint** after confirming/importing an image; this is an end-to-end upper bound. The updated-flow smoke check separately measured `Interpreter.run` at **190 ms**; image decoding and preprocessing are outside that timer.
- While classification runs, the selected image is dimmed and a centered circular progress indicator is shown.
- Camera evaluation: **Pending a real flower being presented to the phone camera.** The 18 recorded attempts above use gallery and URL sources only.

**Why can the same object score differently across sources?**

Two training-data reasons are differences in lighting/color balance and differences in framing, distance, angle, or background. These can make a camera photo or downloaded picture look unlike the training examples even when the object is the same.

## Final submission checklist

- [x] Model file and six-line labels file are committed under `assets/model/`.
- [ ] `docs/preview.png` added after previewing the model on a fresh example per class.
- [ ] `docs/design-1.png` and `docs/design-2.png` added; Figma source and licence credited here and in the app.
- [x] Welcome, Home, Result, History, and Model screens implemented; Classifier is a separate screen in the photo flow.
- [x] At least two label-parser tests pass.
- [x] `flutter analyze` is clean.
- [x] Debug APK builds and installs on the Samsung SM-A556E.
- [x] The Result page displays the measured TensorFlow Lite inference duration in milliseconds.
- [x] Updated screen navigation, Gallery → Result, and History → Result were verified on the unlocked Samsung phone; `Interpreter.run` measured 190 ms in the smoke check.
- [ ] Demonstrate the camera with a real flower.
- [x] The written model and data-source checkpoint answers above are complete.
- [x] Camera, Gallery, and URL source flows are implemented.
- [ ] Under-60-second screen recording shows camera, gallery, URL download, and History.
