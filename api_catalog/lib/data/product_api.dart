import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../models/product_page.dart';

class ProductApiException implements Exception {
  const ProductApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ProductApi {
  ProductApi({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://dummyjson.com';
  final http.Client _client;

  Future<ProductPage> getProducts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$_baseUrl/products').replace(
      queryParameters: {'limit': '$limit', 'skip': '$skip'},
    );
    final json = await _getJson(uri);
    return ProductPage.fromJson(json);
  }

  Future<Product> getProduct(int id) async {
    final json = await _getJson(Uri.parse('$_baseUrl/products/$id'));
    return Product.fromJson(json);
  }

  Future<ProductPage> searchProducts(String query) async {
    final uri = Uri.parse('$_baseUrl/products/search')
        .replace(queryParameters: {'q': query, 'limit': '30'});
    return ProductPage.fromJson(await _getJson(uri));
  }

  Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw ProductApiException(
          'The server returned HTTP ${response.statusCode}.',
          statusCode: response.statusCode,
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw const ProductApiException('The server returned an invalid response.');
      }
      return decoded;
    } on ProductApiException {
      rethrow;
    } on FormatException {
      throw const ProductApiException('The server returned invalid JSON.');
    } on Exception catch (error) {
      throw ProductApiException('Could not reach the product service: $error');
    }
  }

  void close() => _client.close();
}
