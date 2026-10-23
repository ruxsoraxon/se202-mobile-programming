import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ticker_providers.dart';
import 'tick_row.dart';

/// One row that watches only its own symbol and flashes green or red for
/// 300 ms when its price moves. The flash is started from ref.listen and an
/// AnimationController drives it, so there is no setState.
class SymbolTickRow extends ConsumerStatefulWidget {
  const SymbolTickRow(this.symbol, {super.key});
  final String symbol;

  @override
  ConsumerState<SymbolTickRow> createState() => _SymbolTickRowState();
}

class _SymbolTickRowState extends ConsumerState<SymbolTickRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flash = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
    value: 1, // start finished, so no colour is drawn until the first flash
  );
  Color _flashColor = Colors.transparent;

  @override
  void dispose() {
    _flash.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final symbol = widget.symbol;
    debugPrint('rebuild $symbol'); // shows which rows rebuild

    ref.listen(tickProvider(symbol), (_, next) {
      final tick = next.value;
      if (tick == null) return;
      _flashColor = tick.isUp ? Colors.green : Colors.red;
      _flash.forward(from: 0);
    });

    final tick = ref.watch(tickProvider(symbol));
    final row = switch (tick) {
      AsyncData(:final value) => TickRow(value),
      AsyncError(:final error) => ListTile(title: Text('$symbol: $error')),
      AsyncLoading() => ListTile(title: Text(symbol), subtitle: const Text('...')),
    };

    return AnimatedBuilder(
      animation: _flash,
      child: row,
      builder: (context, child) => ColoredBox(
        color: _flashColor.withValues(alpha: 0.3 * (1 - _flash.value)),
        child: child,
      ),
    );
  }
}
