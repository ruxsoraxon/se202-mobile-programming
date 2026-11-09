import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';

class CartState {
  const CartState({this.lines = const [], this.checkingOut = false});
  final List<CartLine> lines;
  final bool checkingOut;
  CartState copyWith({List<CartLine>? lines, bool? checkingOut}) =>
      CartState(lines: lines ?? this.lines, checkingOut: checkingOut ?? this.checkingOut);
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());
  final _api = CheckoutApi();
  void add(Product product) => emit(state.copyWith(lines: state.lines.withProduct(product)));
  void remove(String id) => emit(state.copyWith(lines: state.lines.without(id)));
  Future<String> checkout() async {
    emit(state.copyWith(checkingOut: true));
    try {
      final order = await _api.submit(state.lines.subtotal);
      emit(state.copyWith(lines: const []));
      return order;
    } finally {
      emit(state.copyWith(checkingOut: false));
    }
  }
}
