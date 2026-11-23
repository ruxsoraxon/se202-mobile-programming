import 'dart:convert';

import 'package:api_catalog/bloc/search_bloc.dart';
import 'package:api_catalog/bloc/search_event.dart';
import 'package:api_catalog/bloc/search_state.dart';
import 'package:api_catalog/data/product_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  blocTest<SearchBloc, SearchState>(
    'empty search returns to idle without a request',
    build: () => SearchBloc(ProductApi(client: MockClient((_) async {
      fail('An empty query should not call the API.');
    }))),
    act: (bloc) => bloc.add(const SearchQueryChanged('  ')),
    expect: () => [isA<SearchIdle>()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits loading and matching results',
    build: () => SearchBloc(ProductApi(client: MockClient((request) async {
      expect(request.url.queryParameters['q'], 'mascara');
      return http.Response(jsonEncode({
        'products': <Object>[],
        'total': 0,
        'skip': 0,
        'limit': 30,
      }), 200);
    }))),
    act: (bloc) => bloc.add(const SearchQueryChanged('mascara')),
    expect: () => [isA<SearchLoading>(), isA<SearchLoaded>()],
  );
}
