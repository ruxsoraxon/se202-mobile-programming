import 'dart:convert';

import 'package:api_catalog/cubit/details_cubit.dart';
import 'package:api_catalog/data/product_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads the requested product into the details state', () async {
    final api = ProductApi(client: MockClient((request) async {
      expect(request.url.path, '/products/1');
      return http.Response(jsonEncode({
        'id': 1,
        'title': 'Test item',
        'price': 9.99,
        'rating': 4,
        'tags': <String>[],
        'thumbnail': 'https://example.com/item.png',
        'dimensions': {'width': 1, 'height': 2, 'depth': 3},
      }), 200);
    }));
    addTearDown(api.close);
    final cubit = DetailsCubit(api);
    addTearDown(cubit.close);
    final states = <ProductDetailsState>[];
    final subscription = cubit.stream.listen(states.add);
    addTearDown(subscription.cancel);

    await cubit.load(1);

    expect(states, [isA<DetailsLoading>(), isA<DetailsLoaded>()]);
    expect((states.last as DetailsLoaded).product.id, 1);
  });
}
