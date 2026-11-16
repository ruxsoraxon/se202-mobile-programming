import 'package:flutter/material.dart';

import '../services/flower_classifier.dart';
import '../theme/app_theme.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({
    required this.classifier,
    required this.onContinue,
    super.key,
  });

  final FlowerClassifier classifier;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 26, 26, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const _BloomMark(),
                    const SizedBox(width: 12),
                    Text('bloom',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
                const Spacer(),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFE9F0E2), Color(0xFFD7E6D8)],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.local_florist_rounded,
                          size: 156,
                          color: AppTheme.green.withValues(alpha: .82)),
                      const Positioned(
                        top: 40,
                        right: 43,
                        child: Icon(Icons.auto_awesome,
                            size: 34, color: Color(0xFFE4A554)),
                      ),
                      const Positioned(
                        bottom: 48,
                        left: 40,
                        child: Icon(Icons.spa_rounded,
                            size: 36, color: Color(0xFFC87C78)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text('Meet the flowers\naround you.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                          letterSpacing: -1.3,
                        )),
                const SizedBox(height: 14),
                Text(
                  'Identify one of ${classifier.labels.length} flowers with an on-device image model.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: const Color(0xFF65766C),
                      ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: onContinue,
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Explore Bloom'),
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text('Your photos stay on your device',
                      style: TextStyle(fontSize: 12, color: Color(0xFF728176))),
                ),
              ],
            ),
          ),
        ),
      );
}

class _BloomMark extends StatelessWidget {
  const _BloomMark();

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.green,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.local_florist_rounded, color: Colors.white),
      );
}
