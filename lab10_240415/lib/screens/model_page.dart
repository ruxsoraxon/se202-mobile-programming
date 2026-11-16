import 'package:flutter/material.dart';

import '../services/flower_classifier.dart';
import '../theme/app_theme.dart';

class ModelPage extends StatelessWidget {
  const ModelPage({required this.classifier, super.key});

  final FlowerClassifier classifier;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            sliver: SliverList.list(children: [
              Text('About the model',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.7,
                      )),
              const SizedBox(height: 8),
              const Text(
                'Bloom uses a Teachable Machine image model bundled with the app.',
                style: TextStyle(color: Color(0xFF65766C), height: 1.45),
              ),
              const SizedBox(height: 22),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                              color: Color(0xFFE5EEE8), shape: BoxShape.circle),
                          child: const Icon(Icons.memory_rounded,
                              color: AppTheme.green),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Flower image classifier',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              const Text('TensorFlow Lite · on-device'),
                            ],
                          ),
                        ),
                      ]),
                      const SizedBox(height: 20),
                      const Divider(height: 1),
                      const SizedBox(height: 14),
                      _FactRow(
                          label: 'Classes',
                          value: '${classifier.labels.length}'),
                      _FactRow(
                          label: 'Input',
                          value:
                              '${classifier.inputSize} × ${classifier.inputSize} RGB'),
                      const _FactRow(
                          label: 'Network', value: 'MobileNet image model'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Recognized flowers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 12),
              for (var index = 0; index < classifier.labels.length; index++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _ClassRow(
                    number: index + 1,
                    label: classifier.labels[index],
                  ),
                ),
              const SizedBox(height: 16),
              const _ModelNote(),
            ]),
          ),
        ]),
      );
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(children: [
          Expanded(
            child:
                Text(label, style: const TextStyle(color: Color(0xFF728176))),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ]),
      );
}

class _ClassRow extends StatelessWidget {
  const _ClassRow({required this.number, required this.label});
  final int number;
  final String label;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(children: [
            Container(
              width: 29,
              height: 29,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Color(0xFFE5EEE8), shape: BoxShape.circle),
              child: Text('$number',
                  style: const TextStyle(
                      color: AppTheme.green, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(width: 12),
            Text(_title(label),
                style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(Icons.local_florist_outlined,
                size: 19, color: AppTheme.green),
          ]),
        ),
      );
}

class _ModelNote extends StatelessWidget {
  const _ModelNote();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4DE),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline_rounded, color: Color(0xFF98733A)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Predictions are estimates. This model only knows the classes listed above and can be confidently wrong on unfamiliar photos.',
                style: TextStyle(color: Color(0xFF705B37), height: 1.4),
              ),
            ),
          ],
        ),
      );
}

String _title(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
