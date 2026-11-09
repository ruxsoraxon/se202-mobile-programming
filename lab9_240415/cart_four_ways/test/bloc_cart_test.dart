import 'package:cart_four_ways/bloc/cart_bloc.dart';
import 'package:cart_four_ways/bloc/cart_event.dart';
import 'package:cart_four_ways/models/cart.dart';
import 'package:cart_four_ways/services/checkout_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCheckoutApi extends Mock implements CheckoutApi {}

void main() {
  test('BLoC emits additions and a single equal coupon state', () async {
    final bloc = CartBloc(MockCheckoutApi());
    final emissions = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 1),
        isA<CartState>().having((s) => s.itemCount, 'itemCount', 2),
        isA<CartState>()
            .having((s) => s.coupon, 'coupon', 'SAVE10')
            .having((s) => s.total, 'total', 88.2),
      ]),
    );
    bloc
      ..add(ProductAdded(catalog.first))
      ..add(ProductAdded(catalog.first))
      ..add(const CouponApplied('SAVE10'))
      ..add(const CouponApplied('SAVE10'));
    await emissions;
    await bloc.close();
  });

  test('BLoC checkout failure retains the cart', () async {
    final api = MockCheckoutApi();
    when(() => api.submit(any()))
        .thenThrow(const CheckoutException('Card declined'));
    final bloc = CartBloc(api);
    final failure = bloc.stream.firstWhere(
      (state) => state.status == CheckoutStatus.failure,
    );
    bloc.add(ProductAdded(catalog.first));
    await Future<void>.delayed(Duration.zero);
    bloc.add(const CheckoutRequested());
    await failure;
    expect(bloc.state.lines, hasLength(1));
    await bloc.close();
  });
}
