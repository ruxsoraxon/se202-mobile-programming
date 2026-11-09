import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartViewState {
  const CartViewState({this.lines = const [], this.checkingOut = false, this.message});
  final List<CartLine> lines;
  final bool checkingOut;
  final String? message;
  CartViewState copyWith({List<CartLine>? lines, bool? checkingOut, String? message, bool clearMessage = false}) =>
      CartViewState(lines: lines ?? this.lines, checkingOut: checkingOut ?? this.checkingOut,
        message: clearMessage ? null : message ?? this.message);
}

final cartProvider = NotifierProvider<CartNotifier, CartViewState>(CartNotifier.new);

class CartNotifier extends Notifier<CartViewState> {
  final _api = CheckoutApi();
  @override
  CartViewState build() => const CartViewState();
  void add(Product product) => state = state.copyWith(lines: state.lines.withProduct(product), clearMessage: true);
  void remove(String id) => state = state.copyWith(lines: state.lines.without(id), clearMessage: true);
  Future<void> checkout() async {
    state = state.copyWith(checkingOut: true, clearMessage: true);
    try {
      final order = await _api.submit(state.lines.subtotal);
      state = state.copyWith(lines: const [], checkingOut: false, message: 'Order placed: $order');
    } on CheckoutException catch (error) {
      state = state.copyWith(checkingOut: false, message: error.message);
    }
  }
  void clearMessage() => state = state.copyWith(clearMessage: true);
}
