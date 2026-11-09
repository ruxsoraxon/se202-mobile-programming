import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../widgets/cart_body.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_cubit.dart';

class CartPageCubit extends StatelessWidget {
  const CartPageCubit({super.key});
  @override
  Widget build(BuildContext context) =>
      BlocProvider(create: (_) => CartCubit(), child: const _CubitCartView());
}

class _CubitCartView extends StatelessWidget {
  const _CubitCartView();
  @override
  Widget build(BuildContext context) => BlocListener<CartCubit, CartState>(
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
      appBar: AppBar(title: const Text('Cart · Cubit')),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: CartBody(
                state: state,
                onAdd: context.read<CartCubit>().add,
                onQtyChanged: context.read<CartCubit>().changeQty,
                onApplyCoupon: context.read<CartCubit>().applyCoupon,
              ),
            ),
            CheckoutBar(
              state: state,
              onCheckout: context.read<CartCubit>().checkout,
            ),
          ],
        ),
      ),
    ),
  );
}
