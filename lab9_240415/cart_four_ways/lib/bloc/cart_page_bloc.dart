import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../widgets/cart_body.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_bloc.dart';
import 'cart_event.dart';

class CartPageBloc extends StatelessWidget {
  const CartPageBloc({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => CartBloc(), child: const _BlocCartView());
}

class _BlocCartView extends StatelessWidget {
  const _BlocCartView();

  @override
  Widget build(BuildContext context) => BlocListener<CartBloc, CartState>(
    listenWhen: (previous, current) => previous.status != current.status,
    listener: (context, state) {
      if (state.status == CheckoutStatus.failure) {
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
      } else if (state.status == CheckoutStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order placed: ${state.orderId}')),
        );
      }
    },
    child: Scaffold(
      appBar: AppBar(title: const Text('Cart · BLoC')),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: CartBody(
                state: state,
                onAdd: (product) =>
                    context.read<CartBloc>().add(ProductAdded(product)),
                onQtyChanged: (id, delta) =>
                    context.read<CartBloc>().add(QuantityChanged(id, delta)),
                onApplyCoupon: (code) =>
                    context.read<CartBloc>().add(CouponApplied(code)),
              ),
            ),
            CheckoutBar(
              state: state,
              onCheckout: () =>
                  context.read<CartBloc>().add(const CheckoutRequested()),
            ),
          ],
        ),
      ),
    ),
  );
}
