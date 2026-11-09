import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/cart_body.dart';
import '../setstate/cart_page_setstate.dart' show CheckoutBar;
import 'cart_bloc.dart';
import 'cart_event.dart';

class CartPageBloc extends StatelessWidget {
  const CartPageBloc({super.key});
  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CartBloc(),
        child: BlocListener<CartBloc, CartState>(
          listenWhen: (previous, current) => current.message != null && previous.message != current.message,
          listener: (context, state) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!))),
          child: const _BlocCartView(),
        ),
      );
}

class _BlocCartView extends StatelessWidget {
  const _BlocCartView();
  @override
  Widget build(BuildContext context) => BlocBuilder<CartBloc, CartState>(
        builder: (context, state) => Column(children: [
          Expanded(child: CartBody(lines: state.lines,
            onAdd: (product) => context.read<CartBloc>().add(ProductAdded(product)),
            onRemove: (id) => context.read<CartBloc>().add(ProductRemoved(id)))),
          CheckoutBar(lines: state.lines, busy: state.checkingOut,
            onCheckout: () => context.read<CartBloc>().add(CheckoutRequested())),
        ]),
      );
}
