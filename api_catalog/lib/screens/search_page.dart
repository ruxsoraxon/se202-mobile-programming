import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../cubit/details_cubit.dart';
import 'product_details_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Search products')),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Product name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) => context
                  .read<SearchBloc>()
                  .add(SearchQueryChanged(query)),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) => switch (state) {
                SearchIdle() => const Center(child: Text('Type to search products.')),
                SearchLoading() => const Center(child: CircularProgressIndicator()),
                SearchFailure(:final message) => Center(child: Text(message)),
                SearchLoaded(:final products) when products.isEmpty =>
                  const Center(child: Text('No matching products.')),
                SearchLoaded(:final products) => ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(products[index].title),
                      subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
                      leading: const Icon(Icons.shopping_bag_outlined),
                      onTap: () {
                        final api = context.read<SearchBloc>().api;
                        final id = products[index].id;
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => BlocProvider(
                            create: (_) => DetailsCubit(api)..load(id),
                            child: ProductDetailsPage(productId: id),
                          ),
                        ));
                      },
                    ),
                  ),
              },
            ),
          ),
        ]),
      );
}
