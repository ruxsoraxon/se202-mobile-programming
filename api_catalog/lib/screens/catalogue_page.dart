import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/details_cubit.dart';
import '../cubit/products_cubit.dart';
import '../models/product.dart';
import 'product_details_page.dart';
import 'search_page.dart';

class CataloguePage extends StatelessWidget {
  const CataloguePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Product Catalogue'),
          actions: [
            IconButton(
              tooltip: 'Search products',
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SearchPage()),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) => switch (state) {
            ProductsInitial() || ProductsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ProductsFailure(:final message) => _ErrorView(
                message: message,
                onRetry: context.read<ProductsCubit>().load,
              ),
            ProductsLoaded(:final page) => _ProductList(products: page.products),
          },
        ),
      );
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});
  final List<Product> products;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: context.read<ProductsCubit>().load,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: products.length,
          itemBuilder: (context, index) => _ProductTile(product: products[index]),
        ),
      );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: Image.network(
            product.thumbnail,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          ),
          title: Text(product.title),
          subtitle: Text('${product.brand ?? 'Unbranded'} | \$${product.price.toStringAsFixed(2)}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            final api = context.read<ProductsCubit>().api;
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => BlocProvider(
                create: (_) => DetailsCubit(api)..load(product.id),
                child: ProductDetailsPage(productId: product.id),
              ),
            ));
          },
        ),
      );
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off, size: 44),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ]),
        ),
      );
}
