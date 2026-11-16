import 'dart:io';

import '../services/flower_classifier.dart';

class ClassificationRecord {
  const ClassificationRecord({
    required this.image,
    required this.source,
    required this.predictions,
    required this.createdAt,
    required this.modelInferenceTime,
  });

  final File image;
  final String source;
  final List<FlowerPrediction> predictions;
  final DateTime createdAt;
  final Duration modelInferenceTime;

  FlowerPrediction get bestPrediction => predictions.first;
}
