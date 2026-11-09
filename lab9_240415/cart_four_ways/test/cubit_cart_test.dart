import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/cubit/cart_cubit.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  late MockCheckoutApi api;
  setUp(() => api = MockCheckoutApi());

  blocTest<CartCubit, CartState>(
    'adds twice and applies SAVE10 once for duplicate equal state',
    build: () => CartCubit(api),
    act: (cubit) => cubit
      ..add(catalog.first)
      ..add(catalog.first)
      ..applyCoupon('SAVE10')
      ..applyCoupon('SAVE10'),
    expect: () => [
      isA<CartState>().having((state) => state.itemCount, 'items', 1),
      isA<CartState>().having((state) => state.itemCount, 'items', 2),
      isA<CartState>()
          .having((state) => state.coupon, 'coupon', 'SAVE10')
          .having((state) => state.total, 'total', 88.2),
    ],
  );

  blocTest<CartCubit, CartState>(
    'checkout failure retains the cart',
    setUp: () =>
        when(() => api.submit(any()))
            .thenThrow(const CheckoutException('Card declined')),
    build: () => CartCubit(api),
    act: (cubit) async {
      cubit.add(catalog.first);
      await cubit.checkout();
    },
    expect: () => [
      isA<CartState>().having((state) => state.itemCount, 'items', 1),
      isA<CartState>().having(
        (state) => state.status,
        'status',
        CheckoutStatus.submitting,
      ),
      isA<CartState>()
          .having((state) => state.status, 'status', CheckoutStatus.failure)
          .having((state) => state.itemCount, 'items', 1),
    ],
  );
}
