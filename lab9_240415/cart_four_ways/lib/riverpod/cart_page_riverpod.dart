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
    final canUndo = ref.watch(canUndoProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart · Riverpod'),
        actions: [
          TextButton.icon(
            onPressed: canUndo ? cart.undo : null,
            icon: const Icon(Icons.undo),
            label: const Text('Undo'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: CartBody(
              state: state,
              onAdd: cart.add,
              onQtyChanged: cart.changeQty,
              onApplyCoupon: cart.applyCoupon,
              showSummary: false,
            ),
          ),
          const _RiverpodSummaryCard(),
          CheckoutBar(state: state, onCheckout: cart.checkout),
        ],
      ),
    );
  }
}

class _RiverpodSummaryCard extends ConsumerWidget {
  const _RiverpodSummaryCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final total = ref.watch(cartProvider.select((state) => state.total));
    final state = ref.read(cartProvider);
    debugPrint('Riverpod summary rebuild: total=$total');
    return CartSummary(state: state);
  }
}
