import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/balance_provider.dart';

class BalanceDialog extends ConsumerWidget {
  const BalanceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    final fails = ref.watch(balanceFailsProvider);

    final text = switch (balance) {
      AsyncData(value: AsyncData(:final value)) => 'Balance: ${value.toStringAsFixed(2)}',
      AsyncData(value: AsyncError(:final error)) => 'Guarded error: $error',
      AsyncData(value: AsyncLoading()) => 'Loading...',
      AsyncError(:final error) => 'Provider error: $error',
      AsyncLoading() => 'Loading...',
    };

    return AlertDialog(
      title: const Text('Account balance'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          SwitchListTile(
            title: const Text('Make the request fail'),
            value: fails,
            onChanged: (v) => ref.read(balanceFailsProvider.notifier).state = v,
          ),
        ],
      ),
    );
  }
}