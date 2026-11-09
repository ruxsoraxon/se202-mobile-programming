import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<ProductAdded>(
      (event, emit) =>
          emit(state.copyWith(lines: state.lines.withProduct(event.product))),
    );
    on<QuantityChanged>(
      (event, emit) => emit(
        state.copyWith(lines: state.lines.changeQty(event.id, event.delta)),
      ),
    );
    on<CouponApplied>((event, emit) {
      final code = event.code.trim().toUpperCase();
      emit(
        code == 'SAVE10'
            ? state.copyWith(coupon: code, clearCouponError: true)
            : state.copyWith(couponError: 'Invalid coupon code'),
      );
    });
    on<CheckoutRequested>(_checkout);
  }

  final _api = CheckoutApi();
  Future<void> _checkout(
    CheckoutRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(
      state.copyWith(
        status: CheckoutStatus.submitting,
        clearCheckoutError: true,
      ),
    );
    try {
      final order = await _api.submit(state.total);
      if (emit.isDone) return;
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
      if (emit.isDone) return;
      emit(
        state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: error.message,
        ),
      );
    }
  }
}
