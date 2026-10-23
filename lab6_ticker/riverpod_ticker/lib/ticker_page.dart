import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/ticker_providers.dart';
import 'widgets/symbol_tick_row.dart';
import 'widgets/tick_row.dart';

import 'widgets/balance_dialog.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticks = ref.watch(tickerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live ticker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Fail after 5 ticks',
            onPressed: () => ref.read(failAfterProvider.notifier).state = 5,
          ),
          IconButton(
            icon: const Icon(Icons.wifi),
            tooltip: 'Stop failing',
            onPressed: () => ref.read(failAfterProvider.notifier).state = null,
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Account balance',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const BalanceDialog(),
            ),
          ),
        ],
      ),
      body: switch (ticks) {
        // Error with stale data: show rows dimmed, banner on top
        AsyncError(:final error, :final value?) => Column(
          children: [
            MaterialBanner(
              content: ListenableBuilder(
                listenable: Listenable.merge([retryAttempt, retryGaveUp]),
                builder: (context, _) {
                  final status = retryGaveUp.value
                      ? ' (gave up after $maxRetries retries)'
                      : retryAttempt.value > 0
                          ? ' (auto retry ${retryAttempt.value} of $maxRetries)'
                          : '';
                  return Text('Feed error: $error, showing last prices$status');
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => retryNow(ref),
                  child: const Text('Retry now'),
                ),
              ],
            ),
            Expanded(
              child: Opacity(
                opacity: 0.5,
                child: ListView(
                  children: [
                    for (final t in value) TickRow(t, key: ValueKey(t.symbol)),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Error with nothing to show
        AsyncError(:final error) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Could not load ticker\n$error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => retryNow(ref),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        // Refresh in progress, keep rows, show thin progress bar
        AsyncValue(:final value?, isLoading: true) => Column(
          children: [
            const LinearProgressIndicator(),
            ListenableBuilder(
              listenable: retryAttempt,
              builder: (context, _) => retryAttempt.value == 0
                  ? const SizedBox.shrink()
                  : Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.errorContainer,
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Feed error, showing last prices '
                        '(auto retry ${retryAttempt.value} of $maxRetries)',
                      ),
                    ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final t in value) SymbolTickRow(t.symbol, key: ValueKey(t.symbol))
                ],
              ),
            ),
          ],
        ),

        AsyncData(value: []) => const Center(
          child: Text('No symbols subscribed'),
        ),
        AsyncData(value: [final only]) => Center(child: TickRow(only)),
                AsyncData(:final value) => RefreshIndicator(
            onRefresh: () => ref.refresh(tickerProvider.future),
            child: ListView(
              children: [for (final t in value) SymbolTickRow(t.symbol, key: ValueKey(t.symbol))],
            ),
          ),

        AsyncLoading() => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
