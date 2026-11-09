import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart.dart';
import '../widgets/cart_body.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_notifier.dart';

class CartPageRiverpod extends ConsumerWidget {
  const CartPageRiverpod({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cartProvider.select((state) => state.status), (
      previous,
      status,
    ) {
      final state = ref.read(cartProvider);
      if (status == CheckoutStatus.failure && previous != status) {
        ScaffoldMessenger.of(context).showMaterialBanner(
          MaterialBanner(
            content: Text(state.checkoutError ?? 'Checkout failed'),
            actions: [
              TextButton(
                onPressed: ScaffoldMessenger.of(context)
                    .hideCurrentMaterialBanner,
                child: const Text('Dismiss'),
              ),
            ],
          ),
        );
      } else if (status == CheckoutStatus.success && previous != status) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed: ${state.orderId}')),
        );
      }
    });
    final state = ref.watch(cartProvider);
    final cart = ref.read(cartProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart · Riverpod')),
      body: Column(
        children: [
          Expanded(
            child: CartBody(
              state: state,
              onAdd: cart.add,
              onQtyChanged: cart.changeQty,
              onApplyCoupon: cart.applyCoupon,
            ),
          ),
          CheckoutBar(state: state, onCheckout: cart.checkout),
        ],
      ),
    );
  }
}
