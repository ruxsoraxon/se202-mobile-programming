import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../services/flower_classifier.dart';
import '../theme/app_theme.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({required this.record, super.key});

  final ClassificationRecord record;

  @override
  Widget build(BuildContext context) {
    final best = record.bestPrediction;
    return Scaffold(
      appBar: AppBar(title: const Text('Flower result')),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: AspectRatio(
                aspectRatio: 1.15,
                child: Image.file(record.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 22),
            const Text('BEST MATCH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Color(0xFF668071),
                )),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(19),
                child: Row(children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE5EEE8), shape: BoxShape.circle),
                    child: const Icon(Icons.local_florist_rounded,
                        color: AppTheme.green, size: 29),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_title(best.label),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        Text('${(best.confidence * 100).round()}% match',
                            style: const TextStyle(color: Color(0xFF668071))),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 22),
            Text('Other possibilities',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 10),
            for (final prediction in record.predictions.skip(1))
              Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: _PredictionRow(prediction: prediction),
              ),
            const SizedBox(height: 10),
            Text('Photo from ${record.source}',
                style: const TextStyle(color: Color(0xFF728176))),
            const SizedBox(height: 5),
            Text(
                'Model inference: ${record.modelInferenceTime.inMilliseconds} ms',
                style: const TextStyle(color: Color(0xFF728176))),
            const SizedBox(height: 8),
            const Text(
              'Confidence is the model’s score for these classes, not a guarantee that the prediction is correct.',
              style: TextStyle(color: Color(0xFF728176), height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _PredictionRow extends StatelessWidget {
  const _PredictionRow({required this.prediction});
  final FlowerPrediction prediction;

  @override
  Widget build(BuildContext context) {
    final double confidence = prediction.confidence;
    final String label = prediction.label;
    return Column(children: [
      Row(children: [
        Expanded(child: Text(_title(label))),
        Text('${(confidence * 100).round()}%',
            style: const TextStyle(color: Color(0xFF718177))),
      ]),
      const SizedBox(height: 7),
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: confidence,
          minHeight: 6,
          backgroundColor: const Color(0xFFE9EDE6),
          color: const Color(0xFF8CAB91),
        ),
      ),
    ]);
  }
}

String _title(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
