import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/cart.dart';
import '../widgets/cart_body.dart';
import '../services/checkout_api.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_cubit.dart';

class CartPageCubit extends StatelessWidget {
  const CartPageCubit({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => CartCubit(CheckoutApi()),
    child: const _CubitCartView(),
  );
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
      appBar: AppBar(
        title: const Text('Cart · Cubit'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (previous, current) =>
                previous.canUndo != current.canUndo,
            builder: (context, state) => TextButton.icon(
              onPressed: state.canUndo ? context.read<CartCubit>().undo : null,
              icon: const Icon(Icons.undo),
              label: const Text('Undo'),
            ),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: CartBody(
                state: state,
                onAdd: context.read<CartCubit>().add,
                onQtyChanged: context.read<CartCubit>().changeQty,
                onApplyCoupon: context.read<CartCubit>().applyCoupon,
                showSummary: false,
              ),
            ),
            BlocSelector<CartCubit, CartState, (List<CartLine>, String?)>(
              selector: (state) => (state.lines, state.coupon),
              builder: (context, summary) {
                debugPrint('Cubit summary rebuilt: ${summary.$1.subtotal}');
                return CartSummary(
                  state: CartState(lines: summary.$1, coupon: summary.$2),
                );
              },
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
