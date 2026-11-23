import 'dart:convert';

import 'package:api_catalog/data/product_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('sends product id request and parses JSON response', () async {
    Uri? requested;
    final api = ProductApi(client: MockClient((request) async {
      requested = request.url;
      return http.Response(jsonEncode({
        'id': 1,
        'title': 'Test item',
        'price': 9.99,
        'rating': 4,
        'tags': <String>[],
        'thumbnail': 'https://example.com/item.png',
        'dimensions': {'width': 1, 'height': 2, 'depth': 3},
        'reviews': <Object>[],
      }), 200);
    }));
    addTearDown(api.close);

    final product = await api.getProduct(1);

    expect(requested?.path, '/products/1');
    expect(product.id, 1);
    expect(product.price, 9.99);
  });

  test('turns non-2xx response into an API exception', () async {
    final api = ProductApi(client: MockClient((_) async => http.Response('nope', 503)));
    addTearDown(api.close);

    await expectLater(api.getProduct(1), throwsA(isA<ProductApiException>()));
  });
}
