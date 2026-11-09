import '../models/cart.dart';

sealed class CartEvent {}
class ProductAdded extends CartEvent { ProductAdded(this.product); final Product product; }
class ProductRemoved extends CartEvent { ProductRemoved(this.id); final String id; }
class CheckoutRequested extends CartEvent {}
