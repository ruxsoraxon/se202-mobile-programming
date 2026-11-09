import 'package:flutter/material.dart';

import '../models/cart.dart';

class CartBody extends StatefulWidget {
  const CartBody({
    super.key,
    required this.state,
    required this.onAdd,
    required this.onQtyChanged,
    required this.onApplyCoupon,
  });

  final CartState state;
  final void Function(Product) onAdd;
  final void Function(String id, int delta) onQtyChanged;
  final void Function(String code) onApplyCoupon;

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  final _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            children: [
              for (final product in catalog)
                ActionChip(
                  label: Text(
                    '${product.name} · ${product.price.toStringAsFixed(0)}',
                  ),
                  onPressed: () => widget.onAdd(product),
                ),
            ],
          ),
        ),
        Expanded(
          child: state.lines.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView(
                  children: [
                    for (final line in state.lines)
                      ListTile(
                        key: ValueKey(line.product.id),
                        title: Text(line.product.name),
                        subtitle: Text('× ${line.qty}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              key: ValueKey('qty-minus-${line.product.id}'),
                              tooltip: 'Decrease ${line.product.name}',
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () =>
                                  widget.onQtyChanged(line.product.id, -1),
                            ),
                            IconButton(
                              key: ValueKey('qty-plus-${line.product.id}'),
                              tooltip: 'Increase ${line.product.name}',
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () =>
                                  widget.onQtyChanged(line.product.id, 1),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      key: const ValueKey('coupon-field'),
                      controller: _couponController,
                      decoration: InputDecoration(
                        labelText: 'Coupon code',
                        errorText: state.couponError,
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                      onSubmitted: widget.onApplyCoupon,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    key: const ValueKey('apply-coupon'),
                    onPressed: () =>
                        widget.onApplyCoupon(_couponController.text),
                    child: const Text('Apply'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _SummaryRow(label: 'Items', value: '${state.itemCount}'),
                      _SummaryRow(
                        label: 'Subtotal',
                        value: state.subtotal.toStringAsFixed(2),
                      ),
                      _SummaryRow(
                        label: 'Discount',
                        value: '-${state.discount.toStringAsFixed(2)}',
                      ),
                      const Divider(),
                      _SummaryRow(
                        label: 'Total',
                        value: state.total.toStringAsFixed(2),
                        valueKey: const ValueKey('cart-total'),
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueKey,
    this.bold = false,
  });
  final String label;
  final String value;
  final Key? valueKey;
  final bool bold;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        ),
        Text(
          value,
          key: valueKey,
          style: bold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
      ],
    ),
  );
}
