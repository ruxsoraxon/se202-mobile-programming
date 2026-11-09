import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());
  final _api = CheckoutApi();

  void add(Product product) =>
      emit(state.copyWith(lines: state.lines.withProduct(product)));
  void changeQty(String id, int delta) =>
      emit(state.copyWith(lines: state.lines.changeQty(id, delta)));
  void applyCoupon(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    emit(
      code == 'SAVE10'
          ? state.copyWith(coupon: code, clearCouponError: true)
          : state.copyWith(couponError: 'Invalid coupon code'),
    );
  }

  Future<void> checkout() async {
    emit(
      state.copyWith(
        status: CheckoutStatus.submitting,
        clearCheckoutError: true,
      ),
    );
    try {
      final order = await _api.submit(state.total);
      if (isClosed) return;
      emit(
        state.copyWith(
          lines: const [],
          clearCoupon: true,
          clearCouponError: true,
          status: CheckoutStatus.success,
          orderId: order,
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
