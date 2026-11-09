import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_cubit.dart';

class CartPageCubit extends StatelessWidget {
  const CartPageCubit({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CartCubit(),
        child: const _CubitCartView(),
      );
}

class _CubitCartView extends StatelessWidget {
  const _CubitCartView();
  @override
  Widget build(BuildContext context) => BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => Column(children: [
          Expanded(child: CartBody(lines: state.lines,
            onAdd: context.read<CartCubit>().add,
            onRemove: context.read<CartCubit>().remove)),
          CheckoutBar(lines: state.lines, busy: state.checkingOut, onCheckout: () => _checkout(context)),
        ]),
      );

  Future<void> _checkout(BuildContext context) async {
    try {
      final order = await context.read<CartCubit>().checkout();
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed: $order')));
    } on CheckoutException catch (error) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}
