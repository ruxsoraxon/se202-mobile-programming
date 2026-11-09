import 'package:cart_four_ways/setstate/cart_page_setstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('adds two keyboards and applies SAVE10 to the total', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CartPageSetState()));

    final keyboard = find.text('Keyboard · 49');
    await tester.tap(keyboard);
    await tester.tap(keyboard);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('coupon-field')),
      'SAVE10',
    );
    await tester.tap(find.byKey(const ValueKey('apply-coupon')));
    await tester.pumpAndSettle();

    expect(find.text('88.20'), findsOneWidget);
    expect(find.text('× 2'), findsOneWidget);
  });
}
