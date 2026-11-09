import '../models/cart.dart';

sealed class CartEvent {
  const CartEvent();
}

final class ProductAdded extends CartEvent {
  const ProductAdded(this.product);
  final Product product;
}

final class QuantityChanged extends CartEvent {
  const QuantityChanged(this.id, this.delta);
  final String id;
  final int delta;
}

final class CouponApplied extends CartEvent {
  const CouponApplied(this.code);
  final String code;
}

final class CheckoutRequested extends CartEvent {
  const CheckoutRequested();
}

final class UndoRequested extends CartEvent {
  const UndoRequested();
}
