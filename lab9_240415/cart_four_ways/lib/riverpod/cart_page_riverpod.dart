import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/cart_body.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_notifier.dart';

class CartPageRiverpod extends ConsumerWidget {
  const CartPageRiverpod({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cartProvider.select((state) => state.message), (previous, message) {
      if (message != null && message != previous) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        ref.read(cartProvider.notifier).clearMessage();
      }
    });
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    return Column(children: [
      Expanded(child: CartBody(lines: state.lines, onAdd: cart.add, onRemove: cart.remove)),
      CheckoutBar(lines: state.lines, busy: state.checkingOut, onCheckout: cart.checkout),
    ]);
  }
}
