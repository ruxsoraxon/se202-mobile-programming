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
  CartState _state = const CartState();
  final List<CartState> _history = [];

  void _mutate(CartState next) {
    _history.add(_state);
    setState(
      () => _state = next.copyWith(
        status: CheckoutStatus.idle,
        clearOrderId: true,
        clearCheckoutError: true,
      ),
    );
  }

  void _add(Product product) =>
      _mutate(_state.copyWith(lines: _state.lines.withProduct(product)));
  void _changeQty(String id, int delta) =>
      _mutate(_state.copyWith(lines: _state.lines.changeQty(id, delta)));

  void _applyCoupon(String rawCode) {
    final code = rawCode.trim().toUpperCase();
    if (code == 'SAVE10') {
      _mutate(_state.copyWith(coupon: code, clearCouponError: true));
    } else {
      _mutate(_state.copyWith(couponError: 'Invalid coupon code'));
    }
  }

  void _undo() {
    if (_history.isEmpty) return;
    setState(() => _state = _history.removeLast());
  }

  Future<void> _checkout() async {
    setState(
      () => _state = _state.copyWith(
        status: CheckoutStatus.submitting,
        clearCheckoutError: true,
      ),
    );
    try {
      final order = await _api.submit(_state.total);
      if (!mounted) return;
      _history.add(_state.copyWith(status: CheckoutStatus.idle));
      setState(
        () => _state = _state.copyWith(
          lines: const [],
          clearCoupon: true,
          clearCouponError: true,
          status: CheckoutStatus.success,
          orderId: order,
        ),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Order placed: $order')));
    } on CheckoutException catch (error) {
      if (!mounted) return;
      setState(
        () => _state = _state.copyWith(
          status: CheckoutStatus.failure,
          checkoutError: error.message,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Cart · setState'),
      actions: [
        TextButton.icon(
          onPressed: _history.isEmpty ? null : _undo,
          icon: const Icon(Icons.undo),
          label: const Text('Undo'),
        ),
      ],
    ),
    body: Column(
      children: [
        if (_state.status == CheckoutStatus.failure)
          MaterialBanner(
            content: Text(_state.checkoutError ?? 'Checkout failed'),
            leading: const Icon(Icons.error_outline),
            actions: [
              TextButton(
                onPressed: () => setState(
                  () => _state = _state.copyWith(
                    status: CheckoutStatus.idle,
                    clearCheckoutError: true,
                  ),
                ),
                child: const Text('Dismiss'),
              ),
            ],
          ),
        Expanded(
          child: CartBody(
            state: _state,
            onAdd: _add,
            onQtyChanged: _changeQty,
            onApplyCoupon: _applyCoupon,
            showSummary: false,
          ),
        ),
        CartSummary(state: _state),
        CheckoutBar(state: _state, onCheckout: _checkout),
      ],
    ),
  );
}

class CheckoutBar extends StatelessWidget {
  const CheckoutBar({super.key, required this.state, required this.onCheckout});
  final CartState state;
  final VoidCallback onCheckout;

  @override
  Widget build(BuildContext context) {
    final busy = state.status == CheckoutStatus.submitting;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: state.lines.isEmpty || busy ? null : onCheckout,
          icon: busy
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.shopping_bag_outlined),
          label: Text(
            busy
                ? 'Processing…'
                : 'Checkout · ${state.total.toStringAsFixed(2)}',
          ),
        ),
      ),
    );
  }
}
