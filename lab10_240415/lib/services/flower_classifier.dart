import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class FlowerPrediction {
  const FlowerPrediction({required this.label, required this.confidence});
  final String label;
  final double confidence;
}

class FlowerClassifier {
  FlowerClassifier._(this._interpreter, this._labels, this._inputSize);

  final Interpreter _interpreter;
  final List<String> _labels;
  final int _inputSize;
  Duration _lastInferenceTime = Duration.zero;

  List<String> get labels => _labels;
  int get inputSize => _inputSize;
  Duration get lastInferenceTime => _lastInferenceTime;

  static Future<FlowerClassifier> load() async {
    final interpreter = await Interpreter.fromAsset(
      'assets/model/model_unquant.tflite',
      options: InterpreterOptions()..threads = 4,
    );
    final inputShape = interpreter.getInputTensor(0).shape;
    if (inputShape.length != 4 || inputShape[3] != 3) {
      interpreter.close();
      throw StateError(
          'Expected an RGB image model; got input shape $inputShape.');
    }
    try {
      final rawLabels = await rootBundle.loadString('assets/model/labels.txt');
      final labels = parseLabels(rawLabels);
      final outputShape = interpreter.getOutputTensor(0).shape;
      if (labels.length != outputShape.last) {
        throw StateError(
          'The model returns ${outputShape.last} classes, but labels.txt has ${labels.length}.',
        );
      }
      return FlowerClassifier._(interpreter, labels, inputShape[1]);
    } catch (_) {
      interpreter.close();
      rethrow;
    }
  }

  Future<List<FlowerPrediction>> classify(File file) async {
    final bytes = await file.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const FormatException('This image could not be opened.');
    }
    final square = img.copyResizeCropSquare(decoded, size: _inputSize);
    final input = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(_inputSize, (x) {
          final pixel = square.getPixel(x, y);
          return [
            pixel.r / 127.5 - 1,
            pixel.g / 127.5 - 1,
            pixel.b / 127.5 - 1
          ];
        }),
      ),
    );
    final outputShape = _interpreter.getOutputTensor(0).shape;
    final output = List.generate(
        outputShape[0], (_) => List.filled(outputShape.last, 0.0));
    final stopwatch = Stopwatch()..start();
    _interpreter.run(input, output);
    stopwatch.stop();
    _lastInferenceTime = stopwatch.elapsed;
    final scores = output.first.map((value) => value.toDouble()).toList();
    // Quantized and floating Teachable Machine exports generally return
    // probabilities. Normalize only if numerical output is outside that range.
    if (scores.any((score) => !score.isFinite || score < 0 || score > 1.01)) {
      final maxScore = scores.reduce((a, b) => a > b ? a : b);
      final exponentials =
          scores.map((score) => math.exp(score - maxScore)).toList();
      final total = exponentials.reduce((a, b) => a + b);
      for (var i = 0; i < scores.length; i++) {
        scores[i] = exponentials[i] / total;
      }
    }
    final predictions = [
      for (var i = 0; i < scores.length; i++)
        FlowerPrediction(
            label: _labels[i],
            confidence: scores[i].clamp(0.0, 1.0).toDouble()),
    ]..sort((a, b) => b.confidence.compareTo(a.confidence));
    return predictions;
  }

  void close() => _interpreter.close();
}

/// Parses Teachable Machine's labels.txt format, including optional numeric
/// prefixes, Windows newlines, blank lines, and labels containing spaces.
List<String> parseLabels(String rawLabels) => rawLabels
    .split(RegExp(r'\r?\n'))
    .map((line) {
      final match = RegExp(r'^\s*\d+\s+(.+?)\s*$').firstMatch(line);
      return match?.group(1) ?? line.trim();
    })
    .where((label) => label.isNotEmpty)
    .toList(growable: false);
