import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

final checkoutApiProvider = Provider<CheckoutApi>((ref) => CheckoutApi());
final cartProvider = NotifierProvider<CartNotifier, CartState>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  void add(Product product) =>
      state = state.copyWith(lines: state.lines.withProduct(product));
  void changeQty(String id, int delta) =>
      state = state.copyWith(lines: state.lines.changeQty(id, delta));
  void applyCoupon(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    state = code == 'SAVE10'
        ? state.copyWith(coupon: code, clearCouponError: true)
        : state.copyWith(couponError: 'Invalid coupon code');
  }

  Future<void> checkout() async {
    state = state.copyWith(
      status: CheckoutStatus.submitting,
      clearCheckoutError: true,
    );
    try {
      final order = await ref.read(checkoutApiProvider).submit(state.total);
      state = state.copyWith(
        lines: const [],
        clearCoupon: true,
        clearCouponError: true,
        status: CheckoutStatus.success,
        orderId: order,
      );
    } on CheckoutException catch (error) {
      state = state.copyWith(
        status: CheckoutStatus.failure,
        checkoutError: error.message,
      );
    }
  }
}
