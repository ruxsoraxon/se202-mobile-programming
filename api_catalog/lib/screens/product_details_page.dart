import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/details_cubit.dart';
import '../models/product.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({required this.productId, super.key});
  final int productId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Product details')),
        body: BlocBuilder<DetailsCubit, ProductDetailsState>(
          builder: (context, state) => switch (state) {
            DetailsLoading() => const Center(child: CircularProgressIndicator()),
            DetailsFailure(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.read<DetailsCubit>().load(productId),
                      child: const Text('Try again'),
                    ),
                  ]),
                ),
              ),
            DetailsLoaded(:final product) => _Details(product: product),
          },
        ),
      );
}

class _Details extends StatelessWidget {
  const _Details({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(product.thumbnail, height: 240, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(
                    height: 180, child: Icon(Icons.image_not_supported, size: 48))),
          ),
          const SizedBox(height: 16),
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          Text(product.brand ?? 'Unbranded'),
          const SizedBox(height: 8),
          Text('\$${product.price.toStringAsFixed(2)}  ·  ★ ${product.rating}'),
          const SizedBox(height: 16),
          Text('Dimensions', style: Theme.of(context).textTheme.titleMedium),
          Text('${product.dimensions.width} × ${product.dimensions.height} × ${product.dimensions.depth}'),
          const SizedBox(height: 16),
          Text('Tags', style: Theme.of(context).textTheme.titleMedium),
          Wrap(spacing: 8, children: product.tags.map((tag) => Chip(label: Text(tag))).toList()),
          const SizedBox(height: 16),
          Text('Reviews (${product.reviews.length})', style: Theme.of(context).textTheme.titleMedium),
          for (final review in product.reviews)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('${review.reviewerName} | ${List.filled(review.rating, '★').join()}'),
              subtitle: Text('${review.comment}\n${review.date.toLocal().toString().split(' ').first}'),
            ),
        ],
      );
}
