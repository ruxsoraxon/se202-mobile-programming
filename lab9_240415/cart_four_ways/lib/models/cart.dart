class Product {
  const Product({required this.id, required this.name, required this.price});

  final String id;
  final String name;
  final double price;
}

const catalog = [
  Product(id: 'p1', name: 'Keyboard', price: 49),
  Product(id: 'p2', name: 'Mouse', price: 25),
  Product(id: 'p3', name: 'Monitor', price: 199),
];

class CartLine {
  const CartLine({required this.product, required this.qty});

  final Product product;
  final int qty;
  double get subtotal => product.price * qty;
  CartLine copyWith({int? qty}) =>
      CartLine(product: product, qty: qty ?? this.qty);

  @override
  bool operator ==(Object other) =>
      other is CartLine && other.product.id == product.id && other.qty == qty;
  @override
  int get hashCode => Object.hash(product.id, qty);
}

enum CheckoutStatus { idle, submitting, success, failure }

class CartState {
  const CartState({
    this.lines = const [],
    this.coupon,
    this.couponError,
    this.status = CheckoutStatus.idle,
    this.orderId,
    this.checkoutError,
  });

  final List<CartLine> lines;
  final String? coupon;
  final String? couponError;
  final CheckoutStatus status;
  final String? orderId;
  final String? checkoutError;

  int get itemCount => lines.itemCount;
  double get subtotal => lines.subtotal;
  double get discount => coupon == 'SAVE10' ? subtotal * 0.10 : 0;
  double get total => subtotal - discount;

  CartState copyWith({
    List<CartLine>? lines,
    String? coupon,
    String? couponError,
    CheckoutStatus? status,
    String? orderId,
    String? checkoutError,
    bool clearCoupon = false,
    bool clearCouponError = false,
    bool clearOrderId = false,
    bool clearCheckoutError = false,
  }) => CartState(
    lines: lines ?? this.lines,
    coupon: clearCoupon ? null : coupon ?? this.coupon,
    couponError: clearCouponError ? null : couponError ?? this.couponError,
    status: status ?? this.status,
    orderId: clearOrderId ? null : orderId ?? this.orderId,
    checkoutError: clearCheckoutError
        ? null
        : checkoutError ?? this.checkoutError,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartState &&
          other.coupon == coupon &&
          other.couponError == couponError &&
          other.status == status &&
          other.orderId == orderId &&
          other.checkoutError == checkoutError &&
          other.lines.length == lines.length &&
          List.generate(
            lines.length,
            (index) => lines[index] == other.lines[index],
          ).every((same) => same);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(lines),
    coupon,
    couponError,
    status,
    orderId,
    checkoutError,
  );
}

extension CartLines on List<CartLine> {
  List<CartLine> withProduct(Product product) {
    final index = indexWhere((line) => line.product.id == product.id);
    if (index == -1) return [...this, CartLine(product: product, qty: 1)];
    return [
      for (final line in this)
        line.product.id == product.id ? line.copyWith(qty: line.qty + 1) : line,
    ];
  }

  List<CartLine> without(String productId) => [
    for (final line in this)
      if (line.product.id != productId) line,
  ];

  List<CartLine> changeQty(String id, int delta) => [
    for (final line in this)
      if (line.product.id == id && line.qty + delta > 0)
        line.copyWith(qty: line.qty + delta)
      else if (line.product.id != id)
        line,
  ];

  double get subtotal => fold(0, (sum, line) => sum + line.subtotal);
  int get itemCount => fold(0, (sum, line) => sum + line.qty);
}
