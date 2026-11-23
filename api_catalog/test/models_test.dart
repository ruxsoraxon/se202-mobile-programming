import 'dart:convert';
import 'dart:io';

import 'package:api_catalog/models/product.dart';
import 'package:api_catalog/models/product_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final fixture = File('test/fixtures/product.json');

  test('parses product values, nested dimensions, and reviews', () {
    final product = Product.fromJson(
      jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>,
    );

    expect(product.title, 'Essence Mascara Lash Princess');
    expect(product.price, 9.99);
    expect(product.dimensions.width, 15.14);
    expect(product.tags, ['beauty', 'mascara']);
    expect(product.reviews, hasLength(3));
    expect(product.reviews.first.date, DateTime.parse('2025-04-30T09:41:02.053Z'));
  });

  test('handles absent optional brand and tags', () {
    final json = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>
      ..remove('brand')
      ..remove('tags');
    final product = Product.fromJson(json);

    expect(product.brand, isNull);
    expect(product.tags, isEmpty);
  });

  test('parses the paginated products response', () {
    final product = jsonDecode(fixture.readAsStringSync()) as Map<String, dynamic>;
    final page = ProductPage.fromJson({
      'products': [product],
      'total': 194,
      'skip': 0,
      'limit': 30,
    });

    expect(page.products.single.id, 1);
    expect(page.total, 194);
    expect(page.limit, 30);
  });
}
