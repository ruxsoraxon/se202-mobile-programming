import 'package:flutter/material.dart';

import '../models/classification_record.dart';
import '../theme/app_theme.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    required this.records,
    required this.onOpenRecord,
    super.key,
  });

  final List<ClassificationRecord> records;
  final ValueChanged<ClassificationRecord> onOpenRecord;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomScrollView(slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            sliver: SliverList.list(children: [
              Text('Your discoveries',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.7,
                      )),
              const SizedBox(height: 8),
              Text(
                records.isEmpty
                    ? 'Photos you identify will be collected here during this session.'
                    : '${records.length} ${records.length == 1 ? 'flower' : 'flowers'} identified this session',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF65766C),
                    ),
              ),
              const SizedBox(height: 22),
              if (records.isEmpty)
                const _HistoryEmptyState()
              else
                for (final record in records)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HistoryTile(
                      record: record,
                      onTap: () => onOpenRecord(record),
                    ),
                  ),
            ]),
          ),
        ]),
      );
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                  color: Color(0xFFE5EEE8), shape: BoxShape.circle),
              child: const Icon(Icons.local_florist_outlined,
                  color: AppTheme.green, size: 34),
            ),
            const SizedBox(height: 16),
            Text('Nothing in your garden yet',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 7),
            const Text(
              'Identify a flower and your result will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF65766C), height: 1.4),
            ),
          ]),
        ),
      );
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record, required this.onTap});

  final ClassificationRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final prediction = record.bestPrediction;
    final date = record.createdAt;
    final timestamp =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')} · ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(record.image,
                  width: 70, height: 70, fit: BoxFit.cover),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title(prediction.label),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                  const SizedBox(height: 4),
                  Text(
                      '${(prediction.confidence * 100).round()}% match · ${record.source}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF65766C),
                          )),
                  const SizedBox(height: 4),
                  Text(timestamp,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: const Color(0xFF8A968C),
                          )),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF708176)),
          ]),
        ),
      ),
    );
  }
}

String _title(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';
