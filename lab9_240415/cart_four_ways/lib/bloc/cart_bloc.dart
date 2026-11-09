import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._api) : super(const CartState()) {
    on<ProductAdded>(
      (event, emit) => _update(
        emit,
        state.copyWith(lines: state.lines.withProduct(event.product)),
      ),
    );
    on<QuantityChanged>(
      (event, emit) => _update(
        emit,
        state.copyWith(lines: state.lines.changeQty(event.id, event.delta)),
      ),
    );
    on<CouponApplied>((event, emit) {
      final code = event.code.trim().toUpperCase();
      _update(
        emit,
        code == 'SAVE10'
            ? state.copyWith(coupon: code, clearCouponError: true)
            : state.copyWith(couponError: 'Invalid coupon code'),
      );
    });
    on<CheckoutRequested>(_checkout);
    on<UndoRequested>((event, emit) {
      if (_history.isEmpty) return;
      final previous = _history.removeLast();
      emit(previous.copyWith(canUndo: _history.isNotEmpty));
    });
  }

  final CheckoutApi _api;
  final List<CartState> _history = [];

  void _update(Emitter<CartState> emit, CartState next) {
    if (next == state) return;
    _history.add(state);
    emit(next.copyWith(canUndo: true));
  }

  @override
  void onChange(Change<CartState> change) {
    super.onChange(change);
    // Equal states are filtered by Bloc before onChange, demonstrating deduplication.
    // ignore: avoid_print
    print(
      'CartBloc: ${change.nextState.status}, '
      '${change.nextState.itemCount} items, total ${change.nextState.total}',
    );
  }

  Future<void> _checkout(
    CheckoutRequested event,
    Emitter<CartState> emit,
  ) async {
    final checkoutTotal = state.total;
    emit(
      state.copyWith(
        status: CheckoutStatus.submitting,
        clearCheckoutError: true,
      ),
    );
    try {
      final order = await _api.submit(checkoutTotal);
      if (emit.isDone) return;
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
