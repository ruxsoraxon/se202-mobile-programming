import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import 'cart_event.dart';

class CartState {
  const CartState({this.lines = const [], this.checkingOut = false, this.message});
  final List<CartLine> lines;
  final bool checkingOut;
  final String? message;
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<ProductAdded>((event, emit) => emit(CartState(lines: state.lines.withProduct(event.product))));
    on<ProductRemoved>((event, emit) => emit(CartState(lines: state.lines.without(event.id))));
    on<CheckoutRequested>(_checkout);
  }
  final _api = CheckoutApi();
  Future<void> _checkout(CheckoutRequested event, Emitter<CartState> emit) async {
    emit(CartState(lines: state.lines, checkingOut: true));
    try {
      final order = await _api.submit(state.lines.subtotal);
      emit(CartState(message: 'Order placed: $order'));
    } on CheckoutException catch (error) {
      emit(CartState(lines: state.lines, message: error.message));
    }
  }
}
