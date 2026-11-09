import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/riverpod/cart_notifier.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  test('adds twice and applies SAVE10', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final cart = container.read(cartProvider.notifier);

    cart.add(catalog.first);
    cart.add(catalog.first);
    cart.applyCoupon('SAVE10');

    expect(container.read(cartProvider).total, 88.2);
  });

  test('checkout failure keeps cart lines', () async {
    final api = MockCheckoutApi();
    when(() => api.submit(any()))
        .thenThrow(const CheckoutException('Card declined'));
    final container = ProviderContainer(
      overrides: [checkoutApiProvider.overrideWith((ref) => api)],
    );
    addTearDown(container.dispose);
    final cart = container.read(cartProvider.notifier);
    cart.add(catalog.first);

    await cart.checkout();

    expect(container.read(cartProvider).status, CheckoutStatus.failure);
    expect(container.read(cartProvider).lines, hasLength(1));
    expect(container.read(cartProvider).lines.single.product.id, 'p1');
  });
}
