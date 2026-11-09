import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';

class CartPageSetState extends StatefulWidget {
  const CartPageSetState({super.key});

  @override
  State<CartPageSetState> createState() => _CartPageSetStateState();
}

class _CartPageSetStateState extends State<CartPageSetState> {
  final _api = CheckoutApi();
  List<CartLine> _lines = const [];
  bool _checkingOut = false;

  Future<void> _checkout() async {
    setState(() => _checkingOut = true);
    try {
      final order = await _api.submit(_lines.subtotal);
      if (!mounted) return;
      setState(() => _lines = const []);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed: $order')));
    } on CheckoutException catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    } finally {
      if (mounted) setState(() => _checkingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Expanded(child: CartBody(lines: _lines,
          onAdd: (product) => setState(() => _lines = _lines.withProduct(product)),
          onRemove: (id) => setState(() => _lines = _lines.without(id)))),
        CheckoutBar(lines: _lines, busy: _checkingOut, onCheckout: _checkout),
      ]);
}

class CheckoutBar extends StatelessWidget {
  const CheckoutBar({super.key, required this.lines, required this.busy, required this.onCheckout});
  final List<CartLine> lines;
  final bool busy;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: lines.isEmpty || busy ? null : onCheckout,
          icon: busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.shopping_bag_outlined),
          label: Text(busy ? 'Processing…' : 'Checkout · ${lines.subtotal.toStringAsFixed(2)}'),
        )),
      );
}
