import 'package:bloc_test/bloc_test.dart';
import 'package:cart_four_ways/bloc/cart_bloc.dart';
import 'package:cart_four_ways/bloc/cart_event.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  late MockCheckoutApi api;
  setUp(() => api = MockCheckoutApi());

  blocTest<CartBloc, CartState>(
    'adds twice and applies SAVE10 once for duplicate equal events',
    build: () => CartBloc(api),
    act: (bloc) => bloc
      ..add(ProductAdded(catalog.first))
      ..add(ProductAdded(catalog.first))
      ..add(const CouponApplied('SAVE10'))
      ..add(const CouponApplied('SAVE10')),
    expect: () => [
      isA<CartState>().having((state) => state.itemCount, 'items', 1),
      isA<CartState>().having((state) => state.itemCount, 'items', 2),
      isA<CartState>()
          .having((state) => state.coupon, 'coupon', 'SAVE10')
          .having((state) => state.total, 'total', 88.2),
    ],
  );

  blocTest<CartBloc, CartState>(
    'checkout failure retains the cart',
    setUp: () =>
        when(() => api.submit(any()))
            .thenThrow(const CheckoutException('Card declined')),
    build: () => CartBloc(api),
    act: (bloc) async {
      bloc.add(ProductAdded(catalog.first));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const CheckoutRequested());
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

  blocTest<CartBloc, CartState>(
    'droppable transformer ignores repeated checkout while one is running',
    setUp: () => when(() => api.submit(any())).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return 'ORD-1234';
    }),
    build: () => CartBloc(api),
    seed: () => CartState(lines: [CartLine(product: catalog.first, qty: 1)]),
    act: (bloc) => bloc
      ..add(const CheckoutRequested())
      ..add(const CheckoutRequested())
      ..add(const CheckoutRequested()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      isA<CartState>().having(
        (state) => state.status,
        'status',
        CheckoutStatus.submitting,
      ),
      isA<CartState>().having(
        (state) => state.status,
        'status',
        CheckoutStatus.success,
      ),
    ],
    verify: (_) => verify(() => api.submit(49)).called(1),
  );
}
