import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ticker_providers.dart';
import 'tick_row.dart';

class SymbolTickRow extends ConsumerWidget {
  const SymbolTickRow(this.symbol, {super.key});
  final String symbol;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('rebuild $symbol'); // shows which rows rebuild
    final tick = ref.watch(tickProvider(symbol));
    return switch (tick) {
      AsyncData(:final value) => TickRow(value),
      AsyncError(:final error) => ListTile(title: Text('$symbol: $error')),
      AsyncLoading() => ListTile(title: Text(symbol), subtitle: const Text('...')),
    };
  }
}