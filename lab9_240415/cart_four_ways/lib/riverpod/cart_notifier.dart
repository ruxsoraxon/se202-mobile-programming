import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>((ref) => CheckoutApi());
final cartProvider = NotifierProvider.autoDispose<CartNotifier, CartState>(
  CartNotifier.new,
);

final canUndoProvider = Provider.autoDispose<bool>((ref) {
  ref.watch(cartProvider);
  return ref.read(cartProvider.notifier).canUndo;
});

class CartNotifier extends Notifier<CartState> {
  final List<CartState> _history = [];

  bool get canUndo => _history.isNotEmpty;

  @override
  CartState build() => const CartState();

  void _commit(CartState next) {
    next = next.copyWith(
      status: CheckoutStatus.idle,
      clearOrderId: true,
      clearCheckoutError: true,
    );
    if (next == state) return;
    _history.add(state);
    state = next;
  }

  void add(Product product) =>
      _commit(state.copyWith(lines: state.lines.withProduct(product)));

  void changeQty(String id, int delta) =>
      _commit(state.copyWith(lines: state.lines.changeQty(id, delta)));

  void applyCoupon(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    _commit(
      code == 'SAVE10'
          ? state.copyWith(coupon: code, clearCouponError: true)
          : state.copyWith(couponError: 'Invalid coupon code'),
    );
  }

  void undo() {
    if (_history.isEmpty) return;
    state = _history.removeLast();
  }

  Future<void> checkout() async {
    state = state.copyWith(
      status: CheckoutStatus.submitting,
      clearCheckoutError: true,
    );
    try {
      final order = await ref.read(checkoutApiProvider).submit(state.total);
      if (!ref.mounted) return;
      final successfulState = state.copyWith(
        lines: const [],
        clearCoupon: true,
        clearCouponError: true,
        status: CheckoutStatus.success,
        orderId: order,
      );
      if (state.lines.isNotEmpty || state.coupon != null) {
        _history.add(
          state.copyWith(status: CheckoutStatus.idle, clearCheckoutError: true),
        );
      }
      state = successfulState;
    } on CheckoutException catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: error.message,
      );
    }
  }
}
