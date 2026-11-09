import 'package:cart_four_ways/cubit/cart_cubit.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  test('Cubit emits additions and a single equal coupon state', () async {
    final api = MockCheckoutApi();
    final cubit = CartCubit(api);
    final emissions = expectLater(
      cubit.stream,
      emitsInOrder([
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 2),
        isA<CartState>()
            .having((s) => s.coupon, 'coupon', 'SAVE10')
            .having((s) => s.total, 'total', 88.2),
      ]),
    );
    cubit
      ..add(catalog.first)
      ..add(catalog.first)
      ..applyCoupon('SAVE10')
      ..applyCoupon('SAVE10');
    await emissions;
    await cubit.close();
  });

  test('Cubit checkout failure retains the cart', () async {
    final api = MockCheckoutApi();
    when(() => api.submit(any()))
        .thenThrow(const CheckoutException('Card declined'));
    final cubit = CartCubit(api);
    cubit.add(catalog.first);
    await cubit.checkout();
    expect(cubit.state.status, CheckoutStatus.failure);
    expect(cubit.state.lines, hasLength(1));
    await cubit.close();
  });
}
