// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

Future<void> main() async {
  final client = http.Client();
  try {
    final response = await client.get(Uri.parse('https://dummyjson.com/products/1'));
    print(response.statusCode);
    if (response.statusCode != 200) {
      throw StateError('DummyJSON returned HTTP ${response.statusCode}.');
    }

    final product = jsonDecode(response.body) as Map<String, dynamic>;
    print(product['title']);
    print((product['dimensions'] as Map<String, dynamic>).runtimeType);
  } finally {
    client.close();
  }
}
