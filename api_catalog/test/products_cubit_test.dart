import 'dart:convert';

import 'package:api_catalog/cubit/products_cubit.dart';
import 'package:api_catalog/data/product_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('emits loading then loaded for a successful request', () async {
    final api = ProductApi(client: MockClient((_) async => http.Response(
          jsonEncode({
            'products': [
              {
                'id': 1,
                'title': 'Test item',
                'price': 9.99,
                'rating': 4,
                'tags': <String>[],
                'thumbnail': 'https://example.com/item.png',
                'dimensions': {'width': 1, 'height': 2, 'depth': 3},
              }
            ],
            'total': 1,
            'skip': 0,
            'limit': 30,
          }),
          200,
        )));
    addTearDown(api.close);
    final cubit = ProductsCubit(api);
    addTearDown(cubit.close);
    final states = <ProductsState>[];
    final subscription = cubit.stream.listen(states.add);
    addTearDown(subscription.cancel);

    await cubit.load();

    expect(states, [isA<ProductsLoading>(), isA<ProductsLoaded>()]);
  });
}
