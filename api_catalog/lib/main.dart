import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/search_bloc.dart';
import 'cubit/products_cubit.dart';
import 'data/product_api.dart';
import 'screens/catalogue_page.dart';

void main() {
  final api = ProductApi();
  runApp(ApiCatalogueApp(api: api));
}

class ApiCatalogueApp extends StatelessWidget {
  const ApiCatalogueApp({required this.api, super.key});

  final ProductApi api;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ProductsCubit(api)..load()),
          BlocProvider(create: (_) => SearchBloc(api)),
        ],
        child: MaterialApp(
          title: 'API Catalogue',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
            useMaterial3: true,
          ),
          home: const CataloguePage(),
        ),
      );
}
