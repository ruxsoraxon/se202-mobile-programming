import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    required this.classCount,
    required this.history,
    required this.onClassify,
    required this.onOpenRecord,
    required this.onOpenHistory,
    super.key,
  });

  final int classCount;
  final List<ClassificationRecord> history;
  final VoidCallback onClassify;
  final ValueChanged<ClassificationRecord> onOpenRecord;
  final VoidCallback onOpenHistory;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
              sliver: SliverList.list(children: [
                Row(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppTheme.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.local_florist_rounded,
                        color: Colors.white),
                  ),
                  const SizedBox(width: 11),
                  Text('bloom',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          )),
                  const Spacer(),
                  _StatusChip(classCount: classCount),
                ]),
                const SizedBox(height: 32),
                Text('A little closer to\nnature.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.06,
                          letterSpacing: -1.4,
                        )),
                const SizedBox(height: 12),
                Text(
                  'Discover a flower with a photo. Bloom runs its model right here on your device.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: const Color(0xFF65766C),
                      ),
                ),
                const SizedBox(height: 24),
                _HeroCard(onClassify: onClassify),
                const SizedBox(height: 26),
                Row(children: [
                  Expanded(
                    child: Text('Recent discoveries',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                )),
                  ),
                  if (history.isNotEmpty)
                    TextButton(
                      onPressed: onOpenHistory,
                      child: const Text('See all'),
                    ),
                ]),
                const SizedBox(height: 8),
                if (history.isEmpty)
                  const _EmptyRecent()
                else
                  for (final record in history.take(2))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _RecentRecord(
                        record: record,
                        onTap: () => onOpenRecord(record),
                      ),
                    ),
                const SizedBox(height: 18),
                Row(children: [
                  const Icon(Icons.shield_outlined,
                      size: 17, color: AppTheme.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Private by nature · your photos stay on-device',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF728176),
                            )),
                  ),
                ]),
              ]),
            ),
          ],
        ),
      );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.classCount});
  final int classCount;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE5EEE8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.circle, size: 8, color: AppTheme.green),
          const SizedBox(width: 7),
          Text('$classCount flowers',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.green,
              )),
        ]),
      );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.onClassify});
  final VoidCallback onClassify;

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE7EEDF), Color(0xFFD9E8D9)],
          ),
        ),
        child: Stack(children: [
          const Positioned(
            top: 13,
            right: 22,
            child: Icon(Icons.local_florist_rounded,
                size: 82, color: Color(0x66C87C78)),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.photo_camera_back_outlined,
                    size: 28, color: AppTheme.green),
                const SizedBox(height: 34),
                Text('What’s blooming?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        )),
                const SizedBox(height: 7),
                const Text('Take a picture or choose one to get started.'),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: onClassify,
                  icon: const Icon(Icons.search_rounded),
                  label: const Text('Identify a flower'),
                ),
              ],
            ),
          ),
        ]),
      );
}

class _EmptyRecent extends StatelessWidget {
  const _EmptyRecent();

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(children: [
            const Icon(Icons.eco_outlined, color: AppTheme.green),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Your flower identifications will appear here.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF65766C),
                      )),
            ),
          ]),
        ),
      );
}

class _RecentRecord extends StatelessWidget {
  const _RecentRecord({required this.record, required this.onTap});
  final ClassificationRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(record.image,
                    width: 54, height: 54, fit: BoxFit.cover),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_title(record.bestPrediction.label),
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text(
                        '${(record.bestPrediction.confidence * 100).round()}% · ${record.source}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF728176),
                            )),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ]),
          ),
        ),
      );
}

String _title(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
