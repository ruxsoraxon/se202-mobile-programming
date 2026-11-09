import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._api) : super(const CartState());
  final CheckoutApi _api;
  final List<CartState> _history = [];

  void _update(CartState next) {
    if (next == state) return;
    _history.add(state);
    emit(next.copyWith(canUndo: true));
  }

  void add(Product product) =>
      _update(state.copyWith(lines: state.lines.withProduct(product)));
  void changeQty(String id, int delta) =>
      _update(state.copyWith(lines: state.lines.changeQty(id, delta)));
  void applyCoupon(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    _update(
      code == 'SAVE10'
          ? state.copyWith(coupon: code, clearCouponError: true)
          : state.copyWith(couponError: 'Invalid coupon code'),
    );
  }

  void undo() {
    if (_history.isEmpty) return;
    final previous = _history.removeLast();
    emit(previous.copyWith(canUndo: _history.isNotEmpty));
  }

  Future<void> checkout() async {
    final checkoutTotal = state.total;
    emit(
      state.copyWith(
        status: CheckoutStatus.submitting,
        clearCheckoutError: true,
      ),
    );
    try {
      final order = await _api.submit(checkoutTotal);
      if (isClosed) return;
      _history.add(state.copyWith(status: CheckoutStatus.idle));
      emit(
        state.copyWith(
          lines: const [],
          clearCoupon: true,
          clearCouponError: true,
          status: CheckoutStatus.success,
          orderId: order,
          canUndo: true,
        ),
      );
    } on CheckoutException catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: error.message,
        ),
      );
    }
  }
}
