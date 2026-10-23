import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Demo toggle: when true the simulated balance request fails.
final balanceFailsProvider = StateProvider<bool>((ref) => false);

Future<double> _fetchBalance({required bool fail}) async {
  await Future<void>.delayed(const Duration(milliseconds: 600));
  if (fail) throw Exception('Balance service unavailable');
  return 12345.67;
}

/// One-shot request. AsyncValue.guard catches the exception and returns it
/// as a value, so this provider itself always ends as AsyncData.
final balanceProvider = FutureProvider.autoDispose<AsyncValue<double>>((ref) {
  final fail = ref.watch(balanceFailsProvider);
  return AsyncValue.guard(() => _fetchBalance(fail: fail));
});